"""Publish a 1990s HTML + Shockwave site (e.g. Absolut DJ) as is, with one script added to
every page so its Shockwave movies play in DirPlayer.

usage: python3 -I build_web_work.py <slug> <folder inside original/>
"""
import os, re, shutil, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
slug, folder = sys.argv[1], sys.argv[2]
src = os.path.join(REPO, 'works', slug, 'original', folder)
dst = os.path.join(REPO, 'site', 'w', slug, 'web', folder)
shutil.rmtree(os.path.join(REPO, 'site', 'w', slug, 'web'), ignore_errors=True)
shutil.copytree(src, dst, ignore=shutil.ignore_patterns('.DS_Store', '__MACOSX'))
n = 0
for dp, dns, fns in os.walk(dst):
    for fn in fns:
        if not fn.lower().endswith(('.htm', '.html')):
            continue
        p = os.path.join(dp, fn)
        html = open(p, 'rb').read()
        rel = os.path.relpath(os.path.join(REPO, 'site', 'shared', 'shockwave-page.js'), dp).replace(os.sep, '/')
        tag = ('<script src="%s"></script>' % rel).encode()
        m = re.search(rb'<head[^>]*>', html, re.I)
        html = html[:m.end()] + tag + html[m.end():] if m else tag + html
        open(p, 'wb').write(html)
        n += 1
print('published', dst, n, 'pages')
