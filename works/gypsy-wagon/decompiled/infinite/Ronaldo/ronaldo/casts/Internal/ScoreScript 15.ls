global gWordList, gZotSpr, gComplete

on exitFrame
  checkList()
  if gComplete = 1 then
    payoff(2)
    exit
  end if
  if getProp(gWordList, "in") = 1 then
    set the visible of sprite gZotSpr to 0
    makeLightning(8, 4)
    go(the frame)
  end if
  if not rollOver(6) then
    go("go2")
  end if
end
