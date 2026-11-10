# Changes from the 1998 CD

Every change to the original art, sound or code is listed here. The untouched CD is in `original/`.

## Score and timing

| Piece | Frames | What changed | Why |
|---|---|---|---|
| Entertainment (`entertainment_module/entertainment.dir`) | 75–86, sprite 100 | Full-screen shape colour index 48 → 255 (black) | Showed as a lavender band left of the tilted film strip (sprocket3) during the film burn |
| Entertainment | 75–82 | Played at 12 fps (`site/speeds.json`) | The blurred film rushing through the gate was authored "as fast as possible" and was gone in a blink |

## Replaced art

| Piece | Members | What changed | How |
|---|---|---|---|
| Clay demo (`work_module/plumb_loco/clay_demo/clay_demo6.dir`) | Internal 722–727, "main light 1 PICT.00000"–".00005" (score frames 162–171) | Lighting frames retouched by Joel in Photoshop, same size and palette | Written back into the movie with `tools/replace_bitmap.py` |

To replace more art: edit the exported PNG in `assets/`, keeping its size and its 256-colour palette, then run
`python3 -I tools/replace_bitmap.py <movie.dir> <member>=<edited.png> ...`, re-gzip the movie into `site/rs/`, and add a row above.
