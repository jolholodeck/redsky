on exitFrame
  global g.obj.SystemManager, gdmoShellPuppets, gdmoLaunchDemo
  set the colorDepth to the colrDepth of gdmoLaunchDemo
  repeat with i = 1 to 15
    puppetSound(i, 0)
    sound stop i
  end repeat
  updateStage()
  set gdmoShellPuppets to savePuppetState(g.obj.SystemManager)
  unPuppetAllSprites(g.obj.SystemManager)
  case the mediaType of gdmoLaunchDemo of
    #dirMovie:
      play movie the demoPathName of gdmoLaunchDemo
    #unknown:
      put "<play> called for #unknown movie type.  (shouldnt get here)"
    otherwise:
      put "unsupported type requested!"
  end case
end
