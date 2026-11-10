global gFlag

on mouseDown
  puppetSprite(24, 0)
  set gFlag to 0
  go("C")
  cursor(-1)
end
