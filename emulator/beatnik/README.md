# Beatnik music

Four works (MoodMaker, DataZord, Beer Pager, Spider-Man Teaser) used the Beatnik Xtra, a
1990s Director plug-in that played RMF songs and live MIDI notes with Headspace's own
instruments. No browser has it, so the archive runs **NeoBAE**, the open-source Beatnik
Audio Engine (github.com/zefie/miniBAE, commit in `NEOBAE_COMMIT`; Beatnik's code is
BSD-3, NeoBAE's changes LGPL-3.0), compiled to WebAssembly.

| File | What it is |
|---|---|
| `rsbae.c` | A small interface to NeoBAE: many songs in one mixer, RMF/MIDI loading, noteOn/noteOff with bank and program, controllers, track mutes, volume |
| `emscripten-shim.h` | Lets NeoBAE's WASM platform layer build without Emscripten |
| `build.sh` | Builds `bae.wasm` with zig (`pip install ziglang`) for wasm32-wasi |

In the site: `site/beatnik/bae.wasm` (the engine), `rsbae.js` (loads it without Emscripten),
`beatnik.js` (the stand-in for the Xtra's Lingo methods: play, stop, setVolume, noteOn,
noteOff, playNote, setController, getController, setTrackMute, fadeFromTo...), and
`patches.hsb`, NeoBAE's General MIDI bank, standing in for the Beatnik bank each
computer had installed. The player routes `new(xtra "Beatnik")` and calls on it to these
through `window.__rsXtra` (see `jsbridge.rs` in the player patch).

## Fixes

| Date | Symptom | Cause and change |
|---|---|---|
| 2026-11-13 | Garbled, stuttering music and sounds in every Beatnik work | `BAE_BuildMixerSlice` renders exactly one mixer slice (about 11 ms) however many frames it's asked for. `rs_render` asked for up to 4096 frames in one call, so most of each block was the previous block's audio repeated. `rs_render` now renders whole slices in a loop and reports how many frames it made (`rs_rendered`); `rsbae.js` returns exactly those. |
| 2026-11-13 | (tool) | `rs_master(percent)` added, for setting the mixer's master volume. |
