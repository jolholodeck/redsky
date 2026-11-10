global _piList, _piArg, _piCode, _typeCode, _typeList, _typeArg, dbIndexList, gHitList, gShoppingList, gNumORecs, gTitleFieldSprite, gIngFieldSprite, gInstrFieldSprite, gNoteFieldSprite, gCurrentHit, gIngStart, gInstrStart, gNotesStart, gPrevHitSprite, gNextHitSprite, gNewSearchSprite, gDeleteRecSprite, gNumOrigRecipes, gNotesVisible, gPrintButtonSprite, gEditButtonSprite, gOpenSlotNumber, gWhichTextSprite, gTabOrder, gHowManyLines, gWeeklyTabs, gCurrentInputField, gCoverSprite

on initGrayCode
  set dbIndexList to []
  set gHitList to [1]
  set gShoppingList to [" ", " ", " ", " ", " ", " ", " "]
  setGlobals()
  readInList()
end

on setGlobals
  set gIngStart to 1000
  set gInstrStart to 2000
  set gNotesStart to 3000
  set gTitleFieldSprite to 12
  set gIngFieldSprite to 13
  set gInstrFieldSprite to 14
  set gCoverSprite to 32
  set gNoteFieldSprite to 33
  set gTabOrder to [gTitleFieldSprite, gIngFieldSprite, gInstrFieldSprite, gNoteFieldSprite]
  set gHowManyLines to [1, 11, 11, 5]
  set gWeeklyTabs to [20, 21, 22, 23, 24, 25, 26]
  set gEditButtonSprite to 16
  set gPrintButtonSprite to 18
  set gDeleteRecSprite to 19
  set gPrevHitSprite to 20
  set gNextHitSprite to 21
  set gNumOrigRecipes to 40
  set gNotesVisible to 0
  set gCurrentHit to 1
  set gDelimiter to "~"
end

on makeChannelsVisible
  repeat with x = 1 to 48
    set the visible of sprite x to 1
  end repeat
end

on readInList
  set the itemDelimiter to "~"
  set theData to field "Recipe Index"
  set gNumORecs to the number of lines in theData
  repeat with x = 1 to gNumORecs
    set theName to item 1 of theData
    set primeIng to item 2 of theData
    set recipeType to item 3 of theData
    set subList to []
    addAt(subList, theName)
    addAt(subList, primeIng)
    addAt(subList, recipeType)
    addAt(dbIndexList, subList)
    delete line 1 of theData
  end repeat
end

on searchList ingChoice, typeChoice
  set gHitList to []
  repeat with x = 1 to gNumORecs
    set tempList to []
    set tempList to getAt(dbIndexList, x)
    set primeIng to getAt(tempList, 2)
    set recipeType to getAt(tempList, 3)
    if (primeIng = "*") or (recipeType = "*") then
      next repeat
    end if
    if (ingChoice = "E") and (typeChoice = "E") then
      addAt(gHitList, x)
      next repeat
    end if
    if (ingChoice = "E") and (typeChoice = recipeType) then
      addAt(gHitList, x)
      next repeat
    end if
    if (typeChoice = "E") and (ingChoice = primeIng) then
      addAt(gHitList, x)
      next repeat
    end if
    if (primeIng = ingChoice) and (recipeType = typeChoice) then
      addAt(gHitList, x)
      next repeat
    end if
  end repeat
  if gHitList = [] then
    set gCurrentHit to 0
    alert("No recipes found which meet your search criteria.")
    set gCurrentHit to 1
    set gHitList to [1]
    exit
  end if
  set firstFind to getAt(gHitList, 1)
  set tempList to getAt(dbIndexList, firstFind)
  set theName to getAt(tempList, 1)
  set the text of field "Title Field" to " "
  set gCurrentHit to 1
  set the text of field "counterText" to "1 of" && count(gHitList)
  recipeSprites(0)
  go("card1")
end

on setRecipeScreen
  puppetSprite(gTitleFieldSprite, 1)
  puppetSprite(gIngFieldSprite, 1)
  puppetSprite(gInstrFieldSprite, 1)
  puppetSprite(gEditButtonSprite, 1)
  puppetSprite(gDeleteRecSprite, 1)
  puppetSprite(gCoverSprite, 1)
  puppetSprite(gNoteFieldSprite, 1)
  set gNotesVisible to 0
  set whichHit to getAt(gHitList, gCurrentHit)
  set the visible of sprite gPrintButtonSprite to 1
  if whichHit <= gNumOrigRecipes then
    set the visible of sprite gEditButtonSprite to 0
    set the visible of sprite gDeleteRecSprite to 0
  else
    set the visible of sprite gEditButtonSprite to 1
    set the visible of sprite gDeleteRecSprite to 1
  end if
  put "Current index number" && gCurrentHit && "and recipe #" && whichHit
  set tempList to getAt(dbIndexList, whichHit)
  set theName to getAt(tempList, 1)
  set the text of field "recipeTitle" to theName
  set the text of field "piText" to letterConverter(getAt(tempList, 2))
  set the text of field "typeText" to letterConverter(getAt(tempList, 3))
  set the castNum of sprite gIngFieldSprite to cast (gIngStart + whichHit)
  set the castNum of sprite gInstrFieldSprite to cast (gInstrStart + whichHit)
  set the castNum of sprite gNoteFieldSprite to cast (gNotesStart + whichHit)
  set the selStart to the number of chars in field the castNum of sprite gNoteFieldSprite
  set gWhichTextSprite to gTitleFieldSprite
  set gCurrentInputField to the castNum of sprite gWhichTextSprite
  set gLineLimit to getAt(gHowManyLines, 1)
end

on showPrevHit
  set the castNum of sprite _prevButtonSprite to the number of member "prev_dwn"
  updateStage()
  if gCurrentHit = 1 then
    ding()
    holdIt(1)
    exit
  else
    click()
    set the editableText of sprite gTitleFieldSprite to 0
    set the editableText of sprite gIngFieldSprite to 0
    set the editableText of sprite gInstrFieldSprite to 0
    set the editableText of sprite gNoteFieldSprite to 0
    set the text of cast "Edit/Save" to "Edit"
    set gCurrentHit to gCurrentHit - 1
    set whichHit to getAt(gHitList, gCurrentHit)
    set the visible of sprite gPrintButtonSprite to 1
    if whichHit <= gNumOrigRecipes then
      set the visible of sprite gEditButtonSprite to 0
      set the visible of sprite gDeleteRecSprite to 0
    else
      set the visible of sprite gEditButtonSprite to 1
      set the visible of sprite gDeleteRecSprite to 1
    end if
    put "Current index number" && gCurrentHit && "and recipe #" && whichHit
    set tempList to getAt(dbIndexList, whichHit)
    set theName to getAt(tempList, 1)
    set the text of field "recipeTitle" to theName
    set the text of cast "dropRecipeText" to theName
    set the castNum of sprite gIngFieldSprite to cast (gIngStart + whichHit)
    set the castNum of sprite gInstrFieldSprite to cast (gInstrStart + whichHit)
    set the castNum of sprite gNoteFieldSprite to cast (gNotesStart + whichHit)
  end if
  set the text of field "piText" to letterConverter(getAt(tempList, 2))
  set the text of field "typeText" to letterConverter(getAt(tempList, 3))
  set the text of field "counterText" to string(gCurrentHit) && "of" && count(gHitList)
  set the selStart to the number of chars in field the castNum of sprite gNoteFieldSprite
  updateStage()
end

on showNextHit
  if gCurrentHit = count(gHitList) then
    ding()
    exit
  else
    click()
    set the editableText of sprite gTitleFieldSprite to 0
    set the editableText of sprite gIngFieldSprite to 0
    set the editableText of sprite gInstrFieldSprite to 0
    set the editableText of sprite gNoteFieldSprite to 0
    set the text of cast "Edit/Save" to "Edit"
    set gCurrentHit to gCurrentHit + 1
    set whichHit to getAt(gHitList, gCurrentHit)
    set the visible of sprite gPrintButtonSprite to 1
    if whichHit <= gNumOrigRecipes then
      set the visible of sprite gEditButtonSprite to 0
      set the visible of sprite gDeleteRecSprite to 0
    else
      set the visible of sprite gEditButtonSprite to 1
      set the visible of sprite gDeleteRecSprite to 1
    end if
    put "Current index number" && gCurrentHit && "and recipe #" && whichHit
    set tempList to getAt(dbIndexList, whichHit)
    set theName to getAt(tempList, 1)
    set the text of field "recipeTitle" to theName
    set the text of cast "dropRecipeText" to theName
    set the castNum of sprite gIngFieldSprite to cast (gIngStart + whichHit)
    set the castNum of sprite gInstrFieldSprite to cast (gInstrStart + whichHit)
    set the castNum of sprite gNoteFieldSprite to cast (gNotesStart + whichHit)
  end if
  set the text of field "piText" to letterConverter(getAt(tempList, 2))
  set the text of field "typeText" to letterConverter(getAt(tempList, 3))
  set the text of field "counterText" to string(gCurrentHit) && "of" && count(gHitList)
  set the selStart to the number of chars in field the castNum of sprite gNoteFieldSprite
  updateStage()
end

on createNewRecord
  puppetSprite(gTitleFieldSprite, 1)
  puppetSprite(gIngFieldSprite, 1)
  puppetSprite(gInstrFieldSprite, 1)
  puppetSprite(gNoteFieldSprite, 1)
  puppetSprite(gCoverSprite, 1)
  set the editableText of sprite gTitleFieldSprite to 1
  set the editableText of sprite gIngFieldSprite to 1
  set the editableText of sprite gInstrFieldSprite to 1
  set the editableText of sprite gNoteFieldSprite to 1
  set gOpenSlotNumber to 0
  repeat with x = 1 to gNumORecs
    set tempList to []
    set tempList to getAt(dbIndexList, x)
    set checkSlot to getAt(tempList, 3)
    if checkSlot = "*" then
      set gOpenSlotNumber to x
      exit repeat
    end if
  end repeat
  if gOpenSlotNumber = 0 then
    set gOpenSlotNumber to gNumORecs + 1
  end if
  duplicate(cast "Ingredient Template", 1000 + gOpenSlotNumber)
  set the name of cast (1000 + gOpenSlotNumber) to EMPTY
  set the text of cast (1000 + gOpenSlotNumber) to "Type ingredients here."
  duplicate(cast "Directions Template", 2000 + gOpenSlotNumber)
  set the name of cast (2000 + gOpenSlotNumber) to EMPTY
  set the text of cast (2000 + gOpenSlotNumber) to "Type directions here."
  duplicate(cast "Notes Template", 3000 + gOpenSlotNumber)
  set the name of cast (3000 + gOpenSlotNumber) to EMPTY
  set the text of cast (3000 + gOpenSlotNumber) to "Type notes here."
  set the text of field "recipeTitle" to "Replace this with your recipe title."
end

on letterConverter letter
  if letter = "C" then
    return "Poultry"
  end if
  if letter = "B" then
    return "Beef"
  end if
  if letter = "S" then
    return "Seafood"
  end if
  if letter = "P" then
    return "Pork"
  end if
  if letter = "V" then
    return "Vegetarian"
  end if
  if letter = "U" then
    return "Soup"
  end if
  if letter = "D" then
    return "Salads"
  end if
  if letter = "O" then
    return "Other"
  end if
  if letter = "L" then
    return "Last Minute Wonders"
  end if
  if letter = "K" then
    return "Kid Pleasers"
  end if
  if letter = "A" then
    return "American Favorites"
  end if
  if letter = "T" then
    return "Dinner for Two"
  end if
  if letter = "W" then
    return "Around the World"
  end if
  if letter = "M" then
    return "My Own"
  end if
end

on saveRecord
  global gPrimaryIng, gRecipeType
  if the text of field "recipeTitle" = EMPTY then
    alert("You need to give your recipe a name in order to save it!")
    exit
  end if
  clearNotes()
  set subList to []
  set lineCount to the number of chars in field "recipeTitle"
  set theName to line 1 of (field "recipeTitle")
  set primeIng to gPrimaryIng
  set recipeType to gRecipeType
  addAt(subList, theName)
  addAt(subList, primeIng)
  addAt(subList, recipeType)
  addAt(dbIndexList, gOpenSlotNumber, subList)
  if gOpenSlotNumber <= gNumORecs then
    put theName & "~" & primeIng & "~" & recipeType & "~" into line gOpenSlotNumber of (field "Recipe Index")
  else
    put RETURN after line gNumORecs of (field "Recipe Index")
    set gNumORecs to gNumORecs + 1
    put theName & "~" & primeIng & "~" & recipeType & "~" into line gNumORecs of (field 999)
  end if
  set dbIndexList to []
  readInList()
  cleanUpRecipeScreen()
  go("recipe0")
end

on cancelSave
  cleanUpRecipeScreen()
  go("recipe0")
  set the text of field "recipeTitle" to " "
end

on setUpAddScreen
  set the visible of sprite gNewSearchSprite to 1
  set the visible of sprite gDeleteRecSprite to 1
  set the visible of sprite gPrintButtonSprite to 1
  set the castNum of sprite gIngFieldSprite to cast (1000 + gOpenSlotNumber)
  set the castNum of sprite gInstrFieldSprite to cast (2000 + gOpenSlotNumber)
  set the castNum of sprite gNoteFieldSprite to cast (3000 + gOpenSlotNumber)
  set gWhichTextSprite to gTitleFieldSprite
  set gCurrentInputField to the castNum of sprite gWhichTextSprite
  set gLineLimit to getAt(gHowManyLines, 1)
end

on deleteRecord
  clearNotes()
  set whichHit to getAt(gHitList, gCurrentHit)
  if whichHit <= gNumOrigRecipes then
    alert("This recipe is not deletable!")
  else
    set subList to []
    addAt(subList, "*")
    addAt(subList, "*")
    addAt(subList, "*")
    setAt(dbIndexList, whichHit, subList)
    put "*~*~*~" into line whichHit of (field "Recipe Index")
    set dbIndexList to []
    readInList()
    deleteAt(gHitList, gCurrentHit)
    if count(gHitList) = 0 then
      cleanUpRecipeScreen()
      go("recipe0")
      exit
    end if
    put "gCurrentHit = " && gCurrentHit && "     Number of items in hit list +1 = " && string(count(gHitList) + 1)
    if gCurrentHit = (count(gHitList) + 1) then
      set gCurrentHit to gCurrentHit - 1
      set whichHit to getAt(gHitList, gCurrentHit)
      put "Current index number" && gCurrentHit && "and recipe #" && whichHit
      set tempList to getAt(dbIndexList, whichHit)
      set theName to getAt(tempList, 1)
      set the text of field "recipeTitle" to theName
      set the castNum of sprite gIngFieldSprite to cast (gIngStart + whichHit)
      set the castNum of sprite gInstrFieldSprite to cast (gInstrStart + whichHit)
      set the castNum of sprite gNoteFieldSprite to cast (gNotesStart + whichHit)
    else
      set whichHit to getAt(gHitList, gCurrentHit)
      put "Current index number" && gCurrentHit && "and recipe #" && whichHit
      set tempList to getAt(dbIndexList, whichHit)
      set theName to getAt(tempList, 1)
      set the text of field "recipeTitle" to theName
      set the castNum of sprite gIngFieldSprite to cast (gIngStart + whichHit)
      set the castNum of sprite gInstrFieldSprite to cast (gInstrStart + whichHit)
      set the castNum of sprite gNoteFieldSprite to cast (gNotesStart + whichHit)
    end if
  end if
  set the text of field "counterText" to string(gCurrentHit) && "of" && count(gHitList)
  if whichHit <= gNumOrigRecipes then
    set the visible of sprite gEditButtonSprite to 0
    set the visible of sprite gDeleteRecSprite to 0
  else
    set the visible of sprite gEditButtonSprite to 1
    set the visible of sprite gDeleteRecSprite to 1
  end if
  updateStage()
end

on cleanUpRecipeScreen
  set the visible of sprite gDeleteRecSprite to 1
  set the visible of sprite gPrintButtonSprite to 1
  set the visible of sprite gEditButtonSprite to 1
  set the text of cast "Edit/Save" to "Edit"
  set the loc of sprite gNoteFieldSprite to point(-1000, -1000)
  set the loc of sprite gCoverSprite to point(-1000, -1000)
  set the editableText of sprite gTitleFieldSprite to 0
  set the editableText of sprite gIngFieldSprite to 0
  set the editableText of sprite gInstrFieldSprite to 0
  set the editableText of sprite gNoteFieldSprite to 0
  puppetSprite(gTitleFieldSprite, 0)
  puppetSprite(gIngFieldSprite, 0)
  puppetSprite(gInstrFieldSprite, 0)
  puppetSprite(gNoteFieldSprite, 0)
  puppetSprite(gCoverSprite, 0)
  puppetSprite(gEditButtonSprite, 0)
  puppetSprite(gPrintButtonSprite, 0)
  puppetSprite(gDeleteRecSprite, 0)
  clearNotes()
end

on addARecord
  global _PrimaryIng, _RecipeType
  if gNumORecs > 999 then
    alert("Unable to complete request. 1000 recipe limit reached.")
  else
    recipeSprites(0)
    go("addR1")
    createNewRecord()
  end if
end
