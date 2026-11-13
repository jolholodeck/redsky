property iFlashFXspr, iFlashFXdata
global Ball, gun, Andre, gBoundsRect, gWidth, gHeight, gDepth, gLeft, gTop, gRight, gBot, gFarRect, gShadowDivY, gStageOffH, gStageOffV, gPerspective, gDepthIncX, gDepthIncY, gGravity, gGravFreq, gBgdOffH, gBgdOffV, gBgdOffPt, grInnerTarget, grMidTarget, gOuterLeft, gOuterRight, gTGTinnerCast, gTGTmidCast, gTGTouterCast, gTGTleftCast, gTGTrightCast, gBallSpr, gShadowSpr, gGunSpr, gFarSpr, gTGTspr, gSmokeSpr, gAndreSpr, gDotCast, gBackWallFXspr, gFgdFXspr, gStaticSpr, gFireSnd, gBounceSnd, glShockSnds, gStaticSnd, gLastKey, gLeftKey, gRightKey, gFarCastNum, gStatusField

on new me
  set iFlashFXspr to 0
  set iFlashFXdata to 0
  return me
end

on mMove me
  mDoFlashFX(me)
end

on mWinMatch me, who
  beep(3)
  if who = #Andre then
  else
  end if
end

on mScheduleFlashFX me, type
  if listp(iFlashFXdata) then
    exit
  end if
  case type of
    #fgd:
      set snd to getAt(glShockSnds, random(count(glShockSnds)))
      set iFlashFXdata to [0, [gFgdFXspr, 47, point(0, 0), snd], 72, 255, 2, 255, 72]
    #bgd:
      set iFlashFXdata to [0, [gBackWallFXspr, 66, point(158, 71), 0], 162, 204]
  end case
end

on mDoFlashFX
  if iFlashFXdata = 0 then
    exit
  end if
  set idx to getAt(iFlashFXdata, 1) + 1
  if idx = 1 then
    set data to getAt(iFlashFXdata, 2)
    set iFlashFXspr to getAt(data, 1)
    set the castNum of sprite iFlashFXspr to getAt(data, 2)
    set the loc of sprite iFlashFXspr to getAt(data, 3) + gBgdOffPt
    set snd to getAt(data, 4)
    if snd then
      puppetSound(1, snd)
    end if
  else
    if idx > (count(iFlashFXdata) - 2) then
      set the locH of sprite iFlashFXspr to -1000
      set iFlashFXdata to 0
      set iFlashFXspr to 0
      exit
    end if
  end if
  setAt(iFlashFXdata, 1, idx)
  set the foreColor of sprite iFlashFXspr to getAt(iFlashFXdata, idx + 2)
end
