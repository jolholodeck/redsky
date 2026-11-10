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

## Build

The Rust standard library has to be built from source for WebAssembly when rustup can't download it:

1. Check out upstream at the commit above and `git apply dirplayer-redsky.patch`.
2. Put Rust's `library/` source for your rustc version at `$(rustc --print sysroot)/lib/rustlib/src/rust/library`.
3. In `vm-rust/.cargo/config.toml`: `[unstable] build-std = ["std","panic_abort"]`.
4. Run `tools/buildvm.sh` (cargo + wasm-bindgen 0.2.108 + vite). Copy `dist-polyfill/dirplayer-polyfill.js`, gzipped, to `site/dirplayer-polyfill.js.gz`.

With a normal rustup install, step 2 and 3 are replaced by `rustup target add wasm32-unknown-unknown`.
