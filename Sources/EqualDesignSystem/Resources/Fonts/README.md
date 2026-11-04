# Fonts

Drop the DM Sans font files here (from https://fonts.google.com/specimen/DM+Sans, SIL Open Font License):

- `DMSans-VariableFont_opsz,wght.ttf`
- `DMSans-Italic-VariableFont_opsz,wght.ttf`

`EqualFonts.register()` registers every `.ttf` / `.otf` in this folder at launch. Until the files are added, text falls back to the system font (SF Pro) at the same sizes, weights and tracking.
