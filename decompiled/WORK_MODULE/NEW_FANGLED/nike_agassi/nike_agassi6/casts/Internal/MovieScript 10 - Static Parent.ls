property iStaticState, iStaticFreq, iStaticSwitchTime, iStaticMinTicks, iStaticPicts, iCurStaticPict, iStaticCols, iContinuous
global Ball, gun, Andre, score, gBoundsRect, gWidth, gHeight, gDepth, gLeft, gTop, gRight, gBot, gFarRect, gShadowDivY, gStageOffH, gStageOffV, gPerspective, gDepthIncX, gDepthIncY, gGravity, gGravFreq, gBgdOffH, gBgdOffV, gBgdOffPt, grInnerTarget, grMidTarget, gOuterLeft, gOuterRight, gTGTinnerCast, gTGTmidCast, gTGTouterCast, gTGTleftCast, gTGTrightCast, gBallSpr, gShadowSpr, gGunSpr, gFarSpr, gTGTspr, gSmokeSpr, gAndreSpr, gDotCast, gBackWallFXspr, gFgdFXspr, gStaticSpr, gFireSnd, gBounceSnd, glShockSnds, gStaticSnd, gLastKey, gLeftKey, gRightKey, gFarCastNum, gStatusField

on new me
  set iStaticState to #idle
  set iStaticFreq to 300
  set iStaticSwitchTime to 0
  set iStaticMinTicks to 8
  set iStaticPicts to [23, 24, 25, 26, 27]
  set iStaticCols to [0, 36, 43, 78, 86]
  set iContinuous to 0
  set iCurStaticPict to 0
  return me
end

on mMove me
  case iStaticState of
    #idle:
      if the iNbSets of score < 3 then
        exit
      end if
      if random(iStaticFreq) <> iStaticFreq then
        exit
      end if
      set iStaticSwitchTime to the timer
      set iStaticState to #start
    #start:
      set the loc of sprite gStaticSpr to point(11, 28) + gBgdOffPt
      puppetSound(2, gStaticSnd)
      set iStaticState to #static
    #stop:
      set the locH of sprite gStaticSpr to -1000
      puppetSound(2, 0)
      set iStaticState to #idle
      set iContinuous to 0
    #static:
      if not iContinuous then
        if the timer > (iStaticSwitchTime + iStaticMinTicks) then
          if random(10) = 10 then
            set iStaticState to #stop
            exit
          end if
        end if
      end if
      set oldPict to iCurStaticPict
      repeat while iCurStaticPict = oldPict
        set iCurStaticPict to getAt(iStaticPicts, random(count(iStaticPicts)))
      end repeat
      set the foreColor of sprite gStaticSpr to getAt(iStaticCols, random(count(iStaticCols)))
      set the castNum of sprite gStaticSpr to iCurStaticPict
  end case
end

on mTriggerStatic me
  set iStaticState to #start
  set iContinuous to 0
  set iStaticSwitchTime to the timer
end

on mLockStatic me
  set iStaticState to #start
  set iContinuous to 1
  set the backColor of sprite gStaticSpr to 214
  set the ink of sprite gStaticSpr to 0
end

on mUnlockStatic me
  set iStaticState to #stop
  set iContinuous to 0
  set the backColor of sprite gStaticSpr to 0
  set the ink of sprite gStaticSpr to 36
end
