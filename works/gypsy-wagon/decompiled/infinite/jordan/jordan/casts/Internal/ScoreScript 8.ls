on exitFrame
  global gFrame1Timer
  if the timer > gFrame1Timer then
    go(the frame - 1)
    set gFrame1Timer to the timer + 120 + random(60 * 4)
  end if
  if rollOver(1) then
    go(#next)
  else
    go(the frame)
  end if
end
