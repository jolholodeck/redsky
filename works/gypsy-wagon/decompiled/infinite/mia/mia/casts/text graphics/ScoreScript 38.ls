on exitFrame
  global gCursorNum, gCursorMaskNum
  set the cursor of sprite 3 to [gCursorNum, gCursorMaskNum]
  go(the frame)
end
