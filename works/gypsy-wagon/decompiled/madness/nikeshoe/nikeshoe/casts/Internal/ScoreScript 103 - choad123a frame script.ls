on exitFrame
  if (the mouseH > 170) or (the mouseV > 80) then
    go(chars(the frameLabel, 1, 6))
  else
    go(the frame)
  end if
end
