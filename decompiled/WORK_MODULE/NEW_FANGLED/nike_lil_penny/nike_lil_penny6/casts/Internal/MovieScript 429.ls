global g.obj.SystemManager, gCrntRule, gMenuSprite, gExitSprite, gDEBUG

on startMovie
  global g.obj.SystemManager, firstFrame, lastFrame
  if objectp(g.obj.SystemManager) then
    sysEnterStartMovie(g.obj.SystemManager)
  end if
  set gCrntRule to 0
  set gMenuSprite to 4
  set gExitSprite to 15
  set gDEBUG to 0
  set cnum to the number of member "Nike cursor"
  set mnum to the number of member "Nike cursor mask"
  set the cursor of sprite gMenuSprite to [cnum, mnum]
  set the cursor of sprite gExitSprite to [cnum, mnum]
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

on systemExitCleanupHandler
  if objectp(g.obj.SystemManager) then
    puppetAllSprites(g.obj.SystemManager)
    go("gdmoFadeToBlack")
  end if
end

on keyDown
  if objectp(g.obj.SystemManager) then
    systemKeyHandler(g.obj.SystemManager, the key)
  end if
  if the keyCode = 124 then
    set gCrntRule to gCrntRule + 1
    if gCrntRule > 15 then
      set gCrntRule to 15
    end if
    goToCrntRule()
  end if
  if the keyCode = 123 then
    set gCrntRule to gCrntRule - 1
    if gCrntRule < 0 then
      set gCrntRule to 0
    end if
    goToCrntRule()
  end if
end

on goToCrntRule
  go("rule" & gCrntRule)
end

on navigate selector
  if the lastClick > 10 then
    exit
  end if
  case selector of
    #menu:
      if not rollOver(gMenuSprite) then
        exit
      end if
      set mx to the mouseH - the locH of sprite gMenuSprite
      set my to the mouseV - the locV of sprite gMenuSprite
      if (mx / 32) > 6 then
        set newRule to 15
      else
        set newRule to 1 + (mx / 32) + (7 * (my > 23))
      end if
    #fwd:
      set newRule to min(gCrntRule + 1, 15)
    #bwd:
      set newRule to max(gCrntRule - 1, 1)
    #splash:
      set newRule to 0
    #start:
      set newRule to 1
    #home:
      if objectp(g.obj.SystemManager) then
        puppetAllSprites(g.obj.SystemManager)
        go("gdmoFadeToBlack")
      else
        play done
      end if
      abort()
    otherwise:
      exit
  end case
  if newRule <> gCrntRule then
    set gCrntRule to newRule
    goToCrntRule()
  end if
end
