"""Unprotect one work's Director files and publish it to the site.

usage: python3 -I build_work.py <slug> [--no-decompile]

works/<slug>/original/      as received (never edited)
works/<slug>/decompiled/    unprotected .dir/.cst + Lingo (.ls) via ProjectorRays,
                            including movies cut out of Mac projectors (named from the
                            projector's own file list)
site/w/<slug>/rs/           every playable file, lowercased and gzipped
site/w/<slug>/files.txt     original relative path -> published name

AIFF is converted to WAV under the original name (the player decodes WAV); QuickTime
is transcoded to MP4 beside it; Beatnik .rmf is rendered by render_rmf.py if present.
"""
import gzip, os, re, shutil, struct, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
PR = os.path.expanduser('~/tools/ProjectorRays/projectorrays')
sys.path.insert(0, HERE)

slug = sys.argv[1]
decompile = '--no-decompile' not in sys.argv
W = os.path.join(REPO, 'works', slug)
ORIG, DEC = os.path.join(W, 'original'), os.path.join(W, 'decompiled')
SITE = os.path.join(REPO, 'site', 'w', slug)


def kind(path):
    with open(path, 'rb') as f:
        h = f.read(12)
    if h[:4] in (b'RIFX', b'XFIR'):
        k = h[8:12] if h[:4] == b'RIFX' else h[8:12][::-1]
        return k.decode('latin1')
    return None


def projector_movies(path):
    """Embedded movies of a Mac projector: [(name, bytes)]."""
    d = open(path, 'rb').read()
    base = d.find(b'RIFX')
    if base <= 0 or d[base + 8:base + 12] != b'APPL':
        return []
    import extract_projector as ep  # noqa: E402
    return ep.movies(path)


def run_pr(src, out):
    os.makedirs(os.path.dirname(out), exist_ok=True)
    r = subprocess.run([PR, 'decompile', src, '-o', out], capture_output=True, text=True)
    ok = r.returncode == 0 and os.path.exists(out)
    if ok:  # Lingo source beside it, in <name>/casts/<cast>/*.ls
        stem = os.path.splitext(out)[0]
        os.makedirs(stem, exist_ok=True)
        subprocess.run([PR, 'decompile', src, '-o', stem, '--dump-scripts'], capture_output=True, text=True)
        for dp, dns, fns in os.walk(stem):
            for fn in fns:
                if not fn.endswith('.ls'):
                    os.remove(os.path.join(dp, fn))
        for sub in os.listdir(stem):
            inner = os.path.join(stem, sub, 'casts')
            if os.path.isdir(inner):
                shutil.move(inner, os.path.join(stem, 'casts_tmp'))
                shutil.rmtree(os.path.join(stem, sub))
                os.rename(os.path.join(stem, 'casts_tmp'), os.path.join(stem, 'casts'))
                break
    print(('  ok   ' if ok else '  FAIL ') + os.path.relpath(out, W) + ('' if ok else ' ' + (r.stderr.strip().splitlines() or ['?'])[-1][:120]))
    return ok


def main():
    if decompile:
        shutil.rmtree(DEC, ignore_errors=True)
        for dp, dns, fns in os.walk(ORIG):
            if '__MACOSX' in dp.split(os.sep):
                continue
            for fn in fns:
                src = os.path.join(dp, fn)
                rel = os.path.relpath(src, ORIG)
                k = kind(src)
                if k in ('MV93', 'MDGF', 'FGDM') and not fn.lower().endswith(('.cxt', '.cst', '.cct')):
                    run_pr(src, os.path.join(DEC, os.path.splitext(rel)[0] + '.dir'))
                elif k in ('MV93', 'MDGF', 'FGDM'):
                    run_pr(src, os.path.join(DEC, os.path.splitext(rel)[0] + '.cst'))
                elif k in ('MC95', 'FGDC'):
                    run_pr(src, os.path.join(DEC, os.path.splitext(rel)[0] + '.cst'))
                else:
                    for name, blob in projector_movies(src):
                        if blob[8:12] == b'FGDM':   # Shockwave movie: publish it as is
                            raw = os.path.join(W, 'extracted', os.path.dirname(rel), os.path.splitext(name.strip())[0] + '.dcr')
                            os.makedirs(os.path.dirname(raw), exist_ok=True)
                            open(raw, 'wb').write(blob)
                        tmp = os.path.join(DEC, '_tmp_' + re.sub(r'\W', '_', name))
                        os.makedirs(DEC, exist_ok=True)
                        open(tmp, 'wb').write(blob)
                        stem = os.path.splitext(name)[0]
                        ext = '.cst' if name.lower().endswith(('.cst', '.cxt')) else '.dir'
                        run_pr(tmp, os.path.join(DEC, os.path.dirname(rel), stem + ext))
                        os.remove(tmp)
    publish()


def publish():
    shutil.rmtree(os.path.join(SITE, 'rs'), ignore_errors=True)
    os.makedirs(os.path.join(SITE, 'rs'), exist_ok=True)
    lines = []
    ext_dir = os.path.join(W, 'extracted')

    def put(src, rel, data=None):
        pub = rel.lower().replace(' ', '_')
        pub = re.sub(r'[^a-z0-9_./-]', '_', pub)
        dst = os.path.join(SITE, 'rs', pub + '.gz')
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        with gzip.open(dst, 'wb', 9) as g:
            g.write(data if data is not None else open(src, 'rb').read())
        lines.append(rel.lower() + '\t' + pub + '\t' + rel)

    # Director files: the unprotected versions
    for dp, dns, fns in os.walk(DEC):
        for fn in fns:
            if fn.lower().endswith(('.dir', '.cst')):
                src = os.path.join(dp, fn)
                rel = os.path.relpath(src, DEC)
                if os.path.exists(os.path.join(ext_dir, os.path.splitext(rel)[0] + '.dcr')):
                    continue   # its Shockwave original is published instead
                put(src, rel)
    # Shockwave movies cut out of projectors (the player reads them directly)
    ext_dir = os.path.join(W, 'extracted')
    for dp, dns, fns in os.walk(ext_dir):
        for fn in fns:
            src = os.path.join(dp, fn)
            put(src, os.path.relpath(src, ext_dir))
    # everything else that a movie might open by path
    for dp, dns, fns in os.walk(ORIG):
        if '__MACOSX' in dp.split(os.sep):
            continue
        for fn in fns:
            src = os.path.join(dp, fn)
            rel = os.path.relpath(src, ORIG)
            low = fn.lower()
            if kind(src) or low == '.ds_store':
                continue
            if low.endswith(('.aif', '.aiff')):
                wav = os.path.join(W, 'converted', rel + '.wav')
                if not os.path.exists(wav):
                    os.makedirs(os.path.dirname(wav), exist_ok=True)
                    subprocess.run(['ffmpeg', '-v', 'error', '-y', '-i', src, '-c:a', 'pcm_s16le', wav])
                if os.path.exists(wav):
                    put(wav, rel)   # WAV data under the original AIFF name
            elif low.endswith(('.txt', '.ini', '.mac', '.pc', '.gif', '.jpg', '.htm', '.html', '.wav', '.rmf', '.hsb')):
                put(src, rel)
            elif low.endswith('.mov'):
                mp4 = os.path.join(W, 'converted', os.path.splitext(rel)[0] + '.mp4')
                if not os.path.exists(mp4):
                    os.makedirs(os.path.dirname(mp4), exist_ok=True)
                    subprocess.run(['ffmpeg', '-v', 'error', '-y', '-i', src, '-c:v', 'libx264', '-preset', 'veryfast',
                                    '-crf', '20', '-pix_fmt', 'yuv420p', '-c:a', 'aac', '-movflags', '+faststart', mp4])
                if os.path.exists(mp4):
                    put(mp4, os.path.splitext(rel)[0] + '.mp4')
    # rendered Beatnik music, if any
    conv = os.path.join(W, 'converted')
    for dp, dns, fns in os.walk(conv):
        for fn in fns:
            if fn.lower().endswith(('.wav', '.ogg', '.m4a', '.json')) and '.rmf' in fn.lower():
                src = os.path.join(dp, fn)
                put(src, os.path.relpath(src, conv))
    open(os.path.join(SITE, 'files.txt'), 'w').write('\n'.join(sorted(set(lines))) + '\n')
    print(slug, 'published', len(lines), 'files')


if __name__ == '__main__':
    main()
