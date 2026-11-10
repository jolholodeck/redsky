global goWorkMgr

on mouseDown
  mExit(goWorkMgr)
end

on mouseEnter
  mExitButtonStartRoll(goWorkMgr)
end

on mouseLeave
  mExitButtonStopRoll(goWorkMgr)
end
