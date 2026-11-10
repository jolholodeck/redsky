const { chromium } = require('playwright');
(async () => {
  const D = process.argv[2];
  const browser = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required'] }); const page = await browser.newPage({ viewport: { width: 700, height: 600 } });
  page.on('dialog', d => { console.log('[dialog]', d.message()); d.dismiss(); });
  page.on('console', m => { const t = m.text(); if (/error|panic|lenient|\[rs\] audio/i.test(t) && !/GL Driver|Failed to load/.test(t)) console.log('[c]', t.slice(0, 200)); });
  await page.goto('http://localhost:8766/play.html?via=entertainment'); await page.click('#cover');
  console.log('audio after click', await page.evaluate(() => window.__rsAudioCtx && window.__rsAudioCtx.state));
  const st = await page.$('#stage'); const bb = await st.boundingBox(); const ev = c => page.evaluate(c => window.__vm.eval_command(c), c);
  const q = async (tag, expr) => { await ev(`put "${tag}", ${expr}`); const o = await page.evaluate(() => window.__vm.mcp_get_console_output(400)); return (o.split('\n').filter(l => l.includes(tag)).pop() || '').replace(/^-- \S+ /, ''); };
  const state = () => page.evaluate(() => { if (!window.__vm) return 'novm'; const e = JSON.parse(window.__vm.mcp_get_execution_state()); return e.current_frame; }).catch(e => 'err');
  await page.waitForTimeout(6000);
  console.log('audio', await page.evaluate(() => window.__rsAudioCtx.state), 'frame', await state(), 'nav', await q('NV', 'objectp(goNavMgr), the movieName'));
  // space through the intro
  for (let i = 0; i < 3; i++) { await page.keyboard.press('Space'); await page.waitForTimeout(3000); console.log('after space', i, 'frame', await state()); }
  await st.screenshot({ path: D + '/after_spaces.png' });
  // wait for the cowboy to finish the welcome
  for (let i = 0; i < 60; i++) { const s = Number(await q('SC', 'state_cowboy')); if (s >= 1.5) break; await page.waitForTimeout(1000); }
  console.log('state', await q('SC', 'state_cowboy'));
  const pts = [[200, 300], [300, 260], [150, 380], [250, 360], [330, 350], [60, 440], [200, 455], [560, 300], [60, 230]];
  let n = 0;
  for (const [x, y] of pts) {
    await page.mouse.move(bb.x + x, bb.y + y, { steps: 4 }); await page.waitForTimeout(400);
    const z = await q('PZ', 'ginsidebigpuffs, ginsidesmallpuffs');
    await page.mouse.click(bb.x + x, bb.y + y); await page.waitForTimeout(250);
    const a = await q('BG', 'animation_exists(#bang)');
    await st.screenshot({ path: `${D}/dust${n++}.png` });
    console.log('pt', x, y, 'zones', z, 'bang', a);
    await page.waitForTimeout(1500);
  }
  await browser.close();
})();
