# Red Sky 98

Restoration of the 1998 Red Sky Interactive demo CD (Adobe Director 6) for the web,
for the future Red Sky archive site.

| Folder | What it holds |
| --- | --- |
| `original/` | The CD exactly as received (Mac and Windows files). `__MACOSX/` holds the Mac resource forks, including the Mac projector's code and Xtras. Never edited. |
| `decompiled/` | Unprotected Director files (`.dir`, `.cst`) and recovered Lingo source (`.ls`), made with ProjectorRays (commit 6f9bceb). `MAIN/` is the startup movie cut out of the Mac projector. |
| `assets/` | Every bitmap (PNG, original palettes) and sound (WAV) extracted per movie, with a `manifest.json` per movie. |
| `analysis/` | `timing.json`: per-movie score data (tempo, waits, transitions, palette and sound cues) and timing-related Lingo counts. |
| `emulator/` | Our patch to DirPlayer (github.com/igorlira/dirplayer-rs, commit 68376fbb4494) and how to build it. |
| `site/` | The playable site: index, player page, gzipped movies, and the built player. Published to GitHub Pages. |
| `tools/` | Extraction, analysis and test scripts. |

Plan and piece tracker: the "Red Sky 98 Restoration Plan" doc.

## Run locally

`cd site && python3 -m http.server 8098`, then open http://localhost:8098/.
Opening `index.html` directly does not work; browsers block it.

## Rules

- `original/` and `decompiled/` are never edited.
- Fixes live in the emulator patch and in per-piece settings; replacement assets sit beside the originals.
- Every change from the original is logged per piece.
