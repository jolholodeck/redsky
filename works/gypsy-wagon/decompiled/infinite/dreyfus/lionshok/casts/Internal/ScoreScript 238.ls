on exitFrame
  global musicLoopStarted
  if soundBusy(1) and (musicLoopStarted = 0) then
    go(the frame)
  else
    recordMousePos()
    go("init")
  end if
end
