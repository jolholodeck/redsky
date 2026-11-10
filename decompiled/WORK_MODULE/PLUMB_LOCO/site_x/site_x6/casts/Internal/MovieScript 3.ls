global kDotCast, kOffscreenLoc

on initSpriteMgr
  set kDotCast to member "dotCast"
  set kOffscreenLoc to point(-1000, 0)
end

on initPuppets sprs, doUpdate
  if integerp(sprs) then
    puppetSprite(sprs, 1)
  else
    if ilk(sprs, #point) then
      set a to max(min(getAt(sprs, 1), 48), 1)
      set z to max(min(getAt(sprs, 2), 48), 1)
      if a > z then
        set temp to a
        set a to z
        set z to temp
      end if
      repeat with x = a to z
        puppetSprite(x, 1)
      end repeat
    else
      if ilk(sprs, #list) then
        repeat with x in sprs
          if not integerp(x) then
            next repeat
          end if
          set x to max(min(x, 48), 1)
          puppetSprite(x, 1)
        end repeat
      else
        exit
      end if
    end if
  end if
  if voidp(doUpdate) then
    exit
  end if
  if doUpdate then
    updateStage()
  end if
end

on releasePuppets sprs, doClear, doUpdate
  if doClear then
    clearSprites(sprs)
  end if
  if integerp(sprs) then
    puppetSprite(sprs, 0)
  else
    if ilk(sprs, #point) then
      set a to max(min(getAt(sprs, 1), 48), 1)
      set z to max(min(getAt(sprs, 2), 48), 1)
      if a > z then
        set temp to a
        set a to z
        set z to temp
      end if
      repeat with x = a to z
        puppetSprite(x, 0)
      end repeat
    else
      if ilk(sprs, #list) then
        repeat with x in sprs
          if not integerp(x) then
            next repeat
          end if
          set x to max(min(x, 48), 1)
          puppetSprite(x, 0)
        end repeat
      else
        exit
      end if
    end if
  end if
  if voidp(doUpdate) then
    exit
  end if
  if doUpdate then
    updateStage()
  end if
end

on clearSprites sprs, doUpdate
  global kDotCast, kOffscreenLoc
  initPuppets(sprs)
  if integerp(sprs) then
    set the member of sprite sprs to kDotCast
    set the loc of sprite sprs to kOffscreenLoc
    set the blend of sprite sprs to 100
  else
    if ilk(sprs, #point) then
      set a to max(min(getAt(sprs, 1), 48), 1)
      set z to max(min(getAt(sprs, 2), 48), 1)
      if a > z then
        set temp to a
        set a to z
        set z to temp
      end if
      repeat with x = a to z
        set the member of sprite x to kDotCast
        set the loc of sprite x to kOffscreenLoc
        set the blend of sprite x to 100
      end repeat
    else
      if ilk(sprs, #list) then
        repeat with x in sprs
          if not integerp(x) then
            next repeat
          end if
          set x to max(min(x, 48), 1)
          set the member of sprite x to kDotCast
          set the loc of sprite x to kOffscreenLoc
          set the blend of sprite x to 100
        end repeat
      else
        exit
      end if
    end if
  end if
  if voidp(doUpdate) then
    exit
  end if
  if doUpdate then
    updateStage()
  end if
end
