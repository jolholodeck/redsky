global gSpriteList, gSoundList, g.obj.SystemManager

on startMovie
  global g.obj.SystemManager
  if objectp(g.obj.SystemManager) then
    sysEnterStartMovie(g.obj.SystemManager)
  end if
  buildLists()
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

on buildLists
  set gSpriteList to [3: 4, 5: 5, 7: 6, 9: 7, 11: 8, 13: 9, 15: 10, 17: 11, 22: 14, 24: 15, 26: 16, 28: 17, 30: 18, 32: 19]
  set gSoundList to [3: EMPTY, 5: "bballSound", 7: "tennisSound", 9: "crossSound", 11: EMPTY, 13: EMPTY, 15: "skateSound", 17: EMPTY, 22: EMPTY, 24: EMPTY, 26: EMPTY, 28: EMPTY, 30: EMPTY, 32: EMPTY]
end

on hiliteButton whichMember
  set unhilite to whichMember
  set hilite to whichMember + 1
  set sprNum to getaProp(gSpriteList, whichMember)
  set sndName to getaProp(gSoundList, whichMember)
  if not (sndName = EMPTY) then
    puppetSound(sndName)
  end if
  set the memberNum of sprite sprNum to hilite
  updateStage()
  repeat while rollOver(sprNum)
    if the mouseDown then
      if (sprNum = 10) and (the frameLabel = "sportmenu") then
        set the memberNum of sprite sprNum to unhilite
        updateStage()
        hideSportsMenu()
        puppetSprite(40, 1)
        puppetSound("skateClickaroo")
        go("skateClick")
        exit
        next repeat
      end if
      if (sprNum = 19) and (the frameLabel = "skatemenu") then
        set the memberNum of sprite sprNum to unhilite
        updateStage()
        hideSportsMenu()
        hideSkateMenu()
        resetShoe()
        puppetSound("skateClickaroo")
        go("choadClick")
        exit
      end if
    end if
  end repeat
  set the memberNum of sprite sprNum to unhilite
  updateStage()
end

on showSportsMenu
  repeat with i = 4 to 11
    puppetSprite(i, 0)
  end repeat
end

on hideSportsMenu
  repeat with i = 4 to 11
    puppetSprite(i, 1)
    set the locH of sprite i to -1000
  end repeat
end

on showSkateMenu
  repeat with i = 14 to 19
    puppetSprite(i, 0)
  end repeat
end

on hideSkateMenu
  repeat with i = 14 to 19
    puppetSprite(i, 1)
    set the locH of sprite i to -1000
  end repeat
end

on showDescription
  repeat with i = 22 to 26
    puppetSprite(i, 0)
  end repeat
end

on hideDescription
  repeat with i = 22 to 26
    puppetSprite(i, 1)
    set the locH of sprite i to -1000
  end repeat
end

on randomShoe
  set the memberNum of sprite 40 to 1000 + random(100)
end

on resetShoe
  set the memberNum of sprite 40 to the number of member "shoecover"
  puppetSprite(40, 0)
end
