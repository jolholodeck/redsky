global gMetronome

on exitFrame
  if gMetronome then
    go(the frame - 1)
  else
    go(the frame)
  end if
end
