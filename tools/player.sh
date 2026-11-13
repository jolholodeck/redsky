#!/bin/bash
# Build or save one module's player.
#
#   tools/player.sh build <module>   apply players/<module>/dirplayer.patch to a clean DirPlayer
#                                    checkout, build it, write site/players/<module>/dirplayer-polyfill.js.gz
#   tools/player.sh save <module>    write the DirPlayer checkout's current changes back to
#                                    players/<module>/dirplayer.patch (after editing the Rust)
#   tools/player.sh load <module>    reset the checkout and apply that module's patch, to edit it
#
# DirPlayer checkout: $DIRPLAYER (default ~/tools/dirplayer-rs), cloned from
# https://github.com/igorlira/dirplayer-rs at the commit in emulator/UPSTREAM_COMMIT, with
# `npm install` done. See emulator/README.md for the toolchain.
set -euo pipefail
cmd=${1:-}; mod=${2:-}
REPO=$(cd "$(dirname "$0")/.." && pwd)
DP=${DIRPLAYER:-$HOME/tools/dirplayer-rs}
PATCH=$REPO/players/$mod/dirplayer.patch
PATHS="vm-rust/src vm-rust/lingo.pest src/components"
[ -n "$mod" ] && [ -f "$PATCH" ] || { echo "usage: $0 build|save|load <module>; modules: $(ls "$REPO/players")"; exit 2; }
[ -d "$DP/.git" ] || { echo "No DirPlayer checkout at $DP (set DIRPLAYER)"; exit 2; }

load() {
  cd "$DP"
  git checkout -q "$(cat "$REPO/emulator/UPSTREAM_COMMIT")" -- $PATHS
  git reset -q -- $PATHS
  git clean -qfd -- $PATHS
  git apply --index "$PATCH"   # --index records new files, so `save` sees them
  echo "LOADED $mod"
}

case $cmd in
  load) load ;;
  save)
    cd "$DP"; git add -A -- $PATHS
    git diff --cached -- $PATHS > "$PATCH"
    echo "SAVED $mod ($(grep -c '^diff --git' "$PATCH") files changed from upstream)" ;;
  build)
    # Build what is in the checkout if it holds this module's patch; otherwise load it first.
    cd "$DP"; git add -A -- $PATHS
    if ! git diff --cached -- $PATHS | cmp -s - "$PATCH"; then
      if [ "${FORCE_LOAD:-}" = 1 ] || git diff --cached --quiet -- $PATHS; then load; else
        echo "The checkout holds changes that are not in players/$mod/dirplayer.patch."
        echo "Run '$0 save $mod' to keep them, or FORCE_LOAD=1 to discard them."; exit 1; fi
    fi
    cd "$DP/vm-rust"
    export RUSTC_BOOTSTRAP=1 CARGO_PROFILE_RELEASE_LTO=false CARGO_PROFILE_RELEASE_CODEGEN_UNITS=16 CARGO_PROFILE_RELEASE_INCREMENTAL=true CARGO_PROFILE_RELEASE_OPT_LEVEL=2
    log=$(mktemp)
    if ! cargo build --release --target wasm32-unknown-unknown --lib > "$log" 2>&1 || grep -q "^error" "$log"; then
      grep -E "^error" -A10 "$log" | head -80; echo BUILD_FAILED; exit 1; fi
    wasm-bindgen --target web --out-dir pkg target/wasm32-unknown-unknown/release/vm_rust.wasm
    cd "$DP" && rm -rf node_modules/vm-rust && cp -r vm-rust/pkg node_modules/vm-rust
    npx vite build -c vite.config.polyfill.js > "$log" 2>&1 || { tail -20 "$log"; exit 1; }
    mkdir -p "$REPO/site/players/$mod"
    gzip -9c dist-polyfill/dirplayer-polyfill.js > "$REPO/site/players/$mod/dirplayer-polyfill.js.gz"
    echo "BUILD_OK $mod $(date +%T)" ;;
  *) echo "usage: $0 build|save|load <module>"; exit 2 ;;
esac
