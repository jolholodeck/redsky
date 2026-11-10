const { chromium } = require('playwright');
(async () => {
  const D = process.argv[2];
  const browser = await chromium.launch(); const page = await browser.newPage({ viewport: { width: 700, height: 600 } });
  page.on('dialog', d => { console.log('[dialog]', d.message()); d.dismiss(); });
  await page.goto('http://localhost:8766/play.html?m=entertainment_module/entertainment.dir'); await page.click('#cover');
  const st = await page.$('#stage'); const ev = c => page.evaluate(c => window.__vm.eval_command(c), c);
  const q = async (tag, expr) => { await ev(`put "${tag}", ${expr}`); const o = await page.evaluate(() => window.__vm.mcp_get_console_output(400)); return o.split('\n').filter(l => l.includes(tag)).pop(); };
  const state = async () => Number(((await q('ST', 'state_cowboy')) || '').split(' ').pop());
  const b = await st.boundingBox();
  await page.waitForTimeout(20000); await ev('set goNavMgr to [#iCurModuleID: #entertainment]');
  const t0 = Date.now(); let shot = 0, clicked = false, clickedPig = false; let last = -1;
  const sprites = 'the member of sprite 24, the loc of sprite 24, the puppet of sprite 24, "|", the member of sprite 25, the loc of sprite 25, the puppet of sprite 25, "|", the member of sprite 36, the loc of sprite 36, the puppet of sprite 36';
  while (Date.now() - t0 < 200000) {
    await page.waitForTimeout(500);
    const s = await state();
    if (s !== last) { console.log('t+' + Math.round((Date.now() - t0) / 1000), 'state', s, await q('SP', sprites)); last = s; await st.screenshot({ path: `${D}/s${s}_${shot++}.png` }); }
    let r36 = null;
    if (s >= 4 && s < 5 && !clicked) r36 = (await q('R36', 'the rect of sprite 36')).match(/rect\((-?\d+), (-?\d+), (-?\d+), (-?\d+)\)/).slice(1).map(Number);
    if (r36 && r36[0] >= 0) {
      const r = r36;
      console.log('change button rect', r); await st.screenshot({ path: `${D}/before_toggle.png` });
      await page.mouse.click(b.x + (r[0] + r[2]) / 2, b.y + (r[1] + r[3]) / 2); clicked = true;
      await page.waitForTimeout(2500); await st.screenshot({ path: `${D}/after_toggle.png` });
      console.log('after toggle', await q('SP', sprites), await q('DP', 'state_ddorpig'));
    }
    if (clicked && !clickedPig && s >= 3 && s < 5) {
      const r = (await q('R25', 'the rect of sprite 25')).match(/rect\((-?\d+), (-?\d+), (-?\d+), (-?\d+)\)/).slice(1).map(Number);
      if (r[0] >= 0) { await page.mouse.click(b.x + (r[0] + r[2]) / 2, b.y + (r[1] + r[3]) / 2); clickedPig = true; console.log('clicked pig', r);
        for (let k = 0; k < 4; k++) { await page.waitForTimeout(800); await st.screenshot({ path: `${D}/pigclick_${k}.png` }); }
        console.log('after pig click', await q('SP', sprites)); }
    }
    if (s >= 7.5) { await page.waitForTimeout(4000); console.log('end', await q('SP', sprites)); await st.screenshot({ path: `${D}/end.png` }); break; }
  }
  await browser.close();
})();
