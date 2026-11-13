on mouseDown
  DarkenButton(the clickOn)
end

on mouseUp
  global clickedOnButton
  lightenbutton()
  if clickedOnButton = the clickOn then
    flashHelpButton(0)
    turnOnPopUp()
    puppetTransition(23, 0, 0, 1)
  end if
end
