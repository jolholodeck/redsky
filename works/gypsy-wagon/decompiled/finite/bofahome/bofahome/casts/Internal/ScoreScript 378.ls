on mouseDown
  DarkenButton(the clickOn)
end

on mouseUp
  global clickedOnButton
  lightenbutton()
  if clickedOnButton = the clickOn then
    go("RSI credit")
  end if
end
