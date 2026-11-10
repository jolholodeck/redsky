on exitFrame
  global goWorkMgr, goNavMgr, goSoundMgr, goStateMgr
  repeat while soundBusy(3)
  end repeat
  set whichMovie to mGetMovieName(goWorkMgr)
  mShuttingDown(goSoundMgr)
  mPurgeAllSounds(goNavMgr)
  cleanupWork()
  if not (the shiftDown) then
    set beenToWork to mGetData(goStateMgr, #beenToWork)
    if voidp(beenToWork) then
      puppetSprite(120, 1)
      set the castLibNum of sprite 120 to the number of castLib "WorkArt"
      set the memberNum of sprite 120 to 22
      set the loc of sprite 120 to point(0, 0)
      updateStage()
      set maxTime to the timer + (10 * 60)
      repeat while the timer < maxTime
        if the keyPressed = ENTER then
          exit repeat
        end if
        if the keyPressed = RETURN then
          exit repeat
        end if
      end repeat
    end if
  end if
  set the locH of sprite 120 to -1000
  updateStage()
  puppetSprite(120, 0)
  cursor(200)
  mSetData(goStateMgr, #beenToWork, 1)
  go(1, whichMovie)
end
