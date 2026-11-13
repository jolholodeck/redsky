/*
 * rsbae.c -- a small multi-song interface to NeoBAE (the open-source Beatnik Audio
 * Engine) for the Red Sky archive's stand-in for Director's Beatnik Xtra.
 *
 * One mixer; any number of songs. Each Beatnik Xtra object in Lingo maps to one song:
 * an RMF/MIDI file it plays, and/or live notes (noteOn/noteOff with bank+program).
 */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "NeoBAE.h"
#include "emscripten.h"

extern void BAE_BuildMixerSlice(void *threadContext, void *pAudioBuffer, int32_t bufferByteLength, int32_t sampleFrames);
extern void *BAE_WASM_GetMixerThreadContext(void);
extern struct GM_Mixer *GM_GetCurrentMixer(void);

#define MAX_SONGS 32
#define MAX_FRAMES 4096
static BAEMixer gMix = NULL;
static BAESong gSongs[MAX_SONGS];
static int16_t gOut[MAX_FRAMES * 2];

static void *slice_ctx(void)
{
    void *ctx = BAE_WASM_GetMixerThreadContext();
    if (ctx) return ctx;
    if (gMix && BAEMixer_MakeCurrent(gMix) == BAE_NO_ERROR) return (void *)GM_GetCurrentMixer();
    return NULL;
}

EMSCRIPTEN_KEEPALIVE int rs_init(int rate)
{
    if (gMix) return 0;
    gMix = BAEMixer_New();
    if (!gMix) return -1;
    BAERate r = rate >= 48000 ? BAE_RATE_48K : rate <= 22050 ? BAE_RATE_22K : BAE_RATE_44K;
    BAEResult e = BAEMixer_Open(gMix, r, BAE_LINEAR_INTERPOLATION, BAE_USE_16 | BAE_USE_STEREO, 56, 8, 64, FALSE);
    if (e != BAE_NO_ERROR) return (int)e;
    BAEMixer_SetDefaultReverb(gMix, BAE_REVERB_TYPE_8);
    memset(gSongs, 0, sizeof gSongs);
    return 0;
}

EMSCRIPTEN_KEEPALIVE int rs_add_bank(void *data, int len)
{
    BAEBankToken tok;
    return gMix ? (int)BAEMixer_AddBankFromMemory(gMix, data, (uint32_t)len, &tok) : -1;
}

EMSCRIPTEN_KEEPALIVE int rs_song_new(void)
{
    for (int i = 1; i < MAX_SONGS; i++)
        if (!gSongs[i]) {
            gSongs[i] = BAESong_New(gMix);
            return gSongs[i] ? i : -1;
        }
    return -1;
}

static BAESong S(int id) { return (id > 0 && id < MAX_SONGS) ? gSongs[id] : NULL; }

EMSCRIPTEN_KEEPALIVE int rs_song_delete(int id)
{
    BAESong s = S(id);
    if (!s) return -1;
    BAESong_Stop(s, FALSE);
    BAESong_Delete(s);
    gSongs[id] = NULL;
    return 0;
}

/* Load an RMF (or MIDI) file into a song. Replaces what the song held. */
EMSCRIPTEN_KEEPALIVE int rs_song_load(int id, void *data, int len)
{
    BAESong s = S(id);
    if (!s) return -1;
    BAESong_Stop(s, FALSE);
    BAESong_Delete(s);
    s = gSongs[id] = BAESong_New(gMix);
    if (!s) return -1;
    BAEResult e;
    if (len > 4 && memcmp(data, "MThd", 4) == 0)
        e = BAESong_LoadMidiFromMemory(s, data, (uint32_t)len, TRUE);
    else
        e = BAESong_LoadRmfFromMemory(s, data, (uint32_t)len, 0, TRUE);
    return (int)e;
}

EMSCRIPTEN_KEEPALIVE int rs_song_start(int id, int loops)
{
    BAESong s = S(id);
    if (!s) return -1;
    BAESong_SetLoops(s, (int16_t)loops);
    BAESong_Preroll(s);
    return (int)BAESong_Start(s, 0);
}

EMSCRIPTEN_KEEPALIVE int rs_song_stop(int id)
{
    BAESong s = S(id);
    return s ? (int)BAESong_Stop(s, FALSE) : -1;
}

EMSCRIPTEN_KEEPALIVE int rs_song_is_done(int id)
{
    BAESong s = S(id);
    BAE_BOOL done = TRUE;
    if (s) BAESong_IsDone(s, &done);
    return done ? 1 : 0;
}

/* volume: 0..127 maps to 0..1.0 (Beatnik Xtra used 0-127 / 0-100 in places) */
EMSCRIPTEN_KEEPALIVE int rs_song_volume(int id, int vol, int scale)
{
    BAESong s = S(id);
    if (!s) return -1;
    if (scale <= 0) scale = 127;
    return (int)BAESong_SetVolume(s, FLOAT_TO_UNSIGNED_FIXED((double)vol / (double)scale));
}

EMSCRIPTEN_KEEPALIVE int rs_note_on(int id, int chn, int bank, int pgm, int note, int vel)
{
    BAESong s = S(id);
    if (!s) return -1;
    BAESong_ProgramBankChange(s, (unsigned char)chn, (unsigned char)pgm, (unsigned char)bank, 0);
    return (int)BAESong_NoteOnWithLoad(s, (unsigned char)chn, (unsigned char)note, (unsigned char)vel, 0);
}

EMSCRIPTEN_KEEPALIVE int rs_note_off(int id, int chn, int note, int vel)
{
    BAESong s = S(id);
    return s ? (int)BAESong_NoteOff(s, (unsigned char)chn, (unsigned char)note, (unsigned char)vel, 0) : -1;
}

EMSCRIPTEN_KEEPALIVE int rs_controller(int id, int chn, int ctrl, int val)
{
    BAESong s = S(id);
    return s ? (int)BAESong_ControlChange(s, (unsigned char)chn, (unsigned char)ctrl, (unsigned char)val, 0) : -1;
}

EMSCRIPTEN_KEEPALIVE int rs_program(int id, int chn, int bank, int pgm)
{
    BAESong s = S(id);
    return s ? (int)BAESong_ProgramBankChange(s, (unsigned char)chn, (unsigned char)pgm, (unsigned char)bank, 0) : -1;
}

EMSCRIPTEN_KEEPALIVE int rs_reverb(int type)
{
    return gMix ? (int)BAEMixer_SetDefaultReverb(gMix, (BAEReverbType)type) : -1;
}

/* Render frames of interleaved 16-bit stereo; returns a pointer to them. */
EMSCRIPTEN_KEEPALIVE int16_t *rs_render(int frames)
{
    if (frames > MAX_FRAMES) frames = MAX_FRAMES;
    if (!gMix) { memset(gOut, 0, frames * 4); return gOut; }
    BAE_BuildMixerSlice(slice_ctx(), gOut, frames * 4, frames);
    return gOut;
}

EMSCRIPTEN_KEEPALIVE int rs_track_mute(int id, int track, int mute)
{
    BAESong s = S(id);
    if (!s) return -1;
    return (int)(mute ? BAESong_MuteTrack(s, (uint16_t)track) : BAESong_UnmuteTrack(s, (uint16_t)track));
}

EMSCRIPTEN_KEEPALIVE int rs_channel_mute(int id, int chn, int mute)
{
    BAESong s = S(id);
    if (!s) return -1;
    return (int)(mute ? BAESong_MuteChannel(s, (uint16_t)chn) : BAESong_UnmuteChannel(s, (uint16_t)chn));
}

EMSCRIPTEN_KEEPALIVE int rs_song_position(int id, int ms)
{
    BAESong s = S(id);
    return s ? (int)BAESong_SetMicrosecondPosition(s, (uint32_t)ms * 1000u) : -1;
}
