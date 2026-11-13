property iOrgX, iOrgY, iWidth, iHeight, iDivX, iDivY, iPlotCast, iPlotCol
global Ball, gun, gameSpace, gBoundsRect, gWidth, gHeight, gDepth, gLeft, gTop, gRight, gBot, gFarRect, gShadowDivY, gStageOffH, gStageOffV, gPerspective, gDepthIncX, gDepthIncY, gGravity, gGravFreq, gBgdOffH, gBgdOffV, gBgdOffPt, grInnerTarget, grMidTarget, gOuterLeft, gOuterRight, gTGTinnerCast, gTGTmidCast, gTGTouterCast, gTGTleftCast, gTGTrightCast, gBallSpr, gShadowSpr, gGunSpr, gFarSpr, gTGTspr, gSmokeSpr, gAndreSpr, gPlotSpr, gDotCast, gFireSnd, gBounceSnd, gLastKey, gLeftKey, gRightKey, gFarCastNum, gStatusField

on new me
  set iOrgX to 227
  set iOrgY to 194
  set iWidth to 33.0
  set iHeight to 47.0
  set iDivX to gWidth / iWidth
  set iDivY to gDepth / iHeight
  set iPlotCast to 21
  set iPlotCol to 185
  set the castNum of sprite gPlotSpr to iPlotCast
  return me
end

on mMove me
  if the iState of Ball = #idle then
    exit
  end if
  if the iVelZ of Ball > 0 then
    set the foreColor of sprite gPlotSpr to 185
  else
    set the foreColor of sprite gPlotSpr to 35
  end if
  set the locH of sprite gPlotSpr to iOrgX + (the iLocX of Ball / iDivX) + gBgdOffH
  set the locV of sprite gPlotSpr to iOrgY + iHeight - (the iLocZ of Ball / iDivY) + gBgdOffV
end

on mHide me
  set the locH of sprite gPlotSpr to -100
end
