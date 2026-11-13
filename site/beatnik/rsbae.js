// rsbae.js -- load the NeoBAE engine (bae.wasm) without Emscripten. Works in browsers and Node.
(function (root) {
  async function createBae(wasmBytes, { onLog } = {}) {
    let mem;
    const u8 = () => new Uint8Array(mem.buffer), dv = () => new DataView(mem.buffer);
    const wasi = {
      fd_write(fd, iovs, n, nwritten) {
        let total = 0, text = '';
        for (let i = 0; i < n; i++) { const p = dv().getUint32(iovs + i * 8, true), l = dv().getUint32(iovs + i * 8 + 4, true); text += new TextDecoder().decode(u8().subarray(p, p + l)); total += l; }
        dv().setUint32(nwritten, total, true); if (onLog && text.trim()) onLog(text.trim()); return 0;
      },
      fd_close: () => 0, fd_fdstat_get: () => 8, fd_prestat_get: () => 8, fd_prestat_dir_name: () => 8,
      fd_read: () => 8, fd_seek: () => 8, path_open: () => 44, poll_oneoff: () => 0,
      proc_exit(c) { throw new Error('bae exit ' + c); },
      random_get(p, l) { const a = u8(); for (let i = 0; i < l; i++) a[p + i] = (Math.random() * 256) | 0; return 0; },
    };
    const t0 = (typeof performance !== 'undefined' ? performance : Date).now();
    const { instance } = await WebAssembly.instantiate(wasmBytes, { wasi_snapshot_preview1: wasi, env: { now_ms: () => (typeof performance !== 'undefined' ? performance : Date).now() - t0 } });
    const x = instance.exports; mem = x.memory; x._initialize && x._initialize();
    const copyIn = bytes => { const p = x.malloc(bytes.length); u8().set(bytes, p); return p; };
    return {
      x,
      init: rate => x.rs_init(rate),
      addBank: bytes => x.rs_add_bank(copyIn(bytes), bytes.length),   // bank memory stays owned by the engine
      songNew: () => x.rs_song_new(),
      songLoad(id, bytes) { const p = copyIn(bytes); return x.rs_song_load(id, p, bytes.length); },
      songStart: (id, loops) => x.rs_song_start(id, loops | 0),
      songStop: id => x.rs_song_stop(id),
      songDelete: id => x.rs_song_delete(id),
      songDone: id => x.rs_song_is_done(id),
      songVolume: (id, v, scale) => x.rs_song_volume(id, v, scale || 127),
      noteOn: (id, c, b, p, n, v) => x.rs_note_on(id, c, b, p, n, v),
      noteOff: (id, c, n, v) => x.rs_note_off(id, c, n, v | 0),
      controller: (id, c, k, v) => x.rs_controller(id, c, k, v),
      program: (id, c, b, p) => x.rs_program(id, c, b, p),
      reverb: t => x.rs_reverb(t),
      trackMute: (id, t, m) => x.rs_track_mute(id, t, m ? 1 : 0),
      channelMute: (id, c, m) => x.rs_channel_mute(id, c, m ? 1 : 0),
      songPosition: (id, ms) => x.rs_song_position(id, ms | 0),
      render(frames) { const p = x.rs_render(frames); return new Int16Array(mem.buffer, p, frames * 2); },
    };
  }
  if (typeof module !== 'undefined') module.exports = { createBae }; else root.createBae = createBae;
})(typeof window !== 'undefined' ? window : globalThis);
