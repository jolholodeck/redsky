on exitFrame
  global gsptTough, gToughState, gCursorNum, gCursorMaskNum
  puppetSprite(gsptTough + 2, 1)
  puppetSprite(gsptTough + 3, 1)
  set the cursor of sprite 18 to 0
  set the cursor of sprite 19 to 0
  set the cursor of sprite 21 to [gCursorNum, gCursorMaskNum]
  set gToughState to 1
  go("Idle1")
end
