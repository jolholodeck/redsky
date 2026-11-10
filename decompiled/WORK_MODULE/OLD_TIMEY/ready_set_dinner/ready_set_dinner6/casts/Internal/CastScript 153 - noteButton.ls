on mouseUp
  global gNoteFieldSprite, gNotesVisible, gCoverSprite
  if gNotesVisible = 0 then
    set the editableText of sprite gNoteFieldSprite to 1
    puppetSprite(gNoteFieldSprite, 1)
    puppetSprite(gCoverSprite, 1)
    set the loc of sprite gNoteFieldSprite to point(74, 178)
    set the loc of sprite gCoverSprite to point(0, 0)
    set gNotesVisible to 1
  else
    set the editableText of sprite gNoteFieldSprite to 0
    set the loc of sprite gNoteFieldSprite to point(-1000, -1000)
    set the loc of sprite gCoverSprite to point(-1000, -1000)
    puppetSprite(gNoteFieldSprite, 0)
    puppetSprite(gCoverSprite, 0)
    set gNotesVisible to 0
  end if
  updateStage()
end
