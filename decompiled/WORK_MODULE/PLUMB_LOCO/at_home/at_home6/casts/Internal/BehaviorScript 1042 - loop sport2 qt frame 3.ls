on exitFrame
  if the movieTime of sprite 14 > 600 then
    go(the frame + 1)
  else
    go(the frame)
  end if
end
