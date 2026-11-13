// Loaded first by every page of a 1990s Shockwave site kept in this archive.
// 1. Tells the page's plug-in check that Shockwave for Director 6 is installed.
// 2. Loads this module's copy of DirPlayer, which replaces each <embed src="*.dcr"> with a working player.
(function () {
  const plugin = { name: 'Shockwave for Director', description: 'Macromedia Shockwave for Director Netscape plug-in, version 6.0', filename: 'np32dsw.dll', length: 1 };
  const real = navigator.plugins, realMimes = navigator.mimeTypes;
  const plugins = [plugin]; plugins['Shockwave for Director'] = plugin; plugins.refresh = function () {};
  plugins.item = i => plugins[i] || null;
  plugins.namedItem = n => n === plugin.name ? plugin : (real && real.namedItem ? real.namedItem(n) : null);
  const mime = { type: 'application/x-director', suffixes: 'dcr,dir,dxr', description: 'Shockwave for Director', enabledPlugin: plugin };
  const mimes = [mime]; mimes['application/x-director'] = mime;
  mimes.item = i => mimes[i] || null;
  mimes.namedItem = n => n === mime.type ? mime : (realMimes && realMimes.namedItem ? realMimes.namedItem(n) : null);
  try {
    Object.defineProperty(navigator, 'plugins', { get: () => plugins, configurable: true });
    Object.defineProperty(navigator, 'mimeTypes', { get: () => mimes, configurable: true });
  } catch (e) {}
  const here = document.currentScript.src;
  const load = async () => {
    // Each module has its own player: site/players/<module>/, where the module is the w/<module>/ folder this page is in.
    const mod = (location.pathname.match(/\/w\/([a-z0-9-]+)\//) || [])[1];
    const res = await fetch(new URL('../players/' + mod + '/dirplayer-polyfill.js.gz', here));
    const js = await new Response(res.body.pipeThrough(new DecompressionStream('gzip'))).text();
    const s = document.createElement('script'); s.textContent = js; document.body.appendChild(s);
  };
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', load); else load();
})();
