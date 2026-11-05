/* Equal AI iOS Design System — documentation site (hash router, no build step). */
(function () {
  "use strict";
  const D = window.EQ;
  const E = window.EqualDS;
  const h = React.createElement;
  const $main = document.getElementById("main");
  const $side = document.getElementById("side");
  const $shell = document.querySelector(".shell");
  let roots = [];

  // ── utilities ─────────────────────────────────────────────
  const esc = (s) => String(s ?? "").replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
  const camel = (n) => n.replace(/[-_.]([a-z0-9])/g, (_, c) => c.toUpperCase());
  const levelName = { atoms: "Atoms", molecules: "Molecules", organisms: "Organisms" };
  const ghFile = (f) => `${D.repo}/blob/main/${f}`;
  const store = { get(k) { try { return localStorage.getItem(k); } catch { return null; } }, set(k, v) { try { localStorage.setItem(k, v); } catch {} } };

  const inlineMd = (t) => esc(t).replace(/`([^`]+)`/g, "<code>$1</code>").replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
  function md(src) {
    const inline = (t) => esc(t).replace(/`([^`]+)`/g, "<code>$1</code>").replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>").replace(/(^|[^*])\*([^*]+)\*/g, "$1<em>$2</em>");
    const out = []; let list = null;
    for (const raw of String(src || "").split("\n")) {
      const line = raw.trimEnd();
      if (/^- /.test(line)) { if (!list) { list = []; } list.push(`<li>${inline(line.slice(2))}</li>`); continue; }
      if (list) { out.push(`<ul>${list.join("")}</ul>`); list = null; }
      if (!line.trim()) continue;
      if (/^## /.test(line)) out.push(`<h2>${inline(line.slice(3))}</h2>`);
      else if (/^# /.test(line)) continue;
      else out.push(`<p>${inline(line)}</p>`);
    }
    if (list) out.push(`<ul>${list.join("")}</ul>`);
    return out.join("");
  }

  function toast(msg) {
    let t = document.querySelector(".toast");
    if (!t) { t = document.createElement("div"); t.className = "toast"; t.setAttribute("role", "status"); document.body.appendChild(t); }
    t.textContent = msg; t.classList.add("show");
    clearTimeout(t._h); t._h = setTimeout(() => t.classList.remove("show"), 1600);
  }
  async function copy(text) {
    try { await navigator.clipboard.writeText(text); toast("Copied"); }
    catch { const ta = document.createElement("textarea"); ta.value = text; document.body.appendChild(ta); ta.select(); try { document.execCommand("copy"); toast("Copied"); } catch {} ta.remove(); }
  }

  let codeId = 0;
  const codes = {};
  function codeBlock(code, label = "Swift", lang = "swift") {
    const id = "code" + ++codeId; codes[id] = code;
    return `<div class="code"><div class="code-head"><span>${esc(label)}</span><button class="copy" type="button" data-copy="${id}">Copy</button></div><pre><code class="language-${lang}">${esc(code)}</code></pre></div>`;
  }

  function unmount() { roots.forEach((r) => { try { r.unmount(); } catch {} }); roots = []; }
  function mount(el, make) {
    const root = ReactDOM.createRoot(el);
    root._el = el;
    try { root.render(make()); } catch (e) { el.textContent = "Preview failed: " + e.message; }
    roots.push(root);
  }
  const fromJs = (js) => () => new Function("E", "h", "React", `return (${js});`)(E, h, React);

  function siteTheme() { return document.documentElement.getAttribute("data-theme") || "dark"; }
  function setTheme(t) {
    document.documentElement.setAttribute("data-theme", t);
    store.set("eq-theme", t);
    document.querySelectorAll("[data-theme-set]").forEach((b) => b.classList.toggle("on", b.dataset.themeSet === t));
  }

  /** A preview container that renders `make` in a theme. */
  function pvHtml(key, theme, extra = "") { return `<div class="pv" data-theme="${theme}" data-pv="${key}" ${extra}></div>`; }
  const pvMakers = {};
  function registerPv(key, make) { pvMakers[key] = make; return key; }
  function mountAll(scope = document) {
    scope.querySelectorAll("[data-pv]").forEach((el) => { if (!el._mounted && pvMakers[el.dataset.pv]) { el._mounted = true; mount(el, pvMakers[el.dataset.pv]); } });
  }
  function highlight(scope = document) {
    if (!window.hljs) return;
    scope.querySelectorAll("pre code[class^='language-']").forEach((el) => { if (!el.dataset.hl) { el.dataset.hl = "1"; window.hljs.highlightElement(el); } });
  }

  // ── sidebars ──────────────────────────────────────────────
  function sideDocs(active) {
    const link = (href, label) => `<a href="#/${href}" class="${active === href ? "on" : ""}">${label}</a>`;
    return `<h5>Docs</h5>${link("start", "Getting started")}${link("brand", "Brand book")}
      <h5>Foundations</h5>${link("foundations/color", "Color")}${link("foundations/typography", "Typography")}${link("foundations/layout", "Spacing, radius & effects")}${link("foundations/icons", "Icons")}${link("foundations/illustrations", "Illustrations & logos")}
      <h5>Reference</h5>${link("components", "Components")}${link("screens", "Screens & flows")}`;
  }
  function sideComponents(active) {
    const groups = ["atoms", "molecules", "organisms"].map((lv) => {
      const items = D.components.filter((c) => c.level === lv);
      return `<h5><span>${levelName[lv]}</span><span>${items.length}</span></h5>` + items.map((c) => `<a href="#/components/${c.slug}" data-name="${esc(c.name.toLowerCase())}" class="${active === c.slug ? "on" : ""}">${esc(c.name)}</a>`).join("");
    }).join("");
    return `<input class="side-search" id="side-search" type="search" placeholder="Search components…" aria-label="Search components">
      <a href="#/components" class="${!active ? "on" : ""}">Overview</a>${groups}`;
  }
  /** Screens grouped by flow: the part of the name before " · ". */
  function screenGroups() {
    const order = ["Splash", "Phone number", "OTP", "Name & gender", "Welcome", "Intro", "Permission", "Chats permission", "Home", "Equal chat", "Limit chat", "Gold trial start", "Trial home", "Trial started", "Soft paywall", "Plan expired", "Paywall", "Limit paywall", "Value recap", "Purchase confirm", "App Store confirmation", "Activating Gold", "UPI wait", "Payment processing", "Processing sheet", "Purchase success", "Settings", "Subscription"];
    const groupOf = (n) => order.find((o) => n === o || n.startsWith(o + " ") || n.startsWith(o + " ·")) || n.split(" · ")[0];
    const map = new Map();
    for (const s of D.screens) { const g = groupOf(s.name); if (!map.has(g)) map.set(g, []); map.get(g).push(s); }
    return [...map.entries()].sort((a, b) => (order.indexOf(a[0]) + 1 || 99) - (order.indexOf(b[0]) + 1 || 99));
  }
  function sideScreens(active) {
    return `<input class="side-search" id="side-search" type="search" placeholder="Search screens…" aria-label="Search screens"><a href="#/screens" class="${!active ? "on" : ""}">Overview</a>` +
      screenGroups().map(([g, list]) => `<h5><span>${esc(g)}</span><span>${list.length}</span></h5>` + list.map((s) => `<a href="#/screens/${s.slug}" data-name="${esc(s.name.toLowerCase())}" class="${active === s.slug ? "on" : ""}">${esc(s.name.includes(" · ") ? s.name.split(" · ").slice(1).join(" · ") : s.name)}</a>`).join("")).join("") +
      `<h5>Flows</h5><a href="#/screens#flows">Flow boards</a>`;
  }

  // ── pages ─────────────────────────────────────────────────
  function pageHome() {
    const t = siteTheme();
    const tiles = [
      ["Assistant toggle", "h('div',{style:{padding:16}},h(E.AssistantToggleCard))"],
      ["Chat list item", "h('div',{style:{padding:16}},h(E.ChatListItem,{name:'Amit Nanda',message:'Amit called to remind you about the meeting',time:'3:15 PM',unread:1,initials:'AN',contact:true,actions:[{label:'Call back',glyph:'📞'},{label:'Add to Calendar',glyph:'🗓️'}]}))"],
      ["Chat bubbles", "h('div',{style:{padding:16,background:'var(--action-bottom)'}},h('div',{className:'eq-bubbles'},h(E.ChatBubble,{from:'user'},'Make a call'),h(E.ChatBubble,{from:'assistant',withAvatar:true},'You’ve used all 30 AI calls on your Gold plan this month.')))"],
      ["Plan cards", "h('div',{style:{padding:'28px 16px 16px',background:'#fff'}},h('div',{className:'eq-plans'},h(E.PlanCard,{name:'Gold',price:'₹249'}),h(E.PlanCard,{name:'Gold Plus',price:'₹499',selected:true,best:true})))"],
      ["Membership card", "h('div',{style:{padding:16}},h(E.MembershipCard,{status:'active'}))"],
      ["Trial card", "h('div',{style:{padding:16}},h(E.PromoCard,{kind:'trial'}))"],
    ];
    const collage = tiles.map(([cap, js], i) => `<figure class="card tile" style="margin:0">${pvHtml(registerPv("home" + i, fromJs(js)), t)}<figcaption>${esc(cap)}</figcaption></figure>`).join("");
    const atom = registerPv("atomA", fromJs("h('div',{style:{display:'flex',gap:10,alignItems:'center',flexWrap:'wrap',padding:8}},h(E.Avatar,{initials:'AN',contact:true}),h(E.UnreadCount,{count:1}),h(E.Chip,{variant:'suggested',glyph:'📞'},'Call back'))"));
    const mol = registerPv("atomM", fromJs("h('div',{style:{padding:8}},h(E.ChatListItem,{name:'Amit Nanda',message:'Amit called to remind you about the meeting',time:'3:15 PM',unread:1,initials:'AN',contact:true,actions:[{label:'Call back',glyph:'📞'}]}))"));
    const org = registerPv("atomO", fromJs("h('div',{style:{padding:8}},h(E.ChatList,{items:[{name:'Amit Nanda',message:'Amit called to remind you about the meeting',time:'3:15 PM',unread:1,initials:'AN',contact:true,actions:[{label:'Call back',glyph:'📞'}]},{name:'HDFC Bank',message:'Home loan offer especially for you',time:'3:02 PM',avatarSrc:E.assets.bank,tint:'finance',actions:[{label:'Mute',glyph:'🔕'}]}]}))"));
    const s = D.stats;
    const usage = `import SwiftUI\nimport EqualDesignSystem\n\nstruct InboxView: View {\n    @State private var tab: EqualTabBar.Tab = .chats\n\n    var body: some View {\n        VStack(spacing: 0) {\n            EqualAppHeader(plan: "Gold")\n            ScrollView {\n                VStack(spacing: EqualSpacing.s16) {\n                    EqualPromoCard(.trialEnding)\n                    EqualChatList(EqualChat.samples)\n                }\n                .padding(.horizontal, EqualSpacing.s24)\n            }\n        }\n        .overlay(alignment: .bottom) { EqualTabBar(selection: $tab, unread: 2) }\n        .equalScreenBackground()\n    }\n}`;
    const figmaScreens = D.screens.filter((x) => x.figma);
    return `<div class="page wide">
      <section class="hero">
        <div class="stack">
          <span class="eyebrow">SwiftUI · iOS 17+ · Swift Package</span>
          <h1 class="h1">The Equal AI iOS design system, from token to screen</h1>
          <p class="lead">Every colour, text style and component from the EQAI-iOS Figma, written in SwiftUI and organised as atoms, molecules and organisms. Each page shows the live component, the SwiftUI render, and the Swift you write.</p>
          <div class="cta"><a class="btn primary" href="#/start">Get started</a><a class="btn ghost" href="#/components">Browse components</a><a class="btn ghost" href="${esc(D.repo)}" target="_blank" rel="noopener">View on GitHub</a></div>
          <p class="small">DM Sans · SF Symbols · one tokens.json generating the Swift</p>
        </div>
        <div class="collage">${collage}</div>
      </section>
      <section class="stats" aria-label="What's inside">
        <div><b>${s.colors}</b><span>colour tokens</span></div><div><b>${s.textStyles}</b><span>text styles</span></div>
        <div><b>${s.atoms}</b><span>atoms</span></div><div><b>${s.molecules}</b><span>molecules</span></div><div><b>${s.organisms}</b><span>organisms</span></div>
        <div><b>${s.screens}</b><span>screens</span></div><div><b>${s.swiftLines.toLocaleString()}</b><span>lines of Swift</span></div>
      </section>
      <section class="stack">
        <span class="eyebrow">Atomic design</span>
        <h2 class="h2">Atoms make molecules, molecules make organisms</h2>
        <p class="lead">A chat row is an Avatar, an UnreadCount and Chips. The home list is chat rows. Screens use organisms only, so a change to an atom reaches every screen.</p>
        <div class="atomic">
          <div class="card"><span class="pill accent">Atoms</span>${pvHtml(atom, t)}<code class="small">EqualAvatar · EqualUnreadCount · EqualChip</code></div>
          <span class="arrow" aria-hidden="true">→</span>
          <div class="card"><span class="pill accent">Molecule</span>${pvHtml(mol, t)}<code class="small">EqualChatListItem</code></div>
          <span class="arrow" aria-hidden="true">→</span>
          <div class="card"><span class="pill accent">Organism</span>${pvHtml(org, t)}<code class="small">EqualChatList</code></div>
        </div>
      </section>
      <section class="split">
        <div class="stack">
          <span class="eyebrow">Foundations</span>
          <h2 class="h2">Tokens you can copy</h2>
          <p class="lead">${s.colors} colours with light and dark values, the file's 22 iOS text styles in DM Sans, spacing, radii, shadows and gradients. Click any swatch to copy its Swift name.</p>
          <div class="row"><a class="btn ghost" href="#/foundations/color">Colour</a><a class="btn ghost" href="#/foundations/typography">Typography</a><a class="btn ghost" href="#/foundations/icons">Icons</a></div>
        </div>
        <div class="stack">${codeBlock(`// tokens/tokens.json\n"text-action": { "light": "#00b140", "dark": "#baff29" }\n\n// python3 scripts/generate_tokens.py →\npublic static let textAction = Color.equalDynamic(light: 0x00B140, dark: 0xBAFF29)\n\n// In a view\nText("3:15 PM").equalTextStyle(.footnoteEm).foregroundStyle(EqualColor.textAction)`, "One source")}</div>
      </section>
      <section class="stack">
        <div class="title-row"><div class="stack" style="gap:8px"><span class="eyebrow">Screens</span><h2 class="h2">Real screens to start from</h2></div><a class="btn ghost" href="#/screens">See screens and flows →</a></div>
        <div class="screens-strip">${figmaScreens.map((x) => `<a href="#/screens/${x.slug}"><img class="phone-img" loading="lazy" src="${x.figma}" alt="${esc(x.name)} screen"><span>${esc(x.name)}</span></a>`).join("")}</div>
      </section>
      <section class="split">
        <div class="stack"><span class="eyebrow">Build</span><h2 class="h2">Compose a screen in a few lines</h2><p class="lead">Add the package, call <span class="inline-code">EqualFonts.register()</span> at launch, and build with organisms. Colours follow light and dark automatically.</p><div class="row"><a class="btn primary" href="#/start">Install the package</a></div></div>
        <div>${codeBlock(usage, "InboxView.swift")}</div>
      </section>
      ${footer()}
    </div>`;
  }

  function footer() {
    return `<footer class="foot"><span>Equal AI iOS Design System · built from the EQAI-iOS Figma (Oboarding/Paywall Changes).</span><span><a href="${esc(D.repo)}" target="_blank" rel="noopener">Source on GitHub</a> · <a href="#/start">Docs</a> · <a href="#/components">Components</a></span></footer>`;
  }

  function pageStart() {
    const install = `// Package.swift\ndependencies: [\n    .package(url: "${D.repo}.git", branch: "main")\n],\ntargets: [\n    .target(name: "YourApp", dependencies: [\n        .product(name: "EqualDesignSystem", package: "equal-ai-ios-design-system")\n    ])\n]`;
    const app = `import SwiftUI\nimport EqualDesignSystem\n\n@main\nstruct EqualApp: App {\n    init() { EqualFonts.register() }   // registers DM Sans from the package\n\n    var body: some Scene {\n        WindowGroup { HomeScreen() }\n    }\n}`;
    const tokens = `Text("Amit Nanda")\n    .equalTextStyle(.headlineEm)                 // DM Sans 18/22 semibold, -2.6%\n    .foregroundStyle(EqualColor.textPrimary)     // #111111 light · #F7F7F7 dark\n\nRoundedRectangle(cornerRadius: EqualRadius.m)    // 16\n    .fill(EqualColor.bgSurface)\n    .equalShadow(.card)\n    .padding(EqualSpacing.s24)                   // the screen gutter`;
    const tree = `equal-ai-ios-design-system/
├─ Package.swift                 EqualDesignSystem (iOS 17, macOS 14)
├─ tokens/tokens.json            the single source for every token
├─ Sources/EqualDesignSystem/
│  ├─ Tokens/                    generated: EqualColor, EqualTextStyle, EqualSpacing, EqualRadius, EqualShadow
│  ├─ Foundation/                colour helpers, fonts, typography, gradients, icons, images, logo, glass
│  ├─ Atoms/                     ${D.stats.atoms} atoms
│  ├─ Molecules/                 ${D.stats.molecules} molecules
│  ├─ Organisms/                 ${D.stats.organisms} organisms
│  ├─ Screens/                   ${D.stats.screens} screen templates
│  ├─ Catalog/                   EqualCatalogView: every entry, browsable in-app
│  └─ Resources/                 Fonts (DM Sans) · Images (only non-codable 3D renders, photos, screenshots)
├─ Examples/EqualCatalogApp/     an @main App that shows the catalog
├─ Tools/Snapshots/              swift run equal-snapshots → PNG renders of every entry
├─ design/                       Figma exports: screens, flows, images, SVG icons
├─ docs/                         brand book and component guidelines
├─ scripts/                      generate_tokens.py · build-web.mjs
└─ web/                          this site`;
    return `<div class="page">
      <div class="stack"><span class="eyebrow">Docs</span><h1 class="h1">Getting started</h1>
      <p class="lead">EqualDesignSystem is a Swift Package. It needs iOS 17 or later and has no dependencies.</p></div>
      <section class="stack"><h2 class="h3">1 · Add the package</h2><p class="prose">In Xcode choose <strong>File → Add Package Dependencies…</strong> and paste <code class="inline-code">${esc(D.repo)}</code>, or add it to <code class="inline-code">Package.swift</code>:</p>${codeBlock(install, "Package.swift")}</section>
      <section class="stack"><h2 class="h3">2 · Register the font</h2><p class="prose">DM Sans (variable, SIL OFL) ships inside the package. Call <code>EqualFonts.register()</code> once at launch. All text is DM Sans; SF Pro appears only inside SF Symbols icons.</p>${codeBlock(app, "EqualApp.swift")}</section>
      <section class="stack"><h2 class="h3">3 · Use tokens</h2><p class="prose">Colours are <code>EqualColor</code> (semantic ones switch with dark mode), text styles are <code>.equalTextStyle(_:)</code>, layout is <code>EqualSpacing</code> and <code>EqualRadius</code>, depth is <code>.equalShadow(_:)</code>, fills are <code>EqualGradient</code>.</p>${codeBlock(tokens, "Tokens")}</section>
      <section class="stack"><h2 class="h3">4 · Build from components</h2><p class="prose">Components are prefixed <code>Equal</code> so they never clash with SwiftUI. Screens are composed from <strong>organisms</strong>, organisms from <strong>molecules</strong>, molecules from <strong>atoms</strong>. Browse them on the <a href="#/components">components</a> page; every page has the usage and the full source.</p>
        <div class="grid c3">${["atoms", "molecules", "organisms"].map((lv) => `<a class="card" style="padding:18px;text-decoration:none" href="#/components"><b>${levelName[lv]}</b><p class="small" style="margin:6px 0 0">${D.components.filter((c) => c.level === lv).map((c) => c.name.replace(/^Equal/, "")).slice(0, 8).join(", ")}…</p></a>`).join("")}</div></section>
      <section class="stack"><h2 class="h3">5 · See everything in the catalog</h2><p class="prose"><code>EqualCatalogView()</code> lists every foundation, component and screen. <code>Examples/EqualCatalogApp</code> is a ready <code>@main</code> app: create an iOS App target in Xcode, add the package as a local dependency and use that file.</p>${codeBlock("WindowGroup {\n    EqualCatalogView()\n}", "Catalog")}</section>
      <section class="stack"><h2 class="h3">Repository layout</h2>${codeBlock(tree, "Tree", "plaintext")}</section>
      <section class="stack"><h2 class="h3">Change a token</h2><p class="prose">Edit <code>tokens/tokens.json</code>, then regenerate the Swift and this site:</p>${codeBlock("python3 scripts/generate_tokens.py      # Tokens/*.swift\nswift build                              # compile check\n./scripts/render-snapshots.sh            # SwiftUI renders + catalog manifest\nnode scripts/build-web.mjs               # web/data.js", "Terminal", "bash")}</section>
      ${footer()}
    </div>`;
  }

  function pageBrand() {
    return `<div class="page"><div class="stack"><span class="eyebrow">Docs</span><h1 class="h1">Brand book</h1><p class="lead">How Equal sounds and looks, and the rules every screen follows.</p></div><div class="prose">${md(D.brandBook)}</div>${footer()}</div>`;
  }

  // Foundations
  function colorGroups() {
    const g = { Semantic: [], Primitives: [], Gold: [], "Avatar tints": [], "iOS system": [] };
    let semantic = true;
    for (const t of D.tokens.color.tokens) {
      if (t.name === "brand-green") semantic = false;
      if (semantic) g.Semantic.push(t);
      else if (/^(brand|grey|red)-/.test(t.name)) g.Primitives.push(t);
      else if (/^avatar-/.test(t.name)) g["Avatar tints"].push(t);
      else if (/^ios-/.test(t.name)) g["iOS system"].push(t);
      else g.Gold.push(t);
    }
    return g;
  }
  function pageColor() {
    const groups = colorGroups();
    const sw = (t) => {
      const v = t.value; const light = typeof v === "string" ? v : v.light; const dark = typeof v === "string" ? null : v.dark;
      const name = "EqualColor." + camel(t.name);
      return `<button class="card swatch" type="button" data-copytext="${esc(name)}" title="Copy ${esc(name)}"><div class="chip checker">${dark && dark !== light ? `<i style="background:${light}"></i><i style="background:${dark}"></i>` : `<i class="solo" style="background:${light}"></i>`}</div><div class="info"><b>${esc(name)}</b><span>${esc(light)}${dark && dark !== light ? " · " + esc(dark) : ""}</span><p>${esc(t.usage)}</p></div></button>`;
    };
    return `<div class="page"><div class="stack"><span class="eyebrow">Foundations</span><h1 class="h1">Colour</h1><p class="lead">${D.tokens.color.tokens.length} tokens. Semantic colours come from the Figma "Allias" collection and switch between light (left half) and dark (right half). Reach primitives only through a semantic token. Click a swatch to copy its Swift name.</p></div>
      ${Object.entries(groups).map(([name, list]) => `<section class="stack"><h2 class="h3">${name} <span class="small">${list.length}</span></h2><div class="swatches">${list.map(sw).join("")}</div></section>`).join("")}
      <section class="stack"><h2 class="h3">In Swift</h2>${codeBlock("Text(\"Amit called to remind you\")\n    .foregroundStyle(EqualColor.textSecondary)\n\nCapsule()\n    .fill(EqualColor.unreadFill)\n    .overlay(Capsule().stroke(EqualColor.unreadStroke))\n\n// Semantic tokens are dynamic:\npublic static let bgPrimary = Color.equalDynamic(light: 0xF7F7F7, dark: 0x000000)", "Colour")}</section>
      ${footer()}</div>`;
  }
  function pageType() {
    const rows = D.tokens.type.groups.map((g) => `<section class="stack"><h2 class="h3">${esc(g.name)}</h2><p class="small">${esc(g.note || "")}</p><div>${g.styles.map((s) => {
      const fam = g.family === "system" ? "-apple-system, system-ui" : "'DM Sans', system-ui";
      const style = `font-family:${fam};font-size:${s.fontSize};line-height:${s.lineHeight};font-weight:${s.fontWeight};letter-spacing:${s.letterSpacing || 0};${s.fontStyle ? "font-style:" + s.fontStyle : ""}`;
      return `<div class="type-row"><div style="${style};white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${esc(s.sample || "Amit called to remind you about the meeting")}</div><div class="meta"><b>.${esc(camel(s.name))}</b>${parseInt(s.fontSize)}/${parseInt(s.lineHeight)} · ${s.fontWeight}${s.letterSpacing && s.letterSpacing !== "0em" ? " · " + s.letterSpacing : ""}<br>${esc(s.usage || "")}</div></div>`;
    }).join("")}</div></section>`).join("");
    return `<div class="page"><div class="stack"><span class="eyebrow">Foundations</span><h1 class="h1">Typography</h1><p class="lead">DM Sans everywhere, on the iOS Dynamic Type scale with -2.6% tracking. SF Pro only for iOS chrome.</p></div>
      ${codeBlock("Text(\"Choose your plan\").equalTextStyle(.title1Em)\nText(\"Amit Nanda\").equalTextStyle(.headlineEm)\nText(\"Call back\").font(.equal(.callout))\nText(\"₹499\").font(.equal(size: 22, weight: .bold))", "Typography")}${rows}${footer()}</div>`;
  }
  function pageLayout() {
    const sp = D.tokens.spacing.tokens.map((t) => `<div class="scale-row"><code>EqualSpacing.s${parseInt(t.value)}</code><div><div class="bar" style="width:${parseInt(t.value) * 4}px"></div></div><span class="muted">${esc(t.usage)}</span></div>`).join("");
    const rd = D.tokens.radius.tokens.map((t) => `<div class="scale-row"><code>EqualRadius.${camel(t.name.replace("radius-", ""))}</code><div><div class="radius-box" style="border-radius:${t.value === "9999px" ? "999px" : t.value}"></div></div><span class="muted">${esc(t.value)} · ${esc(t.usage)}</span></div>`).join("");
    const sh = D.tokens.shadow.tokens.map((t) => `<div class="scale-row"><code>.equalShadow(.${camel(t.name.replace("shadow-", ""))})</code><div style="padding:10px;background:#f7f7f7;border-radius:12px;width:max-content"><div class="shadow-box" style="box-shadow:${t.value}"></div></div><span class="muted">${esc(t.value)} · ${esc(t.usage)}</span></div>`).join("");
    const gr = D.tokens.gradient.tokens.map((t) => { const sw = camel(t.name.replace("gradient-", "")); return `<div class="card" style="padding:12px;display:flex;flex-direction:column;gap:8px"><div class="grad-box" style="background:${t.value}"></div><code style="font-size:12px">EqualGradient.${D.gradientNames.includes(sw) ? sw : sw}</code><span class="small">${esc(t.usage)}</span></div>`; }).join("");
    return `<div class="page"><div class="stack"><span class="eyebrow">Foundations</span><h1 class="h1">Spacing, radius & effects</h1><p class="lead">Content is 345pt wide on a 393pt iPhone with a 24pt gutter. Pills for actions, 16pt for cards, 28pt for sheet tops.</p></div>
      <section class="stack"><h2 class="h3">Spacing</h2><div>${sp}</div></section>
      <section class="stack"><h2 class="h3">Radius</h2><div>${rd}</div></section>
      <section class="stack"><h2 class="h3">Shadow</h2><div>${sh}</div></section>
      <section class="stack"><h2 class="h3">Gradients</h2><div class="grid c3">${gr}</div></section>
      ${footer()}</div>`;
  }
  function pageIcons() {
    const sf = D.icons.map((i) => `<tr><td><code>.${esc(i.swift)}</code></td><td><code>${esc(i.symbol)}</code></td></tr>`).join("");
    const svgs = D.svgIcons.map((f) => `<div class="card icon-cell"><img class="ink" loading="lazy" src="assets/Icons/${esc(f)}" alt=""><span>${esc(f.replace(".svg", ""))}</span></div>`).join("");
    return `<div class="page"><div class="stack"><span class="eyebrow">Foundations</span><h1 class="h1">Icons</h1><p class="lead">In SwiftUI, UI glyphs are SF Symbols through <span class="inline-code">EqualIcon</span>, so they scale with Dynamic Type and take the foreground colour. The original ${D.svgIcons.length} icons exported from Figma are below for reference and custom art.</p></div>
      ${codeBlock("EqualIconView(.phone, size: 20)\n    .foregroundStyle(EqualColor.green)\n\nEqualIcon.chevronRight.image   // Image(systemName: \"chevron.right\")", "Icons")}
      <section class="stack"><h2 class="h3">EqualIcon → SF Symbol</h2><div class="card table-wrap"><table class="table"><thead><tr><th>Swift</th><th>SF Symbol</th></tr></thead><tbody>${sf}</tbody></table></div></section>
      <section class="stack"><h2 class="h3">Figma originals (SVG)</h2><p class="small">In design/icons and web/assets/Icons. Single-ink in the colour they carry in the design.</p><div class="icon-grid">${svgs}</div></section>
      ${footer()}</div>`;
  }
  function pageIllustrations() {
    const cells = D.images.map((i) => `<div class="card icon-cell art-cell" title="${esc(i.doc || "")}"><img loading="lazy" src="assets/Bundle/${esc(i.file)}" alt=""><span>EqualImage.${esc(i.swift)}</span></div>`).join("");
    return `<div class="page"><div class="stack"><span class="eyebrow">Foundations</span><h1 class="h1">Illustrations & logos</h1><p class="lead">Only art that can’t be drawn in code ships as an image: ${D.images.length} 3D renders, photos and screenshots. Everything else (the logo, mark, app icon, flag, rings, rays, badges, glows, the UPI phone) is SwiftUI code.</p></div>
      ${codeBlock("EqualIllustration(.crown, size: 90)\nEqualImage.mascotCrown.image.aspectRatio(contentMode: .fit)\n\nEqualLogo(height: 22)                 // equal ai lockup\nEqualMark(size: 26, color: .white)    // six-dot mark", "Images")}
      <section class="stack"><h2 class="h3">Logos</h2><div class="grid c2"><div class="card" style="padding:28px;background:#fff"><img src="assets/Logos/equal-ai-logo.svg" alt="equal ai logo, green" style="height:40px"></div><div class="card" style="padding:28px;background:#00b140"><img src="assets/Logos/equal-ai-logo-white.svg" alt="equal ai logo, white" style="height:40px"></div></div></section>
      <section class="stack"><h2 class="h3">Bundled images</h2><div class="icon-grid" style="grid-template-columns:repeat(auto-fill,minmax(150px,1fr))">${cells}</div></section>
      ${footer()}</div>`;
  }

  // Components
  function previewFor(c) { return c.preview ? fromJs(c.preview.js) : () => h("div", { className: "eq-stage" }, "No preview"); }
  /** SwiftUI render used as the preview for components that exist only in Swift. */
  function snapHtml(c, theme, cls = "snap-preview") {
    if (!c.snapshot) return `<div class="${cls} empty">Renders in Xcode (text fields and scroll views can’t be drawn offline)</div>`;
    const src = theme === "dark" && c.snapshot.dark ? c.snapshot.dark : c.snapshot.light;
    return `<img class="${cls}" loading="lazy" src="${src}" alt="${esc(c.name)} rendered by SwiftUI">`;
  }
  function pageComponents() {
    const t = siteTheme();
    const section = (lv) => {
      const items = D.components.filter((c) => c.level === lv);
      return `<section class="stack"><h2 class="h3">${levelName[lv]} <span class="small">${items.length}</span></h2><div class="grid c3">${items.map((c) => {
        const stage = c.preview ? pvHtml(registerPv("card-" + c.slug, previewFor(c)), t) : snapHtml(c, t, "card-snap");
        return `<a class="card comp-card" href="#/components/${c.slug}"><div class="stage">${stage}</div><div class="meta"><b>${esc(c.name)}</b><span>${esc(c.short)}</span></div></a>`;
      }).join("")}</div></section>`;
    };
    return `<div class="page wide"><div class="stack"><span class="eyebrow">Components</span><h1 class="h1">Components</h1><p class="lead">${D.components.length} SwiftUI components in three levels. Every card is the component live; open one for its usage, full Swift source, SwiftUI render and guidelines.</p></div>
      ${section("atoms")}${section("molecules")}${section("organisms")}${footer()}</div>`;
  }

  function tokensUsed(src) {
    const out = [];
    const add = (re, fmt, href) => { for (const m of src.matchAll(re)) { const v = fmt(m[1]); if (!out.some((x) => x.v === v)) out.push({ v, href }); } };
    add(/EqualColor\.(\w+)/g, (n) => "EqualColor." + n, "#/foundations/color");
    add(/equalTextStyle\(\.(\w+)\)/g, (n) => "." + n, "#/foundations/typography");
    add(/EqualSpacing\.(\w+)/g, (n) => "EqualSpacing." + n, "#/foundations/layout");
    add(/EqualRadius\.(\w+)/g, (n) => "EqualRadius." + n, "#/foundations/layout");
    add(/EqualGradient\.(\w+)/g, (n) => "EqualGradient." + n, "#/foundations/layout");
    add(/equalShadow\(\.(\w+)\)/g, (n) => "shadow ." + n, "#/foundations/layout");
    return out;
  }

  function pageComponent(slug) {
    const i = D.components.findIndex((c) => c.slug === slug);
    if (i < 0) return pageNotFound();
    const c = D.components[i];
    const t = siteTheme();
    const key = c.preview ? registerPv("detail-" + c.slug, previewFor(c)) : null;
    const names = new Set(D.components.map((x) => x.name));
    const builtFrom = [...new Set([...c.source.matchAll(/\b(Equal[A-Z]\w+)\b/g)].map((m) => m[1]))].filter((n) => n !== c.name && names.has(n));
    const usedIn = D.components.filter((x) => x.name !== c.name && new RegExp("\\b" + c.name + "\\b").test(x.source)).map((x) => ({ name: x.name, href: "#/components/" + x.slug }))
      .concat(D.screens.filter((s) => new RegExp("\\b" + c.name + "\\b").test(s.source)).map((s) => ({ name: s.name, href: "#/screens/" + s.slug })));
    const uniqUsed = usedIn.filter((u, k) => usedIn.findIndex((x) => x.name === u.name) === k);
    const tok = tokensUsed(c.source);
    const prev = D.components[i - 1], next = D.components[i + 1];
    const renderPair = c.snapshot && c.snapshot.light ? `<div class="snap-pair"><figure><img loading="lazy" src="${c.snapshot.light}" alt="${esc(c.name)} rendered by SwiftUI, light"><figcaption>SwiftUI · light</figcaption></figure>${c.snapshot.dark ? `<figure><img loading="lazy" src="${c.snapshot.dark}" alt="${esc(c.name)} rendered by SwiftUI, dark"><figcaption>SwiftUI · dark</figcaption></figure>` : ""}</div><p class="small">Rendered from the Swift source with SwiftUI’s ImageRenderer, in DM Sans.</p>` : "";
    return `<div class="page">
      <div class="crumbs"><a href="#/components">Components</a><span>/</span><span>${levelName[c.level]}</span></div>
      <div class="title-row"><div class="stack" style="gap:10px"><h1 class="h1" style="font-size:clamp(30px,4vw,44px)">${esc(c.name)}</h1><div class="row"><span class="pill accent">${levelName[c.level].replace(/s$/, "")}</span>${c.file ? `<a class="pill" href="${ghFile(c.file)}" target="_blank" rel="noopener">${esc(c.file.replace("Sources/EqualDesignSystem/", ""))} ↗</a>` : ""}</div></div></div>
      <p class="lead">${inlineMd(c.summary)}</p>
      ${key ? `<section class="card preview-panel" aria-label="Live preview">
        <div class="preview-bar"><span class="small">Live preview (web)</span><div class="seg" role="group" aria-label="Preview theme"><button type="button" data-pvtheme="light">Light</button><button type="button" data-pvtheme="dark">Dark</button><button type="button" data-pvtheme="both">Both</button></div></div>
        <div class="preview-body" id="pv-body" data-key="${key}">${pvHtml(key, t)}</div>
      </section>` : `<section class="card preview-panel" aria-label="SwiftUI render">
        <div class="preview-bar"><span class="small">Rendered by SwiftUI</span></div>
        <div class="snap-body">${c.snapshot ? `<figure>${snapHtml(c, "light")}<figcaption>Light</figcaption></figure>${c.snapshot.dark ? `<figure>${snapHtml(c, "dark")}<figcaption>Dark</figcaption></figure>` : ""}` : snapHtml(c, "light")}</div>
      </section>`}
      <section class="stack">
        <div class="tabs" role="tablist"><button type="button" role="tab" class="on" data-tab="usage">Usage</button><button type="button" role="tab" data-tab="source">Source</button>${renderPair && key ? `<button type="button" role="tab" data-tab="render">SwiftUI render</button>` : ""}</div>
        <div data-panel="usage">${codeBlock(c.usage, "Usage")}</div>
        <div data-panel="source" hidden>${codeBlock(c.source, c.file ? c.file.split("/").pop() : "Source")}</div>
        ${renderPair && key ? `<div data-panel="render" hidden>${renderPair}</div>` : ""}
      </section>
      ${c.guidelines ? `<section class="stack"><h2 class="h3">Guidelines</h2><div class="prose">${md(c.guidelines)}</div></section>` : ""}
      <section class="grid c3">
        <div class="stack"><h2 class="h3" style="font-size:16px">Built from</h2><div class="chips">${builtFrom.length ? builtFrom.map((n) => `<a class="pill" href="#/components/${D.components.find((x) => x.name === n).slug}">${esc(n)}</a>`).join("") : '<span class="small">Tokens only</span>'}</div></div>
        <div class="stack"><h2 class="h3" style="font-size:16px">Used in</h2><div class="chips">${uniqUsed.length ? uniqUsed.map((u) => `<a class="pill" href="${u.href}">${esc(u.name)}</a>`).join("") : '<span class="small">Not used by other components yet</span>'}</div></div>
        <div class="stack"><h2 class="h3" style="font-size:16px">Tokens</h2><div class="chips">${tok.slice(0, 18).map((x) => `<a class="pill" href="${x.href}">${esc(x.v)}</a>`).join("") || '<span class="small">—</span>'}</div></div>
      </section>
      <nav class="pager" aria-label="Previous and next">${prev ? `<a class="card" href="#/components/${prev.slug}"><small>Previous</small>${esc(prev.name)}</a>` : "<span></span>"}${next ? `<a class="card" href="#/components/${next.slug}"><small>Next</small>${esc(next.name)}</a>` : "<span></span>"}</nav>
      ${footer()}</div>`;
  }

  // Screens
  function pageScreens() {
    const card = (s) => `<a class="card screen-card" href="#/screens/${s.slug}"><div class="imgs"><div>${s.figma ? `<img loading="lazy" src="${s.figma}" alt="Figma: ${esc(s.name)}">` : "State built from the flow (no single frame)"}</div><div>${s.snapshot ? `<img loading="lazy" src="${s.snapshot}" alt="SwiftUI: ${esc(s.name)}">` : "Run in Xcode"}</div></div><b>${esc(s.name)}</b><span class="small">${esc(s.summary)} · <code>${esc(s.swiftName)}</code></span></a>`;
    const cards = screenGroups().map(([g, list]) => `<section class="stack"><h2 class="h3">${esc(g)} <span class="small">${list.length}</span></h2><div class="grid c4">${list.map(card).join("")}</div></section>`).join("");
    const flows = D.flows.map((f) => `<figure class="flow" style="margin:0"><img loading="lazy" src="assets/Flows/${esc(f)}" alt="${esc(f.replace(/[-.]/g, " "))}"><figcaption class="small" style="margin-top:6px">${esc(f.replace("flow-", "").replace(".png", "").replace(/-/g, " "))}</figcaption></figure>`).join("");
    return `<div class="page wide"><div class="stack"><span class="eyebrow">Screens</span><h1 class="h1">Screens & flows</h1><p class="lead">${D.screens.length} screens and states, composed from organisms and grouped by flow. Each card shows the Figma frame (left) and the SwiftUI render (right).</p></div>
      ${cards}
      <section class="stack" id="flows"><h2 class="h2">Flow boards</h2><p class="lead">The flows from the Figma page: free trial to Gold, the Gold limit upgrade, UPI payment, settings states and the soft paywall.</p><div class="stack">${flows}</div></section>
      ${footer()}</div>`;
  }
  function pageScreen(slug) {
    const s = D.screens.find((x) => x.slug === slug);
    if (!s) return pageNotFound();
    return `<div class="page">
      <div class="crumbs"><a href="#/screens">Screens</a><span>/</span><span>${esc(s.name)}</span></div>
      <div class="stack" style="gap:10px"><h1 class="h1" style="font-size:clamp(30px,4vw,44px)">${esc(s.name)}</h1><div class="row"><span class="pill accent">Screen</span>${s.file ? `<a class="pill" href="${ghFile(s.file)}" target="_blank" rel="noopener">${esc(s.file.replace("Sources/EqualDesignSystem/", ""))} ↗</a>` : ""}</div></div>
      <p class="lead">${esc(s.summary)}</p>
      <div class="screen-compare">
        <figure>${s.figma ? `<img src="${s.figma}" alt="Figma frame: ${esc(s.name)}">` : '<div class="empty">This state has no single frame in the Figma page; see the flow boards.</div>'}<figcaption>Figma</figcaption></figure>
        <figure>${s.snapshot ? `<img src="${s.snapshot}" alt="SwiftUI render: ${esc(s.name)}">` : '<div class="empty">This screen scrolls or takes input, which ImageRenderer cannot draw. Run it in Xcode or open it in EqualCatalogView.</div>'}<figcaption>SwiftUI (${esc(s.swiftName)})</figcaption></figure>
      </div>
      <section class="stack"><h2 class="h3">Composed of</h2><div class="chips">${s.composedOf.map((n) => `<a class="pill" href="#/components/${D.components.find((x) => x.name === n).slug}">${esc(n)}</a>`).join("") || '<span class="small">Wraps another screen or organism.</span>'}</div></section>
      <section class="stack"><h2 class="h3">Usage</h2>${codeBlock(s.usage, "Usage")}</section>
      <section class="stack"><h2 class="h3">Source</h2>${codeBlock(s.source, s.file ? s.file.split("/").pop() : "Source")}</section>
      ${footer()}</div>`;
  }
  function pageNotFound() { return `<div class="page"><h1 class="h1">Not found</h1><p class="lead">That page doesn't exist. <a href="#/">Go home</a>.</p></div>`; }

  // ── router ────────────────────────────────────────────────
  function route() {
    unmount();
    let hash = location.hash.replace(/^#/, "");
    if (hash === "main") return;
    let anchor = null;
    if (hash.includes("#")) { [hash, anchor] = hash.split("#"); }
    const parts = hash.replace(/^\//, "").split("/").filter(Boolean);
    let html, side = "", nav = parts[0] || "";
    if (!parts.length) { html = pageHome(); }
    else if (parts[0] === "start") { html = pageStart(); side = sideDocs("start"); }
    else if (parts[0] === "brand") { html = pageBrand(); side = sideDocs("brand"); nav = "start"; }
    else if (parts[0] === "foundations") {
      const p = parts[1] || "color";
      html = { color: pageColor, typography: pageType, layout: pageLayout, icons: pageIcons, illustrations: pageIllustrations }[p]?.() ?? pageNotFound();
      side = sideDocs("foundations/" + p);
    }
    else if (parts[0] === "components") { html = parts[1] ? pageComponent(parts[1]) : pageComponents(); side = sideComponents(parts[1]); }
    else if (parts[0] === "screens") { html = parts[1] ? pageScreen(parts[1]) : pageScreens(); side = sideScreens(parts[1]); }
    else html = pageNotFound();

    $shell.classList.toggle("full", !side);
    $side.innerHTML = side;
    $side.classList.remove("open");
    document.querySelector(".menu-btn").setAttribute("aria-expanded", "false");
    $main.innerHTML = html;
    document.querySelectorAll("[data-nav]").forEach((a) => a.classList.toggle("on", a.dataset.nav === nav));
    const title = $main.querySelector("h1")?.textContent;
    document.title = parts.length && title ? `${title} · Equal AI iOS Design System` : "Equal AI iOS Design System";
    mountAll($main);
    highlight($main);
    syncPvSeg();
    if (anchor) document.getElementById(anchor)?.scrollIntoView(); else window.scrollTo(0, 0);
    const search = document.getElementById("side-search");
    if (search) search.addEventListener("input", () => {
      const q = search.value.trim().toLowerCase();
      $side.querySelectorAll("a[data-name]").forEach((a) => { a.hidden = q && !a.dataset.name.includes(q); });
    });
    const active = $side.querySelector("a.on"); if (active && active.scrollIntoView && parts[1]) active.scrollIntoView({ block: "nearest" });
  }

  function syncPvSeg() {
    const body = document.getElementById("pv-body"); if (!body) return;
    const mode = body.classList.contains("both") ? "both" : body.querySelector(".pv")?.dataset.theme;
    document.querySelectorAll("[data-pvtheme]").forEach((b) => b.classList.toggle("on", b.dataset.pvtheme === mode));
  }

  // ── events ────────────────────────────────────────────────
  document.addEventListener("click", (e) => {
    const t = e.target.closest("button, a"); if (!t) return;
    if (t.dataset.copy) { copy(codes[t.dataset.copy]); return; }
    if (t.dataset.copytext) { copy(t.dataset.copytext); return; }
    if (t.dataset.themeSet) { setTheme(t.dataset.themeSet); route(); return; }
    if (t.dataset.tab) {
      const sec = t.closest("section");
      sec.querySelectorAll("[data-tab]").forEach((b) => b.classList.toggle("on", b === t));
      sec.querySelectorAll("[data-panel]").forEach((p) => { p.hidden = p.dataset.panel !== t.dataset.tab; });
      return;
    }
    if (t.dataset.pvtheme) {
      const body = document.getElementById("pv-body"); const key = body.dataset.key; const m = t.dataset.pvtheme;
      roots.forEach((r) => { if (body.contains(r._el)) { try { r.unmount(); } catch {} } });
      body.innerHTML = m === "both" ? pvHtml(key, "light") + pvHtml(key, "dark") : pvHtml(key, m);
      body.classList.toggle("both", m === "both");
      mountAll(body); syncPvSeg(); return;
    }
    if (t.classList.contains("menu-btn")) { const open = !$side.classList.contains("open"); $side.classList.toggle("open", open); t.setAttribute("aria-expanded", String(open)); if (!$side.innerHTML.trim()) $side.innerHTML = sideDocs(""); }
  });

  document.getElementById("gh-link").href = D.repo;
  setTheme(store.get("eq-theme") || "dark");
  window.addEventListener("hashchange", route);
  route();
})();
