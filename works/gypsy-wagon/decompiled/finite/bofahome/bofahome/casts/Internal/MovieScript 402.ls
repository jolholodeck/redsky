global firstButtonchannel, lastButtonchannel, buttonAnimChannel, firstButtonAnimCast, firstHilightCast, textChannel, firsttextCast, buttonHilightChannel, nilanimcast, niltextcast, firstScreenShotCast, headerTextChannel, firstHeaderCast, currentbutton, newbutton, currentPosition, destinationArray, screenShotChannel, screenTextChannel, squigglyChannel, popUpChannel, popUpOn, charOffset, screen2built, oldMouseH, oldMouseV, helpFlashing, helpButtonCH, buttonDarkenCh, clickedOnButton

on initglobals
  set headerTextChannel to 13
  set screenShotChannel to 23
  set screenTextChannel to 24
  set buttonHilightChannel to 25
  set buttonAnimChannel to 26
  set textChannel to 12
  set squigglyChannel to 43
  set popUpChannel to 45
  set screen2built to 0
  set helpFlashing to 0
  set helpButtonCH to 21
  set buttonDarkenCh to 48
  puppetSprite(buttonDarkenCh, 1)
  startTimer()
end

on setpuppets trueORfalse
  puppetSprite(headerTextChannel, trueORfalse)
  puppetSprite(buttonAnimChannel, trueORfalse)
  puppetSprite(buttonHilightChannel, trueORfalse)
  puppetSprite(screenShotChannel, trueORfalse)
  puppetSprite(screenTextChannel, trueORfalse)
  puppetSprite(textChannel, trueORfalse)
  puppetSprite(popUpChannel, trueORfalse)
  puppetSprite(popUpChannel - 1, trueORfalse)
  puppetSprite(helpButtonCH, trueORfalse)
end

on initScreen1
  setpuppets(0)
  updateStage()
  setpuppets(1)
  set popUpOn to 0
  turnOFFpopup()
  set firstButtonchannel to 15
  set lastButtonchannel to 21
  set currentbutton to 0
  set currentPosition to "D"
  setDestinationArray1()
  set firstButtonAnimCast to the number of member "No Button Anim1"
  set firstHilightCast to the number of member "No Button Hilight1"
  set firstScreenShotCast to the number of member "No Screen Shot1"
  set firsttextCast to the number of member "No Text1"
  set firstHeaderCast to the number of member "No Header Text1"
  set currentbutton to 0
  set oldMouseH to the mouseH
  set oldMouseV to the mouseV
  startTimer()
  flashHelpButton(0)
end

on initScreen2
  setpuppets(1)
  set firstButtonchannel to 18
  set lastButtonchannel to 21
  set popUpOn to 0
  turnOFFpopup()
  set currentbutton to 0
  set currentPosition to "K"
  setDestinationArray2()
  set firstButtonAnimCast to the number of member "No Button Anim2"
  set firstHilightCast to the number of member "No Button Hilight2"
  set firstScreenShotCast to the number of member "No Screen Shot2"
  set firsttextCast to the number of member "No Text2"
  set firstHeaderCast to the number of member "No Header Text2"
  set oldMouseH to the mouseH
  set oldMouseV to the mouseV
  startTimer()
  flashHelpButton(0)
end

on setDestinationArray1
  set destinationArray to [["A", "A", "C", "B", "B", "C", "C", "A"], ["B", "A", "D", "B", "D", "D", "D", "B"], ["C", "A", "E", "C", "D", "E", "D", "C"], ["D", "C", "E", "C", "D", "E", "D", "D"], ["D", "C", "F", "C", "D", "G", "D", "D"], ["E", "E", "F", "E", "E", "E", "E", "E"], ["E", "E", "E", "E", "E", "G", "E", "E"]]
  set charOffset to 64
end

on setDestinationArray2
  set destinationArray to [["J", "J", "K", "K", "J"], ["K", "J", "K", "L", "K"], ["L", "K", "K", "L", "L"]]
  set charOffset to 73
end

on checkRollover
  if not popUpOn then
    set newbutton to 0
    repeat with button = 1 to lastButtonchannel - firstButtonchannel + 1
      if rollOver(button + firstButtonchannel - 1) then
        set newbutton to button
      end if
    end repeat
    if newbutton <> currentbutton then
      changeButton()
    end if
  end if
end

on checkforIdle
  if not popUpOn then
    if not helpFlashing then
      if the timer > (6 * 60) then
        flashHelpButton(1)
      end if
      if (the mouseH <> oldMouseH) or (the mouseV <> oldMouseV) then
        startTimer()
        set oldMouseH to the mouseH
        set oldMouseV to the mouseV
      end if
    else
      if (the mouseH <> oldMouseH) or (the mouseV <> oldMouseV) then
        startTimer()
        flashHelpButton(0)
      end if
    end if
  end if
  if not soundBusy(1) then
    puppetSound("bobby-KEEP NAME!")
  end if
end

on flashHelpButton trueORfalse
  set helpFlashing to trueORfalse
  puppetSprite(helpButtonCH, trueORfalse)
  set the castNum of sprite helpButtonCH to the number of member "help button" + trueORfalse
end

on goNewSegment stopped
  set n to charToNum(currentPosition) - charOffset
  set dest to getAt(getAt(destinationArray, n), currentbutton + 1)
  if currentPosition = dest then
    if stopped then
      nothing()
    else
      go("into" & currentPosition)
    end if
  else
    if stopped then
      go("outof" & currentPosition)
    else
      set newLabel to currentPosition & "to" & dest
      set currentPosition to dest
      go(newLabel)
    end if
  end if
end

on calcDestination
  set n to charToNum(currentPosition) - charOffset
  return getAt(getAt(destinationArray, n), currentbutton + 1)
end

on changeButton
  set currentbutton to newbutton
  set the castNum of sprite buttonAnimChannel to firstButtonAnimCast + currentbutton
  set the locH of sprite buttonAnimChannel to Hcenter(currentbutton + firstButtonchannel - 1)
  set the locV of sprite buttonAnimChannel to Vcenter(currentbutton + firstButtonchannel - 1)
  set the castNum of sprite buttonHilightChannel to firstHilightCast + currentbutton
  set the locH of sprite buttonHilightChannel to the locH of sprite (currentbutton + firstButtonchannel - 1)
  set the locV of sprite buttonHilightChannel to the locV of sprite (currentbutton + firstButtonchannel - 1)
  set the castNum of sprite textChannel to firsttextCast + currentbutton
  set the castNum of sprite headerTextChannel to firstHeaderCast + currentbutton
  set the castNum of sprite screenTextChannel to firstScreenShotCast + currentbutton
  if the name of cast the castNum of sprite screenTextChannel contains "No" then
    set the castNum of sprite screenShotChannel to the number of member "dark screen"
  else
    set the castNum of sprite screenShotChannel to the number of member "screen"
  end if
end

on turnOnPopUp
  set the foreColor of sprite (popUpChannel - 1) to 255
  set the locH of sprite (popUpChannel - 1) to 1
  set the castNum of sprite popUpChannel to the number of member "popUp800"
  set popUpOn to 1
  set currentbutton to lastButtonchannel - firstButtonchannel
  startTimer()
end

on turnOFFpopup
  set the foreColor of sprite (popUpChannel - 1) to 0
  set the locH of sprite (popUpChannel - 1) to -1000
  set the castNum of sprite popUpChannel to the number of member "nil"
  set popUpOn to 0
  startTimer()
end

on DarkenButton ch
  global buttonDarkenCh
  spriteBox(buttonDarkenCh, the left of sprite ch, the top of sprite ch, the right of sprite ch - 1, the bottom of sprite ch)
  set clickedOnButton to ch
end

on lightenbutton channel
  global buttonDarkenCh
  put "lighten"
  set the locH of sprite buttonDarkenCh to -1000
end

on Hcenter chan
  return (the left of sprite chan + the right of sprite chan) / 2
end

on Vcenter chan
  return (the top of sprite chan + the bottom of sprite chan) / 2
end

on turnoffPuppets
  repeat with L = 1 to 47
    puppetSprite(L, 0)
  end repeat
  updateStage()
end

on alignreg start, end
  repeat with c = start to end
    set the regPoint of cast c to the regPoint of cast start
  end repeat
end
