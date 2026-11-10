import struct, sys
src, start, out = sys.argv[1], int(sys.argv[2],16), sys.argv[3]
d = open(src,'rb').read()
size = struct.unpack('>I', d[start+4:start+8])[0] + 8
m = bytearray(d[start:start+size])
# imap: at 12: 'imap', len, count, mmapOffset
assert m[12:16]==b'imap'
mmap_off = struct.unpack('>I', m[24:28])[0] - start
struct.pack_into('>I', m, 24, mmap_off)
assert m[mmap_off:mmap_off+4]==b'mmap', m[mmap_off:mmap_off+4]
hlen, elen, maxc, used = struct.unpack('>HHii', m[mmap_off+8:mmap_off+20])
p = mmap_off+8+hlen
n=0
for i in range(used):
    fourcc, ln, off = struct.unpack('>4sIi', m[p:p+12])
    if off > 0 and fourcc not in (b'free',b'junk') or (off>=start):
        if off >= start:
            struct.pack_into('>i', m, p+8, off-start); n+=1
    p += elen
open(out,'wb').write(m)
print('wrote', out, size, 'rebased', n)
