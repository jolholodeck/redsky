global gWordList, gZotSpr, gComplete

on exitFrame
  checkList()
  showGlobals()
  if gComplete = 1 then
    payoff(2)
  end if
  if rollOver(4) then
    if getProp(gWordList, "theBest") = 0 then
      set the visible of sprite 12 to 1
      go("theBest")
      softThunder()
      setProp(gWordList, "theBest", 1)
    else
      go(label("theBest") + 6)
    end if
  end if
  if rollOver(5) then
    if getProp(gWordList, "the") = 0 then
      set the visible of sprite 15 to 1
      go("the")
      softThunder()
      setProp(gWordList, "the", 1)
    else
      go(label("the") + 6)
    end if
  end if
  if rollOver(6) then
    if getProp(gWordList, "in") = 0 then
      set the visible of sprite 14 to 1
      go("in")
      softThunder()
      setProp(gWordList, "in", 1)
    else
      go(label("in") + 6)
    end if
  end if
  if rollOver(7) then
    if getProp(gWordList, "toMake") = 0 then
      set the visible of sprite 11 to 1
      go("toMake")
      loudThunder()
      setProp(gWordList, "toMake", 1)
    else
      go(label("toMake") + 6)
    end if
  end if
  if rollOver(8) then
    if getProp(gWordList, "player") = 0 then
      set the visible of sprite 13 to 1
      go("player")
      loudThunder()
      setProp(gWordList, "player", 1)
    else
      go(label("player") + 6)
    end if
  end if
  if rollOver(9) then
    if getProp(gWordList, "world") = 0 then
      set the visible of sprite 16 to 1
      go("world")
      loudThunder()
      setProp(gWordList, "world", 1)
    else
      go(label("world") + 6)
    end if
  end if
  go(the frame)
end
