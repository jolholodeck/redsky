global gLastMouseX, gLastMouseY, minX, maxX, minY, maxY, ballX, ballY, ballZ, holeX, holeY, ballVX, ballVY, ballVZ, lastBallVZ, gHoleSprite, gFlagSprite, gBallSprite, gShadowSprite, gBallInverseSprite, gFlagIndex, gFlagDelay, gFlagDelayCount, gHoleTape1Sprite, gGrassFriction, gAirFriction, gGravity, gElasticity, gHitDistPercent, gMetronome, gGolfBallRollcall, gTigerFaceRollcall, gCrntMode, gGolfGameState, gHoleBlend, gGolfTimeout, gGolfTimeoutAnimob, gGolfTimeoutIndex, gGolfClickedToSwing, gGolfTimeoutOnscreen, gGolfTimeoutSprite, gTigerFaceSprite, gHelloWorldSprite, gExpPointSprite, gBallOnTeeSprite, gClickBot1Sprite, gClickBot2Sprite, gClickBot3Sprite, gCursorRolloverSprite, gCrntTigerGraphic, gTigerFaceChangeTime

on mouseUp
  if ((gGolfGameState = #playing) and rollOver(gBallSprite)) or ((gGolfTimeoutOnscreen = 1) and rollOver(gGolfTimeoutSprite)) then
    set dx to holeX - ballX
    set dy to holeY - ballY
    set framesToSink to 20.0
    playBallHitSound(dx, dy)
    set ballVX to dx / framesToSink
    set ballVY to dy / framesToSink
    set ballVZ to (abs(ballVX) + abs(ballVY)) / 2.0
    set lastBallVZ to ballVZ
    set gGolfClickedToSwing to 1
    if ballZ > 100.0 then
      set ballVZ to -(ballZ / framesToSink)
    end if
  end if
end
