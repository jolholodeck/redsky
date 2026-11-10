on mouseUp
  global gNotesVisible
  if gNotesVisible = 1 then
    ding()
    exit
  else
    cleanUpRecipeScreen()
    recipeButton(1)
  end if
end
