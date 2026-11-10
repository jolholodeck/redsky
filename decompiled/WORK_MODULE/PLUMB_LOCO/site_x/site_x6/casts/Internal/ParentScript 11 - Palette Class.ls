property iCurLoc, iCurDelta, iCurSwatch, ilPalSprs, iState, iMode, iCurPalIdx, iNbPalCasts, iStartStatic, ikStaticTime, iStartCycle, ikCycleTime
global kPi, k2pi, kPalMoveRect, kNbSwatches, kSwatchAngInc, kSwatchAngTol, kMinPalRadius, kMaxPalRadius, kGravity, kInertia, klPalBgdCasts, kPalSwatchBaseCast, kPalThumbBaseCast, kPalBgdSpr, kPalSwatchSpr, kPalThumbSpr

on new me
  set iCurLoc to point(100, 100)
  set iCurDelta to point(0, 0)
  set iCurSwatch to 0
  set iCurPalIdx to 1
  set iNbPalCasts to count(klPalBgdCasts)
  set ilPalSprs to [kPalBgdSpr, kPalSwatchSpr, kPalThumbSpr]
  set iState to #tracking
  set iMode to #cycling
  set iStartStatic to 0
  set ikStaticTime to 60 * 5
  set iStartCycle to the timer
  set ikCycleTime to 5
  return me
end

on mSetUp me
  set iMode to #cycling
  set iStartCycle to the timer
  set the memberNum of sprite kPalBgdSpr to getAt(klPalBgdCasts, iCurPalIdx)
  set the memberNum of sprite kPalSwatchSpr to kPalSwatchBaseCast + iCurSwatch
  set the memberNum of sprite kPalThumbSpr to kPalThumbBaseCast + iCurSwatch
  repeat with curSpr in ilPalSprs
    set the loc of sprite curSpr to iCurLoc
  end repeat
end

on mSuspend me
  clearSprites(ilPalSprs)
  set iState to #suspended
end

on mResume me, mPt
  set iState to #tracking
  set iCurLoc to mPt
  mSetUp(me)
end

on mTrack me, mPt, trackPos
  if iState <> #tracking then
    exit
  end if
  set iCurPalIdx to iCurPalIdx + 1
  if iCurPalIdx > iNbPalCasts then
    set iCurPalIdx to 1
  end if
  set the memberNum of sprite kPalBgdSpr to getAt(klPalBgdCasts, iCurPalIdx)
  set mDelta to mPt - iCurLoc
  set newDelta to (iCurDelta + (mDelta / kGravity)) / kInertia
  set newH to getAt(newDelta, 1)
  set newV to getAt(newDelta, 2)
  setAt(newDelta, 1, integer(newH))
  setAt(newDelta, 2, integer(newV))
  if trackPos then
    set iCurLoc to iCurLoc + newDelta
    set iCurDelta to newDelta
    set iCurLoc to constrainPoint(iCurLoc, kPalMoveRect)
    repeat with curSpr in ilPalSprs
      set the loc of sprite curSpr to iCurLoc
    end repeat
    set openRadius to 0
  else
    set openRadius to 1
  end if
  set mDist to integer(getHyp(mDelta))
  if (mDist > kMinPalRadius) and ((mDist < kMaxPalRadius) or openRadius) then
    set mAngle to slopeToAngle(mDelta)
    set hitIdx to min(integer(mAngle / kSwatchAngInc), 9)
    if hitIdx <> iCurSwatch then
      set iCurSwatch to hitIdx
      set the memberNum of sprite kPalSwatchSpr to kPalSwatchBaseCast + iCurSwatch
      set the memberNum of sprite kPalThumbSpr to kPalThumbBaseCast + iCurSwatch
      set iMode to #static
      set iStartStatic to the timer
    end if
  end if
  if iMode = #static then
    if the timer > (iStartStatic + ikStaticTime) then
      set iStartStatic to 0
      set iMode to #cycling
      set iStartCycle to the timer
    end if
  else
    if the timer > (iStartCycle + ikCycleTime) then
      set iStartCycle to the timer
      set iCurSwatch to iCurSwatch + 1
      if iCurSwatch > 9 then
        set iCurSwatch to 0
      end if
      set the memberNum of sprite kPalSwatchSpr to kPalSwatchBaseCast + iCurSwatch
      set the memberNum of sprite kPalThumbSpr to kPalThumbBaseCast + iCurSwatch
    end if
  end if
end
