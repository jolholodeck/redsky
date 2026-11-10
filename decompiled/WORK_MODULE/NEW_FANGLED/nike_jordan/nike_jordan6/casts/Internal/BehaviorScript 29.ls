on enterFrame
  global gCurrCircle, gSlicesCompleted, gFilmSpr, gCoverUpSpr, gRewardTimer
  set gRewardTimer to the timer + (30 * 60)
  puppetSprite(gFilmSpr, 1)
  puppetSprite(gCoverUpSpr, 1)
  set the visible of sprite gCoverUpSpr to 1
  set the memberNum of sprite gFilmSpr to the number of member "4.1"
  set the memberNum of sprite gCoverUpSpr to the number of member "mandala.overlay"
  set gCurrCircle to 4
  hideSprites()
  set gSlicesCompleted to 0
  puppetSprite(27, 1)
end
