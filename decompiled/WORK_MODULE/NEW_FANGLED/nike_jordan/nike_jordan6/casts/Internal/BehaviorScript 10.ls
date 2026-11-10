on exitFrame
  global gFilmSpr, gCoverUpSpr, gLevel
  if gLevel = 4 then
    set the visible of sprite gCoverUpSpr to 1
  end if
  getAngle()
  puppetSprite(gFilmSpr, 1)
  checkroll(4, 21)
  checkLoopCompletion()
  go(the frame)
end
