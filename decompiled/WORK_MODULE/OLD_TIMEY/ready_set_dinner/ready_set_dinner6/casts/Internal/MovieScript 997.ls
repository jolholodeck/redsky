global dbIndexList, gHitList, gNumORecs, gTitleFieldSprite, gIngFieldSprite, gInstrFieldSprite, gNoteFieldSprite, gCurrentHit, gPrevHitSprite, gNextHitSprite, gNewSearchSprite, gNumOrigRecipes, gDeleteRecSprite, gPrintButtonSprite, gPrintObject, _lastScreen, gNotesVisible, gCoverSprite

on clearNotes
  if gNotesVisible = 1 then
    set the editableText of sprite gNoteFieldSprite to 0
    set the loc of sprite gNoteFieldSprite to point(-1000, -1000)
    set the loc of sprite gCoverSprite to point(-1000, -1000)
    puppetSprite(gNoteFieldSprite, 0)
    puppetSprite(gCoverSprite, 0)
    set gNotesVisible to 0
  end if
end

on getInput whichField
  global gLineLimit, gCurrentInputField
  if whichField = #title then
    set gLineLimit to 1
  end if
  if whichField = #ingredients then
    set gLineLimit to 11
  end if
  if whichField = #directions then
    set gLineLimit to 11
  end if
  if whichField = #notes then
    set gLineLimit to 5
  end if
  set gCurrentInputField to the castNum of sprite the clickOn
  when keyDown then checkForReturn
end

on checkForReturn
  global gWhichTextSprite, gLineLimit, gCurrentInputField, gHowManyLines, gNotesVisible
  if the key = TAB then
    if gNotesVisible = 1 then
      dontPassEvent()
    else
      if gWhichTextSprite = getLast(gTabOrder) then
        set gWhichTextSprite to getAt(gTabOrder, 1)
        set gLineLimit to getAt(gHowManyLines, 1)
        put gWhichTextSprite
        put gLineLimit
      else
        set gLineLimit to getAt(gHowManyLines, getPos(gTabOrder, gWhichTextSprite) + 1)
        set gWhichTextSprite to getAt(gTabOrder, getPos(gTabOrder, gWhichTextSprite) + 1)
        put gWhichTextSprite
        put gLineLimit
      end if
      set gCurrentInputField to the castNum of sprite gWhichTextSprite
      exit
    end if
  end if
end

on getWeeklyInput
  global gCurrentInputField
  set gCurrentInputField to the castNum of sprite the clickOn
  when keyDown then checkWeeklyKey
end

on checkWeeklyKey
  global gWhichTextSprite, gLineLimit, gCurrentInputField, gHowManyLines, gWeeklyTabs
  set gLineLimit to 2
end

on makeFieldsEditable
  global gPrimaryIng, gRecipeType
  set whichHit to getAt(gHitList, gCurrentHit)
  if the text of cast "Edit/Save" = "Edit" then
    if whichHit > gNumOrigRecipes then
      set the editableText of sprite gTitleFieldSprite to 1
      set the editableText of sprite gIngFieldSprite to 1
      set the editableText of sprite gInstrFieldSprite to 1
    end if
    set the editableText of sprite gNoteFieldSprite to 1
    set the text of cast "Edit/Save" to "Save Changes"
    set the visible of sprite gNewSearchSprite to 0
    set the visible of sprite gDeleteRecSprite to 0
    set the visible of sprite gPrintButtonSprite to 0
  else
    if whichHit > gNumOrigRecipes then
      set the editableText of sprite gTitleFieldSprite to 0
    end if
    if whichHit > gNumOrigRecipes then
      set the editableText of sprite gIngFieldSprite to 0
    end if
    if whichHit > gNumOrigRecipes then
      set the editableText of sprite gInstrFieldSprite to 0
    end if
    set the editableText of sprite gNoteFieldSprite to 0
    set the text of cast "Edit/Save" to "Edit"
    set the visible of sprite gNewSearchSprite to 1
    set the visible of sprite gDeleteRecSprite to 1
    set the visible of sprite gPrintButtonSprite to 1
    set theName to the text of field "recipeTitle"
    put theName & "~" & gPrimaryIng & "~" & gRecipeType & "~" into line whichHit of (field 999)
    set dbIndexList to []
    readInList()
  end if
end

on preserveState
  set the visible of sprite gNewSearchSprite to 1
  set the visible of sprite gDeleteRecSprite to 1
  set the visible of sprite gPrintButtonSprite to 1
  set the text of cast "Edit/Save" to "Edit"
  set the loc of sprite gNoteFieldSprite to point(-1000, -1000)
  set the loc of sprite gCoverSprite to point(-1000, -1000)
  puppetSprite(gNoteFieldSprite, 0)
  puppetSprite(gCoverSprite, 0)
end
