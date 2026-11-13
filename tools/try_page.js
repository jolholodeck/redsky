const { chromium } = require('playwright');
(async () => {
  const [url, out, wait = '8000'] = process.argv.slice(2);
  const b = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required'] });
  const p = await b.newPage({ viewport: { width: 900, height: 700 } });
  const seen = new Set();
  p.on('console', m => { const t = m.text().slice(0, 200); if (/error|fail|warn|panic/i.test(t) && !/GL Driver|favicon/.test(t) && !seen.has(t)) { seen.add(t); console.log('[c]', t); } });
  p.on('pageerror', e => console.log('[pageerror]', e.message.slice(0, 200)));
  p.on('dialog', d => { console.log('[dialog]', d.message()); d.dismiss(); });
  await p.goto('http://localhost:8766/' + url); await p.waitForTimeout(Number(wait));
  await p.mouse.click(450, 300); await p.waitForTimeout(3000);
  await p.screenshot({ path: out });
  console.log('url now', p.url(), 'canvases', await p.evaluate(() => document.querySelectorAll('canvas').length));
  await b.close();
})();
