global gToggleTimer1, gFadeOutTimer1, gToggleTimer2, gFadeOutTimer2, gDirection1, gDirection2, gDotSpr, gLineSpr, gMandalaSpr, gSliceList, gCurrSlice, gNumSlices, gRadius, gLineLength, hCent, vCent, gAngle, gIntroCompleted, gLevel, myDist, gCurrCircle, gFrame1Timer, gFilmSpr, gCoverUpSpr, gDustSpr, gFirstDust, gBkgdSound, gRewardTimer, gExiting

on fluctuateVolume
  if the timer > gFadeOutTimer1 then
    set gDirection1 to -1
    if the volume of sound 3 < 30 then
      set newSound3 to gBkgdSound - 1 + random(3)
      puppetSound(3, newSound3)
      updateStage()
      set gFadeOutTimer1 to the timer + (5 * 60) + random(180)
      set gDirection1 to 1
    end if
  else
    if the timer > gToggleTimer1 then
      set gDirection1 to gDirection1 * -1
      set gToggleTimer1 to the timer + 60 + random(400)
    end if
  end if
  if the volume of sound 3 = 255 then
    set gDirection1 to -1
  end if
  if (the volume of sound 3 < 75) and (the timer < gFadeOutTimer1) then
    set gDirection1 to 1
  end if
  set the volume of sound 3 to the volume of sound 3 + (5 * gDirection1)
  set myEndTime1 to the timer + 1
  repeat while the timer < myEndTime1
    if the mouseDown then
      exit repeat
    end if
  end repeat
  if the timer > gFadeOutTimer2 then
    set gDirection2 to -1
    if the volume of sound 4 < 30 then
      set newSound4 to gBkgdSound - 1 + random(3)
      puppetSound(4, newSound4)
      updateStage()
      set gFadeOutTimer2 to the timer + (5 * 60) + random(180)
      set gDirection2 to 1
    end if
  else
    if the timer > gToggleTimer2 then
      set gDirection2 to gDirection2 * -1
      set gToggleTimer2 to the timer + 60 + random(400)
    end if
  end if
  if the volume of sound 4 = 255 then
    set gDirection2 to -1
  end if
  if (the volume of sound 4 < 75) and (the timer < gFadeOutTimer2) then
    set gDirection2 to 1
  end if
  set the volume of sound 4 to the volume of sound 4 + (5 * gDirection2)
  set myEndTime2 to the timer + 1
  repeat while the timer < myEndTime2
    if the mouseDown then
      exit repeat
    end if
  end repeat
end

on startMovie
  set gExiting to 0
  set the trace to 0
  set gMandalaSpr to 1
  set gFilmSpr to 2
  set gCoverUpSpr to 3
  set gDotSpr to 28
  set gLineSpr to 46
  set gDustSpr to 25
  showSprites()
  puppetSprite(gLineSpr, 1)
  puppetSprite(gDotSpr, 1)
  puppetSprite(gDustSpr, 1)
  set the visible of sprite gCoverUpSpr to 0
  set the visible of sprite gDotSpr to 1
  set the visible of sprite gLineSpr to 0
  updateStage()
  set the volume of sound 1 to 255
  set the volume of sound 2 to 255
  set the volume of sound 3 to 200
  set the volume of sound 4 to 125
  set gFirstDust to the number of member "placeHolder"
  set gSliceList to [1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0, 12: 0, 13: 0, 14: 0, 15: 0, 16: 0, 17: 0, 18: 0]
  set gRadius to 110
  set gLineLength to 110
  set hCent to (the stageRight - the stageLeft) / 2
  set vCent to (the stageBottom - the stageTop) / 2
  set gNumSlices to 18
  set gIntroCompleted to 0
  set the exitLock to 1
  set gBkgdSound to the number of member "main_Idle_Loop"
  puppetSound(3, gBkgdSound)
  puppetSound(4, gBkgdSound + 2)
  set gToggleTimer1 to 2 * 60
  set gFadeOutTimer1 to 5 * 60
  set gToggleTimer2 to 3 * 60
  set gFadeOutTimer2 to 8 * 60
  set gDirection1 to 1
  set gDirection2 to 1
  set gFrame1Timer to 0
  set gRandomAmbient1 to the number of member "idle_loop_2"
  set the keyDownScript to "CheckForExitKey()"
end

on showStates
  repeat with i = 1 to 48
    if the puppet of sprite i = 1 then
      put i && "puppetted"
    end if
  end repeat
  put "the  puppet  of sprite1=" && the puppet of sprite 1
  put "the  visible of sprite1=" && the visible of sprite 1
  put "the  ink of sprite1=" && the ink of sprite 1
  put "the blend of sprite 1=" && the blend of sprite 1
end

on getAngle
  set myV to the mouseV
  set myH to the mouseH
  if (myV - vCent) = 0 then
    if (myH - hCent) > 0 then
      set gAngle to 3 * PI / 2
    else
      set gAngle to PI / 2
    end if
  else
    if (myV - vCent) > 0 then
      set gAngle to atan(float(myH - hCent) / (myV - vCent)) + PI
    else
      set gAngle to atan(float(myH - hCent) / (myV - vCent))
      if gAngle < 0 then
        set gAngle to gAngle + (2 * PI)
      end if
    end if
  end if
  set tempSliceNum to gNumSlices - (integer(gNumSlices * gAngle / (2 * PI)) mod gNumSlices)
  if tempSliceNum = 18 then
    set gCurrSlice to 1
  else
    set gCurrSlice to tempSliceNum + 1
  end if
  setaProp(gSliceList, gCurrSlice, 1)
  set myDist to sqrt(((myH - hCent) * (myH - hCent)) + ((myV - vCent) * (myV - vCent)))
  set the locH of sprite gDotSpr to hCent - (gRadius * sin(gAngle))
  set the locV of sprite gDotSpr to vCent - (gRadius * cos(gAngle))
  if myDist > 135 then
    exit
  end if
  set mouseState to 0
  set mytempCir to gCurrCircle
  repeat while the stillDown
    set mouseState to 1
    set myV to the mouseV
    set myH to the mouseH
    if (myV - vCent) = 0 then
      if (myH - hCent) > 0 then
        set gAngle to 3 * PI / 2
      else
        set gAngle to PI / 2
      end if
    else
      if (myV - vCent) > 0 then
        set gAngle to atan(float(myH - hCent) / (myV - vCent)) + PI
      else
        set gAngle to atan(float(myH - hCent) / (myV - vCent))
        if gAngle < 0 then
          set gAngle to gAngle + (2 * PI)
        end if
      end if
    end if
    set gRadius to sqrt(((myH - hCent) * (myH - hCent)) + ((myV - vCent) * (myV - vCent)))
    if myDist > 47 then
      case gLevel of
        "1":
          set gRadius to 118
        "2":
          if gRadius < 85 then
            set gRadius to 85
          end if
        "3":
          if gRadius < 68 then
            set gRadius to 68
          end if
        "4":
          if gRadius < 47 then
            set gRadius to 47
          end if
      end case
    else
      case gCurrCircle of
        "1":
          set gRadius to 118
        "2":
          set gRadius to 85
        "3":
          set gRadius to 68
        "4":
          set gRadius to 47
      end case
    end if
    setCurrCircle()
    if gRadius > gLineLength then
      set gRadius to gLineLength
    end if
    set the locH of sprite gDotSpr to hCent - (gRadius * sin(gAngle))
    set the locV of sprite gDotSpr to vCent - (gRadius * cos(gAngle))
    updateStage()
  end repeat
  if mouseState = 1 then
    set mouseState to 0
    if myDist > 47 then
      puppetSprite(gMandalaSpr, 1)
    end if
    if gLevel = 4 then
      set the memberNum of sprite gMandalaSpr to the number of member "mandala4"
    end if
    if mytempCir <> gCurrCircle then
      puppetSprite(gFilmSpr, 1)
      set gSliceList to [1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0, 12: 0, 13: 0, 14: 0, 15: 0, 16: 0, 17: 0, 18: 0]
      hideSprites()
    end if
    if gCurrCircle <> 3 then
      set the memberNum of sprite gDustSpr to the number of member gFirstDust
    end if
    if (the frame > label("blend out")) and (myDist < 47) then
      exit
    else
      if gLevel = 4 then
        set the visible of sprite gCoverUpSpr to 1
      end if
      if gRadius > 97 then
        set gRadius to 118
        set the visible of sprite gDustSpr to 0
        go(label("Circle1Play") + 1)
      else
        if gRadius > 77 then
          set gRadius to 85
          set the visible of sprite gDustSpr to 0
          go(label("Circle2Play") + 1)
        else
          if gRadius > 65 then
            set gRadius to 68
            set the visible of sprite gDustSpr to 1
            go(label("Circle3Play") + 1)
          else
            set gRadius to 53
            set the visible of sprite gDustSpr to 0
            go(label("Circle4Play") + 1)
            set gRewardTimer to the timer + (30 * 60)
          end if
        end if
      end if
    end if
  end if
end

on setCurrCircle
  if gRadius > 97 then
    set gCurrCircle to 1
  else
    if gRadius > 77 then
      set gCurrCircle to 2
    else
      if gRadius > 65 then
        set gCurrCircle to 3
      else
        set gCurrCircle to 4
      end if
    end if
  end if
end

on checkroll start, stop
  global rolltest, gFrame
  set rolltest to 0
  if myDist < 47 then
    set the visible of sprite 26 to 1
  else
    set the visible of sprite 26 to 0
  end if
  repeat with i = 1 to 18
    if the mouseDown then
      exit repeat
    end if
    if gCurrSlice = i then
      set rolltest to 1
      set the visible of sprite (i + 3) to 1
      case gCurrCircle of
        "1":
          set the memberNum of sprite gFilmSpr to the number of member (gCurrCircle & "." & gCurrSlice)
        "2":
          set myName to gCurrCircle & "." & ((gCurrSlice - 1) / 2) + 1
          set the memberNum of sprite gFilmSpr to the number of member myName
        "3":
          set myName to gCurrCircle & "." & ((gCurrSlice - 1) * 10 / 45) + 1
          set the memberNum of sprite gFilmSpr to the number of member myName
          case gCurrSlice of
            "1":
              set the memberNum of sprite gDustSpr to gFirstDust
            "2":
              set the memberNum of sprite gDustSpr to gFirstDust + 1
            "3":
              set the memberNum of sprite gDustSpr to gFirstDust + 2
            "4":
              set the memberNum of sprite gDustSpr to gFirstDust + 3
            "5":
              set the memberNum of sprite gDustSpr to gFirstDust
            "6":
              set the memberNum of sprite gDustSpr to gFirstDust + 8
            "7":
              set the memberNum of sprite gDustSpr to gFirstDust + 9
            "8":
              set the memberNum of sprite gDustSpr to gFirstDust + 10
            "9":
              set the memberNum of sprite gDustSpr to gFirstDust + 11
            "10":
              set the memberNum of sprite gDustSpr to gFirstDust
            "11":
              set the memberNum of sprite gDustSpr to gFirstDust + 4
            "12":
              set the memberNum of sprite gDustSpr to gFirstDust + 5
            "13":
              set the memberNum of sprite gDustSpr to gFirstDust + 6
            "14":
              set the memberNum of sprite gDustSpr to gFirstDust + 7
            "15":
              set the memberNum of sprite gDustSpr to gFirstDust
            "16":
              set the memberNum of sprite gDustSpr to gFirstDust + 12
            "17":
              set the memberNum of sprite gDustSpr to gFirstDust + 13
            "18":
              set the memberNum of sprite gDustSpr to gFirstDust + 14
          end case
          updateStage()
        "4":
          set the memberNum of sprite gFilmSpr to the number of member (gCurrCircle & "." & gCurrSlice)
      end case
      updateStage()
      exit
    end if
  end repeat
  if rolltest = 0 then
    puppetSound(0)
  end if
end

on idle
  if gExiting then
    exit
  end if
  fluctuateVolume()
end

on checkLoopCompletion
  global gCurrCircle, gSlicesCompleted
  if gLevel = gCurrCircle then
    if gIntroCompleted = 0 then
      set gSlicesCompleted to 0
      repeat with i = 1 to 18
        set gSlicesCompleted to gSlicesCompleted + getAt(gSliceList, i)
      end repeat
      if (gSlicesCompleted > 17) and (gLevel < 4) then
        showSprites()
        puppetSprite(gMandalaSpr, 0)
        go(marker(2))
        set gSliceList to [1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0, 12: 0, 13: 0, 14: 0, 15: 0, 16: 0, 17: 0, 18: 0]
      end if
    end if
  end if
end

on hideSprites
  repeat with i = 4 to 21
    set the visible of sprite i to 0
  end repeat
  updateStage()
end

on showSprites
  repeat with i = 4 to 21
    set the visible of sprite i to 1
  end repeat
  updateStage()
end

on dragLine
  if (the mouseH >= hCent) and (the mouseV <= vCent) then
    set the memberNum of sprite gLineSpr to the number of member "line1"
  else
    if (the mouseH <= hCent) and (the mouseV >= vCent) then
      set the memberNum of sprite gLineSpr to the number of member "line1"
    else
      if (the mouseH < hCent) and (the mouseV < vCent) then
        set the memberNum of sprite gLineSpr to the number of member "line2"
      else
        if (the mouseH > hCent) and (the mouseV > vCent) then
          set the memberNum of sprite gLineSpr to the number of member "line2"
        end if
      end if
    end if
  end if
  if (the mouseH = hCent) and (the mouseV < vCent) then
    set the rect of sprite gLineSpr to rect(159, 20, 161, 130)
  else
    if (the mouseH = hCent) and (the mouseV > vCent) then
      set the rect of sprite gLineSpr to rect(159, 130, 161, 240)
    else
      if (the mouseV = vCent) and (the mouseH < hCent) then
        set the rect of sprite gLineSpr to rect(50, 129, 160, 131)
      else
        if (the mouseV = vCent) and (the mouseH > hCent) then
          set the rect of sprite gLineSpr to rect(160, 129, 270, 131)
        else
          set myLineH to hCent - (gLineLength * sin(gAngle))
          set myLineV to vCent - (gLineLength * cos(gAngle))
          set the rect of sprite gLineSpr to rect(hCent, myLineV, myLineH, vCent)
        end if
      end if
    end if
  end if
end
