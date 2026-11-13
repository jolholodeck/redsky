on exitFrame
  global musicLoopStarted
  init()
  set the volume of sound 1 to 255
  if not musicLoopStarted then
    puppetSound(1, the number of member "medium loop")
  end if
end
