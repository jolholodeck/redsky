on exitFrame
  if rollOver(14) then
    setCursor()
    go(label("sport2") + 6)
  else
    if rollOver(5) then
      setCursor()
      go(label("sport2") + 5)
    else
      go(label("sport2") + 4)
      checkRolloverScreen()
    end if
  end if
end
