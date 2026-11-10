on exitFrame
  global gsptBeautiful, gsptAnimation
  set c1 to gsptBeautiful
  set c2 to gsptAnimation
  clearOverlayChans()
  set fadeList to []
  repeat with c = c1 to c2
    if the type of sprite c > 0 then
      append(fadeList, c)
      set the cursor of sprite c to 0
      puppetSprite(c, 1)
    end if
  end repeat
  set startTime to the timer
  set fadeLevel to 100
  repeat while fadeLevel > 0
    repeat with i = 1 to count(fadeList)
      set c to getAt(fadeList, i)
      set the blend of sprite c to fadeLevel
    end repeat
    updateStage()
    set fadeLevel to 100 - integer(100.0 * float(the timer - startTime) / 60.0)
  end repeat
  repeat with i = 1 to count(fadeList)
    set c to getAt(fadeList, i)
    set the loc of sprite c to point(1000, 100)
    set the blend of sprite c to 100
    puppetSprite(c, 0)
  end repeat
  updateStage()
end
