const { chromium } = require('playwright');
const fs = require('fs');
(async () => {
  const pieces = JSON.parse(fs.readFileSync(process.argv[2]));
  const outdir = process.argv[3];
  const browser = await chromium.launch({ args: ['--autoplay-policy=no-user-gesture-required'] });
  for (const m of pieces) {
    const key = m.split('/').pop().replace('.dir', '');
    const logs = [];
    const page = await browser.newPage({ viewport: { width: 700, height: 560 } });
    page.on('dialog', d => { logs.push('[dialog] ' + d.message()); d.dismiss().catch(()=>{}); });
    page.on('console', msg => { const t = msg.text(); if (/lenient|error|Error|RUNAWAY|warn/i.test(t) && !/GL Driver|ruffle|xtra-registry|Failed to load resource/.test(t)) logs.push(t.slice(0, 300)); });
    page.on('crash', () => logs.push('[CRASH]'));
    try {
      await page.goto('http://localhost:8765/play.html?m=' + m);
      await page.waitForTimeout(9000);
      const st = await page.$('#stage');
      await st.screenshot({ path: `${outdir}/${key}_1.png`, timeout: 15000 });
      const b = await st.boundingBox();
      await page.mouse.click(b.x + 320, b.y + 240);
      await page.waitForTimeout(5000);
      await st.screenshot({ path: `${outdir}/${key}_2.png`, timeout: 15000 });
      await page.mouse.click(b.x + 320, b.y + 400);
      await page.waitForTimeout(4000);
      await st.screenshot({ path: `${outdir}/${key}_3.png`, timeout: 15000 });
    } catch (e) { logs.push('[harness] ' + e.message.split('\n')[0]); }
    const uniq = [...new Set(logs)];
    fs.writeFileSync(`${outdir}/${key}_log.txt`, uniq.join('\n'));
    console.log(key, uniq.length ? uniq.slice(0, 4).join(' | ') : 'OK');
    await page.close().catch(()=>{});
  }
  await browser.close();
})();
