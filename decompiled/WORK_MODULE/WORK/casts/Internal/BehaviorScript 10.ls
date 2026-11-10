on exitFrame
  global goWorkMgr, goNavMgr, goSoundMgr
  repeat while soundBusy(3)
  end repeat
  set whichModule to mGetModuleName(goWorkMgr)
  mShuttingDown(goSoundMgr)
  mPurgeAllSounds(goNavMgr)
  cleanupWork()
  if whichModule = #quit then
    mRestoreSystem(goNavMgr)
    quit()
  else
    mGotoModule(goNavMgr, whichModule)
  end if
end
