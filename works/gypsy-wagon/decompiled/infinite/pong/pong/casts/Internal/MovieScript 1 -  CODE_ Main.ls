global g.obj.SystemManager, gStageX, gStageY, gMinX, gMinY, gMaxX, gMaxY, gLeftScore, gRghtScore, gLeftPaddleX, gRghtPaddleX, gPaddleHalfWidth, gPaddleMinY, gPaddleMaxY, gLeftPaddleY, gRghtPaddleY, gLastLeftPaddleY, gLastRghtPaddleY, gBounceSpeedX, gCompAINextHitY, gCompAINextHitVY, gBallX, gBallY, gBallVX, gBallVY, gLastBallX, gLastBallY, gServingTo, gMaxPaddleDY, gMarque1X, gMarque2X, gLeftTensDigitScoreSprite, gLeftOnesDigitScoreSprite, gRghtTensDigitScoreSprite, gRghtOnesDigitScoreSprite, gLeftPaddleSprite, gRghtPaddleSprite, gBallSprite, gMarque1Sprite, gMarque2Sprite, gMarque1width, gMarque2width, gSoundOn, gSoundHornSprite, gSoundWaveSprite, gSoundWaveLoc, gOverSoundSprites

on startMovie
  global g.obj.SystemManager
  if objectp(g.obj.SystemManager) then
    sysEnterStartMovie(g.obj.SystemManager)
  end if
  set gSoundOn to 1
  set gSoundHornSprite to 7
  set gSoundWaveSprite to 8
  set gSoundWaveLoc to the loc of sprite gSoundWaveSprite
  set xxMarqueDividerSprite to 4
  set gLeftTensDigitScoreSprite to 10
  set gLeftOnesDigitScoreSprite to 11
  set gRghtTensDigitScoreSprite to 12
  set gRghtOnesDigitScoreSprite to 13
  set gLeftPaddleSprite to 15
  set gRghtPaddleSprite to 16
  set gBallSprite to 17
  set gMarque1Sprite to 19
  set gMarque2Sprite to 20
  set gLeftScore to 0
  set gRghtScore to 0
  set gServingTo to 0
  set gMaxPaddleDY to 1
  set gStageX to getAt(the drawRect of the stage, 3)
  set gStageY to getAt(the drawRect of the stage, 4)
  set by to 1 + (the height of cast "ball" / 2)
  set gMinX to 40
  set gMaxX to gStageX - 40
  set gMinY to the locV of sprite xxMarqueDividerSprite + by
  set gMaxY to gStageY - by
  set gMarque1width to the width of cast "Marque text 1"
  set gMarque2width to the width of cast "Marque text 2"
  set gMarque1X to gStageX + 1
  set gMarque2X to gMarque1X + gMarque1width + 50
  initsprites()
  initgame()
  serveBall()
  if objectp(g.obj.SystemManager) then
    sysExitStartMovie(g.obj.SystemManager)
  end if
end

on enterFrame
  set gLastLeftPaddleY to gLeftPaddleY
  set gLastRghtPaddleY to gRghtPaddleY
  set gRghtPaddleY to the mouseV
  if gRghtPaddleY < gPaddleMinY then
    set gRghtPaddleY to gPaddleMinY
  end if
  if gRghtPaddleY > gPaddleMaxY then
    set gRghtPaddleY to gPaddleMaxY
  end if
  if gLeftPaddleY < gBallY then
    set targetY to gBallY - gCompAINextHitY
  else
    set targetY to gBallY + gCompAINextHitY
  end if
  set dy to abs(targetY - gLeftPaddleY)
  if dy > gMaxPaddleDY then
    set dy to gMaxPaddleDY
  end if
  if targetY > gLeftPaddleY then
    set gLeftPaddleY to gLeftPaddleY + dy
  else
    set gLeftPaddleY to gLeftPaddleY - dy
  end if
  if gLeftPaddleY < gPaddleMinY then
    set gLeftPaddleY to gPaddleMinY
  end if
  if gLeftPaddleY > gPaddleMaxY then
    set gLeftPaddleY to gPaddleMaxY
  end if
  if (abs(the mouseH - the locH of sprite gSoundHornSprite) < 6) and (abs(the mouseV - the locV of sprite gSoundHornSprite) < 6) then
    if gOverSoundSprites = 0 then
      set gOverSoundSprites to 1
      set gSoundOn to 1 - gSoundOn
      if gSoundOn = 1 then
        set the loc of sprite gSoundWaveSprite to gSoundWaveLoc
        puppetSprite(gSoundWaveSprite, 0)
      else
        puppetSprite(gSoundWaveSprite, 1)
        set the loc of sprite gSoundWaveSprite to point(1000, 40)
      end if
    end if
  else
    set gOverSoundSprites to 0
  end if
end

on mouseUp
  if objectp(g.obj.SystemManager) then
    puppetAllSprites(g.obj.SystemManager)
  end if
  go("gdmoFadeToBlack")
end

on exitFrame
  set gLastBallX to gBallX
  set gLastBallY to gBallY
  set gBallX to gBallX + gBallVX
  set gBallY to gBallY + gBallVY
  set dx to gBallX - gLeftPaddleX
  if dx < 7 then
    set impactY to gLastBallY + ((gLeftPaddleX - gLastBallX) * (gBallVY / gBallVX))
    if abs(impactY - gLeftPaddleY) < gPaddleHalfWidth then
      if gSoundOn = 1 then
        puppetSound("pong.paddle.hit")
      end if
      set gBallVX to gBounceSpeedX + abs(gLeftPaddleY - gLastLeftPaddleY)
      set gBallVY to impactY - gLeftPaddleY
      setCompAINextHitY()
    end if
  end if
  set dx to gRghtPaddleX - gBallX
  if dx < 7 then
    set impactY to gLastBallY + ((gRghtPaddleX - gLastBallX) * (gBallVY / gBallVX))
    if abs(impactY - gRghtPaddleY) < gPaddleHalfWidth then
      if gSoundOn = 1 then
        puppetSound("pong.paddle.hit")
      end if
      set gBallVX to -gBounceSpeedX - abs(gRghtPaddleY - gLastRghtPaddleY)
      set gBallVY to impactY - gRghtPaddleY
    end if
  end if
  if gBallX < gMinX then
    tallyScore(1)
  end if
  if gBallX > gMaxX then
    tallyScore(0)
  end if
  if gBallY < gMinY then
    if gSoundOn = 1 then
      puppetSound("pong.wall.hit")
    end if
    set gBallY to gMinY + (gMinY - gBallY)
    set gBallVY to -gBallVY
  end if
  if gBallY > gMaxY then
    if gSoundOn = 1 then
      puppetSound("pong.wall.hit")
    end if
    set gBallY to gMaxY - (gBallY - gMaxY)
    set gBallVY to -gBallVY
  end if
  set gMarque1X to gMarque1X - 1
  set gMarque2X to gMarque2X - 1
  if gMarque1X < -gMarque1width then
    set gMarque1X to gMarque2X + gMarque2width + gStageX + 10
  end if
  if gMarque2X < -gMarque2width then
    set gMarque2X to gMarque1X + gMarque1width + 50
  end if
  set the locH of sprite gBallSprite to gBallX
  set the locV of sprite gBallSprite to gBallY
  set the locV of sprite gRghtPaddleSprite to gRghtPaddleY
  set the locV of sprite gLeftPaddleSprite to gLeftPaddleY
  set the locH of sprite gMarque1Sprite to gMarque1X
  set the locH of sprite gMarque2Sprite to gMarque2X
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
  end if
  go("gdmoFadeToBlack")
end
