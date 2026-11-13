on exitFrame
  global gsptBall, gBallState, gCursorNum, gCursorMaskNum
  puppetSprite(gsptBall + 0, 1)
  puppetSprite(gsptBall + 1, 1)
  set the cursor of sprite 10 to 0
  set the cursor of sprite 11 to 0
  set the cursor of sprite 12 to 0
  set the cursor of sprite 9 to [gCursorNum, gCursorMaskNum]
  set gBallState to 1
  go("Idle2")
end
