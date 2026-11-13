global goConsole, koConstants, goSysEnvirons, gDebug

on startMovie
  cursor(4)
  if the runMode = "Projector" then
    the alertHook = script("AlertHook.class")
  end if
  if the shiftDown and the controlDown then
    gDebug = 1
  else
    gDebug = 0
  end if
  member("devFeedback", 1).text = " "
  set the exitLock to 1
  koConstants = new(script("Constants.class"))
  koConstants.ikMaxNbWidgets = GetNormVal(point(3, 7), point(10000, 25000), goSysEnvirons.iMachineMetric)
  koConstants.ikMaxThreads = GetNormVal(point(9, 15), point(10000, 25000), goSysEnvirons.iMachineMetric)
  put koConstants.ikMaxNbWidgets
  put koConstants.ikMaxThreads
  the actorList = []
  goConsole = new(script("Console.class"))
  set the keyDownScript to "goConsole.ioKbdHandler.mHandleKey()"
  set the mouseDownScript to "goConsole.ioCurFrameset.mHandleClick()"
  goConsole.ioCurFrameset.mStartup()
  goConsole.ioKbdHandler.mEnableKbd()
end

on stopMovie
  member("devFeedback", 1).text = " "
  goConsole.ioSong.mStopAllNotes()
  goConsole.ioSong.mStopLoops()
  the actorList = []
  set the keyDownScript to EMPTY
  set the mouseDownScript to EMPTY
  goConsole.ioCastLibMgr.mUnlinkAll()
  if the runMode = "Projector" then
    if objectp(goConsole.ioSongMgr) then
      goConsole.ioSongMgr.mKillSong(#zordSong)
    end if
    goConsole = 0
    koConstants = 0
  end if
end

on idle
  goConsole.ioCurFrameset.mTrackCursor()
end

on fadeOutIntroScreen
  global goSongMgr, gSndMusID, goSndMus
  spr = 119
  maskMbr = member(102, 1)
  introMbr = member(81, 2)
  lStaticSnd = [#bank: 2, #pgm: 17, #vel: 100, #action: #play, #note: 93, #dur: 700]
  goConsole.ioSong.mPostEvent(lStaticSnd)
  Levent = [#bank: 2, #pgm: 110, #vel: 100, #action: #play, #note: 60, #dur: 2000]
  goConsole.ioSong.mPostEvent(Levent)
  repeat with X = 1 to 5
    ms = the milliSeconds
    sprite(spr).member = maskMbr
    updateStage()
    repeat while the milliSeconds < (ms + 30)
    end repeat
    ms = the milliSeconds
    sprite(spr).member = introMbr
    updateStage()
    repeat while the milliSeconds < (ms + 30)
    end repeat
  end repeat
  sprite(spr).member = koConstants.ikDummyMbr
  sprite(spr).locH = -1000
  goSongMgr.mKillSong(gSndMusID)
  gSndMusID = VOID
  goSndMus = VOID
  goSongMgr = VOID
  Levent = [#bank: 2, #pgm: 3, #vel: 127, #action: #play, #note: 50, #dur: 400]
  goConsole.ioSong.mPostEvent(Levent)
end

on GetNormVal range1, range2, theVal
  r = range1[2] - range1[1]
  r2 = range2[2] - range2[1]
  return min(max(range1[1], ((theVal - range2[1]) / (r2 / r)) + range1[1]), range1[2])
end
