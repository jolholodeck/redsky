const { chromium } = require('playwright');
(async () => {
  const b = await chromium.launch(); const p = await b.newPage({ viewport: { width: 640, height: 520 } });
  p.on('pageerror', e => console.log('ERR', e.message));
  await p.goto('http://localhost:8766/w/millennium-clock/index.html'); await p.waitForTimeout(800);
  await p.screenshot({ path: process.argv[2] + '/clock1.png' });
  await p.waitForTimeout(3000); await p.screenshot({ path: process.argv[2] + '/clock2.png' });
  const r = await (await p.$('canvas')).boundingBox(); const sx = r.width / 180, sy = r.height / 230;
  await p.mouse.click(r.x + 25 * sx, r.y + 190 * sy); await p.waitForTimeout(600); await p.screenshot({ path: process.argv[2] + '/clock3.png' });
  await p.mouse.click(r.x + 25 * sx, r.y + 190 * sy); await p.waitForTimeout(600); await p.screenshot({ path: process.argv[2] + '/clock4.png' });
  await b.close();
})();
