global gactualticks, gSuspended, goStateMgr

on startMovie
  set the keyDownScript to EMPTY
  set gSuspended to 0
  set the idleLoadMode to 3
  set the idleLoadPeriod to 0
  timer_init()
  mouse_init(6)
  animation_init()
  sync_init()
  flicker_init()
  if mGetData(goStateMgr, #cowboy) = VOID then
    computeactualticks()
    set temploadprofile to loadprofile()
    if the machineType = 256 then
      set tempmachineprofile to machineprofile()
      if (temploadprofile > (9 * gactualticks)) or (tempmachineprofile < 14000) then
        put "load profile: " & temploadprofile
        put "machine profile: " & tempmachineprofile
        if weakalert() = 1 then
          exit
        end if
      end if
    end if
    setupglobals()
  else
    preloadMember("cb_1.aif", "e_workbotttle00020")
    superidleload()
    go("Loop")
    restorestate()
    set the keyDownScript to "checkForModuleKey()"
  end if
end

on exitFrame
  if gSuspended then
    exit
  end if
  timer_idle()
  animation_idle()
end

on mouseDown
  if gSuspended then
    exit
  end if
  mouse_mousedown()
end

on superidleload
  set temp to the idleReadChunkSize
  set the idleReadChunkSize to 10485760
  finishIdleLoad()
  set the idleReadChunkSize to temp
end

on computeactualticks
  if the machineType = 256 then
    set gactualticks to 62.39999999999999858
  else
    set gactualticks to 60.10000000000000142
  end if
end

on checkForModuleKey
  set destModule to mCheckModuleKey(goNavMgr)
  if destModule = #none then
    exit
  end if
  set gSuspended to 1
  if destModule = #quit then
    flicker_splicecut(2, "black_frame")
    mRestoreSystem(goNavMgr)
    quit()
  end if
  clickModule(destModule)
end

on clickModule destModule
  flicker_splicecut(2, "black_frame")
  prepModule()
  mGotoModule(goNavMgr, destModule)
end

on machineprofile
  set iterations to 0
  startTimer()
  repeat while the timer < 60
    set iterations to iterations + 1
    set temp to 1 / 1.0
    set temp to 1 / 1
    set temp to "a"
    set temp to "a" & "b"
    set temp to [1]
    set temp to ["1"]
  end repeat
  return iterations
end

on loadprofile
  startTimer()
  preloadMember("cb_1.aif", "e_workbotttle00020")
  superidleload()
  return the timer
end

on weakalert
  set alertobj to new(xtra("MUI"))
  set alertinitlist to [#buttons: #yesno, #title: "Performance Alert", #message: "This machine is not fast enough to run the entertainment" & RETURN & "portion of the Red Sky Interactive demo." & RETURN & RETURN & "Do you want to jump to the portfolio of Red Sky's work?" & RETURN, #movable: 1]
  if objectp(alertobj) then
    set result to alert(alertobj, alertinitlist)
    case result of
      1:
        mGotoModule(goNavMgr, #work)
    end case
  end if
  return result
end
