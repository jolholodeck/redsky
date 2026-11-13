on exitFrame
  global gSpriteBug1, gSpriteCell1, gBugDirectionList
  set the loc of sprite gSpriteBug1 to the loc of sprite (gSpriteCell1 + getAt(getAt(gBugDirectionList, 1), 1) - 1)
  set the loc of sprite (gSpriteBug1 + 1) to the loc of sprite (gSpriteCell1 + getAt(getAt(gBugDirectionList, 2), 1) - 1)
  if externalParamValue("sw2") <> "0" then
    go(21)
  end if
end
