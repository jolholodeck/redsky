on exitFrame
  global gsptBeautiful, gBeautifulState, gCursorNum, gCursorMaskNum
  puppetSprite(gsptBeautiful + 2, 1)
  puppetSprite(gsptBeautiful + 3, 1)
  set the cursor of sprite 3 to 0
  set the cursor of sprite 4 to 0
  set the cursor of sprite 6 to [gCursorNum, gCursorMaskNum]
  set gBeautifulState to 1
  go("Idle1")
end
