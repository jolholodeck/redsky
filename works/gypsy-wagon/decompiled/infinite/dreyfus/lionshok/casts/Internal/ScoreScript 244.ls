on exitFrame
  global exitCh, againCh, musicPhase
  set againCh to 46
  recordMousePos()
  if musicPhase = 1 then
    sound fadeOut 1, 90
  end if
  puppetSprite(exitCh, 0)
  puppetSprite(againCh, 1)
end
