on mouseUp
  global gHitList, gCurrentHit, gNoteFieldSprite, gNotesVisible
  set whichHit to getAt(gHitList, gCurrentHit)
  if whichHit > 40 then
    makeFieldsEditable()
    updateStage()
  end if
end
