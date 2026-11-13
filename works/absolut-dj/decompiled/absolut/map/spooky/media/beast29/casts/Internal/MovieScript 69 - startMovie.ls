global gSpriteBug1, gNumberOfBugs, gSpriteChoice1, gNumberOfChoices, gSpriteTurn1, gNumberOfTurns, gSpriteCell1, gNumberOfCells, gCellList, gBugDirectionList, gBeatTime, gBeatDelay, gBeatTimer, gNumberOfBeats, gCurrentBrush, gBlankCellCast, gScreenPaintCast1, gMusicCast1, gImportData, gSoundOn, gMyVol

on startMovie
  set gMyVol to the volume of sound 1
  set gSoundOn to 1
  set gNumberOfBugs to 2
  set gNumberOfChoices to 7
  set gNumberOfTurns to 2
  set gNumberOfCells to 64
  set gBlankCellCast to 73
  set gBeatTime to 8
  if the platform contains "Windows" then
    set gBeatDelay to 315
    put "windows"
  else
    set gBeatDelay to 315
  end if
  set gNumberOfBeats to 4
  set gScreenPaintCast1 to 50
  set gMusicCast1 to 37
  set gSpriteBug1 to 100
  set gSpriteChoice1 to 105
  set gSpriteTurn1 to 112
  set gSpriteCell1 to 20
  set gBugDirectionList to list([3, 3], [32, 4])
  if stringp(externalParamValue("sw1")) then
    set gImportData to externalParamValue("sw1")
    importData()
    if getAt(getAt(gBugDirectionList, 1), 1) < 1 then
      set gBugDirectionList to list([3, 3], [32, 4])
    end if
  else
    initcellList()
    set gBugDirectionList to list([3, 3], [32, 4])
  end if
  set gCurrentBrush to 0
  set gBeatTimer to the timer + gBeatDelay - 4
  puppetSound(1, 45)
  set the cursor of sprite 5 to [96, 97]
  set the cursor of sprite 105 to [96, 97]
  set the cursor of sprite 106 to [96, 97]
  set the cursor of sprite 107 to [96, 97]
  set the cursor of sprite 108 to [96, 97]
  set the cursor of sprite 109 to [96, 97]
  set the cursor of sprite 110 to [96, 97]
  set the cursor of sprite 111 to [96, 97]
  set the cursor of sprite 112 to [96, 97]
  set the cursor of sprite 113 to [96, 97]
  set the cursor of sprite 114 to [96, 97]
  set the cursor of sprite 115 to [96, 97]
  set the cursor of sprite 87 to [96, 97]
  set the cursor of sprite 88 to [96, 97]
  set the cursor of sprite 93 to [96, 97]
  set the cursor of sprite 119 to [96, 97]
  set the cursor of sprite 120 to [96, 97]
  set the hilite of member 31 to 0
  set the cursor of sprite 89 to [96, 97]
  set the cursor of sprite 90 to [96, 97]
  set the cursor of sprite 91 to [96, 97]
end

on keyDown
end

on prepareMovie
end

on stopMovie
  set the text of member "to" to EMPTY
  set the textFont of member "to" to "Arial"
  set the text of member "from" to EMPTY
  set the text of member "subject" to EMPTY
  set the text of member "status" to EMPTY
  set the volume of sound 1 to gMyVol
  set the volume of sound 2 to gMyVol
  set the volume of sound 3 to gMyVol
  set the volume of sound 4 to gMyVol
end

on exitFrame
  if gBeatTimer < (the timer - 1) then
    moveBugs()
    set gBeatTimer to gBeatTimer + gBeatDelay
  end if
  if the text of cast "status" = "Sending....." then
    if netDone() = 1 then
      set the text of cast "status" to "Sent"
    end if
  end if
  checkRollOvers()
end

on moveBugs
  repeat with x = 1 to gNumberOfBugs
    set myInfo to getAt(gBugDirectionList, x)
    set myCell to getAt(myInfo, 1)
    set myDirection to getAt(myInfo, 2)
    case myDirection of
      1:
        set myCell to myCell - 8
        if myCell < 1 then
          set myCell to myCell + 64
        end if
      2:
        set myCell to myCell + 1
        if (myCell mod 8) = 1 then
          set myCell to myCell - 8
        end if
      3:
        set myCell to myCell + 8
        if myCell > 64 then
          set myCell to myCell - 64
        end if
      4:
        set myCell to myCell - 1
        if (myCell mod 8) = 0 then
          set myCell to myCell + 8
        end if
    end case
    set the loc of sprite (gSpriteBug1 + x - 1) to the loc of sprite (gSpriteCell1 + myCell - 1)
    set mySound to getAt(gCellList, myCell)
    set mySound2 to mySound
    if mySound2 > 8 then
      set mySound2 to 8
    end if
    if mySound2 then
      puppetSound(3 + x - 1, mySound2 + gMusicCast1 - 2)
    end if
    if mySound > 0 then
      set the castNum of sprite (gSpriteCell1 + myCell - 1) to 73
      updateStage()
      set the castNum of sprite (gSpriteCell1 + myCell - 1) to 83 + mySound - 1
    end if
    if mySound = (gNumberOfChoices + 1) then
      set myDirection to 3
    else
      if mySound = (gNumberOfChoices + 2) then
        set myDirection to 4
      else
        if mySound = (gNumberOfChoices + 3) then
          set myDirection to 2
        else
          if mySound = (gNumberOfChoices + 4) then
            set myDirection to 1
          end if
        end if
      end if
    end if
    setAt(gBugDirectionList, x, list(myCell, myDirection))
  end repeat
end

on clickCell whichSprite
  if getAt(gCellList, whichSprite - gSpriteCell1 + 1) = gCurrentBrush then
    setAt(gCellList, whichSprite - gSpriteCell1 + 1, 0)
    setBlank(whichSprite)
  else
    setAt(gCellList, whichSprite - gSpriteCell1 + 1, gCurrentBrush)
    setPaint(whichSprite)
  end if
end

on setBlank whichSprite
  set the ink of sprite whichSprite to 37
  set the castNum of sprite whichSprite to gBlankCellCast
end

on setPaint whichSprite
  set the ink of sprite whichSprite to 36
  set the castNum of sprite whichSprite to gScreenPaintCast1 + gCurrentBrush - 1
end

on clickPaint whichSprite
  set myPaint to whichSprite - gSpriteChoice1 + 1
  if myPaint = gCurrentBrush then
    nothing()
  else
    set gCurrentBrush to myPaint
    set the castNum of sprite (gSpriteChoice1 + gCurrentBrush - 1) to the castNum of sprite (gSpriteChoice1 + gCurrentBrush - 1) - 1
    checkRollOvers()
  end if
end

on stripquotes whattext
  set returntext to EMPTY
  repeat with x = 1 to the number of chars in whattext
    if (charToNum(char x of whattext) <> 39) and (charToNum(char x of whattext) <> 34) then
      set returntext to returntext & char x of whattext
    end if
  end repeat
  return returntext
end

on doit
  repeat with x = 1 to 127
    put x, numToChar(x)
  end repeat
end

on exportData
  stripquotes(the text of member "to")
  set the text of member "to" to the result
  stripquotes(the text of member "from")
  set the text of member "from" to the result
  stripquotes(the text of member "subject")
  set the text of member "subject" to the result
  set myExportdata to EMPTY
  repeat with x = 1 to gNumberOfCells
    if getAt(gCellList, x) = 10 then
      set myData to "A"
    else
      if getAt(gCellList, x) = 11 then
        set myData to "B"
      else
        set myData to string(getAt(gCellList, x))
      end if
    end if
    set myExportdata to myExportdata & myData
  end repeat
  set cell1 to getAt(getAt(gBugDirectionList, 1), 1)
  set dir1 to getAt(getAt(gBugDirectionList, 1), 2)
  set cell2 to getAt(getAt(gBugDirectionList, 2), 1)
  set dir2 to getAt(getAt(gBugDirectionList, 2), 2)
  if length(string(cell1)) < 2 then
    set cell1 to "0" & cell1
  end if
  if length(string(cell2)) < 2 then
    set cell2 to "0" & cell2
  end if
  set myExportdata to myExportdata & cell1 & dir1 & cell2 & dir2
  put myExportdata, length(myExportdata)
  put cell1, dir1, cell2, dir2
  set strTo to the text of member "to"
  set strFrom to the text of member "from"
  set strSubject to the text of member "subject"
  if (strSubject = EMPTY) or (strSubject = " ") or (strSubject = "  ") then
    set strSubject to "Absolut DJ"
  end if
  set strBody to EMPTY
  set strCGI to "http://www.absolutdj.com/map/spooky/sp_index.asp"
  set strState to myExportdata
  set strLink to strCGI & "?seq=" & strState
  set subjectLen to the number of chars in strSubject
  set i to 0
  repeat while i < subjectLen
    if char i of strSubject = " " then
      put "+" into char i of strSubject
    end if
    set i to i + 1
  end repeat
  set bodyLen to the number of chars in strBody
  set i to 0
  repeat while i < bodyLen
    if char i of strBody = " " then
      put "+" into char i of strBody
    end if
    set i to i + 1
  end repeat
  if the hilite of member 31 = 1 then
    set notify to "true"
  else
    set notify to "false"
  end if
  getNetText("http://www.absolutdj.com/map/spooky/email2.asp?to=" & strTo & "&from=" & strFrom & "&subject=" & strSubject & "&body=" & strBody & "&link=" & strState & "&notify=" & notify)
  set the text of member "to" to EMPTY
  set the text of member "from" to EMPTY
  set the text of member "subject" to EMPTY
  set the text of member "status" to "Sending....."
end

on importData
  set myInfo to gImportData
  initcellList()
  repeat with x = 1 to gNumberOfCells
    set myData to char x of myInfo
    if myData = "A" then
      set myData to 10
    else
      if myData = "B" then
        set myData to 11
      else
        set myData to integer(char x of myInfo)
      end if
    end if
    set gCurrentBrush to myData
    clickCell(x + gSpriteCell1 - 1)
  end repeat
  set cell1 to integer(char 65 to 66 of myInfo * 1)
  set dir1 to integer(char 67 of myInfo * 1)
  set cell2 to integer(char 68 to 69 of myInfo * 1)
  set dir2 to integer(char 70 of myInfo * 1)
  set gBugDirectionList to list([cell1, dir1], [cell2, dir2])
end

on checkRollOvers
  repeat with x = gSpriteChoice1 to gSpriteChoice1 + gNumberOfChoices + 4 - 1
    if (x - gSpriteChoice1 + 1) = gCurrentBrush then
      set myState to 1
    else
      if rollOver(x) then
        set myState to 2
      else
        set myState to 3
      end if
    end if
    set whichone to x - gSpriteChoice1 + 1
    set newCast to 118 + (whichone * 3) - myState
    set the castNum of sprite x to newCast
  end repeat
  if rollOver(15) then
    set the castNum of sprite 89 to 23
  else
    set the castNum of sprite 89 to 22
  end if
  if rollOver(16) then
    set the castNum of sprite 90 to 25
  else
    set the castNum of sprite 90 to 24
  end if
  if rollOver(17) then
    set the castNum of sprite 91 to 27
  else
    set the castNum of sprite 91 to 26
  end if
end

on resetScreen
  repeat with x = gSpriteCell1 to gSpriteCell1 + gNumberOfCells - 1
    set the castNum of sprite x to gBlankCellCast
    set the ink of sprite x to 37
  end repeat
  initcellList()
end

on saveSendData
  go(15)
end

on showHelp
  go(21)
end

on initcellList
  set gCellList to list()
  repeat with x = 1 to gNumberOfCells
    append(gCellList, 0)
  end repeat
end
