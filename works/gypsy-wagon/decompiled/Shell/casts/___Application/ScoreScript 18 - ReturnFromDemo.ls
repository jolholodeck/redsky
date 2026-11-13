on enterFrame
  global g.obj.SystemManager, gdmoShellPuppets, gdmoLaunchDemo
  set the colorDepth to 8
  repeat with i = 1 to 15
    sound stop i
  end repeat
  loadPuppetState(g.obj.SystemManager, gdmoShellPuppets)
end
