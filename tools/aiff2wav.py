import struct, sys, wave, math
def ext80(b):
    exp, mant = struct.unpack('>HQ', b)
    sign = -1 if exp & 0x8000 else 1; exp &= 0x7fff
    if exp == 0 and mant == 0: return 0.0
    return sign * mant * 2.0 ** (exp - 16383 - 63)
for fn in sys.argv[1:]:
    d = open(fn, 'rb').read()
    if d[:4] != b'FORM': print('skip', fn); continue
    p = 12; comm = ssnd = None
    while p + 8 <= len(d):
        cid = d[p:p+4]; ln = struct.unpack('>I', d[p+4:p+8])[0]
        body = d[p+8:p+8+ln]
        if cid == b'COMM': comm = body
        if cid == b'SSND': ssnd = body
        p += 8 + ln + (ln & 1)
    ch, frames, bits = struct.unpack('>hIh', comm[:8]); rate = ext80(comm[8:18])
    if not (4000 <= rate <= 50000): rate = 22254.545
    off = struct.unpack('>I', ssnd[:4])[0]; pcm = ssnd[8+off:]
    sw = (bits + 7) // 8; pcm = pcm[:frames*ch*sw]
    if sw == 1: pcm = bytes((b + 128) & 255 for b in pcm)   # signed -> unsigned
    elif sw == 2: pcm = b''.join(pcm[i+1:i+2] + pcm[i:i+1] for i in range(0, len(pcm) - 1, 2))
    with wave.open(fn, 'wb') as w:
        w.setnchannels(ch); w.setsampwidth(sw); w.setframerate(int(round(rate))); w.writeframes(pcm)
    print('ok', fn, ch, bits, round(rate), frames)
