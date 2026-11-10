property iCurCast, iStartCastNum, iNbCasts, iDepthDiv, iLocX, iLocY, iLocZ, iVelX, iVelY, iVelZ, iShadowCast, iGravCount, iState, iTrailCount, iTrailCols
global gameSpace, gun, Andre, Scanner, score, Face, gGamePhase, gWinner, gBoundsRect, gWidth, gHeight, gDepth, gLeft, gTop, gRight, gBot, gFarRect, gShadowDivY, gStageOffH, gStageOffV, gPerspective, gDepthIncX, gDepthIncY, gGravity, gGravFreq, gBgdOffH, gBgdOffV, gBgdOffPt, grInnerTarget, grMidTarget, gOuterLeft, gOuterRight, gTGTinnerCast, gTGTmidCast, gTGTouterCast, gTGTleftCast, gTGTrightCast, gBallSpr, gShadowSpr, gGunSpr, gFarSpr, gTGTspr, gSmokeSpr, gAndreSpr, gDotCast, gFireSnd, gBounceSnd, gLastKey, gLeftKey, gRightKey, gFarCastNum, gStatusField

on new me
  set iState to #idle
  set iGravCount to 0
  set iTrailCount to 0
  set iTrailCols to [76, 113, 149, 185, 191, 197, 203, 200, 206, 212, 214, 255]
  set iStartCastNum to 71
  set iNbCasts to 14
  set iDepthDiv to (gDepth / iNbCasts) + 1
  set the foreColor of sprite gBallSpr to 76
  set iShadowCast to 15
  set the foreColor of sprite gShadowSpr to 213
  set iLocX to -200
  set iLocY to 0
  set iLocZ to 0
  set iVelX to 0
  set iVelY to 0
  set iVelZ to 0
  set iCurCast to mgetBallCast(me)
  return me
end

on mFire me
  if iState = #moving then
    exit
  end if
  set iGravCount to 0
  set iLocX to the iLocX of gun
  set iLocY to the iCannonY of gun
  set iLocZ to the iCannonZ of gun
  set iVelX to the iVelX of gun
  set iVelY to the iVelY of gun
  set iVelZ to the iVelZ of gun
  set iState to #moving
  puppetSound(1, gFireSnd)
end

on mDisplay me
  set ballCast to mgetBallCast(me)
  set the castNum of sprite gBallSpr to ballCast
  set curOrgX to iLocZ / gDepthIncX
  set curOrgY to iLocZ / gDepthIncY
  set fDepth to gDepth * 1.0
  set curScale to gPerspective + ((1 - gPerspective) * ((fDepth - iLocZ) / fDepth))
  set remapX to integer(iLocX * curScale)
  set remapY to integer(iLocY * curScale)
  set the locH of sprite gBallSpr to curOrgX + remapX + gStageOffH
  set the locV of sprite gBallSpr to curOrgY + remapY + gStageOffV
  set shadowX to curOrgX + remapX + gStageOffH
  set shadowY to gBot - (iLocZ / gShadowDivY) + gStageOffV
  set sz to (gDepth - iLocZ + (iLocY / 2)) / 30
  if sz < 2 then
    set sz to 2
  end if
  set the castNum of sprite gShadowSpr to ballCast
  set the rect of sprite gShadowSpr to rect(shadowX - sz, shadowY - sz, shadowX + sz, shadowY + (sz / 2))
end

on mHide me
  set the locH of sprite gBallSpr to -1000
  set the locH of sprite gShadowSpr to -1000
end

on mMove me
  if iState = #idle then
    exit
  end if
  set iGravCount to iGravCount + 1
  if iGravCount >= gGravFreq then
    set iGravCount to 0
    set iVelY to iVelY + gGravity
  end if
  set newX to iLocX + iVelX
  set newY to iLocY + iVelY
  set newZ to iLocZ + iVelZ
  set BOUNCE to 0
  if newX <= gLeft then
    set iVelX to -iVelX
    set BOUNCE to 1
  else
    if newX >= gRight then
      set iVelX to -iVelX
      set BOUNCE to 1
    end if
  end if
  if newY <= gTop then
    set iVelY to -iVelY
    set BOUNCE to 1
  else
    if newY >= gBot then
      set iVelY to -iVelY
      set BOUNCE to 1
    end if
  end if
  if newZ <= 0 then
    if gLastKey = "x" then
      set iVelZ to -iVelZ
      set BOUNCE to 1
    else
      set iState to #idle
      mHide(me)
      mHide(Scanner)
      mScheduleFlashFX(gameSpace, #fgd)
      set op to mScore(score, #Andre, 1)
      if op = #match then
        set gGamePhase to #startExtro
        mTrigger(Face, #laugh)
        set gWinner to #Andre
      end if
      exit
    end if
  else
    if newZ >= gDepth then
      if gLastKey = "x" then
        set BOUNCE to 1
        set iVelZ to -iVelZ
      else
        set iState to #idle
        set nbPoints to mLightTarget(gameSpace)
        mHide(me)
        mHide(Scanner)
        set op to mScore(score, #user, nbPoints)
        if op = #match then
          set gGamePhase to #startExtro
          mTrigger(Face, #frown)
          set gWinner to #user
        end if
        exit
      end if
    end if
  end if
  set iLocX to iLocX + iVelX
  set iLocY to iLocY + iVelY
  set iLocZ to iLocZ + iVelZ
  mDisplay(me)
  if BOUNCE then
    puppetSound(1, gBounceSnd)
  end if
end

on mStartTrails me
  set iTrailCount to 0
  set the trails of sprite gBallSpr to 1
end

on mStopTrails me
  set iTrailCount to 0
  set the trails of sprite gBallSpr to 0
end

on mDoTrails me
  set iTrailCount to iTrailCount + 1
  if iTrailCount > count(iTrailCols) then
    exit
  end if
  set the foreColor of sprite gBallSpr to getAt(iTrailCols, iTrailCount)
end

on mReset me
end

on mdispose me
end

on mgetBallCast me
  return iStartCastNum + (iLocZ / iDepthDiv)
end

on mGetBallInfo me
  set tempLocX to iLocX
  set tempLocY to iLocY
  set tempLocZ to iLocZ
  set tempVelX to iVelX
  set tempVelY to iVelY
  set tempVelZ to iVelZ
  set tempGravCount to iGravCount
  set nbSteps to 0
  repeat while tempLocZ <= the iLocZ of Andre
    set nbSteps to nbSteps + 1
    set tempGravCount to tempGravCount + 1
    if tempGravCount >= gGravFreq then
      set tempGravCount to 0
      set tempVelY to tempVelY + gGravity
    end if
    set newX to tempLocX + tempVelX
    set newY to tempLocY + tempVelY
    set newZ to tempLocZ + tempVelZ
    if newX <= gLeft then
      set tempVelX to -tempVelX
    else
      if newX >= gRight then
        set tempVelX to -tempVelX
      end if
    end if
    if newY <= gTop then
      set tempVelY to -tempVelY
    else
      if newY >= gBot then
        set tempVelY to -tempVelY
      end if
    end if
    set tempLocX to tempLocX + tempVelX
    set tempLocY to tempLocY + tempVelY
    set tempLocZ to tempLocZ + tempVelZ
  end repeat
  return list(point(tempLocX, tempLocY), nbSteps)
end

on mLightTarget me
  set ballPt to point(iLocX, iLocY) + gBgdOffPt
  if inside(ballPt, grInnerTarget) then
    set cnum to gTGTinnerCast
    set nbPoints to 4
  else
    if inside(ballPt, grMidTarget) then
      set cnum to gTGTmidCast
      set nbPoints to 3
    else
      if iLocX <= gOuterLeft then
        set cnum to gTGTleftCast
        set nbPoints to 1
      else
        if iLocX >= gOuterRight then
          set cnum to gTGTrightCast
          set nbPoints to 1
        else
          set cnum to gTGTouterCast
          set nbPoints to 2
        end if
      end if
    end if
  end if
  set the loc of sprite gTGTspr to gBgdOffPt
  set the castNum of sprite gTGTspr to cnum
  updateStage()
  doPause(2)
  set the loc of sprite gTGTspr to point(-100, 0)
  set the castNum of sprite gTGTspr to gDotCast
  return nbPoints
end

on mSetPos me, x, y, z
  set iLocX to x
  set iLocY to y
  set iLocZ to z
  mDisplay(me)
end
