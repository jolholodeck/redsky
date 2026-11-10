on clearGuide
  puppetSprite(15, 1)
  puppetSprite(16, 1)
  puppetSprite(22, 1)
  set the memberNum of sprite 22 to the number of member "Guide/List off"
  updateStage()
  go("easy1")
  repeat while not (the frameLabel = "easy1b")
    go(the frame + 1)
  end repeat
  puppetSprite(15, 0)
  puppetSprite(16, 0)
  puppetSprite(22, 0)
end

on clearQuick
  puppetSprite(15, 1)
  puppetSprite(16, 1)
  puppetSprite(22, 1)
  set the memberNum of sprite 22 to the number of member "QuickHits off"
  updateStage()
  go("easy2")
  repeat while not (the frameLabel = "easy2b")
    go(the frame + 1)
  end repeat
  puppetSprite(15, 0)
  puppetSprite(16, 0)
  puppetSprite(22, 0)
end

on clearMom
  puppetSprite(15, 1)
  puppetSprite(16, 1)
  puppetSprite(22, 1)
  set the memberNum of sprite 22 to the number of member "Mom off"
  updateStage()
  go("easy3")
  repeat while not (the frameLabel = "easy3b")
    go(the frame + 1)
  end repeat
  puppetSprite(15, 0)
  puppetSprite(16, 0)
  puppetSprite(22, 0)
end
