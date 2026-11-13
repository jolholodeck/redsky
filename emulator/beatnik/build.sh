#!/bin/bash
# Build NeoBAE (open-source Beatnik Audio Engine) to wasm32-wasi with zig.
set -e
cd ~/tools/minibae/neobae
FLAGS="MP3_DEC=1 LZMA_SUPPORT=0 OGG_SUPPORT=0 VORBIS_DEC=0 OPUS_DEC=0 FLAC_DEC=0 KARAOKE=0 XMF_SUPPORT=0 ADP_SUPPORT=0 ADX_SUPPORT=0 QOA_SUPPORT=0 RETRO_RINGTONE_SUPPORT=0 MTHC_SUPPORT=0 ZMF_SUPPORT=0 RMI_SUPPORT=0 BAESCRIPT=0 EMBED_PATCHES=0 USE_BUILTIN_PATCHES_WITH_DLS=0 NATIVE_DLS=0"
SRC=$(make -f Makefile.emcc -pn $FLAGS 2>/dev/null | grep -E "^SRC :=" | sed 's/^SRC := //')
CF=$(make -f Makefile.emcc -pn $FLAGS 2>/dev/null | grep -E "^CFLAGS :=" | sed 's/^CFLAGS := //; s/-fPIC//; s/-O3//; s/-D_VERSION=[^ ]*//')
python3 -m ziglang cc -target wasm32-wasi -mexec-model=reactor -O2 -I ~/tools/bae-wasm/shim $CF -Wno-everything -D_VERSION=\"neobae\" $SRC "$@" \
  -Wl,--export-dynamic -Wl,--no-entry -Wl,--export=malloc -Wl,--export=free -o ~/tools/bae-wasm/bae.wasm
ls -la ~/tools/bae-wasm/bae.wasm
