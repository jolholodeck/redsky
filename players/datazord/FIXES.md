# Power Rangers DataZord: player fixes

This module's own copy of the DirPlayer player. `dirplayer.patch` is every change from upstream
DirPlayer (commit in `emulator/UPSTREAM_COMMIT`); the built player is
`site/players/datazord/dirplayer-polyfill.js.gz`. Only this module loads it.

One line per fix: what was wrong (the symptom) and the Director feature behind it, so a search
by either finds it. Newest first. Fixes copied from another module's player say where from.

## Fixes made for this module

| Date | Who | Symptom | Director feature and change |
| --- | --- | --- | --- |

## Inherited from the shared player (2026-11-13)

Every module's player started as the same build. These fixes were made before the split; the
"Why" column names the piece that needed each one.

| Change | Why |
| --- | --- |
| `the colorDepth` reports 8 | The CD quits unless the screen is 256 colors |
| `the searchPath`, `the pathName`, idle-load properties | Director 4/5 properties the CD uses |
| Unknown built-in handlers warn instead of failing | `puppetPalette`, `finishIdleLoad`, `quit` and others |
| `sound close`, `the volume of sound n` | Director 6 sound commands |
| Old movie paused while the next one loads | Its idle handler spun on cleared globals |
| Surviving objects re-pointed to same-named casts after a movie switch | Manager objects ran the wrong scripts |
| Hardware probes stubbed (latency, CPU, load tests) | They busy-wait forever in a browser |
| `sound playFile` with external files via a JS bridge | The CD's loose AIFF music and voices |
| `the lastClick`, `lastKey`, `lastEvent`, `colorQD` | Menu buttons ignored every click |
| `abs()` on points, `offset(rect, h, v)` | Absolut and the fade-to-black |
| Unpuppeting keeps a sprite's score behaviors | Work menu rows and buttons lost their scripts |
| `the quickTimePresent` reports 0 | Pieces take their non-QuickTime path |
| `rs_debug_channel` export | Debugging score behaviors |
| Score tempo waits: wait N seconds (247), wait for click (248), wait until a score sound ends (254 = first sound row, 255 = second) | 51 timed waits and 15 sound waits were ignored, so scenes rushed |
| Frame rate carried through wait frames | Playback dropped to the movie default after every wait |
| Score sound cues read the full cast library + 16-bit member | Sounds outside cast 1 (most pieces) played the wrong member or a bitmap |
| `puppetPalette` sent to the page as stage brightness (`__rsStageFilter`), with fade time from speed/frames | Film flicker pulse (Palette2, about +6%) and palette fades |
| `updateStage` paced to 30 per second, yielding so each frame shows (`window.__rsUpdateStageMinMs` overrides, 0 disables) | Lingo animation loops ran at CPU speed and showed no in-between frames |
| `play frame X` / `play done` with a return stack; from an input handler the caller waits until `play done`, so the Lingo after `play` runs on return | Entertainment's rapid-click film burn and projectionist never started, and the flicker/cowboy restart ran during it |
| `do "go to the frame+1"`: `go` destinations in evaluated strings are full expressions | Animation callbacks that step the playhead stopped the movie with a parse error |
| puppetPalette on a frame with a built-in palette is measured against the nearest cast palette (e.g. Palette2 vs Palette1) | The Entertainment flicker was far too dark on the cowboy scene |
| Per-piece speed overrides: `site/speeds.json`, read through `window.__rsTempoOverride` | Score sections authored "as fast as possible" flash by on modern machines |
| `puppetSprite(n, 0)` on a channel with a Score span hands it back to the Score on the next tick: member, position, size, ink and blend return to the Score's values; behaviors stay | Transient sprites froze on their last frame (the bottle's "Red Sky Work" arrow, the cowboy/pig toggle, the background cowboy and pig) |
| Rollover events (mouseEnter/Within/Leave) go to the front-most *active* sprite (with a behavior or cast member script), and reach cast member scripts | Entertainment's dust kicks: two hidden puff-zone bitmaps under the unscripted backdrop never saw the pointer |
| `abort` ends an evaluated command quietly | Starting a module through the front door (`play.html?via=`) showed a "Script error: abort" alert |
| Xtras implemented by the page (`jsbridge.rs`): `new(xtra "Beatnik")`, DirectConnection, FileXtra; instance calls, old-style global calls (`play(gxBeatnik, 0, "UI.rmf")`) and static functions (`FileExists`, `DirectoryToList`) go to `window.__rsXtra*` | MoodMaker, DataZord, Beer Pager and Spider-Man stopped at "Xtra not found"; music silent |
| QuickTime members (`rs_video.rs`): a DigitalVideo member type with fileName and duration; movieRate, movieTime, stopTime, volume on sprites; each frame the page is told where video sprites are and plays them as MP4 in a `<video>` over the stage | Gypsy Wagon's Nike and Sony pieces, the 1998 CD's Sony Vaio and @Home clips showed nothing |
| Old-style async Xtra calls (`openFile(xFile, name, mode)`) take the async path | FileIO calls as globals failed with "should be handled by async handler" |
| `the short/long/abbreviated date`, `the short/long time` | Beer Pager stopped at startup |
| `set the foreColor/backColor of member` on fields | Spider-Man's text fields |
| Arithmetic on palette-index colors (`the foreColor of sprite n - 1`) | DataZord |
| Generic member properties answer neutral values (`the size` of a script, `the width` of a palette) | Spider-Man, DataZord |
| `the mouseCast` | Gypsy Wagon's Nike Products |
| Sprite trails stay on the stage until something repaints them, and sit under the trails sprites rather than under everything (software and WebGL renderers) | Gypsy Wagon's menus, written stroke by stroke with a trails pen |
| `new(script "Other")` inside a script with its own `new` makes a fresh instance of the other script | Gypsy Wagon's menu pages were all one object, so menus crashed |
| Empty text and script-context chunks load as empty instead of stopping the player | Gypsy Wagon's Bank of America demo |
| Script errors print the script and handler name to the browser console; `alert` messages too | Debugging |
| `quit()` hands back to the page, which returns to the work's page | DataZord's exit, any piece that quits |
| `the colorDepth` comes from the page (`colorDepth` in works.json, default 8) | Beer Pager refused to run in 256 colours and then waited forever in its dialog |
| Buddy API answers as a late-90s Windows PC: `baCpuInfo("type")` 6, `baVersion("os")` "4.10", `baDiskInfo` 4 GB free | DataZord's system check quit at startup |
| `the fileName of castLib` gives back the path exactly as a script set it | DataZord checks it after linking each module's cast |
| `the quad of sprite`: sprites are drawn at their four corners (WebGL renderer), report the quad's bounding box as their rect, and read the quad back | Spider-Man's web, which is ten bitmaps stretched between moving nodes |
| GLU32 (calls into Windows DLLs) answered by the page: no proxy | Beer Pager's proxy lookup |
