global gCrntRule, gMenuSprite, gExitSprite, gDEBUG

on startMovie
  global firstFrame, lastFrame
  set gCrntRule to 0
  set gMenuSprite to 4
  set gExitSprite to 15
  set gDEBUG to 0
  set cnum to the number of member "Nike cursor"
  set mnum to the number of member "Nike cursor mask"
  set the cursor of sprite gMenuSprite to [cnum, mnum]
  set the cursor of sprite gExitSprite to [cnum, mnum]
end

on stopMovie
end

on systemExitCleanupHandler
end

on keyDown
  if the keyCode = 124 then
    set gCrntRule to gCrntRule + 1
    if gCrntRule > 15 then
      set gCrntRule to 1
    end if
    goToCrntRule()
  end if
  if the keyCode = 123 then
    set gCrntRule to gCrntRule - 1
    if gCrntRule < 1 then
      set gCrntRule to 15
    end if
    goToCrntRule()
  end if
  CheckForExitKey()
end

on mouseUp
  if rollOver(gMenuSprite) then
    if gCrntRule = 0 then
      set newRule to 1
    else
      set mx to the mouseH - the locH of sprite gMenuSprite
      set my to the mouseV - the locV of sprite gMenuSprite
    end if
    if (mx / 32) > 6 then
      set newRule to 15
    else
      set newRule to 1 + (mx / 32) + (7 * (my > 23))
    end if
    if gDEBUG then
      put "rule selected: ", newRule
    end if
    if newRule <> gCrntRule then
      set gCrntRule to newRule
      goToCrntRule()
    end if
  else
    if rollOver(gExitSprite) then
      if gDEBUG then
        put "EXIT clicked"
      end if
      puppetAllSprites(g.obj.SystemManager)
      go("gdmoFadeToBlack")
    end if
  end if
end

on goToCrntRule
  go("rule" & gCrntRule)
end
