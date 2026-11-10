# DirPlayer, patched for Red Sky 98

Upstream: https://github.com/igorlira/dirplayer-rs at commit 68376fbb4494a6bbad4c70081ecdcb99814a74c9.
`dirplayer-redsky.patch` holds every change. Each is marked "Red Sky preservation build" in the source.

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

## Build

The Rust standard library has to be built from source for WebAssembly when rustup can't download it:

1. Check out upstream at the commit above and `git apply dirplayer-redsky.patch`.
2. Put Rust's `library/` source for your rustc version at `$(rustc --print sysroot)/lib/rustlib/src/rust/library`.
3. In `vm-rust/.cargo/config.toml`: `[unstable] build-std = ["std","panic_abort"]`.
4. Run `tools/buildvm.sh` (cargo + wasm-bindgen 0.2.108 + vite). Copy `dist-polyfill/dirplayer-polyfill.js`, gzipped, to `site/dirplayer-polyfill.js.gz`.

With a normal rustup install, step 2 and 3 are replaced by `rustup target add wasm32-unknown-unknown`.
