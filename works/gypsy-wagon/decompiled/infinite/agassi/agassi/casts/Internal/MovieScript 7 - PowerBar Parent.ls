property iOrgX, iOrgY, iWidth, iHeight, iCastNum, iPlotCol, iCurReading, iState, iMinReading, iSwitchFreq, iSpeed, iCurForce, iMaxForce, iNbIncs, iDiv, iInc, iReadoutFld
global Ball, Andre, gun, gameSpace, gBoundsRect, gWidth, gHeight, gDepth, gLeft, gTop, gRight, gBot, gFarRect, gShadowDivY, gStageOffH, gStageOffV, gPerspective, gDepthIncX, gDepthIncY, gGravity, gGravFreq, gBgdOffH, gBgdOffV, gBgdOffPt, grInnerTarget, grMidTarget, gOuterLeft, gOuterRight, gTGTinnerCast, gTGTmidCast, gTGTouterCast, gTGTleftCast, gTGTrightCast, gBallSpr, gShadowSpr, gGunSpr, gFarSpr, gTGTspr, gSmokeSpr, gAndreSpr, gForceSpr, gDotCast, gFireSnd, gBounceSnd, gLastKey, gLeftKey, gRightKey, gFarCastNum, gStatusField

on new me
  set maskSpr to 24
  set iOrgX to the locH of sprite maskSpr
  set iOrgY to the locV of sprite maskSpr
  set iWidth to 9
  set iHeight to 155
  set iMaxForce to 3
  set iNbIncs to 8.0
  set iDiv to iHeight / iNbIncs
  set iInc to (iMaxForce - 1) / iNbIncs
  set iReadoutFld to 273
  set iCurReading to 0
  set iMinReading to 20
  set iSwitchFreq to 60
  set iSpeed to 2
  set iCurForce to iCurReading / iDiv
  mDisplay(me)
  set iCastNum to gDotCast
  set iPlotCol to 255
  set iState to #idle
  set the castNum of sprite gForceSpr to iCastNum
  set the foreColor of sprite gForceSpr to iPlotCol
  return me
end

on mMove me
  case iState of
    #idle:
    #power:
      set iCurReading to min(iCurReading + 8, iHeight)
      if iCurReading >= iHeight then
        set iState to #pulseDown
      end if
    #release:
      set iCurReading to max(iCurReading - 4, 0)
      if iCurReading <= 0 then
        set iState to #idle
      end if
    #pulseUp:
      set iCurReading to min(iCurReading + 20, iHeight)
      if iCurReading >= iHeight then
        set iState to #pulseDown
      end if
    #pulseDown:
      set iCurReading to max(iCurReading - 8, iHeight - 96)
      if iCurReading <= (iHeight - 96) then
        set iState to #pulseUp
      end if
  end case
  mDisplay(me)
end

on mDisplay me
  set iCurRect to rect(iOrgX, iOrgY, iOrgX + iWidth, iOrgY + iHeight - iCurReading)
  set the rect of sprite gForceSpr to iCurRect
  set the text of field iReadoutFld to string(iCurReading)
end

on mGetForce me
  set level to iCurReading / iDiv
  return 1 + (iInc * level)
end

on mFire me
  set iState to #release
end

on mCanFire me
  return iCurReading >= iMinReading
end

on mCanPower me
  if the iState of Andre = #intercept then
    return 0
  end if
  if the iState of Ball <> #idle then
    return 0
  end if
  return (iState <> #power) and (iState <> #release)
end

on mStartPower me
  set iState to #power
end
