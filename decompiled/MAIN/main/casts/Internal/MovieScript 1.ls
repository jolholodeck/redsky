global goStateMgr, goFlickerMgr, goNavMgr, glCRDloopIdx, glCRDloopArt, gCRDnbLoopMbrs, gCRDloopSpr, gCRDnextCue, kCRDcueTime

on startMovie
  initSession()
  set the keyDownScript to "checkSkipKey()"
  set the mouseDownScript to "gotoDemo()"
  cursor([41, 42])
end

on idle
  idleAnimLoop()
end

on checkSkipKey
  if the keyCode = the ikQuitKey of goNavMgr then
    quit()
  end if
  if the key = " " then
    gotoDemo()
  end if
end

on gotoDemo
  set the locH of sprite gCRDloopSpr to -1000
  updateStage()
  cursor(200)
  go("black")
  puppetSprite(gCRDloopSpr, 0)
  if the shiftDown then
    mGotoModule(goNavMgr, #work)
  else
    mGotoModule(goNavMgr, #entertainment)
  end if
end

on initSession
  set glCRDloopIdx to 0
  set glCRDloopArt to [31, 32, 33, 34, 35, 36, 37, 38]
  set gCRDnbLoopMbrs to count(glCRDloopArt)
  set gCRDnextCue to 0
  set kCRDcueTime to 2
  set gCRDloopSpr to 3
  puppetSprite(gCRDloopSpr, 1)
  preloadMember(31, 38)
  set the exitLock to 1
  set the randomSeed to the ticks
  add(the searchPath, the pathName)
  set origCol to the colorDepth
  set origVol to the soundLevel
  if the machineType = 256 then
    checkColorPC()
  else
    checkColorMac()
  end if
  set the soundLevel to 5
  set goStateMgr to new(script "StateMgr")
  if not objectp(goStateMgr) then
    fatalAlert("Couldn't instantiate State Manager.")
  end if
  set goFlickerMgr to new(script "FlickerMgr")
  if not objectp(goFlickerMgr) then
    fatalAlert("Couldn't instantiate Flicker Manager.")
  end if
  set goNavMgr to new(script "NavMgr", origCol, origVol)
  if not objectp(goNavMgr) then
    fatalAlert("Couldn't instantiate Navigation Manager.")
  end if
end

on checkColorMac
  if the colorDepth <> 8 then
    set the colorDepth to 8
    if the colorDepth <> 8 then
      set colStr to "Sorry, this program requires 256 colors to run." & RETURN
      put "Please contact your Apple dealer for information about a color system upgrade." after colStr
      alert(colStr)
      quit()
    end if
  end if
end

on checkColorPC
  if the colorDepth <> 8 then
    set colStr to "Sorry, this program requires 256 colors to run." & RETURN
    put "Please choose a 256-color display mode in the 'Display' Control Panel and try again." after colStr
    alert(colStr)
    quit()
  end if
end

on doPerformanceCheck
  puppetSprite(1, 1)
  preLoadCast(2)
  set freeze to the timer
  repeat with x = 100 to 150
    set the locH of sprite 1 to x
    set the locV of sprite 1 to x
    updateStage()
  end repeat
  set displayTime to the timer - freeze
  puppetSprite(1, 0)
  updateStage()
  set freeze to the timer
  repeat with x = 1 to 1000
    set y to x + 1
    set y to x * 3
    set y to x / 2.0
  end repeat
  set mathTime to the timer - freeze
  set minDispTime to 17
  set maxDispTime to 45
  set dispIncrem to (maxDispTime - minDispTime) / 10.0
  set minMathTime to 18
  set maxMathTime to 40
  set mathIncrem to (maxMathTime - minMathTime) / 10.0
  if (displayTime > maxDispTime) or (mathTime > maxMathTime) then
    set errStr to the text of field "perfErrStr"
    alert(errStr)
  end if
  set displayTime to max(min(displayTime, maxDispTime), minDispTime)
  set mathTime to max(min(mathTime, maxMathTime), minMathTime)
  set displayIndex to integer((maxDispTime - displayTime) / dispIncrem)
  set mathIndex to integer((maxMathTime - mathTime) / mathIncrem)
  set gPerformance to (displayIndex + mathIndex) / 2
  put gPerformance
end

on fatalAlert str
  alert(str)
  quit()
end
