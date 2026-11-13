// Stand-in for Director's Beatnik Xtra (Headspace/Beatnik, 1997-2000), running the open-source
// Beatnik Audio Engine (NeoBAE, compiled to WebAssembly) in the browser.
//
// Each `new(xtra "Beatnik")` object in Lingo gets one engine "song": the RMF/MIDI file it plays,
// and/or live notes it triggers (noteOn/noteOff with bank and program; bank 2 = the instruments
// stored in the RMF the object loaded). All objects mix into one audio output.
(function () {
  const HERE = new URL('.', document.currentScript ? document.currentScript.src : location.href).href;
  let engine = null, ready = null, node = null, ctx = null;
  const queue = [];               // calls made before the engine finished loading
  const inst = new Map();         // Lingo instance id -> { song, volume }

  function audioCtx() {
    if (ctx) return ctx;
    ctx = window.__rsAudioCtx || new (window.AudioContext || window.webkitAudioContext)();
    return ctx;
  }

  function start() {
    if (ready) return ready;
    ready = (async () => {
      const [wasm, bank] = await Promise.all([
        fetch(HERE + 'bae.wasm').then(r => r.arrayBuffer()),
        fetch(HERE + 'patches.hsb').then(r => r.arrayBuffer()),
      ]);
      const bae = await window.createBae(wasm);
      const ac = audioCtx();
      const rate = ac.sampleRate >= 47000 ? 48000 : 44100;
      if (bae.init(rate) !== 0) throw new Error('Beatnik engine failed to start');
      bae.addBank(new Uint8Array(bank));
      // Output: render at the engine rate, resample to the context rate if they differ.
      const step = rate / ac.sampleRate;
      let buf = new Int16Array(0), pos = 0;
      node = ac.createScriptProcessor(2048, 0, 2);
      node.onaudioprocess = e => {
        const L = e.outputBuffer.getChannelData(0), R = e.outputBuffer.getChannelData(1), n = L.length;
        for (let i = 0; i < n; i++) {
          let ip = pos | 0;
          if (ip + 1 >= buf.length / 2) {
            const need = Math.ceil((n - i) * step) + 4;
            const fresh = bae.render(Math.min(4096, Math.max(512, need)));
            const keep = buf.length / 2 > ip ? buf.subarray(ip * 2) : new Int16Array(0);
            const nb = new Int16Array(keep.length + fresh.length); nb.set(keep); nb.set(fresh, keep.length);
            buf = nb; pos -= ip; ip = 0;
          }
          const f = pos - ip;
          L[i] = (buf[ip * 2] * (1 - f) + buf[ip * 2 + 2] * f) / 32768;
          R[i] = (buf[ip * 2 + 1] * (1 - f) + buf[ip * 2 + 3] * f) / 32768;
          pos += step;
        }
        let pk = 0; for (let i = 0; i < n; i += 16) pk = Math.max(pk, Math.abs(L[i]));
        window.__rsBeatnikPeak = Math.max(window.__rsBeatnikPeak || 0, pk);
      };
      node.connect(ac.destination);
      engine = bae;
      while (queue.length) queue.shift()();
      return bae;
    })();
    ready.catch(e => console.warn('[rs] Beatnik:', e));
    return ready;
  }

  function later(fn) { if (engine) fn(); else { queue.push(fn); start(); } }

  function song(id) {
    let o = inst.get(id);
    if (!o) { o = { song: 0, volume: 100 }; inst.set(id, o); }
    if (!o.song && engine) o.song = engine.songNew();
    return o;
  }

  async function loadFile(name, base) {
    let rel = String(name).trim();
    rel = rel.replace(/^@[:\/\\]?/, '').replace(/\\/g, '/').replace(/:/g, '/');
    return window.__rsFetchFile(rel, base);
  }

  const handlers = {
    new() { later(() => song(this.id)); return 0; },
    play(loop, file) {
      const id = this.id;
      if (file === undefined || file === null || file === '') { later(() => { const o = song(id); engine.songStart(o.song, o.loops || 0); }); return 0; }
      const loops = loop ? 32767 : 0;
      loadFile(file, this.base).then(bytes => later(() => {
        const o = song(id); o.loops = loops;
        const err = engine.songLoad(o.song, new Uint8Array(bytes));
        engine.songVolume(o.song, o.volume, 100);
        if (err !== 0) console.warn('[rs] Beatnik: could not load', file, 'error', err);
        engine.songStart(o.song, loops);
      })).catch(e => console.warn('[rs] Beatnik: missing', file, e));
      return 0;
    },
    stop() { later(() => engine.songStop(song(this.id).song)); return 0; },
    setVolume(v) { const id = this.id; const vol = Math.max(0, Math.min(100, Number(v) || 0)); later(() => { const o = song(id); o.volume = vol; engine.songVolume(o.song, vol, 100); }); return 0; },
    getVolume() { return (inst.get(this.id) || { volume: 100 }).volume; },
    noteOn(chn, bank, pgm, note, vel) { const id = this.id; later(() => engine.noteOn(song(id).song, (chn - 1) & 15, bank | 0, pgm | 0, note | 0, vel === undefined ? 127 : vel | 0)); return 0; },
    noteOff(chn, note, vel) { const id = this.id; later(() => engine.noteOff(song(id).song, (chn - 1) & 15, note | 0, vel | 0)); return 0; },
    playNote(chn, bank, pgm, note, vel, dur) {
      const id = this.id;
      later(() => engine.noteOn(song(id).song, (chn - 1) & 15, bank | 0, pgm | 0, note | 0, vel | 0));
      setTimeout(() => later(() => engine.noteOff(song(id).song, (chn - 1) & 15, note | 0, 0)), Math.max(10, Number(dur) || 500));
      return 0;
    },
    getController(chn, ctrl) {
      const o = inst.get(this.id) || {}; const v = o.ctrl && o.ctrl[(chn | 0) + ':' + (ctrl | 0)];
      return v !== undefined ? v : ({ 7: 127, 10: 64, 11: 127 })[ctrl | 0] || 0;
    },
    setTrackMute(track, mute) { const id = this.id; later(() => engine.trackMute(song(id).song, Math.max(0, (track | 0) - 1), mute)); const o = song(id); (o.mutes ||= {})[track | 0] = mute ? 1 : 0; return 0; },
    getTrackMute(track) { const o = inst.get(this.id) || {}; return (o.mutes && o.mutes[track | 0]) || 0; },
    setChannelMute(chn, mute) { const id = this.id; later(() => engine.channelMute(song(id).song, (chn - 1) & 15, mute)); return 0; },
    setPosition(ms) { const id = this.id; later(() => engine.songPosition(song(id).song, ms)); return 0; },
    fadeFromTo(from, to, ms) {
      const id = this.id, steps = Math.max(1, Math.round((Number(ms) || 1000) / 50));
      for (let i = 0; i <= steps; i++) setTimeout(() => handlers.setVolume.call({ id }, from + (to - from) * i / steps), i * 50);
      return 0;
    },
    fadeTo(to, ms) { const o = inst.get(this.id) || { volume: 100 }; return handlers.fadeFromTo.call({ id: this.id }, o.volume, to, ms); },
    setController(chn, ctrl, val) { const o0 = song(this.id); (o0.ctrl ||= {})[(chn | 0) + ':' + (ctrl | 0)] = val | 0; const id = this.id; later(() => engine.controller(song(id).song, (chn - 1) & 15, ctrl | 0, val | 0)); return 0; },
    setProgram(chn, bank, pgm) { const id = this.id; later(() => engine.program(song(id).song, (chn - 1) & 15, bank | 0, pgm | 0)); return 0; },
    setReverbType(t) { later(() => engine.reverb(t | 0)); return 0; },
    isPlaying() { const o = inst.get(this.id); return engine && o && o.song ? (engine.songDone(o.song) ? 0 : 1) : 0; },
    isReady() { return 1; },
    getVersion() { return '2.0'; },
    closeBeatnik() { const id = this.id; later(() => { const o = inst.get(id); if (o && o.song) engine.songDelete(o.song); inst.delete(id); }); return 0; },
    // Setup calls that only mattered to the 1990s plug-in.
    setReady() { start(); return 0; }, setSliceSize() { return 0; }, setAutoStart() { return 0; },
    setSampleLibrary() { return 0; }, getSampleLibrary() { return 'patches.hsb'; }, register() { return 0; }, setTempo() { return 0; },
  };

  window.__rsXtraHandlers = window.__rsXtraHandlers || {};
  window.__rsXtraMethods = window.__rsXtraMethods || {};
  window.__rsXtraMethods.beatnik = Object.keys(handlers).map(k => k.toLowerCase());
  window.__rsXtraHandlers.beatnik = function (id, name, args, base) {
    const key = Object.keys(handlers).find(k => k.toLowerCase() === String(name).toLowerCase());
    if (!key) { console.warn('[rs] Beatnik: no handler', name); return 0; }
    return handlers[key].apply({ id, base }, args);
  };
})();
