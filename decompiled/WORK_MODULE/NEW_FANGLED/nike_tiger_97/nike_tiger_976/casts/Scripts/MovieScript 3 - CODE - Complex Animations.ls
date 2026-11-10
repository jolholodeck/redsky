global gLastMouseX, gLastMouseY, minX, maxX, minY, maxY, ballX, ballY, ballZ, holeX, holeY, ballVX, ballVY, ballVZ, lastBallVZ, gHoleSprite, gFlagSprite, gBallSprite, gShadowSprite, gBallInverseSprite, gFlagIndex, gFlagDelay, gFlagDelayCount, gHoleTape1Sprite, gGrassFriction, gAirFriction, gGravity, gElasticity, gHitDistPercent, gMetronome, gGolfBallRollcall, gTigerFaceRollcall, gCrntMode, gGolfGameState, gHoleBlend, gGolfTimeout, gGolfTimeoutAnimob, gGolfTimeoutIndex, gGolfClickedToSwing, gGolfTimeoutOnscreen, gGolfTimeoutSprite, gTigerFaceSprite, gHelloWorldSprite, gExpPointSprite, gBallOnTeeSprite, gClickBot1Sprite, gClickBot2Sprite, gClickBot3Sprite, gCursorRolloverSprite, gCrntTigerGraphic, gTigerFaceChangeTime

on playBallHitSound x, y
  if (abs(x) > 100) or (abs(y) > 100) then
    puppetSound(3, "iron.hit.aiff")
  else
    puppetSound(3, "putter.hit.aiff")
  end if
end

on launchGolfGame
  set gGolfGameState to #playing
  puppetSprite(gHoleSprite, 1)
  puppetSprite(gFlagSprite, 1)
  puppetSprite(gHoleTape1Sprite, 1)
  puppetSprite(gBallSprite, 1)
  puppetSprite(gShadowSprite, 1)
  set hx to (maxX - minX) / 2
  set hy to (maxY - minY) / 2
  set holeX to random(hx) + (hx / 2.0)
  set holeY to random(hy) + (hy / 2.0)
  set the locH of sprite gHoleSprite to holeX
  set the locV of sprite gHoleSprite to holeY
  set the castNum of sprite gHoleSprite to cast "hole"
  set the locH of sprite gFlagSprite to holeX + 11
  set the locV of sprite gFlagSprite to holeY - 38
  set the castNum of sprite gFlagSprite to cast "flag.1"
  set gFlagIndex to 1
  set gFlagDelay to 3
  set gFlagDelayCount to 0
  set the locH of sprite gHoleTape1Sprite to holeX - 21
  set the locV of sprite gHoleTape1Sprite to holeY + 7
  set the castNum of sprite gHoleTape1Sprite to cast "small.tape.1"
  set gHoleBlend to 0
  set the blend of sprite gHoleSprite to gHoleBlend
  set the blend of sprite gFlagSprite to gHoleBlend
  set the blend of sprite gHoleTape1Sprite to gHoleBlend
  set initspd to 4
  set ballZ to 10.0 * initspd
  set ballVZ to -0.29999999999999999 * initspd
  set ballVX to 3.0 * (5 - initspd + 6)
  set ballVY to -1.0 * (5 - initspd + 2)
  set lastBallVZ to 2.0 * initspd
  set ballX to the locH of sprite gBallSprite
  set ballY to the locV of sprite gBallSprite + ballZ
  set the castNum of sprite gBallSprite to cast "ball1"
  set the locH of sprite gShadowSprite to ballX
  set the locV of sprite gShadowSprite to ballY
  set the castNum of sprite gShadowSprite to cast "shadow"
  set gLastMouseX to the mouseH
  set gLastMouseY to the mouseV
  set gGolfTimeoutIndex to 0
  set gGolfTimeout to the timer + 600
end

on updateGolfGame
  if gHoleBlend < 101 then
    set the blend of sprite gHoleSprite to gHoleBlend
    set the blend of sprite gFlagSprite to gHoleBlend
    set the blend of sprite gHoleTape1Sprite to gHoleBlend / 2
    set gHoleBlend to gHoleBlend + 10
  end if
  if gGolfTimeoutOnscreen = 0 then
    if the timer > gGolfTimeout then
      set gGolfTimeoutOnscreen to 1
      set gGolfTimeoutIndex to 1
      puppetSprite(gGolfTimeoutSprite, 1)
      set the loc of sprite gGolfTimeoutSprite to point(1000, 300)
      puppetSound(3, "zoom 1 w/hit")
    end if
  else
    if gGolfTimeoutIndex > 0 then
      set crntAnim to getAt(gGolfTimeoutAnimob, gGolfTimeoutIndex)
      set mbr to getAt(crntAnim, 1)
      if mbr = -99 then
        set gGolfTimeoutIndex to 0
      else
        set the member of sprite gGolfTimeoutSprite to mbr
        set the loc of sprite gGolfTimeoutSprite to getAt(crntAnim, 2)
        set gGolfTimeoutIndex to gGolfTimeoutIndex + 1
      end if
    end if
  end if
  set ballX to ballX + ballVX
  set ballY to ballY + ballVY
  set ballZ to ballZ + ballVZ
  if ballX < minX then
    set ballX to minX + (minX - ballX)
    set ballVX to -ballVX
  end if
  if ballX > maxX then
    set ballX to maxX - (ballX - maxX)
    set ballVX to -ballVX
  end if
  if ballY < minY then
    set ballY to minY + (minY - ballY)
    set ballVY to -ballVY
  end if
  if ballY > maxY then
    set ballY to maxY - (ballY - maxY)
    set ballVY to -ballVY
  end if
  if (abs(ballVX) + abs(ballVY) + abs(ballVZ)) > 0.10000000000000001 then
    if gMetronome = 1 then
      set the castNum of sprite gBallSprite to cast "ball1"
    else
      set the castNum of sprite gBallSprite to cast "ball2"
    end if
  end if
  if ballZ > 0.0 then
    set tz to ballZ
  else
    set tz to 0.0
  end if
  set the locH of sprite gBallSprite to ballX
  set the locV of sprite gBallSprite to ballY - tz
  set the locH of sprite gShadowSprite to ballX
  set the locV of sprite gShadowSprite to ballY
  puppetSprite(gShadowSprite, ballZ > 3.0)
  set gFlagDelayCount to gFlagDelayCount + 1
  if gFlagDelayCount > gFlagDelay then
    set gFlagIndex to gFlagIndex + 1
    if gFlagIndex > 3 then
      set gFlagIndex to 1
    end if
    if gFlagDelay > 5 then
      set gFlagIndex to 1
    end if
    set the castNum of sprite gFlagSprite to cast ("flag." & gFlagIndex)
    set gFlagDelayCount to 0
    if random(3) = 1 then
      set gFlagDelay to gFlagDelay + random(3) - 2
      if gFlagDelay < 0 then
        set gFlagDelay to 0
      end if
      if gFlagDelay > 7 then
        set gFlagDelay to 7
      end if
    end if
  end if
  if ((gGolfClickedToSwing = 1) and (((abs(ballX - holeX) / 4.0) + abs(ballY - holeY)) < 6.40000000000000036)) or ((((abs(ballX - holeX) / 4.0) + abs(ballY - holeY)) < 3.20000000000000018) and (ballZ < 0.10000000000000001)) then
    puppetSound(3, "golf.sinker.aiff")
    stopAllAnimations()
    set gCrntMode to 1000
    go("TigerFacePayOff")
  end if
  if ballZ < 0.0 then
    set tmp to ballZ / ballVZ
    set ballVX to ballVX * gGrassFriction * gGrassFriction
    set ballVY to ballVY * gGrassFriction * gGrassFriction
    set ballVZ to lastBallVZ * gElasticity
    set ballZ to tmp * ballVZ
    if abs(ballVZ) < 0.29999999999999999 then
      set ballVZ to 0.0
      set ballZ to 0.0
    end if
    set lastBallVZ to ballVZ
  end if
  if abs(ballVX) < 0.20000000000000001 then
    set ballVX to 0.0
  end if
  if abs(ballVY) < 0.20000000000000001 then
    set ballVY to 0.0
  end if
  if ballZ > 0.10000000000000001 then
    set ballVX to ballVX * gAirFriction
    set ballVY to ballVY * gAirFriction
    set ballVZ to ballVZ - gGravity
  else
    set ballVX to ballVX * gGrassFriction
    set ballVY to ballVY * gGrassFriction
  end if
end

on cleanupGolfGame
  set the loc of sprite gBallSprite to point(1000, 300)
  puppetSprite(gBallSprite, 0)
  set the loc of sprite gHoleSprite to point(1000, 300)
  puppetSprite(gHoleSprite, 0)
  set the loc of sprite gFlagSprite to point(1000, 300)
  puppetSprite(gFlagSprite, 0)
  set the loc of sprite gHoleTape1Sprite to point(1000, 300)
  puppetSprite(gHoleTape1Sprite, 0)
  set the loc of sprite gShadowSprite to point(1000, 300)
  puppetSprite(gShadowSprite, 0)
  set the loc of sprite gBallOnTeeSprite to point(1000, 300)
  puppetSprite(gBallOnTeeSprite, 0)
  set the loc of sprite gGolfTimeoutSprite to point(1000, 300)
  puppetSprite(gGolfTimeoutSprite, 0)
  set gGolfGameState to #dormant
  set gGolfTimeoutOnscreen to 0
  set gGolfClickedToSwing to 0
end

on stopAllAnimations
  cleanupGolfGame()
  set the loc of sprite gTigerFaceSprite to point(1000, 44)
  puppetSprite(gTigerFaceSprite, 0)
end
