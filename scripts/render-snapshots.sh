#!/bin/sh
# Renders every catalog entry with SwiftUI and lists renders that came out blank
# (ImageRenderer cannot draw text fields or scroll views), so the site skips them.
set -e
cd "$(dirname "$0")/.."
rm -f web/snapshots/*.png web/snapshots/*.webp
swift run equal-snapshots web/snapshots
python3 - <<'PY'
import glob, json, os
from PIL import Image, ImageChops
blank = []
for f in sorted(glob.glob("web/snapshots/*.png")):
    im = Image.open(f).convert("RGB")
    bg = Image.new("RGB", im.size, im.getpixel((2, 2)))
    diff = ImageChops.difference(im, bg).convert("L").point(lambda v: 255 if v > 12 else 0)
    if diff.histogram()[255] < im.width * im.height * 0.0015:
        blank.append(os.path.basename(f).replace(".png", ".webp"))
    im.save(f.replace(".png", ".webp"), "WEBP", quality=84, method=6)
    os.remove(f)
json.dump(blank, open("web/snapshots/blank.json", "w"), indent=1)
print(f"{len(blank)} blank renders skipped")
PY
