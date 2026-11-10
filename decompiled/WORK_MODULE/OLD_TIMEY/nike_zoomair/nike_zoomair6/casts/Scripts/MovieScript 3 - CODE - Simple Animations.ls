global gPlayMouseSounds, gBallBounceDelay, gBallBounceLast, gLastFootSoundPosition, gCrntCourtSide, gOutOfBounds, gSqueakSounds, gTennisFeetSounds, gNumAnimationsRunning, gRoleCallDelay, gRoleCallCount, gMetronome, gCrntMode, gFlashingAgassi, gFlashingPenny, gFlashingFace, gFlashingAir, gFlashingExit, gFootPrintsOn, gFootPrintList1, gNumFootPrintLists1, gFootPrintListsIndex, gFootPrintList2, gNumFootPrintLists2, gCrntFootPrintList, gCrntFootPrintIndex, gFootPrintPath, gFootPrintBaseSprite, gFootPrintLastSprite, gAgassiSprite, gPennySprite, gFaceSprite, gClickBot1Sprite, gClickBot2Sprite, gExitSprite, gExitGlowSprite, gAirSprite, gHypnoSprite, gHypnoToeSprite, gHypnoHeelSprite, gHypnoRunning, gHypnoDelay, gHypnoDirection, gHypnoMode, gHypnoDuration, gHypnoDelayCount, gHypnoAnimIndex, gHypnoSlowRate, gHypnoFastRate, gHypnoMinDuration, gHypnoMaxDuration, gAirSwooshRevolving, gAirSwooshState, gAnimobAirSwoosh, gAirSwooshIndex, gAnimobMJ, gAgassiHologramOn, gAgassiHoloState, gAgassiHoloDirection, gPennyHologramOn, gJohnsonRollOverOn, gAnimobPennyHands, gPennyPiSection, gPennyHandSprite1, gPennyHandSprite2, gJohnsonRollBaseSprite, gJohnsonRollOverIndex

on launchFlashingAgassi
  if gFlashingAgassi = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  set gFlashingAgassi to 1
  puppetSprite(gAgassiSprite, 1)
end

on cleanupFlashingAgassi
  if gFlashingAgassi > 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning - 1
  end if
  set gFlashingAgassi to 0
  set the ink of sprite gAgassiSprite to 0
  puppetSprite(gAgassiSprite, 0)
end

on launchFlashingPenny
  if gFlashingPenny = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  set gFlashingPenny to 1
  puppetSprite(gPennySprite, 1)
end

on cleanupFlashingPenny
  if gFlashingPenny > 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning - 1
  end if
  set gFlashingPenny to 0
  set the ink of sprite gPennySprite to 0
  puppetSprite(gPennySprite, 0)
end

on launchFlashingFace
  if gFlashingFace = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  set gFlashingFace to 1
  puppetSprite(gFaceSprite, 1)
end

on cleanupFlashingFace
  if gFlashingFace > 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning - 1
  end if
  set gFlashingFace to 0
  set the ink of sprite gFaceSprite to 8
  puppetSprite(gFaceSprite, 0)
end

on launchFlashingAir
  if gFlashingAir = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  set gFlashingAir to 1
  puppetSprite(gAirSprite, 1)
end

on cleanupFlashingAir
  if gFlashingAir > 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning - 1
  end if
  set gFlashingAir to 0
  set the ink of sprite gAirSprite to 8
  if gAirSwooshState = 0 then
    puppetSprite(gAirSprite, 0)
  end if
end

on launchFlashingExit
  if gFlashingExit = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  set gFlashingExit to 1
  puppetSprite(gExitGlowSprite, 1)
end

on cleanupFlashingExit
  if gFlashingExit > 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning - 1
  end if
  set gFlashingExit to 0
  set the loc of sprite gExitGlowSprite to point(1000, 463)
  puppetSprite(gExitGlowSprite, 0)
end

on stopAllAnimations
  cleanupFlashingAgassi()
  cleanupFlashingPenny()
  cleanupFlashingFace()
  cleanupFlashingAir()
  cleanupFlashingExit()
  cleanupHypno()
  cleanupFootPrints()
  set gAirSwooshState to 0
  cleanupAirSwooshRevolve()
  cleanupAgassiHologram()
  cleanupPennyHologram()
  cleanupJohnsonRollOver()
  set gRoleCallCount to 20
  set gPlayMouseSounds to 0
  updateStage()
end
