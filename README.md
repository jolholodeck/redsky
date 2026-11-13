# Red Sky Interactive archive

Restoration of Red Sky Interactive's interactive work for the web: the 1998 demo CD, the 1997
demo CD (Gypsy Wagon), Absolut DJ, the Millennium Clock, the Miller Lite Beer Pager, Sutter Home
MoodMaker, Bandai DataZord and the Spider-Man teaser.

| Folder | What it holds |
| --- | --- |
| `works/<slug>/` | Every other work: `original/` as received (never edited), `decompiled/` (unprotected movies and Lingo), `converted/` (MP4 and WAV made from QuickTime and AIFF), `extracted/` (Shockwave movies cut out of projectors). Built with `tools/build_work.py` or `tools/build_web_work.py`. |
| `original/` | The 1998 CD exactly as received (Mac and Windows files). `__MACOSX/` holds the Mac resource forks, including the Mac projector's code and Xtras. Never edited. |
| `decompiled/` | Unprotected Director files (`.dir`, `.cst`) and recovered Lingo source (`.ls`), made with ProjectorRays (commit 6f9bceb). `MAIN/` is the startup movie cut out of the Mac projector. |
| `assets/` | Every bitmap (PNG, original palettes) and sound (WAV) extracted per movie, with a `manifest.json` per movie. |
| `analysis/` | `timing.json`: per-movie score data (tempo, waits, transitions, palette and sound cues) and timing-related Lingo counts. |
| `players/<module>/` | Each module's own copy of the DirPlayer player: `dirplayer.patch` (changes from upstream DirPlayer) and `FIXES.md` (what each fix was for). Built with `tools/player.sh`. |
| `emulator/` | The upstream DirPlayer commit, `base.patch` (the shared player every module started from) and the toolchain. |
| `site/` | The playable site: `index.html` (the collection), `work.html` (one work), `play.html` (the player), `works.json` (titles, years, start movies), `w/<slug>/` (each work's files, gzipped), `players/<slug>/` (each module's built player), `beatnik/` (the Beatnik engine), `shared/`. Published to GitHub Pages. |
| `tools/` | Extraction, analysis and test scripts. |

## Working together

The work is split by module: one GitHub issue per module holds its status and who has it checked out. `CLAUDE.md` has the workflow.

## Run locally

`cd site && python3 -m http.server 8098`, then open http://localhost:8098/.
Opening `index.html` directly does not work; browsers block it.

## Rules

- `original/` and `decompiled/` are never edited.
- Fixes live in the emulator patch and in per-piece settings; replacement assets sit beside the originals.
- Every change from the original is logged per piece.
