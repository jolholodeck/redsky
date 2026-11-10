global glCRDloopIdx, glCRDloopArt, gCRDnbLoopMbrs, gCRDloopSpr, gCRDnextCue, kCRDcueTime

on getNextLoopFrame
  set idx to glCRDloopIdx
  repeat while idx = glCRDloopIdx
    set glCRDloopIdx to random(gCRDnbLoopMbrs)
  end repeat
  return getAt(glCRDloopArt, glCRDloopIdx)
end

on idleAnimLoop
  if the timer < gCRDnextCue then
    exit
  end if
  set gCRDnextCue to the timer + kCRDcueTime
  set mbr to getNextLoopFrame()
  set the memberNum of sprite gCRDloopSpr to mbr
  updateStage()
end
