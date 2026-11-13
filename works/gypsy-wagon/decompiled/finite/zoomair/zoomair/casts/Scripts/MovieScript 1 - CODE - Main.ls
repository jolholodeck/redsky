global g.obj.SystemManager, gPlayMouseSounds, gBallBounceDelay, gBallBounceLast, gLastFootSoundPosition, gCrntCourtSide, gOutOfBounds, gSqueakSounds, gTennisFeetSounds, gNumAnimationsRunning, gRoleCallDelay, gRoleCallCount, gMetronome, gCrntMode, gFlashingAgassi, gFlashingPenny, gFlashingFace, gFlashingAir, gFlashingExit, gFootPrintsOn, gFootPrintList1, gNumFootPrintLists1, gFootPrintListsIndex, gFootPrintList2, gNumFootPrintLists2, gCrntFootPrintList, gCrntFootPrintIndex, gFootPrintEraseIndex, gFootPrintPath, gFootPrintBaseSprite, gFootPrintLastSprite, gAgassiSprite, gPennySprite, gFaceSprite, gClickBot1Sprite, gClickBot2Sprite, gExitSprite, gExitGlowSprite, gAirSprite, gHypnoSprite, gHypnoToeSprite, gHypnoHeelSprite, gHypnoRunning, gHypnoDelay, gHypnoDirection, gHypnoMode, gHypnoDuration, gHypnoDelayCount, gHypnoAnimIndex, gHypnoSlowRate, gHypnoFastRate, gHypnoMinDuration, gHypnoMaxDuration, gAirSwooshRevolving, gAirSwooshState, gAnimobAirSwoosh, gAirSwooshIndex, gAnimobMJ, gAgassiHologramOn, gAgassiHoloState, gAgassiHoloDirection, gPennyHologramOn, gJohnsonRollOverOn, gAnimobPennyHands, gPennyPiSection, gPennyHandSprite1, gPennyHandSprite2, gJohnsonRollBaseSprite, gJohnsonRollOverIndex

on startMovie
  global g.obj.SystemManager
  if objectp(g.obj.SystemManager) then
    sysEnterStartMovie(g.obj.SystemManager)
  end if
  set gIsPCversion to 0
  set gNumAnimationsRunning to 0
  set gRoleCallDelay to 80
  set gRoleCallCount to 20
  set gMetronome to 0
  set gCrntMode to 0
  set gHypnoRunning to 0
  set gHypnoSlowRate to 2
  set gHypnoFastRate to 0
  set gHypnoMinDuration to 10
  set gHypnoMaxDuration to 100
  set gFlashingAgassi to 0
  set gFlashingPenny to 0
  set gFlashingFace to 0
  set gFlashingAir to 0
  set gFootPrintsOn to 0
  set gFootPrintListsIndex to 0
  set gLastFootSoundPosition to point(the mouseH, the mouseV)
  set gCrntCourtSide to 1
  set gPlayMouseSounds to 0
  set gBallBounceLast to the ticks
  set gOutOfBounds to 0
  if gIsPCversion = 1 then
    set gSqueakSounds to 1
    set gTennisFeetSounds to 2
  else
    set gSqueakSounds to 3
    set gTennisFeetSounds to 5
  end if
  set gAirSwooshState to 0
  set gAirSwooshRevolving to 0
  set gAirSwooshIndex to 0
  set gHypnoSprite to 6
  set gHypnoToeSprite to 7
  set gHypnoHeelSprite to 8
  set gJohnsonRollBaseSprite to 14
  set gFootPrintBaseSprite to 14
  set gFootPrintLastSprite to 29
  set gClickBot1Sprite to 12
  set gClickBot2Sprite to 13
  set gPennyHandSprite1 to 14
  set gPennyHandSprite2 to 15
  set gAgassiSprite to 40
  set gPennySprite to 41
  set gFaceSprite to 42
  set gAirSprite to 43
  set gExitSprite to 44
  set gExitGlowSprite to 45
  set gFootPrintSprite to 48
  set cnum to the number of member "Nike cursor"
  set mnum to the number of member "Nike cursor mask"
  set the cursor of sprite gClickBot1Sprite to [cnum, mnum]
  set the cursor of sprite gClickBot2Sprite to [cnum, mnum]
  set the cursor of sprite gFaceSprite to [cnum, mnum]
  set the cursor of sprite gAirSprite to [cnum, mnum]
  set the cursor of sprite gExitSprite to [cnum, mnum]
  set the cursor of sprite gHypnoSprite to [cnum, mnum]
  initAnimobs()
  if objectp(g.obj.SystemManager) then
    sysExitStartMovie(g.obj.SystemManager)
  end if
end

on stopMovie
  global g.obj.SystemManager
  if objectp(g.obj.SystemManager) then
    sysExitStopMovie(g.obj.SystemManager)
  end if
end

on keyDown
  if objectp(g.obj.SystemManager) then
    systemKeyHandler(g.obj.SystemManager, the key)
  end if
end

on systemExitCleanupHandler
  put "CHILD: in systemExitCleanupHandler"
  sound stop 1
  sound stop 2
  if objectp(g.obj.SystemManager) then
    puppetAllSprites(g.obj.SystemManager)
    go("gdmoFadeToBlack")
  end if
end

on enterFrame
  if gPlayMouseSounds > 0 then
    set crntPoint to point(the mouseH, the mouseV)
    set deltaMove to gLastFootSoundPosition - crntPoint
    set deltaDist to abs(getAt(deltaMove, 1)) + abs(getAt(deltaMove, 2))
    case gPlayMouseSounds of
      1:
        if deltaDist > 50 then
          puppetSound("tennis feet " & random(gTennisFeetSounds))
        end if
      2:
        if deltaDist > 100 then
          puppetSound("bball Squeak " & random(gSqueakSounds))
          set gBallBounceDelay to 10 + random(5)
        else
          if deltaDist > 75 then
            set gBallBounceDelay to 15 + random(10)
          else
            if deltaDist > 3 then
              set gBallBounceDelay to 10 + random(20)
            end if
          end if
        end if
        if (soundBusy(1) = 0) and (soundBusy(2) = 0) then
          if (the ticks - gBallBounceLast) > gBallBounceDelay then
            puppetSound("bball bounce")
            set gBallBounceDelay to 30 + random(240)
            set gBallBounceLast to the ticks
          end if
        end if
    end case
    set impactMargin to 100 + (75 / (deltaDist + 1))
    if ((gOutOfBounds = 0) and ((gCrntCourtSide = 0) and (the mouseH < impactMargin))) or ((gCrntCourtSide = 1) and (the mouseH > (640 - impactMargin))) then
      case gPlayMouseSounds of
        1:
          puppetSound("tennis hit " & random(2))
        2:
          puppetSound("bball swish")
          set gBallBounceDelay to 30 + random(10)
      end case
      set gCrntCourtSide to 1 - gCrntCourtSide
    end if
    if (the mouseV < 50) or (the mouseV > 430) then
      if gOutOfBounds = 0 then
        case gPlayMouseSounds of
          1:
            puppetSound("tennis fault!")
          2:
            puppetSound("bball oof")
        end case
        set gOutOfBounds to 1
      end if
    else
      set gOutOfBounds to 0
    end if
  end if
  set gLastFootSoundPosition to crntPoint
end

on exitFrame
  set gMetronome to 1 - gMetronome
  if gCrntMode = 100 then
    if gRoleCallCount = 1 then
      launchFlashingFace()
    end if
    if gRoleCallCount = 4 then
      launchFlashingAir()
    end if
    if gRoleCallCount = 7 then
      launchFlashingPenny()
    end if
    if gRoleCallCount = 10 then
      launchFlashingAgassi()
    end if
    set gRoleCallCount to gRoleCallCount + 1
    if gRoleCallCount > gRoleCallDelay then
      set gRoleCallCount to 0
    end if
    if (the mouseH < 156) and (the mouseV < 111) then
      set gCrntMode to 210
      go("OverAgassi")
    end if
    if (the mouseH < 165) and (the mouseV > 370) then
      set gCrntMode to 310
      go("OverPenny")
    end if
    if (the mouseH > 555) and (the mouseV < 85) then
      set gCrntMode to 400
      go("OverFace")
    end if
    if rollOver(gAirSprite) then
      set gCrntMode to 600
      go("OverAir")
    end if
    if rollOver(gExitSprite) then
      launchFlashingExit()
    end if
  end if
  if gFlashingFace > 0 then
    if gMetronome = 0 then
      set the ink of sprite gFaceSprite to 4
    else
      set the ink of sprite gFaceSprite to 8
    end if
    set gFlashingFace to gFlashingFace + 1
    if gFlashingFace > 6 then
      cleanupFlashingFace()
    end if
  end if
  if gFlashingAir > 0 then
    if (gMetronome = 1) and (gAirSwooshRevolving = 0) then
      set the ink of sprite gAirSprite to 4
    else
      set the ink of sprite gAirSprite to 8
    end if
    set gFlashingAir to gFlashingAir + 1
    if gFlashingAir > 6 then
      cleanupFlashingAir()
    end if
  end if
  if gFlashingPenny > 0 then
    if gMetronome = 0 then
      set the ink of sprite gPennySprite to 4
    else
      set the ink of sprite gPennySprite to 0
    end if
    set gFlashingPenny to gFlashingPenny + 1
    if gFlashingPenny > 6 then
      cleanupFlashingPenny()
    end if
  end if
  if gFlashingAgassi > 0 then
    if gMetronome = 1 then
      set the ink of sprite gAgassiSprite to 4
    else
      set the ink of sprite gAgassiSprite to 0
    end if
    set gFlashingAgassi to gFlashingAgassi + 1
    if gFlashingAgassi > 6 then
      cleanupFlashingAgassi()
    end if
  end if
  if gFlashingExit > 0 then
    if gMetronome = 1 then
      set the loc of sprite gExitGlowSprite to point(461, 463)
    else
      set the loc of sprite gExitGlowSprite to point(1000, 463)
    end if
    set gFlashingExit to gFlashingExit + 1
    if gFlashingExit > 4 then
      cleanupFlashingExit()
    end if
  end if
  case gCrntMode of
    210:
      if (the mouseH > 155) or (the mouseV > 110) then
        set gCrntMode to 100
        go("Idle")
      else
        if rollOver(gClickBot1Sprite) then
          puppetSprite(gClickBot1Sprite, 1)
          set the castNum of sprite gClickBot1Sprite to cast "agassiTarget.glow"
          updateStage()
          puppetSprite(gClickBot1Sprite, 0)
        end if
        if rollOver(gClickBot2Sprite) then
          puppetSprite(gClickBot2Sprite, 1)
          set the castNum of sprite gClickBot2Sprite to cast "agassiTarget.glow"
          updateStage()
          puppetSprite(gClickBot2Sprite, 0)
        end if
      end if
    310:
      if (the mouseH > 164) or (the mouseV < 371) then
        set gCrntMode to 100
        go("Idle")
      else
        if rollOver(gClickBot1Sprite) then
          puppetSprite(gClickBot1Sprite, 1)
          set the castNum of sprite gClickBot1Sprite to cast "pennyArrow1a.glow"
          updateStage()
          puppetSprite(gClickBot1Sprite, 0)
        end if
        if rollOver(gClickBot2Sprite) then
          puppetSprite(gClickBot2Sprite, 1)
          set the castNum of sprite gClickBot2Sprite to cast "pennyArrow2a.glow"
          updateStage()
          puppetSprite(gClickBot2Sprite, 0)
        end if
      end if
    400:
      if (the mouseH < 556) or (the mouseV > 84) then
        set gCrntMode to 100
        go("Idle")
      end if
    600:
      if rollOver(gAirSprite) = 0 then
        set gCrntMode to 100
        go("Idle")
      else
        if (gMetronome = 1) and (gAirSwooshRevolving = 0) then
          set the ink of sprite gAirSprite to 4
          updateStage()
          set the ink of sprite gAirSprite to 8
        else
          set the ink of sprite gAirSprite to 8
        end if
      end if
  end case
  if gHypnoRunning > 0 then
    updateHypno()
  end if
  if gFootPrintsOn > 0 then
    updateFootPrints()
  end if
  if gAirSwooshRevolving > 0 then
    updateAirSwooshRevolve()
  end if
end
