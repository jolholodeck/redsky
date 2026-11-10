on mouseDown
  DarkenButton(the clickOn)
end

on mouseUp
  global clickedOnButton, screen2built
  lightenbutton()
  if clickedOnButton = the clickOn then
    set screen2built to 1
    turnOFFpopup()
    go("Screen2 fall")
  end if
end
