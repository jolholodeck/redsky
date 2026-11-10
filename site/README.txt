RED SKY 98 — the 1998 Red Sky Interactive demo CD, running in a web browser.

IMPORTANT: don't open index.html by double-clicking it. Browsers block a page opened
as a file from loading its own data ("Load failed" in Safari). It has to be served.

ON YOUR MAC (easiest)
  1. Double-click "Start Red Sky 98.command". A Terminal window opens and your
     browser goes to http://localhost:8098/
  2. If macOS says it can't be opened because it's from an unidentified developer:
     click Done, open System Settings > Privacy & Security, scroll down and click
     "Open Anyway" next to "Start Red Sky 98.command", then double-click it again.
  3. Leave the Terminal window open while you play. Close it to stop.

  Alternative, in Terminal:
     cd   (type "cd " then drag this RedSky98_web folder into the window, press Return)
     python3 -m http.server 8098
  then open http://localhost:8098/ in Safari or Chrome.
  If macOS asks to install command line developer tools for python3, click Install.

ON A WEB SERVER
  Upload this whole folder to any static host (Netlify, GitHub Pages, your own server).
  No server code is needed. Open index.html from that address.

How it works: the original Director 6 files were decompiled with ProjectorRays and are
played by DirPlayer (an open-source Shockwave/Director emulator compiled to WebAssembly),
patched for this CD. Files are stored gzipped (rs/) and decompressed in the browser.
Safari 16.4 or later, or a current Chrome/Firefox/Edge, is needed.
