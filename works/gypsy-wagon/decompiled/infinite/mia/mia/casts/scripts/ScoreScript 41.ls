on exitFrame
  global gsptDoll, gDollState, gCursorNum, gCursorMaskNum
  puppetSprite(gsptDoll + 3, 1)
  puppetSprite(gsptDoll + 4, 1)
  set the cursor of sprite 3 to 0
  set the cursor of sprite 4 to 0
  set the cursor of sprite 5 to 0
  set the cursor of sprite 7 to [gCursorNum, gCursorMaskNum]
  set gDollState to 1
  go("Idle2")
end
