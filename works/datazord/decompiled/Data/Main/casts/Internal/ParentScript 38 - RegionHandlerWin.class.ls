property ancestor, ikDataMbr, ikStartIdx, ikImgWidth, ikImgHeight
global gRegIdx

on new me, dataMbr
  ikDataMbr = dataMbr
  ikStartIdx = 64
  ikImgWidth = ikDataMbr.width
  ikImgHeight = ikDataMbr.height
  return me
end

on mGetRegionIndex me, hitPt
  return ikDataMbr.getPixel(hitPt[1], hitPt[2]) - ikStartIdx
end
