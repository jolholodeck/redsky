on exitFrame
  puppetSprite(24, 1)
  puppetSprite(25, 1)
  if the quickTimePresent then
    sound stop 1
    go(marker(1))
  else
    go(marker(2))
  end if
end
