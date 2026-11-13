global gWordList, gZotSpr, gComplete

on exitFrame
  checkList()
  if gComplete = 1 then
    payoff(1)
  end if
  if getProp(gWordList, "asked") = 1 then
    set the visible of sprite gZotSpr to 0
    makeLightning(12, 4)
    go(the frame)
  end if
  if not rollOver(7) then
    go("go1")
  end if
end
