on exitFrame
  global gSpriteBall, gSpritePutter, gSpriteFakeBall, gSpriteRightFoot, gSpriteLeftFoot, gSpriteTigerLeftFoot, gSpriteTigerRightFoot, gSpriteRollover1, gSpriteRollover2, gBallStart, gSpriteNextHole, gSpriteTigerTalk, gSpriteText
  puppetSprite(gSpriteText, 1)
  set the visible of sprite gSpriteText to 0
  puppetSprite(gSpriteTigerTalk, 1)
  set the visible of sprite gSpriteTigerTalk to 0
  set gBallStart to the loc of sprite gSpriteBall
  set gBallShoot to gBallStart
  puppetSprite(gSpriteFakeBall, 1)
  set the loc of sprite gSpriteFakeBall to gBallStart
  puppetSprite(gSpritePutter, 1)
  puppetSprite(gSpriteBall, 1)
  puppetSprite(gSpriteRightFoot, 1)
  puppetSprite(gSpriteLeftFoot, 1)
  puppetSprite(gSpriteTigerLeftFoot, 1)
  puppetSprite(gSpriteTigerRightFoot, 1)
  puppetSprite(gSpriteRollover1 + 10, 1)
  puppetSprite(gSpriteRollover2 + 10, 1)
end
