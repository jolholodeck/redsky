global gWordList, gZotSpr, gComplete

on exitFrame
  if gComplete = 1 then
    payoff(3)
  end if
  if rollOver(4) then
    if getProp(gWordList, "actually") = 0 then
      set the visible of sprite 14 to 1
      go("actually")
      loudThunder()
      setProp(gWordList, "actually", 1)
    else
      go(label("actually") + 6)
    end if
  end if
  if rollOver(5) then
    if getProp(gWordList, "and") = 0 then
      set the visible of sprite 11 to 1
      go("and")
      loudThunder()
      setProp(gWordList, "and", 1)
    else
      go(label("and") + 6)
    end if
  end if
  if rollOver(6) then
    if getProp(gWordList, "listening") = 0 then
      set the visible of sprite 15 to 1
      go("listening")
      loudThunder()
      setProp(gWordList, "listening", 1)
    else
      go(label("listening") + 6)
    end if
  end if
  if rollOver(7) then
    if getProp(gWordList, "He") = 0 then
      set the visible of sprite 12 to 1
      go("He")
      softThunder()
      setProp(gWordList, "He", 1)
    else
      go(label("He") + 6)
    end if
  end if
  if rollOver(9) then
    if getProp(gWordList, "was") = 0 then
      set the visible of sprite 13 to 1
      go("was")
      softThunder()
      setProp(gWordList, "was", 1)
    else
      go(label("was") + 6)
    end if
  end if
  checkList()
  go(the frame)
end
