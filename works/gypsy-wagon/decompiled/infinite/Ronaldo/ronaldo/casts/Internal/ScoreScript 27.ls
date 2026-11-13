global gWordList, gPlayThunder, gComplete, gCountDown

on exitFrame
  hideSprites()
  set gPlayThunder to 1
  set gWordList to [#and: 0, #He: 0, #was: 0, #actually: 0, #listening: 0]
  set gComplete to 0
  set gCountDown to 0
end
