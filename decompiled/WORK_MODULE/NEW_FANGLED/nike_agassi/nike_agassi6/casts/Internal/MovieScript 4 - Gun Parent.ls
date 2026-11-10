property iLocX, iLocY, iBearingX, iBearingY, iStartCastNum, iCastNum, iSpriteNum, iTotalXbearings, iVisXbearings, iNbYbearings, iMaxDev, iDevInc, iXindexShift, iGunOrgX, iGunRangeX, iSpeedX, iMouseIncX, iMouseIncY, iCannonY, iCannonZ, iVelX, iVelY, iVelZ, iSmokeCasts, iSmokeCols, iMaxSmokeCnt, iSmokeCounter, iState, iDeltas, iDeltaX, iDeltaY
global gameSpace, Ball, Andre, PowerBar, gBoundsRect, gWidth, gHeight, gDepth, gLeft, gTop, gRight, gBot, gFarRect, gShadowDivY, gStageOffH, gStageOffV, gPerspective, gDepthIncX, gDepthIncY, gBgdOffH, gBgdOffV, gBgdOffPt, grInnerTarget, grMidTarget, gOuterLeft, gOuterRight, gTGTinnerCast, gTGTmidCast, gTGTouterCast, gTGTleftCast, gTGTrightCast, gBallSpr, gShadowSpr, gGunSpr, gFarSpr, gTGTspr, gSmokeSpr, gAndreSpr, gDotCast, gFireSnd, gBounceSnd, gLastKey, gLeftKey, gRightKey, gFarCastNum, gStatusField

on new me
  set iDeltas to [point(-33, -6), point(-28, -7), point(-24, -7), point(-19, -7), point(-14, -7), point(-9, -7), point(-5, -7), point(1, -7), point(6, -7), point(10, -7), point(15, -7), point(21, -7), point(25, -7), point(29, -7), point(34, -6), point(-33, 1), point(-29, 1), point(-24, 1), point(-19, 1), point(-15, 1), point(-10, 1), point(-5, 1), point(0, 0), point(5, 0), point(9, 0), point(13, 0), point(17, 0), point(22, 0), point(25, 0), point(29, 0), point(-33, 6), point(-29, 6), point(-25, 6), point(-20, 6), point(-15, 6), point(-10, 6), point(-6, 6), point(-1, 6), point(4, 6), point(8, 6), point(14, 6), point(18, 6), point(22, 6), point(27, 6), point(33, 6)]
  set iState to #idle
  set iSmokeCasts to [61, 62, 63, 64, 65]
  set iSmokeCols to [113, 155, 197, 203, 209]
  set iMaxSmokeCnt to count(iSmokeCasts)
  set iSmokeCounter to 0
  set iStartCastNum to 211
  set iBearingX to 0
  set iBearingY to 0
  set iLocX to gStageOffH + gLeft + (gWidth / 2)
  set iLocY to 154
  set borderX to 130
  set iSpeedX to 6
  set iGunRangeX to gWidth - (borderX * 2)
  set iGunOrgX to gLeft + borderX
  set iTotalXbearings to 15
  set iMaxDev to 2
  set iVisXbearings to iTotalXbearings - (iMaxDev * 2)
  set iNbYbearings to 3
  set iMouseIncX to 320 / iVisXbearings
  set iMouseIncY to 240 / iNbYbearings
  set iDevInc to iGunRangeX / ((iMaxDev * 2) + 1)
  set iXindexShift to (iTotalXbearings - 1) / 2
  set iCastNum to mGetCurGunCast(me)
  set iCannonY to 230
  set iCannonZ to 40
  return me
end

on mDisplay me
  set the castNum of sprite gGunSpr to iCastNum
  set the locH of sprite gGunSpr to iLocX + gStageOffH + iDeltaX
  set the locV of sprite gGunSpr to iLocY + iDeltaY + gBgdOffV
  if iState = #firing then
    set iSmokeCounter to iSmokeCounter + 1
    if iSmokeCounter > iMaxSmokeCnt then
      set iSmokeCounter to 0
      set iState to #idle
      set the castNum of sprite gSmokeSpr to gDotCast
      set the loc of sprite gSmokeSpr to point(-100, 0)
      exit
    end if
    set the castNum of sprite gSmokeSpr to getAt(iSmokeCasts, iSmokeCounter)
    set the foreColor of sprite gSmokeSpr to getAt(iSmokeCols, iSmokeCounter)
    set the locH of sprite gSmokeSpr to iLocX + gStageOffH + iDeltaX
    set the locV of sprite gSmokeSpr to iLocY + iDeltaY + gBgdOffV
  end if
end

on mHide me
  set the locH of sprite gSmokeSpr to -1000
  set the locH of sprite gGunSpr to -1000
end

on mSetDeltas me
  set curDelta to getAt(iDeltas, iCastNum - iStartCastNum + 1)
  set iDeltaX to getAt(curDelta, 1)
  set iDeltaY to getAt(curDelta, 2)
end

on mMove me, dir
  case gLastKey of
    gLeftKey:
      set iLocX to max(iLocX - iSpeedX, iGunOrgX)
    gRightKey:
      set iLocX to min(iLocX + iSpeedX, iGunOrgX + iGunRangeX)
  end case
  set mH to max(min(the mouseH, 320 + gBgdOffH), gBgdOffH) - gBgdOffH
  set mV to max(min(the mouseV, 240 + gBgdOffV), gBgdOffV) - gBgdOffV
  set offX to min(mH / iMouseIncX, iVisXbearings - 1)
  set offY to min(mV / iMouseIncY, 2)
  set iBearingX to offX - ((iVisXbearings - 1) / 2)
  set iBearingY to offY
  set iCastNum to mGetCurGunCast(me)
  mSetDeltas(me)
  mDisplay(me)
end

on mFire me
  set iState to #firing
  set curForce to mGetForce(PowerBar)
  set iVelX to integer(((iBearingX * 2) + random(3) - 2) * curForce)
  set iVelY to integer(((-(2 - iBearingY) * 5) + random(3) - 2) * curForce)
  set iVelZ to integer(10 * curForce)
  mRecoil(me)
  mFire(Ball)
  mFire(PowerBar)
  mFire(Andre)
end

on mGetCurGunCast me
  set curDev to ((iLocX - iGunOrgX) / iDevInc) - iMaxDev
  set curDev to min(max(curDev, -iMaxDev), iMaxDev)
  return iStartCastNum + (iBearingY * iTotalXbearings) + iBearingX + iXindexShift - curDev
end

on mRecoil me
  set curDev to ((iLocX - iGunOrgX) / iDevInc) - iMaxDev
  set curDev to min(max(curDev, -iMaxDev), iMaxDev)
  set angle to iBearingX - curDev
  set the locH of sprite gGunSpr to iLocX + gStageOffH + iDeltaX - (angle * 2)
  set the locV of sprite gGunSpr to iLocY + iDeltaY + 2 + abs(angle) + gBgdOffV
end
