# ProfileAvatarBadge

The Settings profile avatar (Figma 26242:90523 / 26242:91747): the 3D avatar inside a coded gold scalloped star while the plan is active or on trial, or inside a 78pt `#00B140` circle once it has expired. The head is left unmasked so it pokes out of the top edge. Both badges are drawn with `EqualScallopedStar` and `Circle`; only the avatar is an image.

- Variants: `.gold` (78×88: back star with a 2.1pt dark-gold outline, front star filled cream → gold) and `.expired` (78×82 green circle).
- The consumer passes the style and, optionally, the avatar `EqualImage` (default `.avatarMale`).
- Do use it in `EqualProfileHeader` or other profile surfaces; it is sized to the Figma 78pt grid.
- Don't scale it with `.scaleEffect` for other sizes or swap the star for an image; ask for a size parameter instead.
