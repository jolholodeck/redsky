global g.obj.SystemManager

on startMovie
  global g.obj.SystemManager, firstFrame, lastFrame
  if objectp(g.obj.SystemManager) then
    sysEnterStartMovie(g.obj.SystemManager)
  end if
  set firstFrame to label("first") + 1
  set lastFrame to label("last") + 1
  if objectp(g.obj.SystemManager) then
    sysExitStartMovie(g.obj.SystemManager)
  end if
end

on stopMovie
  global g.obj.SystemManager
  if objectp(g.obj.SystemManager) then
    sysExitStopMovie(g.obj.SystemManager)
  end if
end

on keyDown
  global firstFrame, lastFrame
  if objectp(g.obj.SystemManager) then
    systemKeyHandler(g.obj.SystemManager, the key)
  end if
  if the keyCode = 124 then
    if not (marker(1) > lastFrame) then
      go(marker(1))
    end if
  end if
  if the keyCode = 123 then
    if marker(-1) > 0 then
      go(marker(-1))
    end if
  end if
end

on systemExitCleanupHandler
  put "CHILD: in systemExitCleanupHandler"
  if objectp(g.obj.SystemManager) then
    puppetAllSprites(g.obj.SystemManager)
    go("gdmoFadeToBlack")
  end if
end
