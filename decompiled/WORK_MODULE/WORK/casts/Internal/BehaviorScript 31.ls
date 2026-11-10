global goWorkMgr

on mouseEnter me
  mMouseEnteredScrollArea(goWorkMgr, #Up, the spriteNum of me)
end

on mouseLeave me
  mMouseLeftScrollArea(goWorkMgr, #Up, the spriteNum of me)
end

on mouseDown me
  dontPassEvent()
end
