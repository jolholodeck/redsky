property iStamping, iNbShakes, iLastMpt, ikMaxShakes, ikShakeDist, iStartShake, ikShakeTime, ikWaitShake, iStartWaitShake
global palette, StampMap, Browser, kStampSnd, kShakeSnd, kBrowseSnd, kStampChan, kShakeChan, kBrowseChan, kPointCursor

on new me
  set iStamping to 1
  set iNbShakes to 0
  set ikMaxShakes to 6
  set ikShakeDist to 30
  set iLastMpt to point(0, 0)
  set iStartShake to the timer
  set ikShakeTime to 40
  set ikWaitShake to 45
  set iStartWaitShake to 0
  return me
end

on mTrack me, mPt
  if the timer < (iStartWaitShake + ikWaitShake) then
    exit
  end if
  set iStartWaitShake to 0
  if the timer > (iStartShake + ikShakeTime) then
    set iStartShake to the timer
    set iNbShakes to 0
  end if
  set curDist to getHyp(mPt - iLastMpt)
  set iLastMpt to mPt
  if curDist > ikShakeDist then
    set iNbShakes to iNbShakes + 1
  end if
  if iNbShakes > ikMaxShakes then
    set iNbShakes to 0
    set iStartShake to the timer
    set iStartWaitShake to the timer
    set iStamping to not iStamping
    if iStamping then
      mHide(Browser)
      mResume(palette, mPt)
      mPrepForStamp(StampMap)
      cursor(kPointCursor)
    else
      mSuspend(palette)
      mPrepForBrowse(StampMap)
    end if
    puppetSound(kShakeChan, kShakeSnd)
  end if
end
