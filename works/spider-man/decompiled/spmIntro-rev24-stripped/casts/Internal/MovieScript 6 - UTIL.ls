global gPI, g2PI, glGlob

on initStatics lst
  global glNodes, glQuads, glStNds, gSpdrVerts
  glNodes = [[#m: 0, #pt: point(0, 0)], [#m: 0, #pt: point(100, 0)], [#m: 1, #pt: point(100, 99)], [#m: 1, #pt: point(0, 99)], [#m: 0, #pt: point(200, 0)], [#m: 1, #pt: point(200, 99)], [#m: 0, #pt: point(300, 0)], [#m: 1, #pt: point(300, 99)], [#m: 1, #pt: point(100, 198)], [#m: 1, #pt: point(0, 198)], [#m: 1, #pt: point(200, 198)], [#m: 1, #pt: point(300, 198)], [#m: 0, #pt: point(309, 99)], [#m: 0, #pt: point(309, 198)], [#m: 0, #pt: point(100, 295)], [#m: 0, #pt: point(0, 295)], [#m: 0, #pt: point(200, 295)], [#m: 0, #pt: point(300, 295)], [#m: 0, #pt: point(200, 295)]]
  glQuads = [[#len: [100, 99, 100, 99], #mbr: member(1, 2), #node: [1, 2, 3, 4], #spt: 0], [#len: [100, 99, 100, 99], #mbr: member(2, 2), #node: [2, 5, 6, 3], #spt: 0], [#len: [100, 99, 100, 99], #mbr: member(3, 2), #node: [5, 7, 8, 6], #spt: 0], [#len: [100, 99, 100, 99], #mbr: member(5, 2), #node: [4, 3, 9, 10], #spt: 0], [#len: [100, 99, 100, 99], #mbr: member(6, 2), #node: [3, 6, 11, 9], #spt: 0], [#len: [100, 99, 100, 99], #mbr: member(7, 2), #node: [6, 8, 12, 11], #spt: 0], [#len: [9, 99, 9, 99], #mbr: member(8, 2), #node: [8, 13, 14, 12], #spt: 0], [#len: [100, 97, 100, 97], #mbr: member(9, 2), #node: [10, 9, 15, 16], #spt: 0], [#len: [100, 97, 100, 97], #mbr: member(10, 2), #node: [9, 11, 17, 15], #spt: 0], [#len: [100, 97, 100, 97], #mbr: member(11, 2), #node: [11, 12, 18, 19], #spt: 0]]
  glStNds = [3, 6, 9, 11]
  gSpdrVerts = [131103: [1, [point(-40, -28), point(-18, -28), point(-18, -8), point(-40, -8)]], 131104: [1, [point(-45, -44), point(-17, -44), point(-17, -8), point(-45, -8)]], 131105: [1, [point(-46, -45), point(-9, -45), point(-9, -4), point(-46, -4)]], 131113: [1, [point(-46, -45), point(-9, -45), point(-9, -4), point(-46, -4)]], 131114: [1, [point(-46, -45), point(-9, -45), point(-9, -4), point(-46, -4)]], 131115: [1, [point(-46, -45), point(-8, -45), point(-8, -4), point(-46, -4)]], 131116: [1, [point(-46, -46), point(-4, -46), point(-4, -4), point(-46, -4)]], 131117: [1, [point(-46, -46), point(-4, -46), point(-4, -3), point(-46, -3)]], 131118: [1, [point(-46, -46), point(-4, -46), point(-4, -2), point(-46, -2)]], 131119: [1, [point(-47, -47), point(1, -47), point(1, -1), point(-47, -1)]], 131120: [1, [point(-52, -48), point(18, -48), point(18, -1), point(-52, -1)]], 131121: [1, [point(-52, -44), point(14, -44), point(14, 2), point(-52, 2)]], 131122: [1, [point(-45, -43), point(16, -43), point(16, 19), point(-45, 19)]], 131123: [1, [point(-43, -38), point(18, -38), point(18, 25), point(-43, 25)]], 131124: [1, [point(-41, -34), point(21, -34), point(21, 29), point(-41, 29)]], 131125: [1, [point(-35, -33), point(26, -33), point(26, 30), point(-35, 30)]], 131126: [1, [point(-32, -36), point(28, -36), point(28, 30), point(-32, 30)]], 131127: [1, [point(-30, -34), point(28, -34), point(28, 30), point(-30, 30)]], 131128: [1, [point(-28, -28), point(28, -28), point(28, 30), point(-28, 30)]], 131133: [1, [point(-28, -26), point(29, -26), point(29, 30), point(-28, 30)]], 131134: [1, [point(-31, -30), point(28, -30), point(28, 33), point(-31, 33)]], 131135: [1, [point(-29, -34), point(25, -34), point(25, 31), point(-29, 31)]], 131136: [1, [point(-31, -38), point(29, -38), point(29, 26), point(-31, 26)]], 131137: [1, [point(-27, -37), point(36, -37), point(36, 33), point(-27, 33)]], 131138: [1, [point(-26, -29), point(35, -29), point(35, 38), point(-26, 38)]], 131143: [1, [point(-27, -26), point(32, -26), point(32, 31), point(-27, 31)]], 131144: [1, [point(-28, -29), point(27, -29), point(27, 32), point(-28, 32)]], 131145: [1, [point(-28, -33), point(24, -33), point(24, 35), point(-28, 35)]], 131146: [1, [point(-27, -35), point(24, -35), point(24, 28), point(-27, 28)]], 131147: [1, [point(-30, -37), point(30, -37), point(30, 27), point(-30, 27)]], 131148: [1, [point(-26, -35), point(37, -35), point(37, 35), point(-26, 35)]], 131149: [1, [point(-26, -28), point(35, -28), point(35, 39), point(-26, 39)]], 131153: [1, [point(-33, -38), point(20, -38), point(20, 36), point(-33, 36)]], 131154: [1, [point(-26, -37), point(22, -37), point(22, 32), point(-26, 32)]], 131155: [1, [point(-25, -27), point(30, -27), point(30, 32), point(-25, 32)]], 131161: [1, [point(-27, -26), point(28, -26), point(28, 31), point(-27, 31)]], 131163: [1, [point(-25, -24), point(30, -24), point(30, 32), point(-25, 32)]], 131164: [1, [point(-25, -24), point(30, -24), point(30, 32), point(-25, 32)]], 131165: [1, [point(-25, -25), point(30, -25), point(30, 37), point(-25, 37)]], 131166: [1, [point(-25, -25), point(30, -25), point(30, 34), point(-25, 34)]], 131167: [1, [point(-26, -25), point(30, -25), point(30, 32), point(-26, 32)]], 131168: [1, [point(-25, -25), point(30, -25), point(30, 32), point(-25, 32)]], 131173: [1, [point(-32, -33), point(30, -33), point(30, 33), point(-32, 33)]], 131174: [1, [point(-36, -36), point(29, -36), point(29, 32), point(-36, 32)]], 131175: [1, [point(-37, -37), point(28, -37), point(28, 32), point(-37, 32)]], 131177: [1, [point(-37, -37), point(28, -37), point(28, 32), point(-37, 32)]], 131178: [1, [point(-37, -37), point(28, -37), point(28, 32), point(-37, 32)]], 131179: [1, [point(-37, -37), point(28, -37), point(28, 32), point(-37, 32)]], 131180: [1, [point(-37, -37), point(28, -37), point(28, 32), point(-37, 32)]], 131183: [0, [point(-29, -27), point(31, -27), point(31, 32), point(-29, 32)]], 131184: [0, [point(-32, -31), point(28, -31), point(28, 31), point(-32, 31)]], 131185: [0, [point(-41, -41), point(39, -41), point(39, 37), point(-41, 37)]], 131186: [0, [point(-25, -28), point(31, -28), point(31, 31), point(-25, 31)]], 131187: [0, [point(-24, -24), point(24, -24), point(24, 28), point(-24, 28)]], 131193: [0, [point(-20, -28), point(23, -28), point(23, 23), point(-20, 23)]], 131194: [0, [point(-23, -27), point(15, -27), point(15, 15), point(-23, 15)]], 131195: [0, [point(-28, -28), point(12, -28), point(12, 9), point(-28, 9)]], 131196: [0, [point(-23, -26), point(13, -26), point(13, 13), point(-23, 13)]], 131197: [0, [point(-22, -26), point(14, -26), point(14, 14), point(-22, 14)]], 131198: [0, [point(-22, -26), point(14, -26), point(14, 14), point(-22, 14)]], 131199: [0, [point(-23, -25), point(13, -25), point(13, 15), point(-23, 15)]], 131200: [0, [point(-23, -26), point(13, -26), point(13, 14), point(-23, 14)]], 131201: [0, [point(-23, -26), point(13, -26), point(13, 15), point(-23, 15)]], 131202: [0, [point(-23, -26), point(13, -26), point(13, 15), point(-23, 15)]], 131203: [0, [point(-23, -26), point(14, -26), point(14, 15), point(-23, 15)]], 131204: [0, [point(-22, -26), point(14, -26), point(14, 14), point(-22, 14)]], 131206: [0, [point(-24, -26), point(13, -26), point(13, 14), point(-24, 14)]], 131207: [0, [point(-27, -26), point(13, -26), point(13, 14), point(-27, 14)]], 131208: [0, [point(-31, -26), point(14, -26), point(14, 15), point(-31, 15)]], 131209: [0, [point(-30, -26), point(15, -26), point(15, 17), point(-30, 17)]], 131210: [0, [point(-30, -27), point(17, -27), point(17, 20), point(-30, 20)]], 131211: [0, [point(-30, -27), point(18, -27), point(18, 21), point(-30, 21)]], 131212: [0, [point(-30, -27), point(18, -27), point(18, 21), point(-30, 21)]], 131213: [0, [point(-30, -27), point(18, -27), point(18, 21), point(-30, 21)]], 131214: [0, [point(-23, -24), point(16, -24), point(16, 20), point(-23, 20)]], 131215: [0, [point(-23, -27), point(12, -27), point(12, 14), point(-23, 14)]], 131216: [0, [point(-23, -27), point(12, -27), point(12, 16), point(-23, 16)]], 131217: [0, [point(-23, -27), point(12, -27), point(12, 15), point(-23, 15)]], 131218: [0, [point(-23, -27), point(12, -27), point(12, 16), point(-23, 16)]], 131219: [0, [point(-23, -27), point(12, -27), point(12, 15), point(-23, 15)]], 131220: [0, [point(-23, -27), point(12, -27), point(12, 15), point(-23, 15)]], 131221: [0, [point(-24, -27), point(12, -27), point(12, 15), point(-24, 15)]], 131222: [0, [point(-23, -27), point(12, -27), point(12, 15), point(-23, 15)]], 131223: [0, [point(-23, -27), point(12, -27), point(12, 15), point(-23, 15)]], 131224: [0, [point(-23, -27), point(12, -27), point(12, 15), point(-23, 15)]], 131225: [0, [point(-23, -27), point(12, -27), point(12, 15), point(-23, 15)]], 131226: [0, [point(-23, -27), point(12, -27), point(12, 15), point(-23, 15)]], 131227: [0, [point(-23, -27), point(12, -27), point(12, 15), point(-23, 15)]]]
end

on shuffleLst lst
  cnt = lst.count
  repeat with i = 1 to cnt
    j = random(cnt)
    tmp = lst[i]
    lst[i] = lst[j]
    lst[j] = tmp
  end repeat
end

on CDH_hideSpt spt
  if spt > 0 then
    sptObj = sprite(spt)
    sptObj.ink = 0
    sptObj.loc = glGlob.hideLoc
    sptObj.blend = 100
    sptObj.stretch = 0
    sptObj.flipH = 0
    sptObj.trails = 0
    sptObj.forecolor = 255
    sptObj.member = VOID
  end if
end

on vLen vct
  return sqrt((vct[1] * vct[1]) + (vct[2] * vct[2]))
end

on animReady anim
  repeat with frm in anim
    if not frm[1].mediaReady then
      return 0
    end if
  end repeat
  return 1
end

on getAng pt
  x = pt[1]
  y = pt[2]
  if abs(x) < 0.01 then
    return (0.5 + (y < 0.0)) * gPI
  end if
  return atan(y / x) + (gPI * (x < 0.0)) + (g2PI * ((y < 0.0) and (x > 0.0)))
end

on voidList lst
  if ilk(lst) = #list then
    cnt = lst.count
    repeat with i = 1 to cnt
      if ilk(lst[i]) = #list then
        voidList(lst[i])
      end if
      lst[i] = VOID
    end repeat
    lst = VOID
  end if
end

on voidObjList lst
  if ilk(lst) = #list then
    cnt = lst.count
    repeat with i = 1 to cnt
      if ilk(lst[i]) = #object then
        lst[i].mDestroy()
      end if
      lst[i] = VOID
    end repeat
    lst = VOID
  end if
end
