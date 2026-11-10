"""Rebuild a Mac HFS disk image from a zip extracted on a non-Mac system.

Data forks live under <root>/<name>/..., resource forks + Finder info under
<root>/__MACOSX/<name>/._<file> (AppleDouble). Each file is joined into MacBinary II
and copied onto a fresh HFS volume with hfsutils.

usage: python3 -I make_hfs.py <extracted_root> <top_folder> <image_path> <volume_name> <size_mb>
"""
import os, struct, subprocess, sys

root, top, image, volname, size_mb = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], int(sys.argv[5])
work = os.path.join(os.path.dirname(os.path.abspath(image)), 'macbin_tmp')
os.makedirs(work, exist_ok=True)


def crc16_xmodem(data):
    crc = 0
    for b in data:
        crc ^= b << 8
        for _ in range(8):
            crc = ((crc << 1) ^ 0x1021) if crc & 0x8000 else (crc << 1)
            crc &= 0xFFFF
    return crc


def appledouble(path):
    """Return (rsrc_bytes, finder_info_32) from an AppleDouble file, or (b'', None)."""
    if not os.path.exists(path):
        return b'', None
    d = open(path, 'rb').read()
    if d[:4] != b'\x00\x05\x16\x07':
        return b'', None
    n = struct.unpack('>H', d[24:26])[0]
    rsrc, finfo = b'', None
    for i in range(n):
        eid, off, ln = struct.unpack('>III', d[26 + i * 12:38 + i * 12])
        if eid == 2:
            rsrc = d[off:off + ln]
        elif eid == 9:
            finfo = d[off:off + 32]
    return rsrc, finfo


def mac_name(s):
    return s.encode('mac_roman', 'replace')[:31]


def macbinary(name, data, rsrc, finfo):
    h = bytearray(128)
    nb = mac_name(name)
    h[1] = len(nb)
    h[2:2 + len(nb)] = nb
    if finfo:
        h[65:73] = finfo[0:8]              # type + creator
        h[73] = finfo[8]                   # finder flags high byte
        h[75:81] = finfo[10:16]            # location + folder
        h[101] = finfo[9]                  # finder flags low byte
    else:
        h[65:73] = b'????????'
    h[73] &= ~0x01 & 0xFF                  # clear "on desktop"
    struct.pack_into('>II', h, 83, len(data), len(rsrc))
    t = 0xB2000000                         # ~1998 in Mac epoch seconds
    struct.pack_into('>II', h, 91, t, t)
    h[122] = 129
    h[123] = 129
    struct.pack_into('>H', h, 124, crc16_xmodem(bytes(h[:124])))
    pad = lambda b: b + b'\0' * ((128 - len(b) % 128) % 128)
    return bytes(h) + pad(data) + pad(rsrc)


def run(*args):
    r = subprocess.run(args, capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(' '.join(args) + ': ' + r.stderr.strip())
    return r.stdout


if os.path.exists(image):
    os.remove(image)
with open(image, 'wb') as f:
    f.truncate(size_mb * 1024 * 1024)
run('hformat', '-l', volname, image)
run('hmount', image)

src_top = os.path.join(root, top)
count = 0
with_rsrc = 0
for dp, dns, fns in os.walk(src_top):
    rel = os.path.relpath(dp, src_top)
    parts = [] if rel == '.' else rel.split(os.sep)
    hpath = ':' + ':'.join(p.encode('mac_roman', 'replace').decode('latin1') for p in parts)
    for dn in sorted(dns):
        target = (hpath + ':' if parts else ':') + dn
        run('hmkdir', target)
    for fn in sorted(fns):
        if fn == '.DS_Store':
            continue
        data = open(os.path.join(dp, fn), 'rb').read()
        ad = os.path.join(root, '__MACOSX', top, *parts, '._' + fn)
        rsrc, finfo = appledouble(ad)
        if rsrc:
            with_rsrc += 1
        mb = os.path.join(work, 'f.bin')
        open(mb, 'wb').write(macbinary(fn, data, rsrc, finfo))
        dest = (hpath + ':' if parts else ':') + fn
        run('hcopy', '-m', mb, dest)
        count += 1
print(f'copied {count} files ({with_rsrc} with resource forks)')
print(run('hvol'))
run('humount')
os.remove(os.path.join(work, 'f.bin'))
os.rmdir(work)
