"""Timing inventory for Director 6 movies: score tempo/transition/palette/sound channels,
frame labels, timing-related cast members, and timing-related Lingo calls.

usage: python3 -I timing_report.py <work_dir> <out_json>
"""
import glob, json, os, re, struct, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from dirextract import CastFile, read_list  # noqa: E402

TRANS = {1: 'wipe right', 2: 'wipe left', 3: 'wipe down', 4: 'wipe up', 5: 'center out, horizontal',
         6: 'edges in, horizontal', 7: 'center out, vertical', 8: 'edges in, vertical', 9: 'center out, square',
         10: 'edges in, square', 11: 'push left', 12: 'push right', 13: 'push down', 14: 'push up',
         15: 'reveal up', 16: 'reveal up, right', 17: 'reveal right', 18: 'reveal down, right', 19: 'reveal down',
         20: 'reveal down, left', 21: 'reveal left', 22: 'reveal up, left', 23: 'dissolve, pixels fast',
         24: 'dissolve, boxy rectangles', 25: 'dissolve, boxy squares', 26: 'dissolve, patterns',
         27: 'random rows', 28: 'random columns', 29: 'cover down', 30: 'cover down, left', 31: 'cover down, right',
         32: 'cover left', 33: 'cover right', 34: 'cover up', 35: 'cover up, left', 36: 'cover up, right',
         37: 'venetian blinds', 38: 'checkerboard', 39: 'strips on bottom, build left',
         40: 'strips on bottom, build right', 41: 'strips on left, build down', 42: 'strips on left, build up',
         43: 'strips on right, build down', 44: 'strips on right, build up', 45: 'strips on top, build left',
         46: 'strips on top, build right', 47: 'zoom open', 48: 'zoom close', 49: 'vertical blinds',
         50: 'dissolve, bits fast', 51: 'dissolve, pixels', 52: 'dissolve, bits'}

LINGO_PATTERNS = {
    'puppetPalette': r'\bpuppetPalette\s*\(',
    'puppetTransition': r'\bpuppetTransition\s*\(',
    'puppetTempo': r'\bpuppetTempo\s*\(',
    'timer busy-wait': r'repeat while the timer\b',
    'ticks busy-wait': r'repeat while the ticks\b',
    'soundBusy wait': r'repeat while (not )?soundBusy',
    'delay': r'\bdelay\s*\(',
    'updateStage': r'\bupdateStage\s*\(',
    'startTimer': r'\bstartTimer\s*\(',
    'the ticks': r'\bthe ticks\b',
    'the timer': r'\bthe timer\b',
    'sound playFile': r'sound playFile',
    'puppetSound': r'\bpuppetSound\s*\(',
    'soundBusy': r'\bsoundBusy\s*\(',
    'go(the frame)': r'go\(the frame\)',
    'digital video': r'movieRate|movieTime|digitalVideo|quickTime',
    'tempo / frameTempo': r'\bthe (frameTempo|tempo)\b',
    'cursor': r'\bcursor\s*\(',
    'rollOver': r'\brollOver\s*\(',
    'the mouseH/V': r'\bthe mouse[HV]\b',
}


def le_ok(cf):
    return cf.r


def parse_score(cf):
    r = cf.r
    idx = r.first('VWSC')
    if idx is None:
        return None
    d = r.chunk(idx)
    fss, ver, list_start = struct.unpack('>III', d[:12])
    n_entries, list_size, max_len = struct.unpack('>III', d[list_start:list_start + 12])
    offs = struct.unpack('>%dI' % n_entries, d[list_start + 12:list_start + 12 + 4 * n_entries])
    data_off = list_start + 12 + list_size * 4
    entries = []
    for i in range(n_entries):
        s = data_off + offs[i]
        e = data_off + offs[i + 1] if i + 1 < n_entries else len(d)
        entries.append(d[s:e])
    fd = entries[0]
    actual_len, unk1, fcount, fver, rec, nch, _ = struct.unpack('>IIIHHHH', fd[:20])
    p = 20
    buf = bytearray(rec * nch)
    frames = []
    while p + 2 <= len(fd):
        ln = struct.unpack('>H', fd[p:p + 2])[0]
        if ln < 2:
            break
        chunk = fd[p + 2:p + ln]
        p += ln
        q = 0
        while q + 4 <= len(chunk):
            sz, off = struct.unpack('>HH', chunk[q:q + 4])
            buf[off:off + sz] = chunk[q + 4:q + 4 + sz]
            q += 4 + sz
        frames.append(bytes(buf[:rec * 6]))  # main channels only: script, tempo, transition, snd1, snd2, palette
    return dict(record=rec, channels=nch, frames=frames, version=fver)


def member_info(cf, lib_num, member_num, libs):
    if lib_num <= 0 or lib_num > len(libs):
        lib_num = 1
    lib, f = libs[lib_num - 1]
    if not f:
        return None
    sec = lib['members'].get(member_num)
    if sec is None:
        return None
    return f.member(sec)


def frame_labels(cf):
    idx = cf.r.first('VWLB')
    if idx is None:
        return {}
    d = cf.r.chunk(idx)
    n = struct.unpack('>H', d[:2])[0]
    labels = []
    for i in range(n):
        frame, off = struct.unpack('>HH', d[2 + i * 4:6 + i * 4])
        labels.append((frame, off))
    base = 2 + (n + 1) * 4 + 4
    out = {}
    nxt_off = struct.unpack('>H', d[2 + n * 4 + 2:2 + n * 4 + 4])[0] if len(d) >= 2 + n * 4 + 4 else None
    text_len = struct.unpack('>I', d[2 + (n + 1) * 4:2 + (n + 1) * 4 + 4])[0] if len(d) >= 2 + (n + 1) * 4 + 4 else 0
    text = d[base:base + text_len]
    for i, (frame, off) in enumerate(labels):
        end = labels[i + 1][1] if i + 1 < n else len(text)
        out[frame] = text[off:end].decode('mac_roman', 'replace')
    return out


def analyze(path, castmap, workroot):
    cf = CastFile(path)
    libs = []
    for lib in cf.libs:
        if lib['members']:
            libs.append((lib, cf))
        else:
            fb = os.path.splitext(lib['file'].replace(':', '/').split('/')[-1])[0].lower()
            ext = castmap.get(fb) or castmap.get(lib['name'].lower())
            if ext:
                c2 = CastFile(ext)
                libs.append((c2.libs[0], c2))
            else:
                libs.append((lib, None))
    sc = parse_score(cf)
    res = dict(movie=os.path.relpath(path, workroot), frames=0, tempo=[], transitions=[], palettes=[], sounds=[],
               labels={}, video_members=[], linked_sounds=[], lingo={})
    try:
        res['labels'] = {str(k): v for k, v in frame_labels(cf).items()}
    except Exception as e:
        res['labels_error'] = repr(e)
    if sc:
        rec = sc['record']
        res['frames'] = len(sc['frames'])
        prev = {}
        for fi, fr in enumerate(sc['frames'], start=1):
            ch = [fr[i * rec:(i + 1) * rec] for i in range(6)]
            # tempo channel (1)
            t = ch[1]
            if t != prev.get(1):
                sli, cue, tempo, ctempo, wflags, cflags = struct.unpack('>IHBBHH', t[:12])
                if (sli >> 16) != 0xFFFE and not (sli == 0 and tempo == 0 and cue == 0):
                    res['tempo'].append(dict(frame=fi, tempo=tempo, value=cue, wait_flags=wflags,
                                             channel_flags=cflags, raw=t[:20].hex()))
                prev[1] = t
            # transition channel (2)
            tr = ch[2]
            if tr != prev.get(2):
                lib, mem = struct.unpack('>hh', tr[:4])
                if mem:
                    m = member_info(cf, lib, mem, libs)
                    info = dict(frame=fi, member=f'{lib}:{mem}')
                    if m and m['type'] == 14 and len(m['sd']) >= 6:
                        sd = m['sd']
                        info.update(name=m['name'], type=TRANS.get(sd[2], f'#{sd[2]}'), type_id=sd[2],
                                    chunk=sd[1], flags=sd[3], duration_ms=struct.unpack('>H', sd[4:6])[0],
                                    sd=sd.hex())
                    res['transitions'].append(info)
                prev[2] = tr
            # sound channels (3, 4)
            for c in (3, 4):
                s = ch[c]
                if s != prev.get(c):
                    lib, mem = struct.unpack('>hh', s[:4])
                    if mem:
                        m = member_info(cf, lib, mem, libs)
                        res['sounds'].append(dict(frame=fi, channel=c - 2, member=f'{lib}:{mem}',
                                                  name=m['name'] if m else None,
                                                  member_over_255=mem > 255, raw=s[:8].hex()))
                    prev[c] = s
            # palette channel (5)
            pal = ch[5]
            if pal != prev.get(5):
                lib, mem = struct.unpack('>hh', pal[:4])
                if lib or mem:
                    m = member_info(cf, lib, mem, libs) if mem > 0 else None
                    res['palettes'].append(dict(frame=fi, member=f'{lib}:{mem}', name=m['name'] if m else None,
                                                rate=pal[4], flags=pal[5], raw=pal[:16].hex()))
                prev[5] = pal
    # members: digital video, linked sounds
    for li, (lib, f) in enumerate(libs, 1):
        if not f:
            continue
        for num, sec in lib['members'].items():
            m = f.member(sec)
            if not m:
                continue
            if m['type'] in (9, 10):
                res['video_members'].append(dict(member=f'{li}:{num}', name=m['name'], type=m['type'],
                                                 linked=m['script'][:200]))
            if m['type'] == 6 and f.data_for(sec, 'snd ') in (None, b'') and f.data_for(sec, 'sndS') is None:
                res['linked_sounds'].append(dict(member=f'{li}:{num}', name=m['name']))
    # Lingo usage (scripts dumped next to the movie by ProjectorRays)
    sdir = os.path.splitext(path)[0]
    text = ''
    for ls in glob.glob(os.path.join(sdir, '**', '*.ls'), recursive=True):
        text += open(ls, errors='replace').read() + '\n'
    for k, pat in LINGO_PATTERNS.items():
        n = len(re.findall(pat, text, re.I))
        if n:
            res['lingo'][k] = n
    return res


def main():
    work, out = sys.argv[1], sys.argv[2]
    castmap = {}
    for p in glob.glob(os.path.join(work, '**', '*.cst'), recursive=True):
        castmap[os.path.splitext(os.path.basename(p))[0].lower()] = p
    results = []
    for p in sorted(glob.glob(os.path.join(work, '**', '*.dir'), recursive=True)):
        try:
            results.append(analyze(p, castmap, work))
        except Exception as e:
            results.append(dict(movie=os.path.relpath(p, work), error=repr(e)))
    json.dump(results, open(out, 'w'), indent=1)
    for r in results:
        if 'error' in r:
            print(r['movie'], 'ERROR', r['error']); continue
        print(f"{r['movie'][:60]:60} fr={r['frames']:5} tempo={len(r['tempo']):3} trans={len(r['transitions']):3} "
              f"pal={len(r['palettes']):3} snd={len(r['sounds']):3} video={len(r['video_members'])}")


if __name__ == '__main__':
    main()
