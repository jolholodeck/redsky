"""Extract the movies (and Xtras) embedded in a Director 5-7 Mac projector.

usage: python3 -I extract_projector.py <projector> <out_dir>
Writes each embedded movie under its original name from the projector's file list.
As a module: movies(path) -> [(original name, movie bytes)].
"""
import os, re, struct, sys


def rebase(blob, start):
    """Embedded movies keep memory-map offsets relative to the projector file; make them
    relative to the extracted movie."""
    b = bytearray(blob)
    if b[8:12] not in (b'MV93', b'MC95'):
        return bytes(b)
    mo = struct.unpack('>I', b[24:28])[0]
    if mo >= start:
        mo -= start
    struct.pack_into('>I', b, 24, mo)
    assert b[mo:mo + 4] == b'mmap', 'mmap not found after rebasing'
    hlen, elen, maxc, used = struct.unpack('>HHii', b[mo + 8:mo + 20])
    q = mo + 8 + hlen
    for i in range(used):
        e = q + i * elen
        off = struct.unpack('>i', b[e + 8:e + 12])[0]
        if off >= start:
            struct.pack_into('>i', b, e + 8, off - start)
    return bytes(b)


def read(src):
    """(file names from the projector's Dict, [(fourcc, bytes)] of embedded files)."""
    d = open(src, 'rb').read()
    base = d.find(b'RIFX')
    if base < 0 or d[base + 8:base + 12] != b'APPL':
        return [], []
    r = d[base:]
    size = struct.unpack('>I', r[4:8])[0]
    p, dict_text, items = 12, b'', []
    while p + 8 <= min(size + 8, len(r)):
        fcc = r[p:p + 4]
        ln = struct.unpack('>I', r[p + 4:p + 8])[0]
        if fcc == b'Dict':
            dict_text = r[p + 8:p + 8 + ln]
        if fcc in (b'RIFX', b'RIFF'):
            blob = r[p:p + 8 + ln]
            items.append((fcc, rebase(blob, base + p) if fcc == b'RIFX' else blob))
        p += 8 + ln + (ln & 1)
    names = [n.decode('mac_roman') for n in re.findall(rb'[\x20-\x7e\x80-\xff]{3,}', dict_text)]
    return names, items


def movies(src):
    names, items = read(src)
    movie_names = [n.split(':')[-1].strip() for n in names
                   if re.search(r'\.(dir|dxr|cst|cxt|dcr|cct)\s*$', n, re.I)]
    blobs = [b for fcc, b in items if fcc == b'RIFX']
    return [(movie_names[i] if i < len(movie_names) else 'movie%02d.dir' % i, b) for i, b in enumerate(blobs)]


if __name__ == '__main__':
    src, out = sys.argv[1], sys.argv[2]
    os.makedirs(out, exist_ok=True)
    for name, blob in movies(src):
        path = os.path.join(out, name)
        open(path, 'wb').write(blob)
        print(path, len(blob), blob[8:12].decode('latin1'))
