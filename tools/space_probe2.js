const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required'] }); const page = await browser.newPage({ viewport: { width: 700, height: 600 } });
  page.on('dialog', d => { console.log('[dialog]', d.message()); d.dismiss(); });
  page.on('console', m => { const t = m.text(); if (/error|panic|lenient|splice|keydown|\[rs\]/i.test(t) && !/GL Driver|Failed to load/.test(t)) console.log('[c]', t.slice(0, 200)); });
  await page.goto('http://localhost:8766/play.html?via=entertainment'); await page.click('#cover');
  const fr = () => page.evaluate(() => window.__vm ? JSON.parse(window.__vm.mcp_get_execution_state()).current_frame : 0);
  const ev = c => page.evaluate(c => window.__vm.eval_command(c), c);
  while (await fr() !== 40) await page.waitForTimeout(50);
  await page.waitForTimeout(1000);
  const t0 = Date.now(); await page.keyboard.down('Space'); await page.waitForTimeout(80); await page.keyboard.up('Space');
  let last = 0; while (Date.now() - t0 < 5000) { const f = await fr(); if (f !== last) { console.log('t+' + (Date.now() - t0), f); last = f; } await page.waitForTimeout(20); }
  await ev('put "TM", timer_gettime(#waitframe), the key, the frame');
  console.log((await page.evaluate(() => window.__vm.mcp_get_console_output(50))).split('\n').filter(l => /TM/.test(l)).pop());
  await browser.close();
})();
