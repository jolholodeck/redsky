global gFlag

on mouseDown
  puppetSprite(24, 0)
  puppetSprite(25, 0)
  set gFlag to 0
  go(marker(-1))
  cursor(-1)
end
