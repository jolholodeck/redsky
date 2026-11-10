// usage: node shoot.js <url> <outprefix> <steps-json>
// steps: [{wait:ms},{shot:name},{click:[x,y]},{key:"Space"},{shift:true}]
const { chromium } = require('playwright');
(async () => {
  const [url, out, stepsJson] = process.argv.slice(2);
  const steps = JSON.parse(stepsJson || '[{"wait":8000},{"shot":"a"}]');
  const browser = await chromium.launch({ dumpio: !!process.env.DUMPIO, args: ['--autoplay-policy=no-user-gesture-required'] });
  const page = await browser.newPage({ viewport: { width: 700, height: 560 } });
  const fs=require('fs'); const logf=`${process.argv[3]}_log.txt`; fs.writeFileSync(logf,''); const logs = { push: (l) => fs.appendFileSync(logf, l + '\n'), join: () => '' };
  page.on('console', m => logs.push(`[${m.type()}] ${m.text()}`.slice(0, 300)));
  page.on('dialog', async d => { logs.push('[dialog] ' + d.message()); await d.dismiss(); });
  page.on('pageerror', e => logs.push('[pageerror] ' + e.message));
  page.on('requestfailed', r => logs.push('[reqfail] ' + r.url()));
  page.on('response', r => { if (r.status() >= 400) logs.push('[http ' + r.status() + '] ' + r.url()); });
  page.on('crash', () => logs.push('[CRASH]'));
  page.on('close', () => logs.push('[CLOSE]'));
  await page.goto(url);
  for (const s of steps) {
    if (s.wait) await page.waitForTimeout(s.wait);
    if (s.shot) {
      const el = await page.$('#stage');
      await (el || page).screenshot({ path: `${out}_${s.shot}.png` });
    }
    if (s.click) {
      const box = await (await page.$('#stage')).boundingBox();
      if (s.shift) await page.keyboard.down('Shift');
      await page.mouse.click(box.x + s.click[0], box.y + s.click[1]);
      if (s.shift) await page.keyboard.up('Shift');
    }
    if (s.move) {
      const box = await (await page.$('#stage')).boundingBox();
      await page.mouse.move(box.x + s.move[0], box.y + s.move[1]);
    }
    if (s.key) await page.keyboard.press(s.key);
  }
  await browser.close();
})();
