on mouseDown
  DarkenButton(the clickOn)
end

on mouseUp
  global clickedOnButton
  lightenbutton()
  if clickedOnButton = the clickOn then
    turnOFFpopup()
    go("Screen 1 Helicopter")
  end if
end
