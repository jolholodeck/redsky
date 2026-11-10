on mouseUp
  global gTitleFieldSprite, gIngFieldSprite, gInstrFieldSprite, gNoteFieldSprite, gCoverSprite
  if the puppet of sprite gTitleFieldSprite = 1 then
    puppetSprite(gTitleFieldSprite, 0)
  end if
  if the puppet of sprite gIngFieldSprite = 1 then
    puppetSprite(gIngFieldSprite, 0)
  end if
  if the puppet of sprite gInstrFieldSprite = 1 then
    puppetSprite(gInstrFieldSprite, 0)
  end if
  if the puppet of sprite gNoteFieldSprite = 1 then
    puppetSprite(gNoteFieldSprite, 0)
  end if
  if the puppet of sprite gCoverSprite = 1 then
    puppetSprite(gCoverSprite, 0)
  end if
  weeklyButton(1)
end
