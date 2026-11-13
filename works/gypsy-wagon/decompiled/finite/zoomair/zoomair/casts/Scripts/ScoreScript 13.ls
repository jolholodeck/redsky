on exitFrame
  if rollOver(11) then
    go("Who are you")
  else
    go(the frame - 1)
  end if
end
