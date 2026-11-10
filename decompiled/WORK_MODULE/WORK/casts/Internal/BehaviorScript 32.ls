global goWorkMgr

on mouseEnter me
  mMouseEnteredScrollArea(goWorkMgr, #down, the spriteNum of me)
end

on mouseLeave me
  mMouseLeftScrollArea(goWorkMgr, #down, the spriteNum of me)
end

on mouseDown me
  dontPassEvent()
end
