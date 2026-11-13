on exitFrame
  global gCDHnowtimer
  if (the timer - gCDHnowtimer) < 120 then
    go(the frame)
  else
    go("firstLoop")
  end if
end
