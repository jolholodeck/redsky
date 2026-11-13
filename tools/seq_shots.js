// usage: node seq_shots.js <work> <outprefix> <secondsList> [movie]
const { chromium } = require('playwright');
(async () => {
  const [work, out, secs, movie] = process.argv.slice(2);
  const b = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required'] }); const p = await b.newPage({ viewport: { width: 1000, height: 800 } });
  const seen = new Set();
  p.on('dialog', d => { console.log('[dialog]', d.message()); d.dismiss(); });
  p.on('console', m => { const t = m.text().slice(0, 160); if (/\[rs\]|error|lenient/i.test(t) && !/GL Driver|Failed to load res/.test(t) && !seen.has(t)) { seen.add(t); console.log('[c]', t); } });
  await p.goto('http://localhost:8766/play.html?w=' + work + (movie ? '&m=' + movie : '')); await p.click('#cover');
  const st = await p.$('#stage'); let t0 = Date.now();
  for (const s of secs.split(',').map(Number)) {
    await p.waitForTimeout(Math.max(0, s * 1000 - (Date.now() - t0)));
    await st.screenshot({ path: `${out}_${s}.png` });
    console.log(s, await p.evaluate(() => { const e = window.__vm && JSON.parse(window.__vm.mcp_get_execution_state()); return e ? e.current_frame : '-'; }), 'beatnik', await p.evaluate(() => window.__rsBeatnikPeak), 'videos', await p.evaluate(() => [...document.querySelectorAll('#stage video')].map(v => v.currentTime.toFixed(1) + '/' + (v.duration||0).toFixed(1) + '@' + v.style.left + ',' + v.style.top + ' ' + v.style.width + 'x' + v.style.height).join(' ')));
  }
  await b.close();
})();
