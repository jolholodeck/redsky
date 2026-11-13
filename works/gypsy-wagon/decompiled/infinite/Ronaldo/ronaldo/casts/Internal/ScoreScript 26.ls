global gWordList, gPlayThunder, gComplete, gCountDown

on exitFrame
  hideSprites()
  set gPlayThunder to 1
  set gWordList to [#toMake: 0, #theBest: 0, #player: 0, #in: 0, #the: 0, #world: 0]
  set gComplete to 0
  set gCountDown to 0
end
