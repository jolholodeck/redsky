on mouseDown
  global lastClientClickTick, ClientSelect, ShowType
  if (the ticks - lastClientClickTick) < 30 then
    set ShowType to "all"
    set ClientSelect to the name of cast the castNum of sprite the clickOn
    turnOn(the clickOn)
    setChips()
    go("all")
  else
    if ClientSelect = the name of cast the castNum of sprite the clickOn then
      turnOffAll()
    else
      set ClientSelect to the name of cast the castNum of sprite the clickOn
      turnOn(the clickOn)
    end if
  end if
  set lastClientClickTick to the ticks
end
