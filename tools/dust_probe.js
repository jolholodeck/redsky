const { chromium } = require('playwright');
(async () => {
  const D = process.argv[2];
  const browser = await chromium.launch(); const page = await browser.newPage({ viewport: { width: 700, height: 600 } });
  page.on('dialog', d => d.dismiss());
  await page.goto('http://localhost:8766/play.html?via=entertainment'); await page.click('#cover');
  const st = await page.$('#stage'); const bb = await st.boundingBox(); const ev = c => page.evaluate(c => window.__vm.eval_command(c), c);
  const q = async (tag, expr) => { await ev(`put "${tag}", ${expr}`); const o = await page.evaluate(() => window.__vm.mcp_get_console_output(400)); return (o.split('\n').filter(l => l.includes(tag)).pop() || ''); };
  await page.waitForTimeout(5000);
  for (let i = 0; i < 3; i++) { await page.keyboard.press('Space'); await page.waitForTimeout(2500); }
  for (let i = 0; i < 60; i++) { if (Number((await q('SC', 'state_cowboy')).split(' ').pop()) >= 1.5) break; await page.waitForTimeout(1000); }
  await page.mouse.move(bb.x + 250, bb.y + 360, { steps: 4 }); await page.waitForTimeout(400);
  await page.mouse.click(bb.x + 250, bb.y + 360);
  for (let k = 0; k < 6; k++) { await page.waitForTimeout(120); console.log(await q('B' + k, 'the member of sprite 40, the loc of sprite 40, the rect of sprite 40, the visible of sprite 40, the ink of sprite 40, animation_getframe(#bang)')); await page.screenshot({ path: `${D}/b${k}.png`, clip: { x: bb.x + 130, y: bb.y + 220, width: 240, height: 180 } }); }
  await browser.close();
})();
