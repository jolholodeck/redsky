on mouseUp
  global gBallState
  if gBallState > 0 then
    copyTextToOverlay(gsptBall)
    go("ballAnim")
  end if
end
