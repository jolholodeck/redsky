global goWorkMgr, goSoundMgr, goFrameMgr, goIdleMgr, goNavMgr, goStateMgr

on startMovie
  if not objectp(goStateMgr) then
    set goStateMgr to new(script "StateMgr")
  end if
  if not objectp(goNavMgr) then
    set goNavMgr to new(script "NavMgr")
  end if
  preloadMember("w_ricochet1")
  preloadMember("w_ricochet2")
  preloadMember("w_ricochet3")
  StartFrameWork(#kill, #kill)
  mSetData(goStateMgr, #workModule, the pathName & the movieName)
  preloadMember(member "StartPreload", "EndPreload")
  set lButtons to ["w_new_", "w_old_", "w_loco_"]
  set lchButtons to [98, 99, 100]
  set goWorkMgr to new(script "WorkMgr", lButtons, lchButtons)
  set goSoundMgr to new(script "SoundMgr")
  timer_init()
  flicker_init()
  set the idleHandlerPeriod to 1
  set the keyDownScript to "CheckForModuleKey()"
  flicker_setstate(#on)
  flicker_splicecut(2, "Run")
end

on cleanupWork
  mCleanUp(goWorkMgr)
  set goWorkMgr to VOID
  mCleanUp(goSoundMgr)
  set goSoundMgr to VOID
  StopFrameWork()
  set the keyDownScript to EMPTY
end

on idle
  mIdleEvent(goIdleMgr)
  timer_idle()
end

on checkForModuleKey
  set destModule to mCheckModuleKey(goNavMgr)
  if destModule = #none then
    return 
  end if
  mSetModuleName(goWorkMgr, destModule)
  flicker_setstate(#off)
  updateStage()
  flicker_splicecut(3, "Module")
end
