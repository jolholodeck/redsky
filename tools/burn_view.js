const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch(); const page = await browser.newPage({ viewport: { width: 700, height: 600 } });
  page.on('dialog', d => { console.log('[dialog]', d.message()); d.dismiss(); });
  await page.goto('http://localhost:8766/play.html?m=entertainment_module/entertainment.dir'); await page.click('#cover');
  const st = await page.$('#stage'); const ev = c => page.evaluate(c => window.__vm.eval_command(c), c);
  const frame = () => page.evaluate(() => JSON.parse(window.__vm.mcp_get_execution_state()).current_frame);
  const filters = new Set(); const t0 = Date.now();
  while (Date.now() - t0 < 65000) { await page.waitForTimeout(100); filters.add(await page.evaluate(() => document.getElementById('stage').style.filter)); if (Date.now()-t0 > 4000 && Date.now()-t0 < 4200) await st.screenshot({ path: process.argv[2] + '/early.png' }); }
  console.log('filters seen', [...filters].join(' | '));
  await page.evaluate(() => { const o = window.__rsTempoOverride; window.__calls = {}; window.__rsTempoOverride = (f, n) => { const r = o(f, n); window.__calls[f + ':' + n + '=' + r] = 1; return r; }; });
  await ev('set goNavMgr to [#iCurModuleID: #entertainment]');
  await st.screenshot({ path: process.argv[2] + '/cowboy.png' });
  const b = await st.boundingBox();
  for (let i = 0; i < 8; i++) { await page.mouse.click(b.x + 560, b.y + 120); await page.waitForTimeout(90); }
  const t1 = Date.now(); let last = 0, n = 0;
  while (Date.now() - t1 < 8000) {
    const f = await frame();
    if (f !== last) { console.log('t+' + (Date.now() - t1), 'frame', f); last = f; if (f >= 75 && f <= 84 && n < 6) await st.screenshot({ path: process.argv[2] + '/f' + f + '.png' }), n++; }
    await page.waitForTimeout(15);
  }
  console.log(await page.evaluate(() => Object.keys(window.__calls).join(' ')));
  await st.screenshot({ path: process.argv[2] + '/burn.png' });
  await browser.close();
})();
