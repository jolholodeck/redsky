property iMbrBitmap, iMapScale, ilMap
global goSysEnvirons

on new me, mbrBitmap, mapScale, lmap
  iMbrBitmap = mbrBitmap
  iMapScale = mapScale
  ilMap = lmap
  return me
end

on mGetSpot me, theLoc
  theLoc = theLoc * iMapScale
  case goSysEnvirons.iPlatform of
    #win:
      palidx = iMbrBitmap.getPixel(theLoc[1], theLoc[2])
    #mac:
      palidx = 255 - iMbrBitmap.getPixel(theLoc[1], theLoc[2])
  end case
  return ilMap.getPos(palidx)
end
