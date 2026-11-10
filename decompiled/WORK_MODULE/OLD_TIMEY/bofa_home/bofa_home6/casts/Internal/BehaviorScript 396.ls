on mouseDown
  DarkenButton(the clickOn)
end

on mouseUp
  global clickedOnButton, squigglyChannel, screen2built
  lightenbutton()
  if clickedOnButton = the clickOn then
    puppetSprite(squigglyChannel, 1)
    set h to Hcenter(squigglyChannel)
    set V to Vcenter(squigglyChannel)
    set the castNum of sprite squigglyChannel to the number of member "squigJumpingDown"
    set the locH of sprite squigglyChannel to h + 76
    set the locV of sprite squigglyChannel to V - 6
    turnOFFpopup()
    if screen2built then
      go("Screen1 to Screen2")
    else
      go("Screen1 to Screen2 build")
    end if
  end if
end
