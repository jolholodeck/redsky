on mouseDown
  DarkenButton(the clickOn)
end

on mouseUp
  global clickedOnButton, squigglyChannel
  lightenbutton()
  if clickedOnButton = the clickOn then
    puppetSprite(squigglyChannel, 1)
    set h to Hcenter(squigglyChannel)
    set V to Vcenter(squigglyChannel)
    set the castNum of sprite squigglyChannel to the number of member "Helicopter"
    set the locH of sprite squigglyChannel to h + 4
    set the locV of sprite squigglyChannel to V - 160
    turnOFFpopup()
    go("Screen2 to Screen1")
  end if
end
