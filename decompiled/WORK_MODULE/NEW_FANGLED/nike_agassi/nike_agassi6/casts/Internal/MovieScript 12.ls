on plotParabole dx, dy, nbSteps
  set dx to dx * 1.0
  set dy to dy * 1.0
  if dx = 0 then
    set dx to 1.0
  end if
  if dy = 0 then
    set dy to 1.0
  end if
  set nbSteps to nbSteps * 1.0
  set totalSteps to (nbSteps * 2) + 1
  set fourP to dx * dx / dy
  set inc to abs(dx / nbSteps)
  set out to []
  if dx < 0 then
    set curX to dx
    repeat with x = 1 to totalSteps
      set curY to curX * curX / fourP
      add(out, point(curX, curY))
      set curX to curX + inc
    end repeat
  else
    set curX to dx
    repeat with x = 1 to totalSteps
      set curY to curX * curX / fourP
      add(out, point(curX, curY))
      set curX to curX - inc
    end repeat
  end if
  setAt(out, totalSteps, point(-dx, dy))
  return out
end

on waitForTimer endTime
  repeat while the timer < endTime
  end repeat
end

on doPause nbTicks
  set endTime to the timer + nbTicks
  repeat while the timer < endTime
  end repeat
end

on wrap V, incr, max
  set V to V + incr
  if V > max then
    return 1
  end if
  if V < 1 then
    return max
  end if
  return V
end

on prepForShipping
  set lastCast to the number of castMembers
  repeat with x = 1 to lastCast
    if (the castType of cast x = #field) or (the castType of cast x = #text) then
      set the text of member x to " "
    end if
  end repeat
end
