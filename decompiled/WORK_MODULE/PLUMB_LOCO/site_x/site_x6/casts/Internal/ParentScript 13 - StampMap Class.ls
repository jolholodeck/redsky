property ilStampObjs, ilStampSprites, ilAvailChans, ilAvailIDs, iNbStamps
global kPi, k2pi, kNbSwatches, kSwatchAngInc, kSwatchAngTol, kMinPalRadius, kMaxPalRadius, kGravity, kInertia, klPalBgdCasts, kPalSwatchBaseCast, kPalThumbBaseCast, kPalBgdSpr, kPalSwatchSpr, kPalThumbSpr, kBaseStampSpr, kNbStampSprs, kStampSnd, kShakeSnd, kBrowseSnd, kStampChan, kShakeChan, kBrowseChan, kStampFadeTime, kStampFadeInc, palette, Stamp

on new me
  set ilStampObjs to []
  set iNbStamps to 0
  return me
end

on mAddStamp me, stampNum, loc
  if iNbStamps >= kNbSwatches then
    exit
  end if
  set iNbStamps to iNbStamps + 1
  set stampObj to new(script "Stamp Class", stampNum, loc)
  add(ilStampObjs, stampObj)
  puppetSound(kStampChan, kStampSnd)
end

on mGetStampSpr me, stampObj
  set pos to getPos(ilStampObjs, stampObj)
  if pos then
    return kBaseStampSpr + pos - 1
  else
    return 0
  end if
end

on mReleaseStamp me, stampObj
  set pos to getPos(ilStampObjs, stampObj)
  if not pos then
    exit
  end if
  deleteAt(ilStampObjs, pos)
  set stampObj to 0
end

on mTrack me
  clearSprites(point(kBaseStampSpr, kBaseStampSpr + kNbStampSprs - 1))
  set lTemp to duplicate(ilStampObjs)
  set ilStampObjs to []
  repeat with curObj in lTemp
    if the iState of curObj = #dead then
      set curObj to 0
      next repeat
    end if
    add(ilStampObjs, curObj)
  end repeat
  set iNbStamps to count(ilStampObjs)
  set spr to kBaseStampSpr
  repeat with curObj in ilStampObjs
    mTrack(curObj, spr)
    set spr to spr + 1
  end repeat
end

on mPrepForBrowse me
  set spr to kBaseStampSpr
  repeat with curObj in ilStampObjs
    set the iState of curObj to #onScreen
    mTrack(curObj, spr)
    set spr to spr + 1
  end repeat
end

on mPrepForStamp me
  repeat with curObj in ilStampObjs
    set the iFadeTime of curObj to the timer + random(90)
  end repeat
end
