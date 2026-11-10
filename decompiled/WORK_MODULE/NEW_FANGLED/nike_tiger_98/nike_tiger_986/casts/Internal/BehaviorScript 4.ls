on exitFrame
  global gBallIsMoving, gTigerIsWalking
  if gBallIsMoving then
    moveBall()
  end if
  if gTigerIsWalking then
    moveTiger()
  end if
  go(the frame)
end
