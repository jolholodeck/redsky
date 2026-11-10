on exitFrame
  global gEndTime
  if the ticks > gEndTime then
    ReturnToWork()
  end if
  go(the frame)
end
