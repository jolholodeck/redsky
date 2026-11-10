on mouseUp
  global gNotesVisible
  if gNotesVisible = 1 then
    ding()
    exit
  else
    showPrevHit()
  end if
end
