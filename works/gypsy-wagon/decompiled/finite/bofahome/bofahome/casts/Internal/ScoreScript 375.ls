on mouseDown
  DarkenButton(the clickOn)
end

on mouseUp
  global clickedOnButton
  lightenbutton()
  if clickedOnButton = the clickOn then
    puppetSound("intro")
    go(3)
  end if
end
