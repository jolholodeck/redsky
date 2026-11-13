on exitFrame
  global gPayoffTimeout
  if (the timer - gPayoffTimeout) > 180 then
    go("Swoosh falls")
  else
    go(the frame - 1)
  end if
end

on mouseUp
  go("Swoosh falls")
end
