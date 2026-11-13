const fs = require('fs'); const { createBae } = require('/root/tools/bae-wasm/rsbae.js');
(async () => {
  const [rmf, out, secs = '10', bank = '/root/tools/minibae/neobae/src/banks/patches/patches.hsb'] = process.argv.slice(2);
  const bae = await createBae(fs.readFileSync('/root/tools/bae-wasm/bae.wasm'), { onLog: l => {} });
  console.log('init', bae.init(44100), 'bank', bae.addBank(fs.readFileSync(bank)));
  const id = bae.songNew(); console.log('song', id, 'load', bae.songLoad(id, fs.readFileSync(rmf)), 'start', bae.songStart(id, 0));
  const frames = 44100 * Number(secs), pcm = Buffer.alloc(frames * 4); let peak = 0;
  for (let f = 0; f < frames; f += 1024) { const n = Math.min(1024, frames - f); const b = bae.render(n); for (let i = 0; i < n * 2; i++) { pcm.writeInt16LE(b[i], (f * 2 + i) * 2); peak = Math.max(peak, Math.abs(b[i])); } }
  const h = Buffer.alloc(44); h.write('RIFF', 0); h.writeUInt32LE(36 + pcm.length, 4); h.write('WAVEfmt ', 8); h.writeUInt32LE(16, 16); h.writeUInt16LE(1, 20); h.writeUInt16LE(2, 22); h.writeUInt32LE(44100, 24); h.writeUInt32LE(176400, 28); h.writeUInt16LE(4, 32); h.writeUInt16LE(16, 34); h.write('data', 36); h.writeUInt32LE(pcm.length, 40);
  fs.writeFileSync(out, Buffer.concat([h, pcm])); console.log('peak', peak, 'done', bae.songDone(id));
})();
