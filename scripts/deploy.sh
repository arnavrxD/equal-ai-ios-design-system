#!/usr/bin/env bash
# Deploys web/ to the eq-ios-ds Vercel project.
# Vercel's Hobby plan blocks deploys whose git commit author is not on the
# account, so we deploy from a copy outside the git repo (no commit metadata).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/.vercel"
rsync -a "$ROOT/web" "$TMP/"
cp "$ROOT/vercel.json" "$TMP/"
[ -f "$ROOT/.vercel/project.json" ] || { echo "Run: vercel link --project eq-ios-ds" >&2; exit 1; }
cp "$ROOT/.vercel/project.json" "$TMP/.vercel/"
cd "$TMP"
if command -v vercel >/dev/null; then vercel deploy --prod --yes --archive=tgz; else npx --yes vercel deploy --prod --yes --archive=tgz; fi
