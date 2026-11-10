global goStateMgr, goNavMgr

on ReturnToWork
  mFadeToBlack(goNavMgr)
  mPurgeAllSounds(goNavMgr)
  set returnModule to the iCurModuleID of goNavMgr
  mGotoModule(goNavMgr, returnModule)
end

on CheckForExitKey
  put the key && the keyCode
  if (the key = RETURN) or (the key = ENTER) then
    ReturnToWork()
    abort()
  end if
end

on JumpCut
  set lTempPuppets to []
  repeat with ch = 1 to 120
    if the type of the member of sprite ch <> #empty then
      if the puppet of sprite ch = 0 then
        append(lTempPuppets, ch)
        puppetSprite(ch, 1)
      end if
      set the locH of sprite ch to the locH of sprite ch + 10
      set the locV of sprite ch to the locV of sprite ch - 8
    end if
  end repeat
  updateStage()
  repeat with ch = 1 to 120
    if the type of the member of sprite ch <> #empty then
      set the locH of sprite ch to the locH of sprite ch - 10
      set the locV of sprite ch to the locV of sprite ch + 8
    end if
  end repeat
  repeat with ch in lTempPuppets
    puppetSprite(ch, 0)
  end repeat
  updateStage()
end

on PlayRicochet
  set rand to random(3)
  set nmRicochet to the number of member ("w_ricochet" & string(rand))
  puppetSound(3, nmRicochet)
  if the machineType = 256 then
    doPause(20)
  end if
end
