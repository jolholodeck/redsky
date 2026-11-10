const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch(); const page = await browser.newPage({ viewport: { width: 700, height: 600 } });
  await page.goto('http://localhost:8766/play.html?via=work'); await page.click('#cover');
  const st = await page.$('#stage'); const b = await st.boundingBox();
  const shot = n => st.screenshot({ path: `/root/shots/work_${n}.png` });
  await page.waitForTimeout(15000); await shot('1');
  await page.mouse.move(b.x + 330, b.y + 48); await page.waitForTimeout(300); await page.mouse.click(b.x + 330, b.y + 48); await page.waitForTimeout(3000); await shot('2');
  await page.mouse.move(b.x + 320, b.y + 140); await page.waitForTimeout(1500); await shot('3');
  await page.mouse.move(b.x + 320, b.y + 300); await page.waitForTimeout(1500); await shot('4');
  await page.mouse.click(b.x + 320, b.y + 140); await page.waitForTimeout(12000); await shot('5');
  await browser.close();
})();
