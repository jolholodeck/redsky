on mouseDown
  DarkenButton(the clickOn)
end

on mouseUp
  global clickedOnButton
  lightenbutton()
  if clickedOnButton = the clickOn then
    setpuppets(0)
    updateStage()
    turnOFFpopup()
    go("close")
  end if
end
