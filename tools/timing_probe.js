// usage: node timing_probe.js <movie path under rs/> <seconds> <out.json>
const { chromium } = require('playwright');
(async () => {
  const [movie, secs, out] = process.argv.slice(2);
  const browser = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required'] });
  const page = await browser.newPage({ viewport: { width: 700, height: 600 } });
  const logs = [];
  page.on('dialog', d => { logs.push('[dialog] ' + d.message()); d.dismiss(); });
  page.on('console', m => { const t = m.text(); if (/lenient|error|RUNAWAY/i.test(t) && !/GL Driver|ruffle|xtra-registry|Failed to load/.test(t)) logs.push(t.slice(0, 200)); });
  await page.goto('http://localhost:8766/play.html?m=' + movie);
  await page.click('#cover');
  const samples = []; let last = null; const t0 = Date.now();
  let filters = [];
  while (Date.now() - t0 < secs * 1000) {
    const st = await page.evaluate(() => {
      try {
        const s = window.__vm && window.__vm.mcp_get_execution_state();
        const o = typeof s === 'string' ? JSON.parse(s) : s;
        const stage = document.getElementById('stage');
        return { o, f: stage ? stage.style.filter : '' };
      } catch (e) { return { err: String(e) }; }
    });
    if (st && st.o) {
      const fr = st.o.currentFrame ?? st.o.current_frame ?? st.o.frame;
      if (fr !== last) { samples.push([Date.now() - t0, fr]); last = fr; }
      if (st.f && filters[filters.length - 1] !== st.f) filters.push(st.f);
    } else if (samples.length === 0 && st && st.err) { logs.push('state err ' + st.err); }
    await page.waitForTimeout(25);
  }
  const first = await page.evaluate(() => { try { return JSON.stringify(window.__vm.mcp_get_execution_state()).slice(0, 400); } catch (e) { return String(e); } });
  require('fs').writeFileSync(out, JSON.stringify({ samples, logs: [...new Set(logs)], filters: filters.slice(0, 20), first }, null, 1));
  await browser.close();
})();
