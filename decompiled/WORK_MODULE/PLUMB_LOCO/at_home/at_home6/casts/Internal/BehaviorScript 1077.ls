global gTicks

on exitFrame
  if the timer >= (gTicks + (4 * 60)) then
    go(the frame + 1)
  else
    go(the frame)
  end if
end
