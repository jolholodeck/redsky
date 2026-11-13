on exitFrame
  global gsptPrecious, gPreciousState, gCursorNum, gCursorMaskNum
  puppetSprite(gsptPrecious + 0, 1)
  puppetSprite(gsptPrecious + 1, 1)
  set the cursor of sprite 15 to 0
  set the cursor of sprite 14 to [gCursorNum, gCursorMaskNum]
  set gPreciousState to 1
  go("Idle1")
end
