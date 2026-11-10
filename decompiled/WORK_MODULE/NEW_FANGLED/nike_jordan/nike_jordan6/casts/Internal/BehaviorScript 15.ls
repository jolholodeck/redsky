on exitFrame
  global gRadius, gLevel, gDotSpr, gDustSpr, gFilmSpr, gFirstDust
  set the memberNum of sprite gDustSpr to the number of member gFirstDust
  set the memberNum of sprite gFilmSpr to the number of member "4.1"
  set gLevel to 4
  set gRadius to 53
  set the loc of sprite gDotSpr to point(160, 87)
end
