global g.obj.SystemManager

on startMovie
  global g.obj.SystemManager, gList, gWhatActive, gBtnSnd
  if objectp(g.obj.SystemManager) then
    sysEnterStartMovie(g.obj.SystemManager)
  end if
  set gBtnSnd to 481
  set gWhatActive to 0
  repeat with i = 11 to 15
    set the visible of sprite i to 1
  end repeat
  set gList to list()
  set start to the number of member "Intro loop" - 1
  repeat with i = 1 to 5
    setAt(gList, i, start + i)
  end repeat
  puppetSprite(48, 1)
  if objectp(g.obj.SystemManager) then
    sysExitStartMovie(g.obj.SystemManager)
  end if
end

on doCleanUp whichSprite
  global gWhatActive, gList
  puppetSprite(gWhatActive + 33, 1)
  set the castNum of sprite (gWhatActive + 33) to getAt(gList, gWhatActive - 10)
end

on stopMovie
  global g.obj.SystemManager
  if objectp(g.obj.SystemManager) then
    sysExitStopMovie(g.obj.SystemManager)
  end if
end

on keyDown
  if objectp(g.obj.SystemManager) then
    systemKeyHandler(g.obj.SystemManager, the key)
  end if
end

on systemExitCleanupHandler
  put "CHILD: in systemExitCleanupHandler"
  if objectp(g.obj.SystemManager) then
    puppetAllSprites(g.obj.SystemManager)
    go("gdmoFadeToBlack")
  end if
end
