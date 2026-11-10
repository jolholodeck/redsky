on enterFrame
  global g.obj.SystemManager
  if objectp(g.obj.SystemManager) then
    unPuppetAllSprites(g.obj.SystemManager)
    updateStage()
  end if
end
