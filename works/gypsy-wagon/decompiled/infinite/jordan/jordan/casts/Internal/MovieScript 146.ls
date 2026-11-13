global g.obj.SystemManager

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
  global gExiting
  put "CHILD: in systemExitCleanupHandler"
  if objectp(g.obj.SystemManager) then
    set gExiting to 1
    puppetAllSprites(g.obj.SystemManager)
    go("gdmoFadeToBlack")
  else
    play done
  end if
end
