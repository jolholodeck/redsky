global gWordList, gZotSpr, gComplete

on exitFrame
  if gComplete = 1 then
    payoff(1)
  end if
  if rollOver(4) then
    if getProp(gWordList, "what") = 0 then
      set the visible of sprite 11 to 1
      go("what")
      loudThunder()
      setProp(gWordList, "what", 1)
    else
      go(label("what") + 6)
    end if
  end if
  if rollOver(5) then
    if getProp(gWordList, "if") = 0 then
      set the visible of sprite 12 to 1
      go("if")
      loudThunder()
      setProp(gWordList, "if", 1)
    else
      go(label("if") + 6)
    end if
  end if
  if rollOver(6) then
    if getProp(gWordList, "you") = 0 then
      set the visible of sprite 13 to 1
      go("you1")
      loudThunder()
      setProp(gWordList, "you", 1)
    else
      go(label("you1") + 6)
    end if
  end if
  if rollOver(7) then
    if getProp(gWordList, "asked") = 0 then
      set the visible of sprite 14 to 1
      go("asked")
      softThunder()
      setProp(gWordList, "asked", 1)
    else
      go(label("asked") + 6)
    end if
  end if
  if rollOver(9) then
    if getProp(gWordList, "God") = 0 then
      set the visible of sprite 15 to 1
      go("God")
      softThunder()
      setProp(gWordList, "God", 1)
    else
      go(label("God") + 6)
    end if
  end if
  checkList()
  go(the frame)
end
