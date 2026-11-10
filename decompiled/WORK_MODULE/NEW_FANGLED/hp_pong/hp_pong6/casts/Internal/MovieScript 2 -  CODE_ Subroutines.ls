global gStageX, gStageY, gMinX, gMinY, gMaxX, gMaxY, gLeftScore, gRghtScore, gLeftPaddleX, gRghtPaddleX, gPaddleHalfWidth, gPaddleMinY, gPaddleMaxY, gLeftPaddleY, gRghtPaddleY, gLastLeftPaddleY, gLastRghtPaddleY, gBounceSpeedX, gCompAINextHitY, gCompAINextHitVY, gBallX, gBallY, gBallVX, gBallVY, gLastBallX, gLastBallY, gServingTo, gMaxPaddleDY, gMarque1X, gMarque2X, gLeftTensDigitScoreSprite, gLeftOnesDigitScoreSprite, gRghtTensDigitScoreSprite, gRghtOnesDigitScoreSprite, gLeftPaddleSprite, gRghtPaddleSprite, gBallSprite, gMarque1Sprite, gMarque2Sprite, gMarque1width, gMarque2width, gSoundOn, gSoundHornSprite, gSoundWaveSprite, gSoundWaveLoc, gOverSoundSprites

on initsprites
  puppetSprite(gLeftTensDigitScoreSprite, 1)
  puppetSprite(gLeftOnesDigitScoreSprite, 1)
  puppetSprite(gRghtTensDigitScoreSprite, 1)
  puppetSprite(gRghtOnesDigitScoreSprite, 1)
  set the locH of sprite gLeftTensDigitScoreSprite to 5
  set the locV of sprite gLeftTensDigitScoreSprite to gMinY - 1
  set the locH of sprite gLeftOnesDigitScoreSprite to 16
  set the locV of sprite gLeftOnesDigitScoreSprite to gMinY - 1
  set the locH of sprite gRghtTensDigitScoreSprite to gStageX - 24
  set the locV of sprite gRghtTensDigitScoreSprite to gMinY - 1
  set the locH of sprite gRghtOnesDigitScoreSprite to gStageX - 13
  set the locV of sprite gRghtOnesDigitScoreSprite to gMinY - 1
  puppetSprite(gLeftPaddleSprite, 1)
  puppetSprite(gRghtPaddleSprite, 1)
  set by to 2 + (the height of cast "ball" / 2)
  set gPaddleHalfWidth to 2 + (the height of cast "paddle" / 2)
  set gPaddleMinY to gMinY - by + gPaddleHalfWidth
  set gPaddleMaxY to gMaxY + by - gPaddleHalfWidth
  set gLeftPaddleX to gMinX + 10
  set gRghtPaddleX to gMaxX - 10
  set gLeftPaddleY to (gMinY + gMaxY) / 2
  set gRghtPaddleY to (gMinY + gMaxY) / 2
  set gLastLeftPaddleY to gLeftPaddleY
  set gLastRghtPaddleY to gRghtPaddleY
  set the locH of sprite gLeftPaddleSprite to gLeftPaddleX
  set the locV of sprite gLeftPaddleSprite to gLeftPaddleY
  set the locH of sprite gRghtPaddleSprite to gRghtPaddleX
  set the locV of sprite gRghtPaddleSprite to gRghtPaddleY
  puppetSprite(gBallSprite, 1)
  set gBallX to (gMinX + gMaxX) / 2
  set gBallY to (gMinY + gMaxY) / 2
  set gLastBallX to gBallX + 1
  set gLastBallY to gBallY
  set the locH of sprite gBallSprite to gBallX
  set the locV of sprite gBallSprite to gBallY
  puppetSprite(gMarque1Sprite, 1)
  puppetSprite(gMarque2Sprite, 1)
  set the locH of sprite gMarque1Sprite to gMarque1X
  set the locH of sprite gMarque2Sprite to gMarque2X
  set the locV of sprite gMarque1Sprite to -1
  set the locV of sprite gMarque2Sprite to -1
end

on initgame
  set gLeftScore to 0
  set gRghtScore to 0
  set gServingTo to 0
  set gBounceSpeedX to 7
  updateScoreGraphics()
end

on serveBall
  set gBallX to (gMinX + gMaxX) / 2
  set gBallY to (gMinY + gMaxY) / 2
  set gBallVY to random(3)
  set gBallVX to gBounceSpeedX
  if random(2) = 1 then
    set gBallVY to -gBallVY
  end if
  if gServingTo = 0 then
    set gBallVX to -gBallVX
  end if
  setCompAINextHitY()
end

on setCompAINextHitY
  set gCompAINextHitY to 1 + (gRghtScore / 2)
  if gCompAINextHitY > 5 then
    set gCompAINextHitY to 5
  end if
  set gCompAINextHitVY to gRghtScore / 2
  if gCompAINextHitVY > 3 then
    set gCompAINextHitVY to 3
  end if
end

on tallyScore scorer
  if gSoundOn = 1 then
    puppetSound("pong.score")
  end if
  if scorer = 0 then
    set gLeftScore to gLeftScore + 1
  else
    set gRghtScore to gRghtScore + 1
  end if
  if gLeftScore > 99 then
    set gLeftScore to 0
  end if
  if gRghtScore > 99 then
    set gRghtScore to 0
  end if
  set gServingTo to 1 - gServingTo
  set gBounceSpeedX to 5 + (gRghtScore / 2)
  if gBounceSpeedX > 15 then
    set gBounceSpeedX to 15
  end if
  set foo1 to gRghtScore > 1
  set foo2 to gRghtScore > 6
  set gMaxPaddleDY to 1 + foo1 + foo2
  updateScoreGraphics()
  serveBall()
end

on updateScoreGraphics
  set a to gLeftScore / 10
  set b to gLeftScore - (a * 10)
  set the castNum of sprite gLeftTensDigitScoreSprite to cast ("num." & a)
  set the castNum of sprite gLeftOnesDigitScoreSprite to cast ("num." & b)
  set a to gRghtScore / 10
  set b to gRghtScore - (a * 10)
  set the castNum of sprite gRghtTensDigitScoreSprite to cast ("num." & a)
  set the castNum of sprite gRghtOnesDigitScoreSprite to cast ("num." & b)
end
