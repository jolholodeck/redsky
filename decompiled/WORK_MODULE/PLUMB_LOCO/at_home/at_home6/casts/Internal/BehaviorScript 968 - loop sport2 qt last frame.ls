on exitFrame
  if the movieTime of sprite 14 = the stopTime of sprite 14 then
    go("loop")
  else
    go(the frame)
  end if
end
