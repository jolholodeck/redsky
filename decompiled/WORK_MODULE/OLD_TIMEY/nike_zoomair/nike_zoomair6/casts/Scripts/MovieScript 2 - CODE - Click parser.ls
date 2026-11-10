global gPlayMouseSounds, gBallBounceDelay, gBallBounceLast, gLastFootSoundPosition, gCrntCourtSide, gOutOfBounds, gSqueakSounds, gTennisFeetSounds, gNumAnimationsRunning, gRoleCallDelay, gRoleCallCount, gMetronome, gCrntMode, gFlashingAgassi, gFlashingPenny, gFlashingFace, gFlashingAir, gFlashingExit, gFootPrintsOn, gFootPrintList1, gNumFootPrintLists1, gFootPrintListsIndex, gFootPrintList2, gNumFootPrintLists2, gCrntFootPrintList, gCrntFootPrintIndex, gFootPrintPath, gFootPrintBaseSprite, gFootPrintLastSprite, gAgassiSprite, gPennySprite, gFaceSprite, gClickBot1Sprite, gClickBot2Sprite, gExitSprite, gExitGlowSprite, gAirSprite, gHypnoSprite, gHypnoToeSprite, gHypnoHeelSprite, gHypnoRunning, gHypnoDelay, gHypnoDirection, gHypnoMode, gHypnoDuration, gHypnoDelayCount, gHypnoAnimIndex, gHypnoSlowRate, gHypnoFastRate, gHypnoMinDuration, gHypnoMaxDuration, gAirSwooshRevolving, gAirSwooshState, gAnimobAirSwoosh, gAirSwooshIndex, gAnimobMJ, gAgassiHologramOn, gAgassiHoloState, gAgassiHoloDirection, gPennyHologramOn, gJohnsonRollOverOn, gAnimobPennyHands, gPennyPiSection, gPennyHandSprite1, gPennyHandSprite2, gJohnsonRollBaseSprite, gJohnsonRollOverIndex

on mouseUp
  if (gCrntMode > 99) and (gCrntMode < 999) then
    if rollOver(gExitSprite) then
      stopAllAnimations()
      set gCrntMode to 1000
      go("Close")
    end if
  end if
  case gCrntMode of
    5:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 10
        go("Nike is shoe company")
      end if
    10:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 20
        go("Excuse me")
      end if
    20:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 40
        go("Now")
      end if
    40:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 60
        go("Are you an athlete?")
      end if
    60:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 70
        go("MJzoomOn")
      end if
    70:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 80
        go("JohnsonRollOver")
      end if
    80:
      set i to 1
      set MJclick to 0
      repeat while i < 7
        if rollOver(gJohnsonRollBaseSprite + i) then
          set MJclick to 1
        end if
        set i to i + 1
      end repeat
      if rollOver(gClickBot1Sprite) or (MJclick = 1) then
        set gCrntMode to 90
        cleanupJohnsonRollOver()
        go("inWhatTheHellIsThat")
      end if
    90:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 95
        go("ThatIs")
      end if
    95:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 97
        go("buildIcons")
      end if
    100:
      if rollOver(gHypnoSprite) then
        cleanupHypno()
        cleanupFootPrints()
        set gCrntMode to 500
        go("Vomit")
      end if
    210:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 220
        cleanupHypno()
        cleanupFootPrints()
        go("Pirate")
        set gPlayMouseSounds to 1
        set gOutOfBounds to 1
      end if
      if rollOver(gClickBot2Sprite) then
        set gCrntMode to 250
        cleanupHypno()
        cleanupFootPrints()
        go("Swoosh")
        set gPlayMouseSounds to 1
        set gOutOfBounds to 1
      end if
    220:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 230
        go("Hair")
      end if
    230:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 239
        go("PirateHairRetract")
      end if
    250:
      if rollOver(gClickBot2Sprite) then
        set gCrntMode to 260
        go("TresChic")
      end if
    260:
      if rollOver(gClickBot2Sprite) then
        set gCrntMode to 270
        go("Challenge")
      end if
    270:
      if rollOver(gClickBot2Sprite) then
        set gCrntMode to 279
        if gAgassiHoloState = 2 then
          set the castNum of sprite gClickBot2Sprite to cast "challenge.2"
          puppetSound("zoom 1")
          updateStage()
        end if
        cleanupAgassiHologram()
        go("SwooshChallengeRetract")
      end if
    310:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 320
        cleanupHypno()
        cleanupFootPrints()
        go("ThisIsPenny")
        set gPlayMouseSounds to 2
        set gOutOfBounds to 1
      end if
      if rollOver(gClickBot2Sprite) then
        set gCrntMode to 350
        cleanupHypno()
        cleanupFootPrints()
        go("ThisIsPennysShoe")
        set gPlayMouseSounds to 2
        set gOutOfBounds to 1
      end if
    320:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 330
        go("HumbleMan")
      end if
    330:
      if rollOver(gClickBot1Sprite) then
        set gCrntMode to 340
        go("PlayDoesTalking")
      end if
    340:
      if rollOver(gClickBot1Sprite) or rollOver(gClickBot2Sprite) then
        set gCrntMode to 349
        go("PennyRetract")
      end if
    350:
      if rollOver(gClickBot1Sprite) or rollOver(gClickBot2Sprite) then
        set gCrntMode to 360
        cleanupPennyHologram()
        go("CalledZoomFlight")
      end if
    360:
      if rollOver(gClickBot2Sprite) then
        set gCrntMode to 370
        go("WhatPennyWears")
      end if
    370:
      if rollOver(gClickBot2Sprite) then
        set gCrntMode to 379
        go("PennyShoeRetract")
      end if
    400:
      if rollOver(gFaceSprite) then
        set gCrntMode to 410
        cleanupHypno()
        cleanupFootPrints()
        go("FaceIdle")
      end if
    410:
      if rollOver(gClickBot1Sprite) or rollOver(gClickBot2Sprite) then
        set gCrntMode to 420
        go("PassionNotArrogance")
      end if
    420:
      if rollOver(gClickBot1Sprite) or rollOver(gClickBot2Sprite) then
        set gCrntMode to 430
        go("ZoomAirCushioning")
      end if
    430:
      if rollOver(gClickBot1Sprite) or rollOver(gClickBot2Sprite) then
        set gCrntMode to 440
        go("Face2010")
      end if
    440:
      if rollOver(gClickBot1Sprite) or rollOver(gClickBot2Sprite) then
        set gCrntMode to 449
        go("FaceRetract")
      end if
    500:
      go("VomitLoop")
    550:
      go("Idle")
    600:
      if rollOver(gAirSprite) then
        if gFootPrintsOn = 0 then
          launchAirSwooshRevolve()
          launchFootPrints()
        else
          cleanupFootPrints()
        end if
      end if
    1010:
      go("Slogan")
    1015:
      go("Conscience")
    1025:
      go("Just do it")
    1035:
      go("Exit")
  end case
end
