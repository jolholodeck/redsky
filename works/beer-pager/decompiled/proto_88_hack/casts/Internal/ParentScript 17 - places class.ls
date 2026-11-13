property ancestor, pAddTextMem, pAddWhereTextMem, pListTextMem, pNotesTextMem, pNotesTextSpr, pListTextSpr, pAddTextSpr, pAddWhereTextSpr, pNameTextMem, pWhereTextMem, pScrollData1
global oPrefsClass, oDialogueClass, gState

on new me
  pAddTextMem = "in_P_name"
  pAddWhereTextMem = "in_P_where"
  pListTextMem = "prs_P_names"
  pNotesTextMem = "in_P_notes"
  pNameTextMem = "pr_P_name"
  pWhereTextMem = "pr_P_where"
  pListTextSpr = 30
  pAddTextSpr = 31
  pAddWhereTextSpr = 32
  pNotesTextSpr = 34
  pScrollData1 = [10, 11, 12]
  ancestor = new(script("Root"))
  return me
end

on mInitMyScreen me
  clearFields([pListTextMem, pAddTextMem, pAddWhereTextMem, pNotesTextMem, pNameTextMem, pWhereTextMem])
  forceFieldFocus(pNotesTextSpr)
  resetScrollWindow(#places, pListTextMem)
  sendSprite(pListTextSpr, #doSelect, 1, #places)
  mCheckButtons(me)
end

on savePlacesNotes me
  curHiLine = sendSprite(pListTextSpr, #mHiLine)
  curPlacesData = getAt(oPrefsClass.pPlacesData, curHiLine)
  curPlacesData.notes = member(pNotesTextMem).text
  mCallSavePlacesData(me)
  sendSprite(pNotesTextSpr, #mCleanField)
end

on mAddPlace me, newName, newWhere
  newNotes = EMPTY
  myData = [#name: newName, #where: newWhere, #notes: newNotes]
  append(oPrefsClass.pPlacesData, myData)
  mCallSavePlacesData(me)
  resetScrollWindow(#places, pListTextMem)
  sendSprite(pListTextSpr, #resetField)
  newLineNum = getPos(oPrefsClass.pPlacesData, myData)
  sendSprite(pListTextSpr, #doSelect, newLineNum, #places)
  clearFields([pAddTextMem, pAddWhereTextMem])
  mCheckButtons(me)
end

on deletePlace me
  curHiLine = sendSprite(pListTextSpr, #mHiLine)
  deleteAt(oPrefsClass.pPlacesData, curHiLine)
  mCallSavePlacesData(me)
  clearFields([pListTextMem, pAddTextMem, pAddWhereTextMem, pNotesTextMem, pNameTextMem, pWhereTextMem])
  sendSprite(pNotesTextSpr, #mCleanField)
  resetScrollWindow(#places, pListTextMem)
  sendSprite(pListTextSpr, #resetField)
  sendSprite(pListTextSpr, #doSelect, 1, #places)
  mCheckButtons(me)
end

on mCallSavePlacesData me
  oPrefsClass.saveListData(#places)
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #P_add:
      oDialogueClass.mDoDialogue(#addPlace)
    #P_save:
      savePlacesNotes(me)
    #P_delete:
      deletePlace(me, sendSprite(pListTextSpr, #mHiLine))
    #P_cancel:
      dataToField(#places, sprite(pListTextSpr).pHiLine)
      mFieldCleaned(me)
  end case
end

on mLeaveMyScreen me
end

on mDoMyListSelectCallBack me, lineNum
  dataToField(#places, lineNum)
end

on mCheckButtons me
  if count(oPrefsClass.pPlacesData) = 0 then
    mDeactiveButtons([1, 2, 4])
    deConstructScroll(pScrollData1)
    sprite(pNotesTextSpr).editable = 0
  else
    sprite(pNotesTextSpr).editable = 1
    mActivateButtons([1])
    mDeactiveButtons([2])
    constructScroll(pScrollData1)
  end if
end

on mFieldCleaned me
  if gState <> #dialogue then
    mDeactiveButtons([2, 4])
  end if
end

on mFieldDirtied me
  if gState <> #dialogue then
    mActivateButtons([2, 4])
  end if
end

on mErrorAlert me, errorType
  case errorType of
    #errorType:
      alert("ERROR MESSAGE")
  end case
end
