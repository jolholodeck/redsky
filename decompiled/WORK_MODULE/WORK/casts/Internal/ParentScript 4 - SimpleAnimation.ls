property pnCels, pCurrentCel, pnmAnimBase, pState, pchAnim, pnTicksBeforeUpdating, pLastTicks

on new me, nameStart, nameEnd, chAnim, updateFPS
  set pchAnim to chAnim
  set pCurrentCel to 0
  if voidp(updateFPS) then
    set updateFPS to 8
  end if
  set pnTicksBeforeUpdating to 60 / updateFPS
  set pState to #paused
  set pnmAnimBase to the number of member nameStart - 1
  set nmAnimEnd to the number of member nameEnd
  set pnCels to nmAnimEnd - pnmAnimBase
  mRun(me)
  set pLastTicks to the ticks
  return me
end

on mRun me
  if pState = #Run then
    return 
  end if
  RegisterForFrameEvents(me)
  puppetSprite(pchAnim, 1)
  set pState to #Run
end

on mPause me
  if pState = #paused then
    return 
  end if
  DeRegisterForFrameEvents(me)
  puppetSprite(pchAnim, 0)
  set pState to #paused
end

on mFrameEvent me
  if (pLastTicks + pnTicksBeforeUpdating) > the ticks then
    return 
  end if
  set pCurrentCel to pCurrentCel + 1
  if pCurrentCel > pnCels then
    set pCurrentCel to 1
  end if
  set the member of sprite pchAnim to pnmAnimBase + pCurrentCel
  set pLastTicks to the ticks
end

on mCleanUp me
end
