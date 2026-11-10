global gPlayMouseSounds, gBallBounceDelay, gBallBounceLast, gLastFootSoundPosition, gCrntCourtSide, gOutOfBounds, gSqueakSounds, gTennisFeetSounds, gNumAnimationsRunning, gRoleCallDelay, gRoleCallCount, gMetronome, gCrntMode, gFlashingAgassi, gFlashingPenny, gFlashingFace, gFlashingAir, gFlashingExit, gFootPrintsOn, gFootPrintList1, gNumFootPrintLists1, gFootPrintListsIndex, gFootPrintList2, gNumFootPrintLists2, gCrntFootPrintList, gCrntFootPrintIndex, gFootPrintEraseIndex, gFootPrintPath, gFootPrintBaseSprite, gFootPrintLastSprite, gAgassiSprite, gPennySprite, gFaceSprite, gClickBot1Sprite, gClickBot2Sprite, gExitSprite, gExitGlowSprite, gAirSprite, gHypnoSprite, gHypnoToeSprite, gHypnoHeelSprite, gHypnoRunning, gHypnoDelay, gHypnoDirection, gHypnoMode, gHypnoDuration, gHypnoDelayCount, gHypnoAnimIndex, gHypnoSlowRate, gHypnoFastRate, gHypnoMinDuration, gHypnoMaxDuration, gAirSwooshRevolving, gAirSwooshState, gAnimobAirSwoosh, gAirSwooshIndex, gAnimobMJ, gAgassiHologramOn, gAgassiHoloState, gAgassiHoloDirection, gPennyHologramOn, gJohnsonRollOverOn, gAnimobPennyHands, gPennyPiSection, gPennyHandSprite1, gPennyHandSprite2, gJohnsonRollBaseSprite, gJohnsonRollOverIndex

on launchFootPrints
  if gFootPrintsOn = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  set gFootPrintsOn to 1
  set i to gFootPrintBaseSprite
  set x to gFootPrintLastSprite + 1
  repeat while i < x
    puppetSprite(i, 1)
    set the loc of sprite i to point(1000, 300)
    set i to i + 1
  end repeat
  case gFootPrintListsIndex of
    0:
      set gCrntFootPrintList to getAt(gFootPrintList1, random(gNumFootPrintLists1))
    1:
      set gCrntFootPrintList to getAt(gFootPrintList2, random(gNumFootPrintLists2))
  end case
  set gFootPrintListsIndex to 1 - gFootPrintListsIndex
  set gCrntFootPrintIndex to 0
end

on updateFootPrints
  case gFootPrintsOn of
    1:
      if ((the mouseH > 175) and (the mouseH < 500)) or ((the mouseV > 130) and (the mouseV < 350)) then
        set nextAnimob to getAt(gCrntFootPrintList, 1)
        set nextCast to getAt(nextAnimob, 1)
        set the castNum of sprite gFootPrintBaseSprite to nextCast
        set the locH of sprite gFootPrintBaseSprite to the mouseH
        set the locV of sprite gFootPrintBaseSprite to the mouseV
        set gFootPrintsOn to 2
        set gCrntFootPrintIndex to 0
        puppetSound("paper hit 2")
      end if
    2:
      set crntSprite to gFootPrintBaseSprite + gCrntFootPrintIndex
      if rollOver(crntSprite) = 0 then
        set nextAnimob to getAt(gCrntFootPrintList, gCrntFootPrintIndex + 2)
        set nextCast to getAt(nextAnimob, 1)
        set nextSprite to crntSprite + 1
        if (nextCast = -99) or (nextSprite > gFootPrintLastSprite) then
          set gFootPrintEraseIndex to 0
          set gFootPrintsOn to 3
        else
          set mousePoint to point(the mouseH, the mouseV)
          set crntPoint to the loc of sprite crntSprite
          set deltaMove to mousePoint - crntPoint
          set dx to getAt(deltaMove, 1)
          set dy to getAt(deltaMove, 2)
          set adx to abs(dx)
          set ady to abs(dy)
          set w0 to the width of sprite crntSprite
          set h0 to the height of sprite crntSprite
          set w1 to the width of member nextCast
          set h1 to the height of member nextCast
          set ww to (w0 + w1) / 2
          set hh to (h0 + h1) / 2
          if (adx > ww) or (ady > hh) then
            set x0 to the locH of sprite crntSprite
            set y0 to the locV of sprite crntSprite
            if adx > ady then
              if dx > 0 then
                set x1 to x0 + ww
              else
                set x1 to x0 - ww
              end if
              set y1 to y0 + (hh * (1.0 * dy / adx))
            else
              if dy > 0 then
                set y1 to y0 + hh
              else
                set y1 to y0 - hh
              end if
              set x1 to x0 + (ww * (1.0 * dx / ady))
            end if
            if ((x1 > 175) and (x1 < 500)) or ((y1 > 130) and (y1 < 350)) then
              set the castNum of sprite nextSprite to nextCast
              set the loc of sprite nextSprite to point(x1, y1)
              set gCrntFootPrintIndex to gCrntFootPrintIndex + 1
              puppetSound("paper hit 2")
            end if
          end if
        end if
      end if
    3:
      if gFootPrintEraseIndex < (gCrntFootPrintIndex + 1) then
        set spr to gFootPrintBaseSprite + gFootPrintEraseIndex
        set the loc of sprite spr to point(1000, 300)
        set gFootPrintEraseIndex to gFootPrintEraseIndex + 1
        puppetSound("paper rip 2")
      else
        launchFootPrints()
      end if
  end case
end

on cleanupFootPrints
  if gFootPrintsOn > 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning - 1
  end if
  set gFootPrintsOn to 0
  set i to gFootPrintBaseSprite
  set x to gFootPrintLastSprite + 1
  repeat while i < x
    set the loc of sprite i to point(1000, 300)
    puppetSprite(i, 0)
    set i to i + 1
  end repeat
  closeAirSwooshRevolve()
end

on launchAirSwooshRevolve
  if gAirSwooshState < 2 then
    if gAirSwooshRevolving = 0 then
      set gNumAnimationsRunning to gNumAnimationsRunning + 1
    end if
    puppetSprite(gAirSprite, 1)
    set gAirSwooshState to 1
    set gAirSwooshRevolving to 1
  end if
end

on updateAirSwooshRevolve
  case gAirSwooshRevolving of
    1:
      set gAirSwooshIndex to gAirSwooshIndex + 1
      set crntAnimob to getAt(gAnimobAirSwoosh, gAirSwooshIndex)
      set nextSprite to getAt(crntAnimob, 1)
      set nextPoint to getAt(crntAnimob, 2)
      if nextSprite = -99 then
        set gAirSwooshState to 2
        cleanupAirSwooshRevolve()
      else
        set the castNum of sprite gAirSprite to nextSprite
        set the loc of sprite gAirSprite to nextPoint
      end if
    2:
      set gAirSwooshIndex to gAirSwooshIndex - 1
      if gAirSwooshIndex < 1 then
        set gAirSwooshState to 0
        set gAirSwooshIndex to 0
        cleanupAirSwooshRevolve()
      else
        set crntAnimob to getAt(gAnimobAirSwoosh, gAirSwooshIndex)
        set nextSprite to getAt(crntAnimob, 1)
        set nextPoint to getAt(crntAnimob, 2)
        set the castNum of sprite gAirSprite to nextSprite
        set the loc of sprite gAirSprite to nextPoint
      end if
  end case
end

on closeAirSwooshRevolve
  if gAirSwooshState > 0 then
    if gAirSwooshRevolving = 0 then
      set gNumAnimationsRunning to gNumAnimationsRunning + 1
    end if
    puppetSprite(gAirSprite, 1)
    set gAirSwooshState to 1
    set gAirSwooshRevolving to 2
  end if
end

on cleanupAirSwooshRevolve
  if gAirSwooshRevolving > 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning - 1
  end if
  set gAirSwooshRevolving to 0
  if gAirSwooshState = 2 then
    set the castNum of sprite gAirSprite to cast "Swoosh.icon"
    set the loc of sprite gAirSprite to point(579, 436)
  else
    puppetSprite(gAirSprite, 0)
  end if
end

on launchHypno
  if gHypnoRunning = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  set gHypnoRunning to 1
  puppetSprite(gHypnoToeSprite, 1)
  puppetSprite(gHypnoHeelSprite, 1)
  set the loc of sprite gHypnoToeSprite to point(1000, 359)
  set the loc of sprite gHypnoHeelSprite to point(1000, 371)
  set gHypnoDelay to gHypnoSlowRate
  set gHypnoDelayCount to 0
  set gHypnoDirection to 1
  set gHypnoMode to 0
  set gHypnoDuration to gHypnoMinDuration + random(gHypnoMaxDuration - gHypnoMinDuration)
  set gHypnoAnimIndex to 0
end

on updateHypno
  set gHypnoDuration to gHypnoDuration - 1
  if gHypnoDuration < 1 then
    set gHypnoMode to 2
  end if
  set gHypnoDelayCount to gHypnoDelayCount + 1
  if gHypnoDelayCount > gHypnoDelay then
    set gHypnoDelayCount to 0
    case gHypnoAnimIndex of
      0:
        set the locH of sprite gHypnoToeSprite to 1000
        set the locH of sprite gHypnoHeelSprite to 1000
      1:
        set the locH of sprite gHypnoToeSprite to 358
        set the locH of sprite gHypnoHeelSprite to 206
        set the castNum of sprite gHypnoToeSprite to cast "toe.rings.1"
        set the castNum of sprite gHypnoHeelSprite to cast "heel.rings.1"
      2:
        set the castNum of sprite gHypnoToeSprite to cast "toe.rings.2"
        set the castNum of sprite gHypnoHeelSprite to cast "heel.rings.2"
      3:
        set the castNum of sprite gHypnoToeSprite to cast "toe.rings.3"
        set the castNum of sprite gHypnoHeelSprite to cast "heel.rings.3"
      4:
        set the locH of sprite gHypnoToeSprite to 358
        set the locH of sprite gHypnoHeelSprite to 206
        set the castNum of sprite gHypnoToeSprite to cast "toe.rings.4"
        set the castNum of sprite gHypnoHeelSprite to cast "heel.rings.4"
    end case
    set gHypnoAnimIndex to gHypnoAnimIndex + gHypnoDirection
    if gHypnoAnimIndex < 0 then
      set gHypnoAnimIndex to 4
    end if
    if gHypnoAnimIndex > 4 then
      set gHypnoAnimIndex to 0
    end if
    case gHypnoMode of
      0:
        if gHypnoDelay > gHypnoFastRate then
          set gHypnoDelay to gHypnoDelay - 1
        else
          set gHypnoDelay to gHypnoFastRate
          set gHypnoMode to 1
        end if
      2:
        if gHypnoDelay < gHypnoSlowRate then
          set gHypnoDelay to gHypnoDelay + 1
        else
          set gHypnoDirection to -gHypnoDirection
          set gHypnoDelay to gHypnoSlowRate
          set gHypnoMode to 0
          set gHypnoDuration to gHypnoMinDuration + random(gHypnoMaxDuration - gHypnoMinDuration)
        end if
    end case
  end if
end

on cleanupHypno
  if gHypnoRunning = 1 then
    set gNumAnimationsRunning to gNumAnimationsRunning - 1
  end if
  set gHypnoRunning to 0
  puppetSprite(gHypnoToeSprite, 0)
  puppetSprite(gHypnoHeelSprite, 0)
end
