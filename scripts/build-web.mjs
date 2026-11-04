#!/usr/bin/env node
// Builds web/data.js from the Swift sources, the catalog registry, tokens/tokens.json and docs/.
// Run from the repo root:  node scripts/build-web.mjs
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const read = (p) => fs.readFileSync(path.join(ROOT, p), "utf8");
const REPO = "https://github.com/arnavrxD/equal-ai-ios-design-system";

// ── Swift sources ─────────────────────────────────────────────
function walk(dir) {
  return fs.readdirSync(path.join(ROOT, dir), { withFileTypes: true }).flatMap((d) =>
    d.isDirectory() ? walk(path.join(dir, d.name)) : d.name.endsWith(".swift") ? [path.join(dir, d.name)] : []
  );
}
const swiftFiles = walk("Sources/EqualDesignSystem").map((f) => ({ file: f, text: read(f) }));

/** Index of the matching closing brace for the `{` at `open`, skipping string literals. */
function matchBrace(text, open) {
  let depth = 0, inStr = false;
  for (let i = open; i < text.length; i++) {
    const c = text[i];
    if (inStr) {
      if (c === "\\") { i++; continue; }
      if (c === '"') inStr = false;
      continue;
    }
    if (c === '"') { inStr = true; continue; }
    if (c === "{") depth++;
    else if (c === "}") { depth--; if (depth === 0) return i; }
  }
  return -1;
}

/** The declaration of a public type, with its doc comment. */
function extractType(name) {
  for (const { file, text } of swiftFiles) {
    const re = new RegExp(`^public (struct|enum) ${name}\\b[^\\n]*\\{`, "m");
    const m = re.exec(text);
    if (!m) continue;
    let start = m.index;
    const before = text.slice(0, start).split("\n");
    before.pop();
    const docs = [];
    while (before.length && before[before.length - 1].trim().startsWith("///")) docs.unshift(before.pop());
    const open = text.indexOf("{", m.index);
    const end = matchBrace(text, open);
    const source = (docs.length ? docs.join("\n") + "\n" : "") + text.slice(start, end + 1);
    const summary = docs.map((l) => l.replace(/^\s*\/\/\/ ?/, "")).join(" ").replace(/```[\s\S]*?```/g, "").trim();
    return { file, source, summary };
  }
  return null;
}

// ── Catalog registry (level, summary, usage snippet) ───────────
const catalogText = read("Sources/EqualDesignSystem/Catalog/EqualCatalogView.swift");
const catalog = [];
const itemRe = /EqualCatalogItem\("([^"]+)", \.(\w+), "((?:[^"\\]|\\.)*)"\) \{/g;
let im;
while ((im = itemRe.exec(catalogText))) {
  const open = im.index + im[0].length - 1;
  const end = matchBrace(catalogText, open);
  let body = catalogText.slice(open + 1, end).replace(/^\n/, "").replace(/\s+$/, "");
  const lines = body.split("\n");
  const indent = Math.min(...lines.filter((l) => l.trim()).map((l) => l.match(/^ */)[0].length));
  body = lines.map((l) => l.slice(indent)).join("\n").trim();
  catalog.push({ id: im[1], level: im[2], summary: im[3].replace(/\\"/g, '"'), usage: body });
}

// ── Web previews and guideline docs ────────────────────────────
const previews = JSON.parse(read("web/previews/previews.json"));
function guidelines(webName) {
  const p = path.join(ROOT, "docs/components", webName + ".md");
  if (!fs.existsSync(p)) return "";
  return fs.readFileSync(p, "utf8")
    .replace(/^# .*\n+/, "")
    .split("\n")
    .filter((l) => !/^- Props:|EqualDS\.|`EqualDS/.test(l))
    .join("\n")
    .trim();
}

const snapshotsDir = path.join(ROOT, "web/snapshots");
const snap = (id, scheme) => {
  const slug = id.toLowerCase().replace(/ · /g, "-").replace(/ & /g, "-").replace(/, /g, "-").replace(/ /g, "-");
  const f = `${slug}-${scheme}.png`;
  return fs.existsSync(path.join(snapshotsDir, f)) ? `snapshots/${f}` : null;
};
// ImageRenderer cannot draw text fields or scroll views; these renders are left out.
const NO_SNAPSHOT = new Set(["EqualTextField", "EqualSearchBar", "EqualComposer", "EqualChatListItem", "EqualChatList", "EqualSheet", "EqualLiveCallCard",
  "Phone number", "Name & gender", "Home", "Home · empty", "Equal chat · limit", "Paywall", "App Store confirmation", "Settings", "Settings · expired", "Subscription"]);

const slugify = (s) => s.replace(/^Equal/, "").replace(/([a-z])([A-Z])/g, "$1-$2").replace(/[^A-Za-z0-9]+/g, "-").replace(/^-|-$/g, "").toLowerCase();
const webNameFor = (swift) => (swift === "EqualIconView" ? "Icon" : swift === "EqualSheet" ? "EqualSheet" : swift.replace(/^Equal/, ""));

const components = catalog
  .filter((c) => ["atoms", "molecules", "organisms"].includes(c.level))
  .map((c) => {
    const t = extractType(c.id);
    const web = webNameFor(c.id);
    const pv = previews[web];
    return {
      name: c.id,
      slug: slugify(c.id),
      level: c.level,
      summary: t?.summary || c.summary,
      short: c.summary,
      file: t?.file,
      source: t?.source || "",
      usage: c.usage,
      guidelines: guidelines(web),
      preview: pv ? { js: pv.js, height: pv.height } : null,
      snapshot: NO_SNAPSHOT.has(c.id) ? null : { light: snap(c.id, "light"), dark: snap(c.id, "dark") },
    };
  });

// Icon atom lives in Foundation
{
  const t = extractType("EqualIconView");
  components.splice(17, 0, {
    name: "EqualIconView", slug: "icon", level: "atoms", summary: t.summary, short: "SF Symbol glyphs for UI icons.",
    file: t.file, source: extractType("EqualIcon").source + "\n\n" + t.source,
    usage: 'HStack {\n    EqualIconView(.phone, size: 20)\n    EqualIconView(.chevronRight, size: 13, weight: .semibold)\n        .foregroundStyle(EqualColor.textSecondary)\n}',
    guidelines: guidelines("Icon"), preview: previews.Icon ? { js: previews.Icon.js, height: previews.Icon.height } : null, snapshot: null,
  });
}

const FIGMA = {
  "Splash": "00-splash.png", "Phone number": "01-mobile-number-keyboard.png", "Name & gender": "02-select-gender.png",
  "Permission": "03-permission.png", "Home": "06-home-last-day-push.png", "Home · empty": "12-empty-state-permission-card.png",
  "Equal chat · limit": "08-chat-limit-message.png", "Value recap": "09-value-recap.png", "Paywall": "10-paywall-hero.png",
  "App Store confirmation": "13-app-store-confirmation.png", "Subscription": "11-subscription-active.png",
};
const screens = catalog.filter((c) => c.level === "screens").map((c) => {
  const swiftName = (c.usage.match(/^(\w+)\(/) || [])[1];
  const t = swiftName ? extractType(swiftName) : null;
  const uses = t ? [...new Set([...t.source.matchAll(/\b(Equal[A-Z]\w+)\(/g)].map((m) => m[1]))].filter((n) => components.some((x) => x.name === n)) : [];
  return {
    name: c.id, slug: slugify(c.id), summary: c.summary, swiftName, usage: c.usage,
    file: t?.file, source: t?.source || "", composedOf: uses,
    figma: FIGMA[c.id] ? `assets/Screens/${FIGMA[c.id]}` : null,
    snapshot: NO_SNAPSHOT.has(c.id) ? null : snap(c.id, "light"),
  };
});

// ── Foundations ────────────────────────────────────────────────
const tokens = JSON.parse(read("tokens/tokens.json"));
const iconEnum = extractType("EqualIcon").source;
const icons = [...iconEnum.matchAll(/case (\w+) = "([^"]+)"/g)].map((m) => ({ swift: m[1], symbol: m[2] }));
const imageEnum = read("Sources/EqualDesignSystem/Foundation/EqualImage.swift");
const images = [];
for (const m of imageEnum.matchAll(/(?:case|,)\s*(\w+)(?: = "([^"]+)")?/g)) {
  if (["self", "with"].includes(m[1])) continue;
  const file = m[2] || m[1];
  if (fs.existsSync(path.join(ROOT, "Sources/EqualDesignSystem/Resources/Images", file + ".png"))) images.push({ swift: m[1], file });
}
const svgIcons = fs.readdirSync(path.join(ROOT, "web/assets/Icons")).filter((f) => f.endsWith(".svg")).sort();
const flows = fs.readdirSync(path.join(ROOT, "web/assets/Flows")).filter((f) => f.endsWith(".png")).sort();
const gradientsSwift = read("Sources/EqualDesignSystem/Foundation/EqualGradient.swift");
const gradientNames = [...gradientsSwift.matchAll(/public static let (\w+)/g)].map((m) => m[1]);

const stats = {
  swiftFiles: swiftFiles.length,
  swiftLines: swiftFiles.reduce((n, f) => n + f.text.split("\n").length, 0),
  atoms: components.filter((c) => c.level === "atoms").length,
  molecules: components.filter((c) => c.level === "molecules").length,
  organisms: components.filter((c) => c.level === "organisms").length,
  screens: screens.length,
  colors: tokens.color.tokens.length,
  textStyles: tokens.type.groups.reduce((n, g) => n + g.styles.length, 0),
};

const data = { repo: REPO, stats, tokens, components, screens, icons, images, svgIcons, flows, gradientNames,
  brandBook: read("docs/brand-book.md"), packageSwift: read("Package.swift") };
fs.writeFileSync(path.join(ROOT, "web/data.js"), "window.EQ = " + JSON.stringify(data) + ";\n");
console.log(`web/data.js: ${components.length} components, ${screens.length} screens, ${icons.length} icons, ${images.length} images`, stats);
