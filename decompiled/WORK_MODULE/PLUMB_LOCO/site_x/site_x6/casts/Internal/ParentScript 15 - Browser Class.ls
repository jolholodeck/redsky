property iCurHitSpr
global kStageCenterH, kStageTopBorder, kStageBotBorder, klPalBgdCasts, kPalSwatchBaseCast, kPalThumbBaseCast, kTextBaseCast, kNbSwatches, kBaseStampSpr, kTextSpr, kStampFgdSpr, kStampSnd, kShakeSnd, kBrowseSnd, kStampChan, kShakeChan, kBrowseChan, kOpenHandCursor, kPointCursor, StampMap

on new me
  set iCurHitSpr to 0
  return me
end

on mTrack me
  set hitSpr to 0
  set topSpr to kBaseStampSpr + the iNbStamps of StampMap - 1
  repeat with spr = topSpr down to kBaseStampSpr
    if rollOver(spr) then
      set hitSpr to spr
      exit repeat
    end if
  end repeat
  if not hitSpr then
    cursor(kPointCursor)
    clearSprites([kTextSpr, kStampFgdSpr])
    repeat with spr = kBaseStampSpr to topSpr
      set the blend of sprite spr to 100
    end repeat
    set iCurHitSpr to 0
    exit
  end if
  set mnum to the memberNum of sprite hitSpr
  if (mnum < kPalThumbBaseCast) or (mnum > (kPalThumbBaseCast + kNbSwatches - 1)) then
    cursor(kPointCursor)
    clearSprites([kTextSpr, kStampFgdSpr])
    repeat with spr = kBaseStampSpr to topSpr
      set the blend of sprite spr to 100
    end repeat
    set iCurHitSpr to 0
    exit
  end if
  cursor(kOpenHandCursor)
  repeat with spr = kBaseStampSpr to topSpr
    set the blend of sprite spr to 50
  end repeat
  set stampV to the locV of sprite hitSpr
  set stampV to max(min(stampV, kStageBotBorder), kStageTopBorder)
  set the memberNum of sprite kTextSpr to mnum + 10
  set newLoc to mVibrate(me, point(kStageCenterH, stampV), the loc of sprite kTextSpr)
  set the loc of sprite kTextSpr to newLoc
  if the mouseDown then
    if the lastClick < 20 then
      gotoStampPage(mnum)
      exit
    end if
  end if
  if hitSpr = iCurHitSpr then
    exit
  end if
  set iCurHitSpr to hitSpr
  set the memberNum of sprite kStampFgdSpr to mnum
  set the loc of sprite kStampFgdSpr to the loc of sprite hitSpr
  puppetSound(kBrowseChan, kBrowseSnd)
end

on mHide me
  clearSprites([kTextSpr, kStampFgdSpr])
end

on mVibrate me, srcLoc, curLoc
  set newLoc to duplicate(curLoc)
  repeat while newLoc = curLoc
    set newLoc to srcLoc + point(random(3) - 2, random(3) - 2)
  end repeat
  return newLoc
end
