global kPi, k2pi, kStageCenterH, kStageTopBorder, kStageBotBorder, kStageRect, kPalMoveRect, kNbSwatches, kSwatchAngInc, kSwatchAngTol, kMinPalRadius, kMaxPalRadius, kGravity, kInertia, kPointCursor, kOpenHandCursor, kCloseHandCursor, klPalBgdCasts, kPalSwatchBaseCast, kPalThumbBaseCast, kTextBaseCast, kPalBgdSpr, kPalSwatchSpr, kPalThumbSpr, kBaseStampSpr, kNbStampSprs, kTextSpr, kStampFgdSpr, kStampSnd, kShakeSnd, kBrowseSnd, kStampChan, kShakeChan, kBrowseChan, kStampFadeTime, kStampFadeInc, klNetPages, palette, StampMap, Shaker, Browser, gBaseUrl, gFrameName, kPalBorder, gIdleSuspended

on startMovie
  set the stageColor to 51
  set gIdleSuspended to 0
  cursor(200)
  set kPointCursor to [101, 102]
  set kOpenHandCursor to point(103, 104)
  set kCloseHandCursor to point(105, 106)
  set the floatPrecision to 8
  set the idleHandlerPeriod to 1
  set kStageRect to rect(0, 0, the stageRight - the stageLeft, the stageBottom - the stageTop)
  set kPalBorder to 60
  set kPalMoveRect to inflate(kStageRect, -kPalBorder, -kPalBorder)
  set kStageCenterH to (the stageRight - the stageLeft) / 2
  set kStageTopBorder to 30
  set kStageBotBorder to the stageBottom - the stageTop - kStageTopBorder
  set kPi to PI
  set k2pi to 2 * PI
  initSpriteMgr()
  initMetrics()
  initMedia()
  initNetPages()
  initSpriteMap()
  initObjects()
  cursor(kPointCursor)
  set gBaseUrl to "http://www.redsky.com/html/thinks/"
  set gFrameName to "Bottom"
  set the keyDownScript to "demoKeyHandler"
end

on demoKeyHandler
  if (the key = RETURN) or (the key = ENTER) then
    set gIdleSuspended to 1
    ReturnToWork()
  end if
end

on initMetrics
  set kInertia to 2.0
  set kGravity to 10.0
  set kMinPalRadius to 40
  set kMaxPalRadius to 66
  set kNbSwatches to 10
  set kSwatchAngInc to k2pi / 10
  set kSwatchAngTol to k2pi / 30
  set kStampFadeTime to 60 * 10
  set kStampFadeInc to 4
end

on initNetPages
  set klNetPages to []
  set str to the text of field "NetPages"
  set nbLines to the number of lines in str
  repeat with x = 1 to nbLines
    set curLine to line x of str
    if curLine = EMPTY then
      next repeat
    end if
    if curLine starts "--" then
      next repeat
    end if
    set url to encodeURL(curLine)
    add(klNetPages, url)
  end repeat
  if count(klNetPages) < 10 then
    setAt(klNetPages, 10, 0)
  end if
end

on initMedia
  set klPalBgdCasts to [51, 52, 53, 54, 55]
  set kPalSwatchBaseCast to 61
  set kPalThumbBaseCast to 71
  set kTextBaseCast to 81
  set kStampSnd to 123
  set kShakeSnd to 122
  set kBrowseSnd to 121
  set kStampChan to 1
  set kShakeChan to 2
  set kBrowseChan to 3
end

on initSpriteMap
  set kBaseStampSpr to 9
  set kNbStampSprs to kNbSwatches
  set kPalBgdSpr to 20
  set kPalSwatchSpr to 21
  set kPalThumbSpr to 22
  set kStampFgdSpr to 24
  set kTextSpr to 25
  initPuppets([kPalBgdSpr, kPalSwatchSpr, kPalThumbSpr])
  initPuppets(point(kBaseStampSpr, kBaseStampSpr + kNbStampSprs - 1))
  initPuppets([kStampFgdSpr, kTextSpr])
end

on initObjects
  set palette to new(script "Palette Class")
  set StampMap to new(script "StampMap Class")
  set Shaker to new(script "Shaker Class")
  set Browser to new(script "Browser Class")
  mSetUp(palette)
end
