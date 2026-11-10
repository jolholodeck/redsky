on exitFrame
  global gFilmSpr, gRewardTimer
  if the timer > gRewardTimer then
    set the puppet of sprite gFilmSpr to 0
    hideSprites()
    go(#next)
  else
    getAngle()
    puppetSprite(gFilmSpr, 1)
    checkroll(4, 21)
    checkLoopCompletion()
    go(the frame)
  end if
end
