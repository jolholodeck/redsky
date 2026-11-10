on mouseUp
  global gNotesVisible
  if gNotesVisible = 1 then
    ding()
    exit
  else
    cleanUpRecipeScreen()
    weeklyButton(2)
  end if
end
