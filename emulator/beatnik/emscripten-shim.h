#pragma once
#define EMSCRIPTEN_KEEPALIVE __attribute__((used, visibility("default")))
__attribute__((import_module("env"), import_name("now_ms"))) double emscripten_get_now(void);
#define EM_ASM(...)
#define EM_JS(ret, name, args, ...) ret name args
