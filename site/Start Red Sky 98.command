#!/bin/bash
# Serves the Red Sky 98 site on this Mac and opens it in your browser. Close this window to stop.
cd "$(dirname "$0")"
PORT=8098
if command -v python3 >/dev/null 2>&1; then
  ( sleep 1; open "http://localhost:$PORT/" ) &
  echo "Red Sky 98 is running at http://localhost:$PORT/  (close this window to stop)"
  exec python3 -m http.server $PORT --bind 127.0.0.1
else
  echo "python3 was not found. Install Apple's command line tools with:  xcode-select --install"
  read -n 1
fi
