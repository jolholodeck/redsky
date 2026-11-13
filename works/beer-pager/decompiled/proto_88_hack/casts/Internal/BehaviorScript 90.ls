global gmyTimer, gMyMem

on exitFrame
  if the timer > gmyTimer then
    if sprite(79).member = member(137, 1) then
      sprite(79).member = member(139, 1)
    else
      sprite(79).member = member(137, 1)
    end if
    gmyTimer = the timer + (60 * 1)
  end if
  go(the frame)
end
