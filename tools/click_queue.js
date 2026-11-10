const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required'] });
  const page = await browser.newPage({ viewport: { width: 700, height: 600 } });
  const log = m => console.log(m);
  page.on('dialog', d => { log('[dialog] ' + d.message()); d.dismiss(); });
  page.on('console', m => { const t = m.text(); if (/\[rs\] play|error|RUNAWAY|sound/i.test(t) && !/GL Driver|ruffle|xtra-registry|Failed to load|AudioContext/.test(t)) log('[c] ' + t.slice(0, 200)); });
  await page.goto('http://localhost:8766/play.html?m=entertainment_module/entertainment.dir');
  await page.click('#cover');
  const st = await page.$('#stage');
  const ev = c => page.evaluate(c => window.__vm.eval_command(c), c);
  const out = () => page.evaluate(() => window.__vm.mcp_get_console_output(30));
  const frame = () => page.evaluate(() => JSON.parse(window.__vm.mcp_get_execution_state()).current_frame);
  for (let i = 0; i < 40; i++) { await page.waitForTimeout(2500); await ev('put "s", state_cowboy'); const o = await out(); if (/s\s+([2-9]|\d\d)/.test(o.split('\n').filter(l=>/"?s"?/.test(l)).pop()||'')) break; }
  await ev('set goNavMgr to [#iCurModuleID: #entertainment]');
  const b = await st.boundingBox();
  for (let i = 0; i < 3; i++) { await page.mouse.click(b.x + 560, b.y + 120); await page.waitForTimeout(350); }
  await ev('put "queue", mouse_getqueue()');
  await ev('put "frame", the frame');
  await st.screenshot({ path: '/root/shots/burn_c.png' });
  log(await out());
  await browser.close();
})();
