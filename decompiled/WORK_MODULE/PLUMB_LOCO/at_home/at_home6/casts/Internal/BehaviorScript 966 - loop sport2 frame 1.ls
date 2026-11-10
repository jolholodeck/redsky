on exitFrame
  if the quickTimePresent then
    sound stop 1
    go(marker(1))
  else
    go(marker(2))
  end if
end
