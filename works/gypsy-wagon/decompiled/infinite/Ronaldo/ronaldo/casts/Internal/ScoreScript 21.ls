global gWordList, gZotSpr, gComplete

on exitFrame
  checkList()
  if gComplete = 1 then
    payoff(3)
  end if
  if getProp(gWordList, "actually") = 1 then
    set the visible of sprite gZotSpr to 0
    makeLightning(0, 4)
    go(the frame)
  end if
  if not rollOver(4) then
    go("go3")
  end if
end
