global gAniList, gAniCastStart, gAniCastStop, gAniChange, gMyNumber, gRandom, gSuggestionTime, gSuggestionDelay, gFirstSuggestion, gLastSuggestion, gSuggestion, gOverCounter, gOverLength, gSoundDelay, gNextSound, gTextList, gTextPosition, gTextDelay, gBlank, gTextTimer, gMyDestination

on startMovie
  set gTextTimer to 0
  set gTextDelay to 60
  set gBlank to 21
  set gTextList to list(13, 20, 14, 14, 20, 15, 16, 17, 8, 20, 20, 18, 20, 13, 20, 14, 14, 20, 15, 16, 17, 8, 20, 20, 7, 20, 20, 19, 20, 20, 9, 20, 20, 10)
  set gTextPosition to 1
  set gAniList to list(6, 8, 7, 9)
  set gAniCastStart to 1
  set gAniCastStop to 4
  set gAniChange to 1
  set gMyNumber to 1
  set gRandom to 75
  set gSuggestion to 12
  set gFirstSuggestion to 20
  set gLastSuggestion to 20
  set gSuggestionDelay to 240
  set gSuggestionTime to the timer + gSuggestionDelay
  set gOverCounter to 0
  set gOverLength to 20
  set gSoundDelay to 60
  set gNextSound to 0
  if stringp(externalParamValue("sw1")) then
    set gMyDestination to externalParamValue("sw1")
  else
    set gMyDestination to "http://www.nike.com"
  end if
  set the keyDownScript to "CheckForExitKey()"
end

on exitFrame
  checkIfOver()
  if (the frame > 1) and (the frame < 20) then
    checkDistance()
    if gSuggestionTime < the timer then
      nextSuggestion()
    end if
    animateDisc()
    expandDisc()
    set gRandom to 2 + (gMyNumber / 4)
    if gRandom < 2 then
      set gRandom to 2
    end if
  end if
  checkFlash()
end

on flyAway
  set gTextPosition to count(gTextList) + 1
  ReturnToWork()
end

on doFinalText
  if (gTextTimer > the timer) or (gTextPosition > count(gTextList)) then
    exit
  else
    set the castNum of sprite gSuggestion to getAt(gTextList, gTextPosition)
    set gTextPosition to gTextPosition + 1
    set gTextTimer to the timer + gTextDelay
  end if
end

on checkIfOver
  if (the mouseH > 0) and (the mouseH < the stageRight) and (the mouseV > 0) and (the mouseV < (the stageBottom - the stageTop)) then
    if the frame > 15 then
      if (gNextSound < the timer) and (gTextPosition < (count(gTextList) + 1)) then
        put gNextSound, the timer
        puppetSound(1, 6)
        set gNextSound to the timer + gSoundDelay
      end if
      doFinalText()
      if the frame < 24 then
        go(20)
      end if
    else
      if gOverCounter < 1 then
        set gOverCounter to the timer + gOverLength
      else
        if (gOverCounter < the timer) and (the frame < 20) then
          puppetSound(1, 6)
          set gNextSound to the timer + gSoundDelay
          set the castNum of sprite gSuggestion to gBlank
          set gTextPosition to 1
          set gTextTimer to the timer + gTextDelay
          go(20)
        end if
      end if
    end if
  else
    set the castNum of sprite gSuggestion to gBlank
    set gOverCounter to 0
    go(2)
  end if
end

on checkFlash
  set myNumber to random(gRandom)
  if the frame > 16 then
    exit
  end if
  if (myNumber = 1) and (the frame < 5) then
    go(10)
  else
    if (myNumber = 2) and (the frame < 5) then
      go(12)
    else
      if the frame < 20 then
        go(2)
      end if
    end if
  end if
end

on nextSuggestion
  set the castNum of sprite gSuggestion to the castNum of sprite gSuggestion + 1
  if the castNum of sprite gSuggestion > gLastSuggestion then
    set the castNum of sprite gSuggestion to gFirstSuggestion
  end if
  set gSuggestionTime to the timer + gSuggestionDelay
end

on expandDisc
  if gMyNumber < 100 then
    discSize(2, 100)
    discSize(3, 100)
    set myfixedNumber to gMyNumber
    if myfixedNumber < 0 then
      set myfixedNumber to 0
    end if
    discSize(4, 100 - myfixedNumber)
  else
    if gMyNumber < 200 then
      discSize(2, 100)
      discSize(4, 1)
      discSize(3, 200 - gMyNumber)
    else
      if gMyNumber < 300 then
        discSize(3, 1)
        discSize(4, 1)
        discSize(2, 300 - gMyNumber)
      else
        discSize(3, 1)
        discSize(4, 1)
        discSize(2, 1)
      end if
    end if
  end if
end

on discSize whichDisc, percentage
  set discHeigth to the height of sprite getAt(gAniList, 1)
  set discWidth to the width of sprite getAt(gAniList, 1)
  set myHeigth to integer(discHeigth * percentage / 100)
  set myWidth to integer(discWidth * percentage / 100)
  set the height of sprite getAt(gAniList, whichDisc) to myHeigth
  set the width of sprite getAt(gAniList, whichDisc) to myWidth
end

on animateDisc
  repeat with x = 1 to count(gAniList)
    set myNumber to getAt(gAniList, x)
    set the castNum of sprite myNumber to the castNum of sprite myNumber + gAniChange
    if the castNum of sprite myNumber > gAniCastStop then
      set the castNum of sprite myNumber to gAniCastStart
    end if
    if the castNum of sprite myNumber < gAniCastStart then
      set the castNum of sprite myNumber to gAniCastStop
    end if
  end repeat
end

on checkDistance
  set myBottom to 600 - the stageBottom
  set myMouse to 600 - the mouseV - the stageBottom
  set gMyNumber to myBottom - myMouse - (the stageBottom - the stageTop)
end

on storeCode
end
