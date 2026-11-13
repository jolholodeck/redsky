// usage: node try_work.js <work> <movie> <outprefix> [waitMs] [clicks]
const { chromium } = require('playwright');
(async () => {
  const [work, movie, out, waitMs = '12000', clicks = '3'] = process.argv.slice(2);
  const browser = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required'] });
  const page = await browser.newPage({ viewport: { width: 1000, height: 900 } });
  const msgs = new Map();
  const note = t => { const k = t.slice(0, 160); msgs.set(k, (msgs.get(k) || 0) + 1); };
  page.on('dialog', d => { note('[dialog] ' + d.message()); d.dismiss(); });
  page.on('pageerror', e => note('[pageerror] ' + e.message));
  page.on('console', m => { const t = m.text(); if (/Beatnik|\[rs\] xtra/.test(t)) note('[c] ' + t); else if (/error|panic|lenient|warn|not found|fail|unknown|unsupported/i.test(t) && !/GL Driver|Failed to load resource|xtra-registry|ruffle|AudioContext was not allowed/i.test(t)) note('[c] ' + t); });
  await page.goto(`http://localhost:8766/play.html?w=${work}&m=${encodeURIComponent(movie)}`);
  await page.click('#cover');
  await page.waitForTimeout(Number(waitMs));
  const ev = c => page.evaluate(c => window.__vm && window.__vm.eval_command(c), c).catch(() => {});
  await ev('put "STG", the stageRight - the stageLeft, the stageBottom - the stageTop, the movieName, the frame');
  const st = await page.$('#stage');
  const canvas = await page.evaluate(() => { const c = document.querySelector('#stage canvas'); return c ? [c.width, c.height] : null; });
  await st.screenshot({ path: out + '_a.png' });
  const bb = await st.boundingBox();
  for (let i = 0; i < Number(clicks); i++) { await page.mouse.click(bb.x + bb.width * (0.3 + 0.2 * i), bb.y + bb.height * 0.6); await page.waitForTimeout(2500); }
  await st.screenshot({ path: out + '_b.png' });
  const o = await page.evaluate(() => window.__vm ? window.__vm.mcp_get_console_output(60) : '').catch(() => '');
  console.log('beatnikPeak', await page.evaluate(() => window.__rsBeatnikPeak)); console.log('canvas', JSON.stringify(canvas), (o.split('\n').filter(l => /STG/.test(l)).pop() || '').trim());
  for (const [k, v] of msgs) console.log((v > 1 ? v + 'x ' : '') + k);
  await browser.close();
})();
