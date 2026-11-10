global gMothCastList, gMothcastOffset, gMothTypeList, gfirstFireSprite, gLastFireSprite, gMothMoveNumberList, gNumberInBottle, gMothDistance, gFirstMothSprite, gTotalMoths, gFireStates, gActionState, gBottleDive, gBottleList, gMothMoveList, gMothDirectionList, gFireDirectionList, gOldMouseH, gOldMouseV, gNewGlow, gGlowList

on startMovie
  set gGlowList to list(76, 80, 84, 88, 92, 96, 100, 96, 92, 88, 84, 80, 76, 72, 68, 72)
  set gMothCastList to list([300, 302, 304, 301], [318, 321, 322, 320, 319], [335, 338, 339, 337, 336], [351, 354, 355, 354, 353, 352])
  set oldMouseH to 0
  set oldMouseV to 0
  set gMothcastOffset to 10
  set gfirstFireSprite to 40
  set gLastFireSprite to 47
  set gMothDistance to 8
  set gMothTypeList to list(2, 4, 1, 3, 2, 1, 4, 3, 1, 2, 3, 4, 4, 3, 2, 1)
  set gMothMoveNumberList to list(1, 2, 1, 2, 1, 2, 1, 2, 1, 1, 1, 1, 2, 2, 2, 2)
  set gMothDirectionList to list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
  set gFireDirectionList to list(2, 4, 6, 8, 1, 3, 5, 7)
  set gFirstMothSprite to 50
  set gTotalMoths to 5
  set gFireStates to list(0, 0, 0, 0, 0, 0, 0, 0)
  set gActionState to 1
  set gNumberInBottle to 0
  set gBottleDive to 0
  set gMothMoveList to list(point(0, 1), point(0, -1), point(0, 2), point(0, -2), point(1, 2), point(-1, -2), point(2, 2), point(-2, 2), point(1, -2), point(-1, 2), point(-1, 1), point(1, -1), point(1, 0), point(-1, 0), point(2, 0), point(-2, 0), point(2, 1), point(2, -1), point(2, -2), point(-2, 1), point(-2, -1), point(-1, 1), point(-2, -2))
  set gBottleList to list(4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65)
  set the keyDownScript to "checkForExitKey()"
end

on lotsOfBugs
  if the castNum of sprite 11 < 129 then
    set the castNum of sprite 11 to 129
    repeat with x = 12 to 19
      set the castNum of sprite x to 1
    end repeat
  else
    set the castNum of sprite 11 to the castNum of sprite 11 + 1
  end if
  if (the castNum of sprite 11 > 169) and (gActionState < 4) then
    set gActionState to 4
    set the blend of sprite 24 to 20
    updateStage()
    set the castNum of sprite 24 to 209
    repeat with x = 11 to 20
      set the castNum of sprite x to 1
    end repeat
    repeat with x = gfirstFireSprite to gLastFireSprite
      set the castNum of sprite x to 1
    end repeat
  end if
end

on bottleEntry
  set the castNum of sprite 11 to getAt(gBottleList, gBottleDive)
  set gBottleDive to gBottleDive + 1
  if gBottleDive > count(gBottleList) then
    set the castNum of sprite 11 to 1
    set gBottleDive to 0
  end if
  if (gBottleDive > 5) and (gActionState = 3) then
    set the castNum of sprite 11 to 1
    set gBottleDive to 0
  end if
end

on checkFire
  if gActionState > 2 then
    exit
  end if
  repeat with x = 1 to 8
    set myState to getAt(gFireStates, x)
    if myState = 2 then
      fireRun(x)
    end if
    if (myState = 1) and (random(5) = 1) then
      setAt(gFireStates, x, 0)
    end if
    if (myState = 4) and (random(3) = 1) then
      setAt(gFireStates, x, 3)
    end if
    if (myState = 3) and (random(30) = 1) then
      setAt(gFireStates, x, 4)
    end if
    if (myState = 0) and (random(20) = 1) then
      setAt(gFireStates, x, 1)
    end if
    if sprite (gfirstFireSprite + x - 1) intersects 21 and (myState = 2) then
      divebottle(x)
    end if
    set fireSprite to 12 + x - 1
    if getAt(gFireStates, x) < 3 then
      set the castNum of sprite (gfirstFireSprite + x - 1) to getAt(gFireStates, x) + 288
      next repeat
    end if
    if getAt(gFireStates, x) = 3 then
      set the castNum of sprite (gfirstFireSprite + x - 1) to 1
      set the castNum of sprite fireSprite to 1
      next repeat
    end if
    if (getAt(gFireStates, x) = 4) and (the castNum of sprite fireSprite = 1) then
      set the castNum of sprite (gfirstFireSprite + x - 1) to 1
      set the castNum of sprite fireSprite to random(40) + 5
      next repeat
    end if
    if (getAt(gFireStates, x) = 4) and (the castNum of sprite fireSprite > 1) then
      set the castNum of sprite (gfirstFireSprite + x - 1) to 1
      set the castNum of sprite fireSprite to the castNum of sprite fireSprite + 1
    end if
  end repeat
end

on checkSound
  if soundBusy(2) then
    exit
  end if
  if gActionState = 5 then
    set the volume of sound 2 to 256
  end if
  set isSound to random(50)
  if isSound = 1 then
    set mySound to random(9) + 225
    if (mySound = 230) and (gActionState < 5) then
      set mySound to 229
    end if
    if (mySound = 234) and (gActionState < 5) then
      set mySound to 233
    end if
    puppetSound(2, mySound)
  end if
end

on moveFire
  if gActionState < 3 then
    repeat with x = gfirstFireSprite to gLastFireSprite
      set thisFly to x - gfirstFireSprite + 1
      if random(15) = 1 then
        set myDirection to random(count(gMothMoveList))
        setAt(gFireDirectionList, thisFly, myDirection)
      else
        set myDirection to getAt(gFireDirectionList, thisFly)
      end if
      set myTravel to getAt(gMothMoveList, myDirection) * random(2)
      set the loc of sprite x to the loc of sprite x + point(random(13) - 7, random(11) - 6)
      if the locH of sprite x > 560 then
        if random(3) = 1 then
          set the locH of sprite x to the locH of sprite x - 15
        end if
      end if
      if the locH of sprite x < 0 then
        if random(3) = 1 then
          set the locH of sprite x to the locH of sprite x + 15
        end if
      end if
      if the locV of sprite x > 350 then
        if random(2) = 1 then
          set the locV of sprite x to the locV of sprite x - 15
        end if
      end if
      if the locV of sprite x < 0 then
        if random(3) = 1 then
          set the locV of sprite x to the locV of sprite x + 15
        end if
      end if
      set the loc of sprite x to the loc of sprite x + myTravel
    end repeat
  end if
end

on divebottle whichFly
  setAt(gFireStates, whichFly, 3)
  set mySprite to gfirstFireSprite + whichFly - 1
  set myMoveH to 279 - the locH of sprite mySprite
  set myMoveV to 76 - the locV of sprite mySprite
  repeat with x = 1 to 4
    moveToBottle(mySprite, myMoveH, myMoveV)
  end repeat
  set gBottleDive to 1
  set gNumberInBottle to gNumberInBottle + 1
  if gNumberInBottle = 8 then
    set gActionState to 3
  end if
end

on moveToBottle whichSprite, whatMoveH, whatMoveV
  set the locH of sprite whichSprite to the locH of sprite whichSprite + (whatMoveH / 4)
  set the locV of sprite whichSprite to the locV of sprite whichSprite + (whatMoveV / 4)
  updateStage()
end

on fireRun whichFireFly
  set mySprite to whichFireFly + gfirstFireSprite - 1
  set mydistance to the loc of sprite mySprite - point(the mouseH, the mouseV)
  if abs(mydistance) > 20 then
    exit
  end if
  set the loc of sprite mySprite to the loc of sprite mySprite - (mydistance / 2) + point(random(5) - 3, random(5) - 3)
end

on shakeBottle
  if gActionState > 4 then
    exit
  end if
  set newH to the mouseH
  set newV to the mouseV
  if (abs(newH - gOldMouseH) + abs(newV - gOldMouseV)) > 10 then
    if not soundBusy(2) and (random(10) = 1) then
      set mySound to 72 + random(2)
      puppetSound(2, mySound)
    end if
    set myLight to 2
  else
    set myLight to -2
  end if
  set the blend of sprite 24 to the blend of sprite 24 + myLight
  if the blend of sprite 24 < 10 then
    set the blend of sprite 24 to 10
  end if
  if the blend of sprite 24 > 95 then
    set the blend of sprite 24 to 100
    set the castNum of sprite 20 to 223
    set gNewGlow to 1
    sound stop 2
    puppetSound(2, 230)
    set gActionState to 5
    set the blend of sprite 26 to 1
    set the castNum of sprite 26 to 285
    set the castNum of sprite 25 to 214
  end if
  set gOldMouseH to newH
  set gOldMouseV to newV
  if gActionState < 5 then
    if the castNum of sprite 11 < 129 then
      set the castNum of sprite 11 to 129
    else
      set the castNum of sprite 11 to the castNum of sprite 11 + 1
    end if
    if the castNum of sprite 11 > 169 then
      set the castNum of sprite 11 to 129
    end if
  end if
end

on glowBottle
  set the blend of sprite 24 to getAt(gGlowList, gNewGlow)
  set gNewGlow to gNewGlow + 1
  if gNewGlow > count(gGlowList) then
    set gNewGlow to 1
  end if
end

on moveMoth whichMoth
  if gActionState < 4 then
    exit
  end if
  set myFace to 0
  set myH to random(gMothDistance) - (gMothDistance / 2)
  set myV to random(gMothDistance) - (gMothDistance / 2)
  set mySprite to gFirstMothSprite + whichMoth - 1
  if random(15) = 1 then
    set myDirection to random(count(gMothMoveList))
    setAt(gMothDirectionList, whichMoth, myDirection)
  else
    set myDirection to getAt(gMothDirectionList, whichMoth)
  end if
  set myTravel to getAt(gMothMoveList, myDirection) * random(2)
  if (the locH of sprite mySprite > 202) and (the locH of sprite mySprite < 305) then
    if the locH of sprite mySprite > 283 then
      set myH to 2 + (4 * (5 - gActionState)) + 1
    else
      set myH to -2 - (4 * (5 - gActionState)) - 1
    end if
  end if
  if the locH of sprite mySprite > 300 then
    set myH to myH - 1
  end if
  if the locH of sprite mySprite < 225 then
    set myH to myH + 1
  end if
  if the locV of sprite mySprite > 231 then
    set myV to myV - 4
  end if
  if the locV of sprite mySprite < -10 then
    set myV to myV + 1
  end if
  if myH > 0 then
    set myFace to 10
  end if
  set currH to the locH of sprite mySprite
  set currV to the locV of sprite mySprite
  set myList to getAt(gMothCastList, getAt(gMothTypeList, whichMoth))
  set myCurrMoveNum to getAt(gMothMoveNumberList, whichMoth)
  set myNewCast to getAt(myList, myCurrMoveNum) + myFace
  set the castNum of sprite mySprite to myNewCast
  set the loc of sprite mySprite to the loc of sprite mySprite + point(myH, myV)
  set the loc of sprite mySprite to the loc of sprite mySprite + myTravel
  set myCurrMoveNum to myCurrMoveNum + 1
  if myCurrMoveNum > count(myList) then
    set myCurrMoveNum to 1
  end if
  setAt(gMothMoveNumberList, whichMoth, myCurrMoveNum)
  lightMoth(whichMoth)
end

on lightMoth whichMoth
  set whichSprite to gFirstMothSprite + whichMoth - 1
  if the locH of sprite whichSprite < 210 then
    set myBlend to (the locH of sprite whichSprite / 3) + 30
    if myBlend > 100 then
      set myBlend to 100
    end if
    if myBlend < 5 then
      set myBlend to 5
    end if
    set the blend of sprite whichSprite to myBlend
  else
    if the locH of sprite whichSprite > 300 then
      set myBlend to ((559 - the locH of sprite whichSprite) / 4) + 40
      if myBlend > 100 then
        set myBlend to 100
      end if
      if myBlend < 20 then
        set myBlend to 20
      end if
      set the blend of sprite whichSprite to myBlend
    end if
  end if
end

on resetreg fromSprite, tosprite
  repeat with x = fromSprite to tosprite
    set the regPoint of member x to point(0, 0)
  end repeat
end
