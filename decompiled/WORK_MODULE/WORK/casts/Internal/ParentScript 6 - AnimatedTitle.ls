property pnCels, pLastCel, pnmAnimBase, pnmAnimShowing, pState, pchAnim

on new me, animName, chAnim, nCels
  set pnCels to nCels
  set pchAnim to chAnim
  set pState to #paused
  set pLastCel to 0
  set pnmAnimShowing to the number of member (animName & "titleShowing")
  mSetPuppets(me, 1)
  mRun(me)
  return me
end

on mRun me
  if pState = #running then
    return 
  end if
  RegisterForFrameEvents(me)
  puppetSprite(pchAnim, 1)
  set pState to #running
end

on mShow me
  if pState = #showing then
    return 
  end if
  set the member of sprite pchAnim to pnmAnimShowing
  DeRegisterForFrameEvents(me)
  set pState to #showing
end

on mSetPuppets me, trueORfalse
  puppetSprite(pchAnim, trueORfalse)
end

on mFrameEvent me
  set thisCel to random(pnCels)
  if thisCel = pLastCel then
    set thisCel to pLastCel + 1
  end if
  if thisCel > pnCels then
    set thisCel to 1
  end if
  set the member of sprite pchAnim to pnmAnimShowing + thisCel
  set pLastCel to thisCel
end

on mCleanUp me
  mSetPuppets(me, 0)
end
