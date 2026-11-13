property iIdleCycle, iStepLeftAnim, iStepRightAnim, iStepAdjX, iState, iAnimFreq, iCurFreq, iLocX, iLocY, iLocZ, iScale, iOrgX, iOrgY, iInterceptAnim, iDiagAnims, iSideAnims, iFullOnAnims
global Ball, gun, gameSpace, gBoundsRect, gWidth, gHeight, gDepth, gLeft, gTop, gRight, gBot, gFarRect, gShadowDivY, gStageOffH, gStageOffV, gPerspective, gDepthIncX, gDepthIncY, gGravity, gGravFreq, gBgdOffH, gBgdOffV, gBgdOffPt, grInnerTarget, grMidTarget, gOuterLeft, gOuterRight, gTGTinnerCast, gTGTmidCast, gTGTouterCast, gTGTleftCast, gTGTrightCast, gBallSpr, gShadowSpr, gGunSpr, gFarSpr, gTGTspr, gSmokeSpr, gAndreSpr, gDotCast, gFireSnd, gBounceSnd, gHitSnd, gMissSnd, gLastKey, gLeftKey, gRightKey, gFarCastNum, gStatusField

on new me
  set iAnimFreq to 3
  set iCurFreq to 0
  set defPos to 105
  set iIdleCycle to [0, defPos, 106, 107, 106, 105, 104, 103, 102, 101, 102, 103, 104]
  set iStepLeftAnim to [0, 111, 112, 113, 114, 115, 116, 117, 118, 119, defPos]
  set iStepRightAnim to [0, 119, 118, 117, 116, 115, 114, 113, 112, 111]
  set iStepAdjX to 28
  set iLocX to gLeft + (gWidth / 2)
  set iLocY to gHeight
  set iLocZ to gDepth - 10
  set iOrgX to (iLocZ / gDepthIncX) + gStageOffH
  set iOrgY to (iLocZ / gDepthIncY) + gStageOffV
  set fDepth to gDepth * 1.0
  set iScale to gPerspective + ((1 - gPerspective) * ((fDepth - iLocZ) / fDepth))
  set iState to #idle
  set iDiagAnims to [#upLeft: [#ready: [153, 152, 151], #pad: 153, #prep: [157, 156, 155, 154], #jump: [158, 159, 160, 161, 162, 163, 164, 165, 166]], #upRight: [#ready: [172, 171], #pad: 152, #prep: [175, 174, 173], #jump: [176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186]], #up: [#ready: [195, 194, 193, 192], #pad: 195, #prep: [196], #jump: [197, 198, 199, 200, 201, 202, 203]]]
  set iSideAnims to [#left: [#prep: [123, 123, 122, 122, 121, 121], #pad: 123, #move: [141, 142, 143, 144], #hit: [145, 146, 147]], #right: [#prep: [123, 123, 122, 122, 121, 121], #pad: 123, #move: [131, 132, 133, 134], #hit: [135, 136, 137, 138, 139, 140]]]
  set iFullOnAnims to [[401, 402, 403, 404, 405], [401, 411, 412, 413, 414, 415], [401, 421, 422, 423, 424, 425]]
  return me
end

on mMove me
  set iCurFreq to iCurFreq + 1
  if iCurFreq < iAnimFreq then
    exit
  end if
  set iCurFreq to 0
  case iState of
    #intercept:
      set idx to getAt(iInterceptAnim, 1) + 1
      set hit to getAt(iInterceptAnim, 2)
      if idx = hit then
        if gLastKey <> "x" then
          mReturn(Ball)
        end if
      end if
      set cnt to count(iInterceptAnim) - 2
      if idx > cnt then
        set iInterceptAnim to 0
        set iState to #idle
      else
        setAt(iInterceptAnim, 1, idx)
        set info to getAt(iInterceptAnim, idx + 2)
        set cnum to getAt(info, 1)
        set iLocX to getAt(info, 2)
        set iLocY to getAt(info, 3)
        set the castNum of sprite gAndreSpr to cnum
        set the locH of sprite gAndreSpr to iOrgX + integer(iLocX * iScale)
        set the locV of sprite gAndreSpr to iOrgY + integer(iLocY * iScale)
        exit
      end if
    #idle:
      set tolerance to 30
      set stepFreq to 50
      if iLocX < (iStepAdjX + 40) then
        set iState to #right
        set iAnimFreq to 3
      else
        if iLocX > (gWidth - iStepAdjX - 40) then
          set iState to #left
          set iAnimFreq to 3
        else
          if abs(iLocX - the iLocX of gun) > tolerance then
            if iLocX < the iLocX of gun then
              set iState to #right
            else
              set iState to #left
            end if
            set iAnimFreq to 2
            mMove(me)
          else
            if random(stepFreq) = stepFreq then
              set iState to getAt([#right, #left], random(2))
              set iAnimFreq to 1 + random(2)
            else
              set iAnimFreq to 3
              set idx to getAt(iIdleCycle, 1)
              set idx to wrap(idx, 1, count(iIdleCycle) - 1)
              setAt(iIdleCycle, 1, idx)
              set the castNum of sprite gAndreSpr to getAt(iIdleCycle, idx + 1)
            end if
          end if
        end if
      end if
      set the text of field gStatusField to string(iState)
    #left:
      set idx to getAt(iStepLeftAnim, 1) + 1
      set cnt to count(iStepLeftAnim) - 1
      if idx = cnt then
        set iLocX to iLocX - iStepAdjX
        set remapX to integer(iLocX * iScale)
        set the locH of sprite gAndreSpr to iOrgX + remapX
        set the castNum of sprite gAndreSpr to getAt(iStepLeftAnim, idx + 1)
        set iState to #idle
        set the text of field gStatusField to string(iState)
        setAt(iStepLeftAnim, 1, 0)
      else
        setAt(iStepLeftAnim, 1, idx)
        set the castNum of sprite gAndreSpr to getAt(iStepLeftAnim, idx + 1)
      end if
    #right:
      set idx to getAt(iStepRightAnim, 1) + 1
      set cnt to count(iStepRightAnim) - 1
      if idx = 1 then
        set iLocX to iLocX + iStepAdjX
        set remapX to integer(iLocX * iScale)
        set the locH of sprite gAndreSpr to iOrgX + remapX
        set the castNum of sprite gAndreSpr to getAt(iStepRightAnim, idx + 1)
        setAt(iStepRightAnim, 1, idx)
      else
        if idx = cnt then
          set the castNum of sprite gAndreSpr to getAt(iStepRightAnim, idx + 1)
          set iState to #idle
          set the text of field gStatusField to string(iState)
          setAt(iStepRightAnim, 1, 0)
        else
          setAt(iStepRightAnim, 1, idx)
          set the castNum of sprite gAndreSpr to getAt(iStepRightAnim, idx + 1)
        end if
      end if
  end case
end

on mDisplay me
  set remapX to integer(iLocX * iScale)
  set remapY to integer(iLocY * iScale)
  set the locH of sprite gAndreSpr to iOrgX + remapX
  set the locV of sprite gAndreSpr to iOrgY + remapY
end

on mHide me
  set the locH of sprite gAndreSpr to -1000
end

on mFire me
  set iAnimFreq to 1
  setAt(iIdleCycle, 1, 0)
  setAt(iStepLeftAnim, 1, 0)
  setAt(iStepRightAnim, 1, 0)
  set iState to #intercept
  set info to mGetBallInfo(Ball)
  set destpt to getAt(info, 1)
  set destX to getAt(destpt, 1)
  set destY to getAt(destpt, 2)
  set ballSteps to getAt(info, 2)
  set dx to iLocX - destX
  set dy to iLocY - destY
  set xLim to 50
  set yLim to 90
  if dx > xLim then
    if dy > yLim then
      set dir to #upLeft
    else
      set dir to #left
    end if
  else
    if dx < -xLim then
      if dy > yLim then
        set dir to #upRight
      else
        set dir to #right
      end if
    else
      if dy > yLim then
        set dir to #up
      else
        set dir to #fullon
      end if
    end if
  end if
  case dir of
    #fullon:
      set iFullOnAnims to [[401, 402, 403, 404, 405], [401, 411, 412, 413, 414], [401, 421, 422, 423, 424]]
      set downAnim to [123, 123, 122, 122, 121, 121]
      set upAnim to [123, 122, 121]
      set padFrame to 123
      set moveAnim to getAt(iFullOnAnims, random(count(iFullOnAnims)))
      set nbMoves to count(moveAnim)
      set moveInc to -dx / nbMoves
      set intercept to []
      set curX to iLocX
      set curY to iLocY
      set lim to 25
      repeat with curCast in upAnim
        add(intercept, list(curCast, curX, curY))
      end repeat
      repeat with curCast in moveAnim
        set curX to max(min(curX + moveInc, gWidth - lim), lim)
        add(intercept, list(curCast, destX, iLocY))
      end repeat
      set hitFrames to count(intercept)
      set nbPadFrames to ballSteps - hitFrames - count(downAnim)
      if nbPadFrames then
        repeat with x = 1 to nbPadFrames
          addAt(intercept, 1, list(padFrame, iLocX, iLocY))
        end repeat
      end if
      repeat with cnum in downAnim
        addAt(intercept, 1, list(cnum, iLocX, iLocY))
      end repeat
      set hitIdx to count(intercept) - 2
      addAt(intercept, 1, hitIdx)
      addAt(intercept, 1, 0)
      set iInterceptAnim to intercept
    #right, #left:
      set animdata to getaProp(iSideAnims, dir)
      set prepAnim to getaProp(animdata, #prep)
      set padFrame to getaProp(animdata, #pad)
      set hitAnim to getaProp(animdata, #hit)
      set moveAnim to getaProp(animdata, #move)
      set nbMoves to count(moveAnim)
      set moveInc to -dx / nbMoves
      set intercept to []
      set curX to iLocX
      set curY to iLocY
      repeat with curCast in moveAnim
        set curX to curX + integer(moveInc)
        add(intercept, list(curCast, curX, curY))
      end repeat
      set lim to 25
      repeat with curCast in hitAnim
        add(intercept, list(curCast, destX, iLocY))
      end repeat
      set hitFrames to count(intercept)
      set nbPadFrames to ballSteps - hitFrames - count(prepAnim)
      repeat with x = 1 to nbPadFrames
        addAt(intercept, 1, list(padFrame, iLocX, iLocY))
      end repeat
      repeat with cnum in prepAnim
        addAt(intercept, 1, list(cnum, iLocX, iLocY))
      end repeat
      set hitIdx to count(intercept) - count(hitAnim)
      addAt(intercept, 1, hitIdx)
      addAt(intercept, 1, 0)
      set iInterceptAnim to intercept
    #upLeft, #upRight, #up:
      set animdata to getaProp(iDiagAnims, dir)
      set readyAnim to getaProp(animdata, #ready)
      set padFrame to getaProp(animdata, #pad)
      set prepAnim to getaProp(animdata, #prep)
      set jumpAnim to getaProp(animdata, #jump)
      set nbSteps to (count(jumpAnim) - 1) / 2
      set trajectory to plotParabole(dx, dy, nbSteps)
      set xLim to 30
      set idx to 0
      set intercept to []
      repeat with curPt in trajectory
        set idx to idx + 1
        set cnum to getAt(jumpAnim, idx)
        set curX to max(min(getAt(curPt, 1) + destX, gWidth - xLim), xLim)
        set curY to max(min(getAt(curPt, 2) + destY, gHeight), 0)
        add(intercept, list(cnum, curX, curY))
      end repeat
      repeat with cnum in prepAnim
        addAt(intercept, 1, list(cnum, iLocX, iLocY))
      end repeat
      set nbPadFrames to ballSteps - (nbSteps + 1) - count(readyAnim) - count(prepAnim)
      if nbPadFrames > 0 then
        repeat with x = 1 to nbPadFrames
          addAt(intercept, 1, list(padFrame, iLocX, iLocY))
        end repeat
      end if
      repeat with cnum in readyAnim
        addAt(intercept, 1, list(cnum, iLocX, iLocY))
      end repeat
      set hitIdx to count(intercept) - nbSteps
      addAt(intercept, 1, hitIdx)
      addAt(intercept, 1, 0)
      set iInterceptAnim to intercept
    otherwise:
      set iState to #idle
      exit
  end case
  set the text of field gStatusField to "intercept " & dir
end

on mReturn me
  if the iState of Ball = #idle then
    puppetSound(1, gMissSnd)
  else
    set prob to min(32 - the iVelZ of Ball, 15)
    if random(prob) = prob then
      puppetSound(1, gMissSnd)
    else
      set the iVelZ of Ball to -(the iVelZ of Ball) * (1 + random(3))
      if the iLocY of Ball < 50 then
        set the iVelY of Ball to max(the iVelY of Ball, 20)
      end if
      set the iVelX of Ball to (the iVelX of Ball * getAt([-1, 1], random(2))) + random(7) - 4
      puppetSound(1, gHitSnd)
      mScheduleFlashFX(gameSpace, #bgd)
    end if
  end if
end
