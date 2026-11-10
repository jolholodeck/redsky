"""Replace bitmap cast members inside an unprotected Director 5/6 movie or cast (.dir/.cst).

The PNG must be an indexed image the same size as the member, using the member's palette
(an edit of the PNG that dirextract.py exported). Its pixel indexes are written back as a new
BITD chunk appended to the file; the memory map is pointed at it, and the old chunk is left
in place unused. Size, registration point, bit depth and palette of the member are unchanged.

usage: python3 -I replace_bitmap.py <movie.dir> <member_number>=<edited.png> [...]
       (members in the movie's own Internal cast)
"""
import os, struct, sys
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from dirextract import CastFile, parse_bitmap_info  # noqa: E402


def packbits_row(row):
    out = bytearray()
    i, n = 0, len(row)
    while i < n:
        j = i + 1
        while j < n and j - i < 128 and row[j] == row[i]:
            j += 1
        if j - i >= 3:                       # run
            out += bytes([257 - (j - i), row[i]])
            i = j
            continue
        j = i                                # literal until a run of 3 starts
        while j < n and j - i < 128 and not (j + 2 < n and row[j] == row[j + 1] == row[j + 2]):
            j += 1
        out += bytes([j - i - 1]) + row[i:j]
        i = j
    return bytes(out)


def encode(img, bi):
    w, h, bpp, pitch = bi['w'], bi['h'], bi['bpp'], bi['pitch']
    if bpp != 8:
        raise SystemExit('only 8-bit members are supported so far (this one is %d-bit)' % bpp)
    pitch = pitch or ((w * bpp + 15) // 16) * 2
    idx = img.tobytes()
    rows = [idx[y * w:(y + 1) * w] + b'\0' * (pitch - w) for y in range(h)]
    rle = b''.join(packbits_row(r) for r in rows)
    raw = b''.join(rows)
    return rle if len(rle) < len(raw) else raw


def main():
    path = sys.argv[1]
    cf = CastFile(path)
    r = cf.r
    E, fix = r.E, r.fix
    d = bytearray(r.d)
    mmap_off = struct.unpack(E + 'I', d[24:28])[0]
    hlen, elen = struct.unpack(E + 'HH', d[mmap_off + 8:mmap_off + 12])
    lib = next(l for l in cf.libs if l['members'])
    for arg in sys.argv[2:]:
        num, png = arg.split('=', 1)
        num = int(num)
        sec = lib['members'][num]
        m = cf.member(sec)
        assert m and m['type'] == 1, 'member %d is not a bitmap' % num
        bi = parse_bitmap_info(m['sd'])
        img = Image.open(png)
        assert img.mode == 'P', '%s is not an indexed (256-colour) PNG' % png
        assert img.size == (bi['w'], bi['h']), '%s is %dx%d, member %d is %dx%d' % (
            png, img.size[0], img.size[1], num, bi['w'], bi['h'])
        data = encode(img, bi)
        bitd = cf.owned[sec]['BITD']
        off = len(d)
        d += fix(b'BITD') + struct.pack(E + 'I', len(data)) + data + (b'\0' if len(data) % 2 else b'')
        p = mmap_off + 8 + hlen + bitd * elen
        struct.pack_into(E + 'Ii', d, p + 4, len(data), off)
        print('member %d "%s": %d bytes' % (num, m['name'], len(data)))
    struct.pack_into(E + 'I', d, 4, len(d) - 8)
    open(path, 'wb').write(bytes(d))


if __name__ == '__main__':
    main()
