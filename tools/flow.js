const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required'] });
  const page = await browser.newPage({ viewport: { width: 700, height: 560 } });
  const log = m => console.log(m);
  page.on('dialog', d => { log('[dialog] ' + d.message()); d.dismiss(); });
  page.on('console', m => { const t = m.text(); if (/lenient|error|RUNAWAY|remapped|\[rs\] map .*\.(dir|DIR)/i.test(t) && !/GL Driver|ruffle|xtra-registry|Failed to load resource/.test(t)) log('[c] ' + t.slice(0, 200)); });
  await page.goto('http://localhost:8765/play.html');
  const st = await page.$('#stage'); const b = await st.boundingBox();
  const click = async (x, y) => { await page.mouse.move(b.x + x, b.y + y); await page.waitForTimeout(150); await page.mouse.click(b.x + x, b.y + y); };
  const shot = async n => st.screenshot({ path: `/root/shots/flow_${n}.png` }).catch(e => log('shot fail ' + n));
  await page.waitForTimeout(5000); await click(320, 240);
  for (let i = 0; i < 4; i++) { await page.waitForTimeout(4000); await page.keyboard.press('Space'); }
  await page.waitForTimeout(40000); await shot('1ent');
  await page.keyboard.down('Control'); await page.keyboard.press('w'); await page.keyboard.up('Control');
  await page.waitForTimeout(15000); await shot('2work');
  await click(330, 48); await page.waitForTimeout(3000); await shot('3list');
  await click(320, 140); await page.waitForTimeout(15000); await shot('4piece');
  await page.keyboard.press('Enter'); await page.waitForTimeout(15000); await shot('5back');
  await browser.close();
})();
