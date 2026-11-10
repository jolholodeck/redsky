property pnCels, pnCelsRoll, pCurrentCel, pnmAnimBase, pnmAnimRoll, pState, pchAnim

on new me, animName, chAnim, nCels, nCelsRoll
  set pnCels to nCels
  set pnCelsRoll to nCelsRoll
  set pchAnim to chAnim
  set pState to #paused
  set pCurrentCel to 0
  set pnmAnimBase to the number of member (animName & "Idle1") - 1
  set pnmAnimRoll to the number of member (animName & "RollOver1") - 1
  mSetPuppets(me, 1)
  mRun(me)
  RegisterForFrameEvents(me)
  return me
end

on mRun me
  if pState = #running then
    return 
  end if
  set pCurrentCel to 0
  set pState to #running
end

on mRoll me
  if pState = #rolled then
    return 
  end if
  set pCurrentCel to 0
  set pState to #rolled
end

on mSetPuppets me, trueORfalse
  puppetSprite(pchAnim, trueORfalse)
end

on mFrameEvent me
  set pCurrentCel to pCurrentCel + 1
  if pState = #running then
    if pCurrentCel > pnCels then
      set pCurrentCel to 1
    end if
    set the member of sprite pchAnim to pnmAnimBase + pCurrentCel
  else
    if pCurrentCel > pnCelsRoll then
      set pCurrentCel to 1
    end if
    set the member of sprite pchAnim to pnmAnimRoll + pCurrentCel
  end if
end

on mCleanUp me
  DeRegisterForFrameEvents(me)
  mSetPuppets(me, 0)
end
