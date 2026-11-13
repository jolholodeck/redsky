on enterFrame
  global gMandalaSpr, gDotSpr, gDustSpr, gFirstDust, gCoverUpSpr
  set the memberNum of sprite gDustSpr to gFirstDust
  puppetSprite(gMandalaSpr, 0)
  puppetSprite(gCoverUpSpr, 0)
  set the visible of sprite gDotSpr to 0
end
