global gWord1Spr, gCloud1, gLightSpr, gPlayThunder, gDistThunder, gLoudThunder, gThunderTimer, gZotSpr, gComplete, gCountDown, gTimeoutTimer, g.obj.SystemManager

on startMovie
  if objectp(g.obj.SystemManager) then
    sysEnterStartMovie(g.obj.SystemManager)
  end if
  set gComplete to 0
  set gWord1Spr to 11
  set gCloud1 to the number of member "1acloud.PICT"
  set gLightSpr to 2
  set gZotSpr to 3
  set gDistThunder to the number of member "distant.aiff"
  set gLoudThunder to the number of member "sharpthdr.aiff"
  set gPlayThunder to 1
  set the exitLock to 0
  set gThunderTimer to 5 * 60
  set gCountDown to 0
  set gTimeoutTimer to 0
  if objectp(g.obj.SystemManager) then
    sysExitStartMovie(g.obj.SystemManager)
  end if
end

on tellPalette
  repeat with i = 1 to 200
    if the type of member i = #bitmap then
      put i & ":" && the name of member i & ":" && the name of member the palette of member i
    end if
  end repeat
end

on payoff which
  repeat with i = 11 to 16
    set the visible of sprite i to 1
  end repeat
  resetLightning()
  go(marker("payoff" & which))
  exit
end

on checkList
  set myCount to 0
  set gComplete to 0
  repeat with i = 1 to count(gWordList)
    set myCount to myCount + getAt(gWordList, i)
  end repeat
  if (myCount = (count(gWordList) - 1)) and (gCountDown = 0) then
    set gCountDown to 1
    set gTimeoutTimer to the timer + (10 * 60)
  end if
  if (the timer > gTimeoutTimer) and (gCountDown = 1) then
    set gComplete to 1
    set gCountDown to 0
  end if
  if myCount = count(gWordList) then
    set gComplete to 1
  end if
end

on loudThunder
end

on softThunder
  if not soundBusy(1) then
    set the volume of sound 1 to 175 + random(50)
    puppetSound(1, gDistThunder)
    updateStage()
    set gThunderTimer to the timer + (6 * 60) + random(6 * 60)
  end if
end

on idle
  if gPlayThunder = 1 then
    if the timer > gThunderTimer then
      set the volume of sound 1 to 100 + random(155)
      puppetSound(1, gDistThunder)
      set gThunderTimer to the timer + (5 * 60)
      set gThunderTimer to the timer + (6 * 60) + random(6 * 60)
    end if
  end if
end

on makeLightning offset, numPieces
  puppetSprite(gLightSpr, 1)
  set the memberNum of sprite gLightSpr to gCloud1 - 1 + offset + random(numPieces)
  set the blend of sprite gLightSpr to 25 + random(75)
  updateStage()
end

on resetLightning
  set the visible of sprite gZotSpr to 1
  set the memberNum of sprite gLightSpr to gCloud1 + 3
  puppetSprite(gLightSpr, 0)
  updateStage()
end

on hideSprites
  repeat with i = gWord1Spr to gWord1Spr + 6
    set the visible of sprite i to 0
  end repeat
end

on showSprites
  repeat with i = 1 to 48
    set the visible of sprite i to 1
  end repeat
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
