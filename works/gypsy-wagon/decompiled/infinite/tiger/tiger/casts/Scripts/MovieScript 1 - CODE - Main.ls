global gLastMouseX, gLastMouseY, minX, maxX, minY, maxY, ballX, ballY, ballZ, holeX, holeY, ballVX, ballVY, ballVZ, lastBallVZ, gHoleSprite, gFlagSprite, gBallSprite, gShadowSprite, gBallInverseSprite, gFlagIndex, gFlagDelay, gFlagDelayCount, gHoleTape1Sprite, gGrassFriction, gAirFriction, gGravity, gElasticity, gHitDistPercent, gMetronome, gGolfBallRollcall, gTigerFaceRollcall, gCrntMode, gGolfGameState, gHoleBlend, gGolfTimeout, gGolfTimeoutAnimob, gGolfTimeoutIndex, gGolfClickedToSwing, gGolfTimeoutOnscreen, gGolfTimeoutSprite, gTigerFaceSprite, gHelloWorldSprite, gExpPointSprite, gBallOnTeeSprite, gClickBot1Sprite, gClickBot2Sprite, gClickBot3Sprite, gCursorRolloverSprite, gCrntTigerGraphic, gTigerFaceChangeTime, gTiger7Animob

on startMovie
  set minX to 5
  set minY to 5
  set maxX to 331
  set maxY to 255
  set gGrassFriction to 0.95999999999999996
  set gAirFriction to 0.98999999999999999
  set gGravity to 1.0
  set gElasticity to 0.66000000000000003
  set gHitDistPercent to 1.19999999999999996
  set gGolfTimeoutOnscreen to 0
  set gGolfClickedToSwing to 0
  set gMetronome to 0
  set gGolfBallRollcall to 0
  set gCrntTigerGraphic to 1
  set gTigerFaceChangeTime to the timer
  set gCrntMode to 100
  set gGolfGameState to #dormant
  set gHoleBlend to 0
  set gLastMouseX to the mouseH
  set gLastMouseY to the mouseV
  set gShadowSprite to 6
  set gFlagSprite to 7
  set gHoleSprite to 8
  set gHoleTape1Sprite to 9
  set gGolfTimeoutSprite to 10
  set gBallSprite to 45
  set gBallInverseSprite to 46
  set gTigerFaceSprite to 15
  set gHelloWorldSprite to 17
  set gExpPointSprite to 19
  set gBallOnTeeSprite to 21
  set gClickBot1Sprite to 25
  set gClickBot2Sprite to 26
  set gClickBot3Sprite to 27
  set gCursorRolloverSprite to 12
  set gGolfTimeoutAnimob to list(list(member "golf.timeout.icon", point(112, 274)), list(member "golf.timeout.icon", point(112, 274)), list(member "golf.timeout.icon", point(112, 271)), list(member "golf.timeout.icon", point(112, 262)), list(member "golf.timeout.icon", point(112, 245)), list(member "golf.timeout.icon", point(112, 229)), list(member "golf.timeout.icon", point(112, 228)), list(member "golf.timeout.icon", point(112, 234)), list(-99, point(0, 0)))
  set gTiger7Animob to list(list(member "tiger7.2", point(49, 46)), list(member "tiger7.3", point(49, 46)), list(member "tiger7.4", point(49, 46)), list(member "tiger7.5", point(49, 46)), list(member "tiger7.5", point(49, 46)), list(member "tiger7.5", point(49, 46)), list(member "tiger7.5", point(49, 46)), list(member "tiger7.4", point(49, 46)), list(member "tiger7.3", point(49, 46)), list(member "tiger7.2", point(49, 46)), list(-99, point(0, 0)))
  set cnum to the number of member "Nike cursor"
  set mnum to the number of member "Nike cursor mask"
  set the cursor of sprite gBallSprite to [cnum, mnum]
  set the cursor of sprite gCursorRolloverSprite to [cnum, mnum]
  set the cursor of sprite gGolfTimeoutSprite to [cnum, mnum]
end

on enterFrame
  if gGolfGameState <> #dormant then
    set crntMouseX to the mouseH
    set crntMouseY to the mouseV
    set tx to crntMouseX - ballX
    set ty to crntMouseY - ballY + ballZ
    set ab to sqrt((tx * tx) + (ty * ty))
    set tx to gLastMouseX - ballX
    set ty to gLastMouseY - ballY + ballZ
    set bc to sqrt((tx * tx) + (ty * ty))
    set tx to crntMouseX - gLastMouseX
    set ty to crntMouseY - gLastMouseY
    set ac to sqrt((tx * tx) + (ty * ty))
    if (ab + bc) < (ac * gHitDistPercent) then
      playBallHitSound(tx, ty)
      set ballVX to tx / 10.0
      set ballVY to ty / 10.0
      set ballVZ to ac / 10.0
      if ballVZ > lastBallVZ then
        set lastBallVZ to ballVZ
      end if
      set gGolfClickedToSwing to 0
    end if
    set gLastMouseX to crntMouseX
    set gLastMouseY to crntMouseY
  end if
end

on exitFrame
  set gMetronome to 1 - gMetronome
  if gCrntMode < 1000 then
    set the member of sprite gTigerFaceSprite to member ("Tiger" & gCrntTigerGraphic)
    set the loc of sprite gTigerFaceSprite to point(49, 44)
    if gTigerFaceRollcall > 0 then
      case gCrntTigerGraphic of
        7:
          set crntAnim to getAt(gTiger7Animob, gTigerFaceRollcall)
          set mbr to getAt(crntAnim, 1)
          if mbr = -99 then
            set gTigerFaceRollcall to 0
          else
            set the member of sprite gTigerFaceSprite to mbr
            set the loc of sprite gTigerFaceSprite to getAt(crntAnim, 2)
            set gTigerFaceRollcall to gTigerFaceRollcall + 1
          end if
        otherwise:
          if gTigerFaceRollcall > 10 then
            set gTigerFaceRollcall to 0
          else
            if gMetronome = 1 then
              set the member of sprite gTigerFaceSprite to member ("Tiger" & gCrntTigerGraphic & ".inverse")
            end if
            set gTigerFaceRollcall to gTigerFaceRollcall + 1
          end if
      end case
    end if
    if gGolfBallRollcall > 0 then
      if gGolfGameState = #dormant then
        if gMetronome = 1 then
          puppetSprite(gBallInverseSprite, 1)
          set the loc of sprite gBallInverseSprite to point(45, 215)
        else
          set the loc of sprite gBallInverseSprite to point(1000, 100)
          puppetSprite(gBallInverseSprite, 0)
        end if
        set gGolfBallRollcall to gGolfBallRollcall + 1
        if gGolfBallRollcall > 10 then
          set gGolfBallRollcall to 0
          set the loc of sprite gBallInverseSprite to point(1000, 100)
          puppetSprite(gBallInverseSprite, 0)
        end if
      end if
      if gGolfTimeoutOnscreen = 1 then
        if gMetronome = 1 then
          set the member of sprite gGolfTimeoutSprite to member "golf.timeout.icon.burst"
        else
          set the member of sprite gGolfTimeoutSprite to member "golf.timeout.icon"
        end if
        set gGolfBallRollcall to gGolfBallRollcall + 1
        if gGolfBallRollcall > 10 then
          set gGolfBallRollcall to 0
          set the member of sprite gGolfTimeoutSprite to member "golf.timeout.icon"
        end if
      end if
    end if
  end if
  if gCrntMode = 100 then
    if the timer > gTigerFaceChangeTime then
      set gCrntTigerGraphic to random(7)
      set gTigerFaceChangeTime to the timer + 180
    end if
    if (the mouseH < 112) and (the mouseV < 108) then
      set gCrntMode to 210
      go("OverTiger")
    end if
    if (the mouseH > 229) and (the mouseV < 101) then
      set gCrntMode to 310
      go("OverHelloWorld")
    end if
    if (the mouseH > 260) and (the mouseV > 158) then
      set gCrntMode to 400
      go("OverExpPoint")
    end if
    if (gGolfGameState = #dormant) and rollOver(gBallOnTeeSprite) then
      set gGolfGameState to #launching
      if gGolfBallRollcall > 0 then
        set gGolfBallRollcall to 0
        set the loc of sprite gBallInverseSprite to point(1000, 100)
        puppetSprite(gBallInverseSprite, 0)
      end if
      set gCrntMode to 500
      puppetSound(3, "iron.hit.aiff")
      puppetSprite(gBallOnTeeSprite, 1)
      set the member of sprite gBallOnTeeSprite to member "ball.ripped.off.tee"
      go("OverBallOnTee")
    end if
  end if
  case gCrntMode of
    210:
      if (the mouseH > 111) or (the mouseV > 107) then
        set gCrntMode to 100
        go("Idle")
      else
        if rollOver(gTigerFaceSprite) = 0 then
          if rollOver(gClickBot1Sprite) then
            go("TigerRollOut1")
            set gCrntMode to 250
          end if
          if rollOver(gClickBot2Sprite) then
            go("TigerRollOut2")
            set gCrntMode to 260
          end if
        end if
      end if
    250:
      if (the mouseH > 111) or (the mouseV > 107) or rollOver(gTigerFaceSprite) then
        set gCrntMode to 280
        go("TigerRollOut1Cleanup")
      end if
    260:
      if (the mouseH > 111) or (the mouseV > 107) or rollOver(gTigerFaceSprite) then
        set gCrntMode to 290
        go("TigerRollOut2Cleanup")
      end if
    310:
      if (the mouseH < 230) or (the mouseV > 100) then
        set gCrntMode to 100
        go("Idle")
      else
        if rollOver(gHelloWorldSprite) = 0 then
          if rollOver(gClickBot1Sprite) then
            set gCrntMode to 320
            go("Hello1")
          end if
          if rollOver(gClickBot2Sprite) then
            set gCrntMode to 330
            go("Hello2")
          end if
        end if
      end if
    320:
      if (the mouseH < 230) or (the mouseV > 100) or rollOver(gHelloWorldSprite) then
        set gCrntMode to 380
        go("Hello1Cleanup")
      end if
    330:
      if (the mouseH < 230) or (the mouseV > 100) or rollOver(gHelloWorldSprite) then
        set gCrntMode to 390
        go("Hello2Cleanup")
      end if
    400:
      if (the mouseH < 261) or (the mouseV < 159) then
        set gCrntMode to 100
        go("Idle")
      else
        if rollOver(gExpPointSprite) = 0 then
          if rollOver(gClickBot1Sprite) then
            set gCrntMode to 420
            go("ExpPoint1")
          end if
          if rollOver(gClickBot2Sprite) then
            set gCrntMode to 430
            go("ExpPoint2")
          end if
          if rollOver(gClickBot3Sprite) then
            set gCrntMode to 440
            go("ExpPoint3")
          end if
        end if
      end if
    420:
      if (the mouseH < 261) or (the mouseV < 159) or rollOver(gExpPointSprite) then
        set gCrntMode to 470
        go("ExpPoint1Cleanup")
      end if
    430:
      if (the mouseH < 261) or (the mouseV < 159) or rollOver(gExpPointSprite) then
        set gCrntMode to 480
        go("ExpPoint2Cleanup")
      end if
    440:
      if (the mouseH < 261) or (the mouseV < 159) or rollOver(gExpPointSprite) then
        set gCrntMode to 490
        go("ExpPoint3Cleanup")
      end if
  end case
  if gGolfGameState = #playing then
    updateGolfGame()
  end if
end
