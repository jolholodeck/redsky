global gWhereNext

on mouseDown
  puppetSprite(21, 0)
  puppetSprite(22, 0)
  puppetSprite(24, 0)
  puppetSprite(25, 0)
  set gWhereNext to "mainA"
  go(label("mainReturn") + 2)
end
