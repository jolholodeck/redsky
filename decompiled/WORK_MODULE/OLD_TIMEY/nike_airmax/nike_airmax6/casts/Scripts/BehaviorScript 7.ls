on exitFrame
  global gIntroPassCount
  set gIntroPassCount to gIntroPassCount + 1
  if gIntroPassCount < 3 then
    go("Intro.loop")
  else
    go("Max Prelude")
  end if
end
