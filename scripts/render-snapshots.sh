#!/bin/sh
# Renders every catalog entry with SwiftUI and lists renders that came out blank
# (ImageRenderer cannot draw text fields or scroll views), so the site skips them.
set -e
cd "$(dirname "$0")/.."
rm -f web/snapshots/*.png
swift run equal-snapshots web/snapshots
python3 - <<'PY'
import glob, json, os
from PIL import Image, ImageStat
blank = []
for f in sorted(glob.glob("web/snapshots/*.png")):
    im = Image.open(f).convert("RGB")
    st = ImageStat.Stat(im.resize((64, 64)))
    if max(st.stddev) < 6:
        blank.append(os.path.basename(f))
    im.save(f, optimize=True)
json.dump(blank, open("web/snapshots/blank.json", "w"), indent=1)
print(f"{len(blank)} blank renders skipped")
PY
