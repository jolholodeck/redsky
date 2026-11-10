on exitFrame
  global gDollState, gBallState
  if (gDollState = 2) and (gBallState = 2) then
    go("Scene2Fade")
  else
    go(the frame - 1)
  end if
end
