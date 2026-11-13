on mouseUp
  global lastTypeClickTick, ClientSelect, ShowType, showChips
  set ShowType to the name of cast the castNum of sprite the clickOn
  setChips()
  set the text of cast "OutPut" to string(showChips) && ClientSelect && the ticks - lastTypeClickTick
  if (the ticks - lastTypeClickTick) < 30 then
    turnOnAll()
    set ClientSelect to "all"
    set lastTypeClickTick to the ticks
    go(ShowType)
  end if
  if ClientSelect <> EMPTY then
    if string(showChips) <> "[]" then
      go(ShowType)
    end if
  end if
  set lastTypeClickTick to the ticks
  set ShowType to EMPTY
end
