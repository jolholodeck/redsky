const { chromium } = require('playwright');
(async () => {
  const [url, stepsJson] = process.argv.slice(2);
  const steps = JSON.parse(stepsJson);
  const browser = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required'] });
  const page = await browser.newPage({ viewport: { width: 700, height: 560 } });
  page.on('dialog', d => { console.log('[dialog]', d.message()); d.dismiss(); });
  page.on('console', m => { const t = m.text(); if (!/GL Driver|read_memory_map|ruffle|xtra-registry|Failed to load|\[rs\] map/.test(t)) console.log('[c]', t.slice(0, 400)); });
  await page.goto(url);
  for (const s of steps) {
    if (s.wait) await page.waitForTimeout(s.wait);
    if (s.click) { const b = await (await page.$('#stage')).boundingBox(); await page.mouse.move(b.x+s.click[0], b.y+s.click[1]); await page.waitForTimeout(100); await page.mouse.click(b.x+s.click[0], b.y+s.click[1]); }
    if (s.eval) { await page.evaluate(c => window.__vm.eval_command(c), s.eval); await page.waitForTimeout(300); }
    if (s.js) { const r = await page.evaluate(s.js); console.log('[js]', String(r).slice(0, 3000)); }
    if (s.shot) await (await page.$('#stage')).screenshot({ path: s.shot });
  }
  await browser.close();
})();
