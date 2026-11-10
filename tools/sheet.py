import sys, glob, os
from PIL import Image, ImageDraw
pat, out = sys.argv[1], sys.argv[2]
maxn = int(sys.argv[3]) if len(sys.argv)>3 else 60
fs = sorted(glob.glob(pat, recursive=True))
fs = [f for f in fs if Image.open(f).size[0] > 8][:maxn]
T = 160
cols = 8
rows = (len(fs)+cols-1)//cols
sheet = Image.new('RGB', (cols*T, rows*(T+14)), (90,90,90))
d = ImageDraw.Draw(sheet)
for i,f in enumerate(fs):
    im = Image.open(f).convert('RGB'); im.thumbnail((T,T))
    x,y = (i%cols)*T, (i//cols)*(T+14)
    sheet.paste(im,(x,y)); d.text((x+2,y+T),os.path.basename(f)[:24],fill=(255,255,255))
sheet.save(out); print(len(fs), sheet.size)
