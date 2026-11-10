on exitFrame
  global gAniList, gSuggestion
  repeat with x = 1 to count(gAniList)
    puppetSprite(getAt(gAniList, x), 1)
  end repeat
  puppetSprite(gSuggestion, 1)
end
