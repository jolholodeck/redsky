global gWordList, gZotSpr, gComplete

on exitFrame
  checkList()
  if gComplete = 1 then
    payoff(3)
  end if
  if getProp(gWordList, "and") = 1 then
    set the visible of sprite gZotSpr to 0
    makeLightning(4, 4)
    go(the frame)
  end if
  if not rollOver(5) then
    go("go3")
  end if
end
