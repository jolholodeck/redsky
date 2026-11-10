"""Extract bitmaps (PNG), palettes, sounds (WAV), text and a manifest from
unprotected Director 5/6 RIFX files (.dir/.cst produced by ProjectorRays).

usage: python3 -I dirextract.py <root_dir> <out_dir>
Walks root_dir for .dir/.cst files, resolves palettes across a movie's casts.
"""
import json, os, struct, sys, wave, io
from PIL import Image

PAL = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'palettes.json')))
BUILTIN = {-1: 'SYSTEM_MAC_PALETTE', -2: 'RAINBOW_PALETTE', -3: 'GRAYSCALE_PALETTE', -4: 'PASTELS_PALETTE',
           -5: 'VIVID_PALETTE', -6: 'NTSC_PALETTE', -7: 'METALLIC_PALETTE', -8: 'WEB_216_PALETTE',
           -101: 'SYSTEM_WIN_PALETTE', -102: 'SYSTEM_WIN_PALETTE'}
TYPES = {1: 'bitmap', 2: 'filmloop', 3: 'field', 4: 'palette', 5: 'picture', 6: 'sound', 7: 'button',
         8: 'shape', 9: 'movie', 10: 'digitalvideo', 11: 'script', 12: 'richtext', 13: 'ole', 14: 'transition',
         15: 'xtra'}


class Rifx:
    def __init__(self, path):
        self.path = path
        d = self.d = open(path, 'rb').read()
        assert d[:4] in (b'RIFX', b'XFIR'), path
        self.le = d[:4] == b'XFIR'
        E = self.E = '<' if self.le else '>'
        fix = (lambda f: f[::-1]) if self.le else (lambda f: f)
        self.fix = fix
        self.kind = fix(d[8:12]).decode()
        mmap_off = struct.unpack(E + 'I', d[24:28])[0]
        assert fix(d[mmap_off:mmap_off + 4]) == b'mmap'
        hlen, elen, maxc, used = struct.unpack(E + 'HHii', d[mmap_off + 8:mmap_off + 20])
        p = mmap_off + 8 + hlen
        self.chunks = []
        for i in range(used):
            fcc, ln, off = struct.unpack(E + '4sIi', d[p:p + 12])
            self.chunks.append((fix(fcc).decode('latin1'), ln, off))
            p += elen

    def chunk(self, idx):
        fcc, ln, off = self.chunks[idx]
        if off <= 0 or ln == 0:
            return b''
        return self.d[off + 8: off + 8 + ln]

    def first(self, fcc):
        for i, c in enumerate(self.chunks):
            if c[0] == fcc:
                return i
        return None


def read_list(d, data_off):
    cnt = struct.unpack('>H', d[data_off:data_off + 2])[0]
    offs = list(struct.unpack('>%dI' % cnt, d[data_off + 2:data_off + 2 + 4 * cnt]))
    p = data_off + 2 + 4 * cnt
    total = struct.unpack('>I', d[p:p + 4])[0]
    base = p + 4
    items = []
    for i in range(cnt):
        nxt = offs[i + 1] if i + 1 < cnt else total
        items.append(d[base + offs[i]: base + nxt])
    return items


def pstr(b):
    return b[1:1 + b[0]].decode('mac_roman', 'replace') if b else ''


def pstrings_info(info):
    """Parse a CASt info block; returns (name, script_text)."""
    if len(info) < 20:
        return '', ''
    data_off = struct.unpack('>I', info[0:4])[0]
    try:
        items = read_list(info, data_off)
    except struct.error:
        return '', ''
    name = pstr(items[1]) if len(items) > 1 else ''
    script = items[0].decode('mac_roman', 'replace') if items else ''
    return name, script


def unrle(data, expected):
    if len(data) >= expected:
        return data[:expected]
    out = bytearray()
    i = 0
    n = len(data)
    while i < n and len(out) < expected:
        b = data[i]; i += 1
        if b < 0x80:
            out += data[i:i + b + 1]; i += b + 1
        else:
            cnt = 257 - b
            if i < n:
                out += bytes([data[i]]) * cnt
            i += 1
    out += b'\0' * (expected - len(out))
    return bytes(out[:expected])


def parse_clut(data):
    cols = []
    for i in range(0, len(data) - 5, 6):
        cols.append((data[i], data[i + 2], data[i + 4]))
    return cols


def parse_bitmap_info(sd, ver=600):
    pitch, top, left, bottom, right = struct.unpack('>HhhhH', sd[0:10])
    right = struct.unpack('>h', sd[8:10])[0]
    w, h = right - left, bottom - top
    regy, regx = struct.unpack('>hh', sd[18:22]) if len(sd) >= 22 else (0, 0)
    bpp, clutlib, clut = 1, -1, -1
    if pitch & 0x8000:
        pitch &= 0x3fff
        if len(sd) >= 24:
            bpp = sd[23]
        if len(sd) >= 26:
            clutlib = struct.unpack('>h', sd[24:26])[0]
        if len(sd) >= 28:
            v = struct.unpack('>h', sd[26:28])[0]
            clut = v - 1 if v <= 0 else v
    else:
        pitch &= 0x3fff
    return dict(w=w, h=h, pitch=pitch, bpp=bpp, clutlib=clutlib, clut=clut, regx=regx - left, regy=regy - top)


def decode_bitmap(bitd, bi, palette):
    w, h, pitch, bpp = bi['w'], bi['h'], bi['pitch'], bi['bpp']
    if w <= 0 or h <= 0:
        return None
    if bpp == 32:
        raw = unrle(bitd, w * 4 * h) if len(bitd) < w * 4 * h else bitd[:w * 4 * h]
        img = Image.new('RGBA', (w, h))
        px = []
        for y in range(h):
            row = raw[y * w * 4:(y + 1) * w * 4]
            a, r, g, b = row[0:w], row[w:2 * w], row[2 * w:3 * w], row[3 * w:4 * w]
            px += [(r[x], g[x], b[x], 255) for x in range(w)]
        img.putdata(px)
        return img
    if bpp == 16:
        rp = pitch if pitch else w * 2
        raw = unrle(bitd, rp * h)
        img = Image.new('RGB', (w, h))
        px = []
        for y in range(h):
            row = raw[y * rp:(y + 1) * rp]
            hi, lo = row[0:w], row[w:2 * w]
            for x in range(w):
                v = (hi[x] << 8) | lo[x]
                r, g, b = (v >> 10) & 31, (v >> 5) & 31, v & 31
                px.append((r * 255 // 31, g * 255 // 31, b * 255 // 31))
        img.putdata(px)
        return img
    if not pitch:
        pitch = ((w * bpp + 15) // 16) * 2
    raw = unrle(bitd, pitch * h)
    idx = bytearray(w * h)
    for y in range(h):
        row = raw[y * pitch:(y + 1) * pitch]
        if bpp == 8:
            idx[y * w:(y + 1) * w] = row[:w]
        else:
            per = 8 // bpp
            mask = (1 << bpp) - 1
            for x in range(w):
                byte = row[x // per] if x // per < len(row) else 0
                shift = 8 - bpp * (x % per + 1)
                idx[y * w + x] = (byte >> shift) & mask
    img = Image.frombytes('P', (w, h), bytes(idx))
    if bpp == 1:
        pal = [(255, 255, 255), (0, 0, 0)]
    elif bpp in (2, 4):
        n = 1 << bpp
        if palette and len(palette) == 256 and n == 16:
            pal = PAL['MAC_16_PALETTE']
        elif palette and len(palette) >= n:
            pal = palette[:n]
        else:
            pal = [tuple(int(255 - 255 * i / (n - 1)) for _ in range(3)) for i in range(n)]
    else:
        pal = palette
    flat = []
    for c in list(pal)[:256]:
        flat += list(c)
    flat += [0] * (768 - len(flat))
    img.putpalette(flat)
    return img


def mac_snd_to_wav(data):
    """Decode a Mac 'snd ' resource (format 1/2) to (rate, channels, sampwidth, pcm_le_bytes)."""
    if len(data) < 20:
        return None
    fmt = struct.unpack('>H', data[0:2])[0]
    p = 2
    if fmt == 1:
        ndt = struct.unpack('>H', data[p:p + 2])[0]; p += 2 + ndt * 6
    elif fmt == 2:
        p += 2
    else:
        return None
    ncmd = struct.unpack('>H', data[p:p + 2])[0]; p += 2
    hdr = None
    for _ in range(ncmd):
        cmd, p1, p2 = struct.unpack('>HHI', data[p:p + 8]); p += 8
        if cmd in (0x8050, 0x8051):
            hdr = p2
    if hdr is None:
        hdr = p
    sp, ln, rate, ls, le, enc, base = struct.unpack('>IIIIIBB', data[hdr:hdr + 22])
    rate = rate >> 16 or 22050
    if enc == 0:
        pcm = data[hdr + 22:hdr + 22 + ln]
        return rate, 1, 1, pcm
    if enc == 0xFF:
        ch = ln
        nframes = struct.unpack('>I', data[hdr + 22:hdr + 26])[0]
        ss = struct.unpack('>H', data[hdr + 48:hdr + 50])[0]
        pcm = data[hdr + 64:]
        if ss == 16:
            pcm = pcm[:nframes * ch * 2]
            pcm = bytes(b for i in range(0, len(pcm) - 1, 2) for b in (pcm[i + 1], pcm[i]))
            return rate, ch, 2, pcm
        return rate, ch, 1, pcm[:nframes * ch]
    return ('compressed', enc)


def write_wav(path, rate, ch, sw, pcm):
    with wave.open(path, 'wb') as w:
        w.setnchannels(ch); w.setsampwidth(sw); w.setframerate(rate)
        w.writeframes(pcm)


def safe(s):
    s = ''.join(c if c.isalnum() or c in '-_. ' else '_' for c in s).strip()
    return s[:60] or 'unnamed'


class CastFile:
    """One RIFX file containing one or more cast libraries."""

    def __init__(self, path):
        self.r = Rifx(path)
        r = self.r
        key = r.first('KEY*')
        kd = r.chunk(key)
        E = r.E
        _, _, _, used = struct.unpack(E + 'HHii', kd[:12])
        self.key = []
        for i in range(used):
            sec, cid, fcc = struct.unpack(E + 'ii4s', kd[12 + i * 12:24 + i * 12])
            self.key.append((sec, cid, r.fix(fcc).decode('latin1')))
        self.owned = {}
        for sec, cid, fcc in self.key:
            self.owned.setdefault(cid, {})[fcc] = sec
        # cast libraries
        self.libs = []  # list of dict(name, file, id, min, members{num: section})
        mcsl = r.first('MCsL')
        if mcsl is not None:
            self.libs = self._parse_mcsl(r.chunk(mcsl))
        else:
            self.libs = [dict(name=os.path.splitext(os.path.basename(path))[0], file='', id=1024, min=1)]
        for lib in self.libs:
            cas = self.owned.get(lib['id'], {}).get('CAS*')
            lib['members'] = {}
            if cas is not None:
                cd = r.chunk(cas)
                ids = struct.unpack('>%di' % (len(cd) // 4), cd)
                for i, s in enumerate(ids):
                    if s > 0:
                        lib['members'][lib['min'] + i] = s
        if len(self.libs) == 1 and not self.libs[0]['members']:
            cas = r.first('CAS*')
            if cas is not None:
                cd = r.chunk(cas)
                ids = struct.unpack('>%di' % (len(cd) // 4), cd)
                self.libs[0]['members'] = {self.libs[0]['min'] + i: s for i, s in enumerate(ids) if s > 0}

    def _parse_mcsl(self, d):
        data_off, unk0, cnt, items_per, unk1 = struct.unpack('>IHHHH', d[:12])
        items = read_list(d, data_off)
        libs = []
        for c in range(cnt):
            g = lambda k: items[c * items_per + k] if c * items_per + k < len(items) else b''
            name = pstr(g(1)); fp = pstr(g(2)); mm = g(4)
            mn, mx, cid = struct.unpack('>HHi', mm[:8]) if len(mm) >= 8 else (1, 0, 1024 + c)
            libs.append(dict(name=name, file=fp, id=cid, min=mn))
        return libs

    def member(self, sec):
        d = self.r.chunk(sec)
        if len(d) < 12:
            return None
        typ, infolen, sdlen = struct.unpack('>III', d[:12])
        info = d[12:12 + infolen]
        sd = d[12 + infolen:12 + infolen + sdlen]
        name, script = pstrings_info(info)
        return dict(type=typ, name=name, script=script, sd=sd, sec=sec)

    def data_for(self, sec, fcc):
        s = self.owned.get(sec, {}).get(fcc)
        return None if s is None else self.r.chunk(s)


def extract_group(movie_path, cast_paths, outdir, manifest):
    """movie_path: .dir (or .cst alone). cast_paths: dict lowercase-name -> path."""
    files = [CastFile(movie_path)]
    libs = []  # (libnumber, lib dict, CastFile)
    for lib in files[0].libs:
        if lib['members']:
            libs.append((lib, files[0]))
        else:
            fb = lib['file'].replace(':', '/').split('/')[-1]
            fb = os.path.splitext(fb)[0].lower()
            ext = cast_paths.get(fb) or cast_paths.get(lib['name'].lower())
            if ext:
                cf = CastFile(ext)
                l2 = cf.libs[0]
                libs.append((dict(l2, name=lib['name']), cf))
            else:
                libs.append((lib, None))
    # palettes
    pals = {}  # (libnum, member) -> colors
    for li, (lib, cf) in enumerate(libs, 1):
        if not cf:
            continue
        for num, sec in lib['members'].items():
            m = cf.member(sec)
            if m and m['type'] == 4:
                cl = cf.data_for(sec, 'CLUT')
                if cl:
                    pals[(li, num)] = parse_clut(cl)
    os.makedirs(outdir, exist_ok=True)
    entries = []
    for li, (lib, cf) in enumerate(libs, 1):
        if not cf:
            continue
        ldir = os.path.join(outdir, safe(lib['name']))
        for num, sec in sorted(lib['members'].items()):
            m = cf.member(sec)
            if not m:
                continue
            typ = TYPES.get(m['type'], str(m['type']))
            e = dict(lib=lib['name'], num=num, name=m['name'], type=typ)
            base = '%04d_%s' % (num, safe(m['name']) if m['name'] else typ)
            try:
                if m['type'] == 1:
                    bi = parse_bitmap_info(m['sd'])
                    pal = None
                    if bi['bpp'] in (2, 4, 8):
                        if bi['clut'] < 0:
                            pal = [tuple(c) for c in PAL[BUILTIN.get(bi['clut'], 'SYSTEM_MAC_PALETTE')]]
                        else:
                            plib = bi['clutlib'] if bi['clutlib'] > 0 else li
                            pal = pals.get((plib, bi['clut'])) or pals.get((li, bi['clut']))
                            if pal is None:
                                # search any lib
                                for (pl, pn), pc in pals.items():
                                    if pn == bi['clut']:
                                        pal = pc; break
                            if pal is None:
                                pal = [tuple(c) for c in PAL['SYSTEM_MAC_PALETTE']]
                                e['palette_missing'] = True
                    bitd = cf.data_for(sec, 'BITD')
                    e.update(w=bi['w'], h=bi['h'], bpp=bi['bpp'], regx=bi['regx'], regy=bi['regy'],
                             clut=bi['clut'], clutlib=bi['clutlib'])
                    if bitd is not None:
                        img = decode_bitmap(bitd, bi, pal)
                        if img:
                            os.makedirs(ldir, exist_ok=True)
                            fn = os.path.join(ldir, base + '.png')
                            img.save(fn)
                            e['file'] = os.path.relpath(fn, outdir)
                elif m['type'] == 4:
                    if (li, num) in pals:
                        e['colors'] = len(pals[(li, num)])
                        os.makedirs(ldir, exist_ok=True)
                        fn = os.path.join(ldir, base + '.pal.json')
                        json.dump(pals[(li, num)], open(fn, 'w'))
                        e['file'] = os.path.relpath(fn, outdir)
                elif m['type'] == 6:
                    snd = cf.data_for(sec, 'snd ')
                    res = None
                    if snd:
                        res = mac_snd_to_wav(snd)
                    if not res or isinstance(res, tuple) and res[0] == 'compressed':
                        h = cf.data_for(sec, 'sndH'); s = cf.data_for(sec, 'sndS')
                        if h and s is not None:
                            frames, rate = struct.unpack('>II', h[40:48])
                            bits, _, ch = struct.unpack('>III', h[68:80])
                            sw = max(1, bits // 8)
                            pcm = s
                            if sw == 2:
                                pcm = bytes(b for i in range(0, len(pcm) - 1, 2) for b in (pcm[i + 1], pcm[i]))
                            res = (rate, ch or 1, sw, pcm)
                    if res and not (isinstance(res, tuple) and res[0] == 'compressed'):
                        os.makedirs(ldir, exist_ok=True)
                        fn = os.path.join(ldir, base + '.wav')
                        write_wav(fn, *res)
                        e['file'] = os.path.relpath(fn, outdir)
                        e['rate'], e['channels'], e['bits'] = res[0], res[1], res[2] * 8
                        e['seconds'] = round(len(res[3]) / (res[0] * res[1] * res[2]), 2)
                    elif res:
                        e['compressed'] = res[1]
                    # linked sound file name
                    if m['script'] and not e.get('file'):
                        e['linked'] = m['script']
                elif m['type'] in (3, 7):
                    t = cf.data_for(sec, 'STXT')
                    if t and len(t) >= 12:
                        hl, tl = struct.unpack('>II', t[:8])
                        e['text'] = t[hl:hl + tl].decode('mac_roman', 'replace').replace('\r', '\n')
                elif m['type'] == 12:
                    t = cf.data_for(sec, 'RTE0') or cf.data_for(sec, 'RTE1')
                    if t:
                        e['richtext_bytes'] = len(t)
                elif m['type'] in (9, 10):
                    if m['script']:
                        e['linked'] = m['script']
            except Exception as ex:
                e['error'] = repr(ex)
            entries.append(e)
    manifest.extend(entries)
    return entries


def main():
    root, out = sys.argv[1], sys.argv[2]
    allfiles = []
    for dp, dn, fn in os.walk(root):
        for f in fn:
            if f.lower().endswith(('.dir', '.cst')):
                allfiles.append(os.path.join(dp, f))
    # map cast names -> paths (by basename without ext)
    castmap = {}
    for p in allfiles:
        if p.lower().endswith('.cst'):
            castmap[os.path.splitext(os.path.basename(p))[0].lower()] = p
    used_casts = set()
    summary = {}
    for p in sorted(allfiles):
        if not p.lower().endswith('.dir'):
            continue
        rel = os.path.relpath(p, root)
        od = os.path.join(out, os.path.splitext(rel)[0])
        man = []
        cf = CastFile(p)
        for lib in cf.libs:
            if not lib['members'] and lib['name'].lower() in castmap:
                used_casts.add(castmap[lib['name'].lower()])
        extract_group(p, castmap, od, man)
        json.dump(man, open(os.path.join(od, 'manifest.json'), 'w'), indent=1)
        summary[rel] = {t: sum(1 for e in man if e['type'] == t and e.get('file')) for t in ('bitmap', 'sound', 'palette')}
        summary[rel]['members'] = len(man)
        summary[rel]['errors'] = sum(1 for e in man if 'error' in e)
        print(rel, summary[rel], flush=True)
    json.dump(summary, open(os.path.join(out, 'summary.json'), 'w'), indent=1)


if __name__ == '__main__':
    main()
