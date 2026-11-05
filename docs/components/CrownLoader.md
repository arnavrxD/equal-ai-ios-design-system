# CrownLoader

The payment loader: the large `EqualRingLoader` (160pt frame, 133pt ring, 6.65pt `#5E460C` quarter arc on a black 12% track; dark `#C88D00` on white 18%) with the 3D crown (`EqualImage.crown`, 90pt at the 160 size) in the centre. It sits at the top of "Activating Equal Gold" and "Processing payment".

- Pass: `size` (default 160; the crown and ring scale with it).
- States: spinning; still under Reduce Motion.
- Do keep it at 160 on the wait screens. Don't put another image in it: for other content use `EqualRingLoader` with your own centre view.
