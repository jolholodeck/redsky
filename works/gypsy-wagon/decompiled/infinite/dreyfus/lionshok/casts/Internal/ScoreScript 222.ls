on exitFrame
  global musicLoopStarted
  if soundBusy(1) = 0 then
    puppetSound(1, the number of member "medium loop")
    set musicLoopStarted to 1
  end if
end
