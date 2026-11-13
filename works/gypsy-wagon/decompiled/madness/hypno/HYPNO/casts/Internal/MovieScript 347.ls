global g.obj.SystemManager

on startMovie
  global g.obj.SystemManager, oldSound
  if objectp(g.obj.SystemManager) then
    sysEnterStartMovie(g.obj.SystemManager)
  end if
  set oldSound to the volume of sound 1
  set the volume of sound 1 to 80
  set the volume of sound 2 to 80
  put the volume of sound 1
  if objectp(g.obj.SystemManager) then
    sysExitStartMovie(g.obj.SystemManager)
  end if
end

on stopMovie
  global g.obj.SystemManager, oldSound
  sound stop 1
  sound stop 2
  set the volume of sound 1 to oldSound
  set the volume of sound 2 to oldSound
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
