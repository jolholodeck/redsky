on enterFrame
  global gCurrCircle, gSlicesCompleted, gFilmSpr
  puppetSprite(gFilmSpr, 1)
  set the memberNum of sprite gFilmSpr to the number of member "1.1"
  set gCurrCircle to 1
  hideSprites()
  set gSlicesCompleted to 0
end
