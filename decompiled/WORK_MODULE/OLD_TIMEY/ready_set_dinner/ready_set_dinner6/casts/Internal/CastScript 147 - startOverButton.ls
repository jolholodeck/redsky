on mouseUp
  global _piArg, _typeArg, gPrimaryIng, gRecipeType
  click()
  status(2, " ")
  set _piArg to 0
  set _typeArg to 0
  set gPrimaryIng to "E"
  set gRecipeType to "E"
  set the text of cast "ingredientDisplay" to "all ingredients"
  set the text of cast "typeDisplay" to "all recipe types"
  go("recipe1")
end
