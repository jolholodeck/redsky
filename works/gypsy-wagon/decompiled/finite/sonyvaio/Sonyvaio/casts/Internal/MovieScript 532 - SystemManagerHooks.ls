global g.obj.SystemManager

on startMovie
  global g.obj.SystemManager
  if objectp(g.obj.SystemManager) then
    sysEnterStartMovie(g.obj.SystemManager)
  end if
  if objectp(g.obj.SystemManager) then
    sysExitStartMovie(g.obj.SystemManager)
  end if
  if objectp(g.obj.SystemManager) then
    mFixPalette(g.obj.SystemManager)
  end if
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
