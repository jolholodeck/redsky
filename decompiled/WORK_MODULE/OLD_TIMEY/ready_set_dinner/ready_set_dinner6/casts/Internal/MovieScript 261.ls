global _fixpal, _bg, _line, _piCode, _typeCode, _day, _autoHelp, _helpOn, _piArg, _typeArg, _mode, _piList, _typeList, _factList, _lastScreen, _selectDay, _helpButtonSprite, _recipeButtonSprite, _weeklyButtonSprite, _groceryButtonSprite, _exitButtonSprite, _prevButtonSprite, _nextButtonSprite, _startDepth, dbIndexList, gHitList, gNumORecs, gTitleFieldSprite, gIngFieldSprite, gInstrFieldSprite, gNoteFieldSprite, gCoverSprite, gCurrentHit, gIngStart, gInstrStart, gNotesStart, gPrevHitSprite, gNextHitSprite, gNewSearchSprite, gDeleteRecSprite, gNumOrigRecipes, gPrimaryIng, gRecipeType, gHoldIng

on setNotesText
  if the text of field "Grocery Notes" = EMPTY then
    set the text of cast "Grocery Notes" to "  " & RETURN & RETURN & RETURN & RETURN & " "
  end if
  set the textSize of field "Grocery Notes" to 9
  set the textHeight of field "Grocery Notes" to 12
  set the textStyle of field "Grocery Notes" to "plain"
  set the textFont of field "Grocery Notes" to "Geneva"
end

on startMovie
  setNotesText()
  initGrayCode()
  set the text of cast "Edit/Save" to "Edit"
  clearWeeklyFields()
  set _helpButtonSprite to 2
  set _recipeButtonSprite to 3
  set _weeklyButtonSprite to 4
  set _groceryButtonSprite to 5
  set _exitButtonSprite to 6
  set _prevButtonSprite to 22
  set _nextButtonSprite to 23
  set _selectDay to 0
  set gPrimaryIng to "E"
  set gRecipeType to "E"
  set the text of cast "ingredientDisplay" to "all ingredients"
  set the text of cast "typeDisplay" to "all recipe types"
  set _day to EMPTY
  set _piArg to 0
  set _lastScreen to 0
  set _typeArg to 0
  set _helpOn to 0
  set _autoHelp to 1
  set _line to "_______________________________________________"
  if the machineType <> 256 then
    set _startDepth to the colorDepth
    setColorDepth(1)
  end if
  set _piList to ["Poultry", "Pork", "Beef", "Fish", "Vegetarian", "Salads", "Soup", "Other"]
  set _piCode to ["C", "P", "B", "S", "V", "U", "D", "O"]
  set _typeList to ["Last Minute Wonders", "Kid Pleasers", "American Favorites", "Dinner for Two", "Around the World", "Other"]
  set _typeCode to ["L", "K", "A", "T", "W", "O"]
  loadPotatoFacts()
  status(0, " ")
end

on stopMovie
  if the machineType <> 256 then
    setColorDepth(0)
  end if
end

on keyDown
  CheckForExitKey()
end

on systemExitCleanupHandler
  put "CHILD: in systemExitCleanupHandler"
  sound stop 1
  sound stop 2
end

on setColorDepth whichWay
  global _startDepth
  if whichWay = 1 then
    set the colorDepth to 8
  else
    if whichWay = 0 then
      set the colorDepth to _startDepth
    end if
  end if
end

on holdIt quarterSeconds
  set now to the timer
  repeat while the timer < (now + (quarterSeconds * 15))
    if the mouseDown then
      exit
    end if
  end repeat
end

on clearWeeklyFields
  set the text of cast "sunRecipe" to " "
  set the text of cast "monRecipe" to " "
  set the text of cast "tueRecipe" to " "
  set the text of cast "wedRecipe" to " "
  set the text of cast "thuRecipe" to " "
  set the text of cast "friRecipe" to " "
  set the text of cast "satRecipe" to " "
end

on click
  puppetSound("click")
  updateStage()
end

on ding
  puppetSound("ding")
  updateStage()
end

on status which, sText
  if which = 0 then
    set the text of cast "statusBox1" to sText
    set the text of cast "statusBox2" to sText
  else
    if which = 1 then
      set the text of cast "statusBox1" to sText
    else
      if which = 2 then
        set the text of cast "statusBox2" to sText
      end if
    end if
  end if
  updateStage()
end

on helpButton from
  if from = 0 then
    set the castNum of sprite _helpButtonSprite to the number of member "help_dwn"
    click()
    holdIt(1)
    set the castNum of sprite _helpButtonSprite to the number of member "help_up"
    updateStage()
    go("mainHelp")
  else
    if from = 1 then
      set the castNum of sprite _helpButtonSprite to the number of member "help_dwn"
      click()
      holdIt(1)
      set the castNum of sprite _helpButtonSprite to the number of member "help_up"
      updateStage()
      recipeHelp()
    else
      if from = 2 then
        ding()
      else
        if from = 3 then
          set the castNum of sprite _helpButtonSprite to the number of member "help_dwn"
          click()
          holdIt(1)
          set the castNum of sprite _helpButtonSprite to the number of member "help_up"
          updateStage()
          go("weeklyHelp")
        else
          if from = 4 then
            ding()
          end if
        end if
      end if
    end if
  end if
end

on recipeButton from
  if from = 0 then
    set the castNum of sprite _recipeButtonSprite to the number of member "recipe_dwn"
    click()
    holdIt(1)
    set the castNum of sprite _recipeButtonSprite to the number of member "recipe_up"
    set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_up"
    set the castNum of sprite _groceryButtonSprite to the number of member "grocery_dim"
    updateStage()
    set the castNum of sprite _recipeButtonSprite to the number of member "recipe_dim"
    go("recipe0")
  else
    if from = 1 then
      ding()
    else
      if from = 2 then
        ding()
      else
        if from = 3 then
          set the castNum of sprite _recipeButtonSprite to the number of member "recipe_dwn"
          click()
          holdIt(1)
          set the castNum of sprite _recipeButtonSprite to the number of member "recipe_up"
          set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_up"
          set the castNum of sprite _groceryButtonSprite to the number of member "grocery_up"
          updateStage()
          set the castNum of sprite _recipeButtonSprite to the number of member "recipe_dim"
          go("recipe0")
        else
          if from = 4 then
            ding()
          end if
        end if
      end if
    end if
  end if
end

on weeklyButton from
  global gNotesVisible
  if from = 0 then
    if gNotesVisible <> 1 then
      set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_dwn"
      click()
      holdIt(1)
      set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_up"
      set the castNum of sprite _recipeButtonSprite to the number of member "recipe_up"
      set the castNum of sprite _groceryButtonSprite to the number of member "grocery_up"
      updateStage()
      set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_dim"
      cancelSave()
      go("weekly1")
    else
      ding()
    end if
  else
    if from = 1 then
      set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_dwn"
      click()
      holdIt(1)
      set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_up"
      set the castNum of sprite _recipeButtonSprite to the number of member "recipe_up"
      set the castNum of sprite _groceryButtonSprite to the number of member "grocery_up"
      updateStage()
      set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_dim"
      set the text of cast "dropRecipeText" to the text of cast "recipeTitle"
      recipeSprites(0)
      go("weekly1")
    else
      if from = 2 then
        set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_dwn"
        click()
        holdIt(1)
        set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_up"
        set the castNum of sprite _recipeButtonSprite to the number of member "recipe_up"
        set the castNum of sprite _groceryButtonSprite to the number of member "grocery_up"
        updateStage()
        set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_dim"
        set whichCast to the castNum of sprite gIngFieldSprite
        set gHoldIng to the text of cast whichCast
        set the text of cast "dropRecipeText" to the text of cast "recipeTitle"
        cleanUpRecipeScreen()
        go("weeklyAdd")
      else
        if from = 3 then
          ding()
        else
          if from = 4 then
            ding()
          end if
        end if
      end if
    end if
  end if
end

on groceryButton from
  global gNotesVisible
  if from = 0 then
    if gNotesVisible = 1 then
      ding()
    else
      ding()
      go("grocHelp")
    end if
  else
    if from = 1 then
      ding()
      set st1Temp to the text of cast "statusBox1"
      set st2Temp to the text of cast "statusBox2"
      status(1, " ")
      status(2, " You need to find a recipe before you can print a grocery list.")
      holdIt(12)
      status(1, st1Temp)
      status(2, st2Temp)
    else
      if from = 2 then
        set _lastScreen to 2
        set the castNum of sprite _groceryButtonSprite to the number of member "grocery_dwn"
        click()
        preserveState()
        set whichCast to the castNum of sprite gTitleFieldSprite
        set printTitle to the text of cast whichCast
        set whichCast to the castNum of sprite gIngFieldSprite
        set printIng to the text of cast whichCast
        set whichCast to the castNum of sprite gInstrFieldSprite
        set printInstr to the text of cast whichCast
        set whichCast to the castNum of sprite gNoteFieldSprite
        set printNote to the text of cast whichCast
        puppetSprite(gTitleFieldSprite, 0)
        puppetSprite(gIngFieldSprite, 0)
        puppetSprite(gInstrFieldSprite, 0)
        puppetSprite(gNoteFieldSprite, 0)
        puppetSprite(gCoverSprite, 0)
        recipeSprites(0)
        set the castNum of sprite _groceryButtonSprite to the number of member "grocery_up"
        set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_up"
        set the castNum of sprite _recipeButtonSprite to the number of member "recipe_up"
        updateStage()
        set the castNum of sprite _groceryButtonSprite to the number of member "grocery_dim"
        set whichHit to getAt(gHitList, gCurrentHit)
        set tempIng to the text of cast (gIngStart + whichHit)
        set tempText to "GROCERY LIST" & RETURN & RETURN & the text of cast "recipeTitle" & RETURN & the text of cast "ingText" & RETURN & tempIng & RETURN & _line & RETURN & RETURN
        set the text of cast "Print Dump" to tempText
        setNotesText()
        set the text of cast "grocery notes" to "Notes:"
        setNotesText()
        go("gList0")
      else
        if from = 3 then
          set _lastScreen to 3
          set the castNum of sprite _groceryButtonSprite to the number of member "grocery_dwn"
          click()
          holdIt(1)
          set the castNum of sprite _groceryButtonSprite to the number of member "grocery_up"
          set the castNum of sprite _weeklyButtonSprite to the number of member "weekly_dim"
          set the castNum of sprite _recipeButtonSprite to the number of member "recipe_dim"
          updateStage()
          set the castNum of sprite _groceryButtonSprite to the number of member "grocery_dim"
          set tempText to "                       This Week's Grocery List" & RETURN & "                       " & the long date & RETURN & RETURN & "SUNDAY" & RETURN & RETURN & line 1 of (field "sunRecipe") & ":" & RETURN & line 2 of (field "sunRecipe") & RETURN & RETURN & getAt(gShoppingList, 1) & RETURN & RETURN & "MONDAY" & RETURN & RETURN & line 1 of (field "monRecipe") & ":" & RETURN & line 2 of (field "monRecipe") & RETURN & RETURN & getAt(gShoppingList, 2) & RETURN & RETURN & "TUESDAY" & RETURN & RETURN & line 1 of (field "tueRecipe") & ":" & RETURN & line 2 of (field "tueRecipe") & RETURN & RETURN & getAt(gShoppingList, 3) & RETURN & RETURN & "WEDNESDAY" & RETURN & RETURN & line 1 of (field "wedRecipe") & ":" & RETURN & line 2 of (field "wedRecipe") & RETURN & RETURN & getAt(gShoppingList, 4) & RETURN & RETURN & "THURSDAY" & RETURN & RETURN & line 1 of (field "thuRecipe") & ":" & RETURN & line 2 of (field "thuRecipe") & RETURN & RETURN & getAt(gShoppingList, 5) & RETURN & RETURN & "FRIDAY" & RETURN & RETURN & line 1 of (field "friRecipe") & ":" & RETURN & line 2 of (field "friRecipe") & RETURN & RETURN & getAt(gShoppingList, 6) & RETURN & RETURN & "SATURDAY" & RETURN & RETURN & line 1 of (field "satRecipe") & ":" & RETURN & line 2 of (field "satRecipe") & RETURN & RETURN & getAt(gShoppingList, 7) & RETURN & RETURN & _line & RETURN & RETURN
          setNotesText()
          set the text of cast "grocery notes" to "Notes:"
          setNotesText()
          set the text of cast "Print Dump" to tempText
          go("gList0")
        else
          if from = 4 then
            ding()
          end if
        end if
      end if
    end if
  end if
end

on exitButton
  puppetSound("bell")
  go("exit")
end

on backButton from
  put from, _lastScreen
  set the castNum of sprite _exitButtonSprite to the number of member "back_dwn"
  click()
  holdIt(1)
  set the castNum of sprite _exitButtonSprite to the number of member "back_up"
  updateStage()
  if from = 0 then
    puppetSound("bell")
    go("exit")
  else
    if from = 1 then
      recipeSprites(0)
      set the castNum of sprite _exitButtonSprite to the number of member "exit_up"
      go("mainLoop")
    else
      if from = 2 then
        set the text of cast "piRolloverText" to " "
        cleanUpRecipeScreen()
        go("recipe0")
      else
        if from = 3 then
          go("mainLoop")
        else
          if from = 4 then
            if _lastScreen = 2 then
              set _lastScreen to 0
              go("card1")
            else
              if _lastScreen = 3 then
                set _lastScreen to 0
                go("weekly1")
              end if
            end if
          end if
        end if
      end if
    end if
  end if
end

on dropRecipe day
  click()
  set wkRecipes to ["sunRecipe", "monRecipe", "tueRecipe", "wedRecipe", "thuRecipe", "friRecipe", "satRecipe"]
  set the text of cast getAt(wkRecipes, day) to the text of cast "dropRecipeText"
  setAt(gShoppingList, day, gHoldIng)
  go("weekly1a")
end

on searchButton
  click()
  set the text of cast "Edit/Save" to "Edit"
  searchList(gPrimaryIng, gRecipeType)
end

on checkRollOvers
  global _piArg, _typeArg
  set theType to EMPTY
  set theTypeList to ["Salads", "Soup", "Vegetarian", "Fish", "Beef", "Pork", "Poultry"]
  repeat with x = 10 to 16
    if rollOver(x) then
      set theType to getAt(theTypeList, x - 9)
      set the text of cast "piRolloverText" to theType
    end if
  end repeat
  if theType = EMPTY then
    set the text of cast "piRolloverText" to " "
  end if
  if rollOver(26) then
    set the castNum of sprite 32 to the number of member "check"
    updateStage()
    holdIt(1)
    set the castNum of sprite 32 to the number of member "_null"
  else
    if rollOver(27) then
      set the castNum of sprite 33 to the number of member "check"
      updateStage()
      holdIt(1)
      set the castNum of sprite 33 to the number of member "_null"
    else
      if rollOver(28) then
        set the castNum of sprite 34 to the number of member "check"
        updateStage()
        holdIt(1)
        set the castNum of sprite 34 to the number of member "_null"
      else
        if rollOver(29) then
          set the castNum of sprite 35 to the number of member "check"
          updateStage()
          holdIt(1)
          set the castNum of sprite 35 to the number of member "_null"
        else
          if rollOver(30) then
            set the castNum of sprite 36 to the number of member "check"
            updateStage()
            holdIt(1)
            set the castNum of sprite 36 to the number of member "_null"
          end if
        end if
      end if
    end if
  end if
end

on clickTab which
  global _piArg, _typeArg, _piList
  click()
  set the text of cast "piRolloverText" to " "
  set oldpiArg to _piArg
  if which = 1 then
    set _piArg to 1
    set gPrimaryIng to "C"
    set piDisplay to "Poultry"
    set the castNum of sprite 24 to the number of member "pi-1b"
  else
    if which = 2 then
      set _piArg to 2
      set gPrimaryIng to "P"
      set piDisplay to "Pork"
      set the castNum of sprite 23 to the number of member "pi-2b"
    else
      if which = 3 then
        set _piArg to 3
        set gPrimaryIng to "B"
        set piDisplay to "Beef"
        set the castNum of sprite 22 to the number of member "pi-3b"
      else
        if which = 4 then
          set _piArg to 4
          set gPrimaryIng to "S"
          set piDisplay to "Fish"
          set the castNum of sprite 21 to the number of member "pi-4b"
        else
          if which = 5 then
            set _piArg to 5
            set gPrimaryIng to "V"
            set piDisplay to "Vegetarian"
            set the castNum of sprite 20 to the number of member "pi-5b"
          else
            if which = 6 then
              set _piArg to 6
              set gPrimaryIng to "U"
              set piDisplay to "Soup"
              set the castNum of sprite 19 to the number of member "pi-6b"
            else
              if which = 7 then
                set _piArg to 7
                set gPrimaryIng to "D"
                set piDisplay to "Salads"
                set the castNum of sprite 18 to the number of member "pi-7b"
              end if
            end if
          end if
        end if
      end if
    end if
  end if
  set the text of cast "ingredientDisplay" to piDisplay
  updateStage()
  if _piArg <> oldpiArg then
    if oldpiArg = 1 then
      set the castNum of sprite 24 to the number of member "_null"
    else
      if oldpiArg = 2 then
        set the castNum of sprite 23 to the number of member "_null"
      else
        if oldpiArg = 3 then
          set the castNum of sprite 22 to the number of member "_null"
        else
          if oldpiArg = 4 then
            set the castNum of sprite 21 to the number of member "_null"
          else
            if oldpiArg = 5 then
              set the castNum of sprite 20 to the number of member "_null"
            else
              if oldpiArg = 6 then
                set the castNum of sprite 19 to the number of member "_null"
              else
                if oldpiArg = 7 then
                  set the castNum of sprite 18 to the number of member "_null"
                end if
              end if
            end if
          end if
        end if
      end if
    end if
    updateStage()
  end if
  if _typeArg <> 0 then
    set the castNum of sprite 42 to the number of member "addButton"
    status(1, "Click the Show Me" & RETURN & "button to see recipes.")
    status(2, "Or click the Add a New Recipe button to add a new recipe in this category.")
  else
    status(1, "Click a Recipe Type at left or click Show Me to see recipes.")
    status(2, "Or click the Add a New Recipe button to add a new recipe.")
    set the castNum of sprite 42 to the number of member "addButton"
    set the castNum of sprite 43 to the number of member "searchButton"
    set the castNum of sprite 44 to the number of member "startOverButton"
  end if
end

on clickType which
  global _piArg, _typeArg
  click()
  set oldTypeArg to _typeArg
  if which = 1 then
    set _typeArg to 1
    set gRecipeType to "L"
    set tDisplay to "Last Minute Wonders"
    set the castNum of sprite 32 to the number of member "check"
  else
    if which = 2 then
      set _typeArg to 2
      set gRecipeType to "K"
      set tDisplay to "Kid Pleasers"
      set the castNum of sprite 33 to the number of member "check"
    else
      if which = 3 then
        set _typeArg to 3
        set gRecipeType to "A"
        set tDisplay to "American Favorites"
        set the castNum of sprite 34 to the number of member "check"
      else
        if which = 4 then
          set _typeArg to 4
          set gRecipeType to "T"
          set tDisplay to "Dinner for Two"
          set the castNum of sprite 35 to the number of member "check"
        else
          if which = 5 then
            set _typeArg to 5
            set gRecipeType to "W"
            set tDisplay to "Around the World"
            set the castNum of sprite 36 to the number of member "check"
          end if
        end if
      end if
    end if
  end if
  set the text of cast "typeDisplay" to tDisplay
  updateStage()
  if _typeArg <> oldTypeArg then
    if oldTypeArg = 1 then
      set the castNum of sprite 32 to the number of member "_null"
    else
      if oldTypeArg = 2 then
        set the castNum of sprite 33 to the number of member "_null"
      else
        if oldTypeArg = 3 then
          set the castNum of sprite 34 to the number of member "_null"
        else
          if oldTypeArg = 4 then
            set the castNum of sprite 35 to the number of member "_null"
          else
            if oldTypeArg = 5 then
              set the castNum of sprite 36 to the number of member "_null"
            end if
          end if
        end if
      end if
    end if
    updateStage()
  end if
  if _piArg <> 0 then
    set the castNum of sprite 42 to the number of member "addButton"
    status(1, "Click the Show Me" & RETURN & "button to see recipes.")
    status(2, " Or click the Add a New Recipe button to add a new recipe in this category.")
  else
    status(1, "Click a Primary Ingredient above or click Show Me to see recipes")
    status(2, "Or click the Add a New Recipe button to add a new recipe.")
    set the castNum of sprite 42 to the number of member "addButton"
    set the castNum of sprite 43 to the number of member "searchButton"
    set the castNum of sprite 44 to the number of member "startOverButton"
  end if
end

on setUpRecipeFile
  global _piArg, _typeArg, _selectDay
  if _selectDay = 1 then
    status(2, " ")
    set _selectDay to 0
  else
    status(1, "Select a Primary Ingredient" & RETURN & "by clicking a tab above...")
    status(2, "... or a Recipe Type" & RETURN & "by clicking a label at left.")
  end if
  repeat with x = 17 to 24
    set the castNum of sprite x to the number of member "_null"
  end repeat
  repeat with x = 26 to 30
    set the castNum of sprite x to the number of member "_null"
  end repeat
  set the text of cast "piRolloverText" to " "
  set the castNum of sprite 42 to the number of member "addButton"
  set the castNum of sprite 43 to the number of member "searchButton"
  set the castNum of sprite 44 to the number of member "startOverButton"
  updateStage()
end

on clickDay which
  global _selectDay
  set _selectDay to 1
  click()
  set theDays to ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  set day to getAt(theDays, which)
  status(1, "Pick a recipe for " & day)
  go("recipe0")
end

on helpSprites state
  repeat with n = 40 to 41
    puppetSprite(n, state)
  end repeat
end
