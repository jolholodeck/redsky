global gPlayMouseSounds, gBallBounceDelay, gBallBounceLast, gLastFootSoundPosition, gCrntCourtSide, gOutOfBounds, gSqueakSounds, gTennisFeetSounds, gNumAnimationsRunning, gRoleCallDelay, gRoleCallCount, gMetronome, gCrntMode, gFlashingAgassi, gFlashingPenny, gFlashingFace, gFlashingAir, gFlashingExit, gFootPrintsOn, gFootPrintList1, gNumFootPrintLists1, gFootPrintListsIndex, gFootPrintList2, gNumFootPrintLists2, gCrntFootPrintList, gCrntFootPrintIndex, gFootPrintPath, gFootPrintBaseSprite, gFootPrintLastSprite, gAgassiSprite, gPennySprite, gFaceSprite, gClickBot1Sprite, gClickBot2Sprite, gExitSprite, gExitGlowSprite, gAirSprite, gHypnoSprite, gHypnoToeSprite, gHypnoHeelSprite, gHypnoRunning, gHypnoDelay, gHypnoDirection, gHypnoMode, gHypnoDuration, gHypnoDelayCount, gHypnoAnimIndex, gHypnoSlowRate, gHypnoFastRate, gHypnoMinDuration, gHypnoMaxDuration, gAirSwooshRevolving, gAirSwooshState, gAnimobAirSwoosh, gAirSwooshIndex, gAnimobMJ, gAgassiHologramOn, gAgassiHoloState, gAgassiHoloDirection, gPennyHologramOn, gJohnsonRollOverOn, gAnimobPennyHands, gPennyPiSection, gPennyHandSprite1, gPennyHandSprite2, gJohnsonRollBaseSprite, gJohnsonRollOverIndex

on launchAgassiHologram
  if gAgassiHologramOn = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  set gAgassiHologramOn to 1
  puppetSprite(gClickBot2Sprite, 1)
  set the loc of sprite gClickBot2Sprite to point(404, 330)
  set gAgassiHoloState to 0
  set gAgassiHoloDirection to 0
  updateAgassiHologram()
end

on updateAgassiHologram
  case gAgassiHoloState of
    0:
      set the castNum of sprite gClickBot2Sprite to cast "challenge.1"
    1:
      set the castNum of sprite gClickBot2Sprite to cast "challenge.2"
      puppetSound("zoom 1")
    2:
      set the castNum of sprite gClickBot2Sprite to cast "challenge.3"
  end case
  if the mouseH > 404 then
    set gAgassiHoloDirection to 0
  else
    set gAgassiHoloDirection to 1
  end if
  if gAgassiHoloDirection = 0 then
    set gAgassiHoloState to gAgassiHoloState - 1
    if gAgassiHoloState < 0 then
      set gAgassiHoloState to 0
    end if
  else
    set gAgassiHoloState to gAgassiHoloState + 1
    if gAgassiHoloState > 2 then
      set gAgassiHoloState to 2
    end if
  end if
end

on cleanupAgassiHologram
  if gAgassiHologramOn > 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning - 1
  end if
  set gAgassiHologramOn to 0
  puppetSprite(gClickBot2Sprite, 0)
end

on launchPennyHologram
  if gPennyHologramOn = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  set gPennyHologramOn to 1
  puppetSprite(gPennyHandSprite1, 1)
  puppetSprite(gPennyHandSprite2, 1)
  set the loc of sprite gPennyHandSprite1 to point(1000, 300)
  set the loc of sprite gPennyHandSprite2 to point(1000, 300)
end

on updatePennyHologram
  set deltaH to the mouseH - 363.0
  if abs(deltaH) < 0.01 then
    set deltaH to 0.01
  end if
  set angle to atan((the mouseV - 187.0) / deltaH)
  set pieSlice to integer(angle / gPennyPiSection) + 4
  if pieSlice > 6 then
    set pieSlice to 1
  end if
  set animob to getAt(gAnimobPennyHands, pieSlice)
  set the castNum of sprite gPennyHandSprite1 to getAt(animob, 1)
  set the loc of sprite gPennyHandSprite1 to getAt(animob, 2)
  set the ink of sprite gPennyHandSprite1 to 8
  set Animob2 to getAt(gAnimobPennyHands, pieSlice + 6)
  set the castNum of sprite gPennyHandSprite2 to getAt(Animob2, 1)
  set the loc of sprite gPennyHandSprite2 to getAt(Animob2, 2)
  set the ink of sprite gPennyHandSprite2 to 8
  if random(10) = 1 then
    puppetSprite(gClickBot2Sprite, 1)
    set the ink of sprite gClickBot2Sprite to 4
    updateStage()
    set the ink of sprite gClickBot2Sprite to 8
    puppetSprite(gClickBot2Sprite, 0)
  end if
end

on cleanupPennyHologram
  if gPennyHologramOn > 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning - 1
  end if
  set gPennyHologramOn to 0
  puppetSprite(gPennyHandSprite1, 0)
  puppetSprite(gPennyHandSprite2, 0)
end

on launchJohnsonrollOver
  if gJohnsonRollOverOn = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  set gJohnsonRollOverOn to 1
  set i to 1
  repeat while i < 7
    set thisSprite to gJohnsonRollBaseSprite + i
    puppetSprite(thisSprite, 1)
    set the castNum of sprite thisSprite to cast ("Johnson." & i + 1)
    set the loc of sprite thisSprite to point(1000, 300)
    set i to i + 1
  end repeat
  set gJohnsonRollOverIndex to 1
  updateJohnsonRollOver()
end

on updateJohnsonRollOver
  set crntAnimob to getAt(gAnimobMJ, gJohnsonRollOverIndex)
  if gJohnsonRollOverIndex > 1 then
    set prevAnimob to getAt(gAnimobMJ, gJohnsonRollOverIndex - 1)
  else
    set prevAnimob to crntAnimob
  end if
  set crntLoc to getAt(crntAnimob, 2)
  set prevLoc to getAt(prevAnimob, 2)
  set crntX to getAt(crntLoc, 1)
  set prevX to getAt(prevLoc, 1)
  set crntSpr to gJohnsonRollBaseSprite + gJohnsonRollOverIndex - 1
  set prevSpr to gJohnsonRollBaseSprite + gJohnsonRollOverIndex - 2
  set crntWidth to the width of sprite crntSpr / 2
  set prevWidth to the width of sprite prevSpr / 2
  if gJohnsonRollOverIndex > 1 then
    if the mouseH < (prevX + prevWidth) then
      set the loc of sprite crntSpr to point(1000, 300)
      set gJohnsonRollOverIndex to gJohnsonRollOverIndex - 1
      if gJohnsonRollOverIndex < 1 then
        set gJohnsonRollOverIndex to 1
      end if
      puppetSound("paper rip 2")
    else
      set the loc of sprite crntSpr to crntLoc
    end if
  end if
  if the mouseH > (crntX + crntWidth) then
    set gJohnsonRollOverIndex to gJohnsonRollOverIndex + 1
    if gJohnsonRollOverIndex > 7 then
      set gJohnsonRollOverIndex to 7
    else
      puppetSound("paper hit 1")
    end if
  end if
end

on cleanupJohnsonRollOver
  if gJohnsonRollOverOn > 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning - 1
  end if
  set gJohnsonRollOverOn to 0
  set i to 0
  repeat while i < 7
    set thisSprite to gJohnsonRollBaseSprite + i
    set the loc of sprite thisSprite to point(1000, 300)
    puppetSprite(thisSprite, 0)
    set i to i + 1
  end repeat
end
