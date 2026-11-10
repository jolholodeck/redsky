on mouseUp
  global gNotesVisible
  if gNotesVisible = 1 then
    ding()
    exit
  else
    cleanUpRecipeScreen()
    backButton(2)
  end if
end
