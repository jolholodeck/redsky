on exitFrame
  global gsptStrong, gStrongState, gCursorNum, gCursorMaskNum
  puppetSprite(gsptStrong + 0, 1)
  puppetSprite(gsptStrong + 1, 1)
  set the cursor of sprite 10 to 0
  set the cursor of sprite 11 to 0
  set the cursor of sprite 9 to [gCursorNum, gCursorMaskNum]
  set gStrongState to 1
  go("Idle1")
end
