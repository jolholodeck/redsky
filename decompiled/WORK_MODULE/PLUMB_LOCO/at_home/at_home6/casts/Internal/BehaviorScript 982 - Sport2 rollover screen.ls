on exitFrame
  if rollOver(14) then
    setCursor()
    go(label("sport2") + 3)
  else
    if rollOver(5) then
      setCursor()
      go(label("sport2") + 2)
    else
      go(label("sport2") + 1)
      checkRolloverScreen()
    end if
  end if
end
