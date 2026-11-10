on enterFrame
  global gCurrCircle, gSlicesCompleted, gFilmSpr
  puppetSprite(gFilmSpr, 1)
  set the memberNum of sprite gFilmSpr to the number of member "2.1"
  set gCurrCircle to 2
  hideSprites()
  set gSlicesCompleted to 0
end
