on mouseUp
  global gFilmSpr, myDist, gLevel
  if myDist < 48 then
    set the puppet of sprite gFilmSpr to 0
    if gLevel = 4 then
      hideSprites()
      go("blend out")
    else
      go(#next)
    end if
  end if
end
