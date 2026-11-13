#!/bin/bash
cd ~/tools/dirplayer-rs/vm-rust
export RUSTC_BOOTSTRAP=1 CARGO_PROFILE_RELEASE_LTO=false CARGO_PROFILE_RELEASE_CODEGEN_UNITS=16 CARGO_PROFILE_RELEASE_INCREMENTAL=true CARGO_PROFILE_RELEASE_OPT_LEVEL=2
cargo build --release --target wasm32-unknown-unknown --lib > /tmp/cargo.log 2>&1
if grep -q "^error" /tmp/cargo.log; then grep -E "^error" -A10 /tmp/cargo.log | head -80; echo BUILD_FAILED; exit 1; fi
wasm-bindgen --target web --out-dir pkg target/wasm32-unknown-unknown/release/vm_rust.wasm || exit 1
cd .. && rm -rf node_modules/vm-rust && cp -r vm-rust/pkg node_modules/vm-rust && npx vite build -c vite.config.polyfill.js > /tmp/vite.log 2>&1 || { tail -20 /tmp/vite.log; exit 1; }
cp dist-polyfill/dirplayer-polyfill.js ~/site/ && echo BUILD_OK $(date +%T)
