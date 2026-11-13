global gHeadSoundLength, gHeadMovementStep, gSpriteHead, gHeadMin, gHeadMax, gCastFirstHeadSound, gTempList, gHeadPlayLocList, gHeadPlayNoteList, gCurrentNote, gCastFirstNote, gSpriteFirstYear, gCurrentYear, gMyYear, gStartVol

on startMovie
  set the cursor of sprite 22 to [10, 11]
  set the cursor of sprite 23 to [10, 11]
  set the cursor of sprite 24 to [10, 11]
  set the cursor of sprite 25 to [10, 11]
  set the cursor of sprite 26 to [10, 11]
  set the cursor of sprite 27 to [10, 11]
  set the cursor of sprite 28 to [10, 11]
  set the cursor of sprite 29 to [10, 11]
  set the cursor of sprite 30 to [10, 11]
  set the cursor of sprite 31 to [10, 11]
  set the cursor of sprite 32 to [10, 11]
  set the cursor of sprite 118 to [10, 11]
  initGlobals()
  playNote()
end

on stopMovie
  repeat with x = 1 to 6
    set the volume of sound x to gStartVol
  end repeat
end

on initGlobals
  set gTempList to list()
  set gStartVol to the volume of sound 1
  set gHeadMovementStep to 2
  set gHeadMin to 1
  set gHeadMax to 578
  set gCurrentNote to 1
  set gCurrentYear to 0
  set gMyYear to 0
  set gHeadPlayLocList to list(3, 20, 26, 31, 39, 45, 49, 55, 62, 103, 107, 113, 131, 134, 152, 160, 168, 187, 193, 200, 216, 221, 256, 262, 269, 274, 280, 286, 292, 329, 334, 339, 344, 349, 353, 360, 366, 402, 407, 415, 421, 427, 433, 468, 474, 481, 487, 493, 497, 506, 513, 545, 549, 555, 600)
  set gHeadPlayNoteList to list(1, 3, 4, 3, 2, 3, 5, 6, 1, 5, 6, 1, 11, 1, 6, 7, 1, 10, 7, 1, 11, 1, 4, 6, 9, 4, 3, 5, 1, 6, 3, 3, 5, 3, 11, 12, 1, 8, 3, 7, 5, 8, 1, 8, 6, 9, 7, 2, 9, 11, 1, 4, 6, 1, 1, 1)
  set gCastFirstNote to 17
  set gSpriteHead to 113
  set gSpriteFirstYear to 102
end

on exitFrame
  checkHighLight()
  checkYearHighLight()
  moveYear()
  moveHead()
  playHeadSound()
end

on checkYearHighLight
  repeat with x = 82 to 92
    set the castNum of sprite (x - 20) to 43
    if sprite gSpriteHead intersects x then
      set the castNum of sprite (x - 20) to 131 + x - 79
    end if
  end repeat
end

on moveYear
  set foundOne to 0
  repeat with x = gSpriteFirstYear to gSpriteFirstYear + 9
    if rollOver(x) and (gMyYear <> x) then
      set gMyYear to x
      set the foreColor of sprite x to 16
      puppetSound(2, 12 + random(3) - 1)
      if (x - gSpriteFirstYear + 1) <> gCurrentYear then
        set foundOne to 1
        set gCurrentYear to x - gSpriteFirstYear + 1
        go(label(0) + ((x - gSpriteFirstYear + 1) * 5) + 6)
        put x
        put label(0) + ((x - gSpriteFirstYear + 1) * 5) + 6
      end if
      next repeat
    end if
    if gMyYear <> x then
      set the foreColor of sprite x to 0
    end if
  end repeat
end

on playNote
  set myNote to getAt(gHeadPlayNoteList, gCurrentNote)
  puppetSound(1, myNote + gCastFirstNote - 1)
end

on stopHeadSound
end

on moveHead
  set the locH of sprite gSpriteHead to the locH of sprite gSpriteHead + gHeadMovementStep
  if the locH of sprite gSpriteHead > gHeadMax then
    set the locH of sprite gSpriteHead to gHeadMin
    set gCurrentNote to 1
  end if
end

on playHeadSound
  set myLoc to the locH of sprite gSpriteHead
  set nextNote to getAt(gHeadPlayLocList, gCurrentNote + 1)
  if myLoc >= (nextNote - 5) then
    set gCurrentNote to gCurrentNote + 1
    playNote()
  end if
end

on checkHighLight
  set myArea to integer(the mouseH / 58) + 1
  repeat with x = 22 to 32
    set the castNum of sprite x to 43
    if rollOver(60 + x) then
      set the castNum of sprite x to 44
    end if
  end repeat
end

on soundWavePosition
  append(gTempList, the mouseH)
  put gTempList
end
