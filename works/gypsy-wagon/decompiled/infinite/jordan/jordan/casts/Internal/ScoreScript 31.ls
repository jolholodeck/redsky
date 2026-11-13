on exitFrame
  global gDustSpr, gFilmSpr
  set the visible of sprite gDustSpr to 1
  set the puppet of sprite gFilmSpr to 1
  go(marker(-1) + 1)
end
