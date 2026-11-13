property pAddTextMem, pListTextMem, pNotesTextMem, pListTextSpr, pNotesTextSpr, pAddTextSpr, pNameTextMem, pEmailTextMem, pCurEmailToCheck, pCurRequest, pScrollData1
global oPrefsClass, oRequestMgr, oDialogueClass, gState, kWatchCursor, kMyId

on new me
  pAddTextMem = "in_F_email"
  pListTextMem = "prs_F_names"
  pNotesTextMem = "in_F_notes"
  pNameTextMem = "pr_F_name"
  pEmailTextMem = "pr_F_email"
  pListTextSpr = 30
  pNotesTextSpr = 33
  pAddTextSpr = 34
  pScrollData1 = [10, 11, 12]
  pOCurrentRequest = VOID
  return me
end

on mInitMyScreen me
  clearFields([pAddTextMem, pNotesTextMem, pListTextMem, pNotesTextMem, pEmailTextMem, pNameTextMem])
  forceFieldFocus(pNotesTextSpr)
  resetScrollWindow(#friends, pListTextMem)
  sendSprite(pListTextSpr, #doSelect, 1, #friends)
  constructScroll(pScrollData1)
  mCheckButtons(me)
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #F_save:
      saveFriendNotes(me)
    #F_delete:
      deleteFriend(sendSprite(pListTextSpr, #mHiLine))
    #F_submit:
      oDialogueClass.mDoDialogue(#addFriend)
    #F_cancel:
      dataToField(#buddy, sprite(pListTextSpr).pHiLine)
      mFieldCleaned(me)
  end case
end

on mLeaveMyScreen me
end

on mDoMyListSelectCallBack me, lineNum
  dataToField(#buddy, lineNum)
end

on mCheckButtons me
  if count(oPrefsClass.pBuddyData) = 0 then
    mDeactiveButtons([1, 2, 3])
    deConstructScroll(pScrollData1)
    sprite(pNotesTextSpr).editable = 0
    member(pNotesTextMem).editable = 0
  else
    mActivateButtons([1])
    mDeactiveButtons([2])
    constructScroll(pScrollData1)
    sprite(pNotesTextSpr).editable = 1
    member(pNotesTextMem).editable = 1
  end if
end

on mFieldCleaned me
  if gState <> #dialogue then
    mDeactiveButtons([2, 3])
  end if
end

on mFieldDirtied me
  if gState <> #dialogue then
    mActivateButtons([2, 3])
  end if
end

on mErrorAlert me, errorType
  case errorType of
    #serverTimeOut:
      alert("No response from server, try again later.")
    #alreadyOnList:
      alert("That person is already on your list")
  end case
end

on saveFriendNotes me
  curHiLine = sendSprite(pListTextSpr, #mHiLine)
  curBuddyData = getAt(oPrefsClass.pBuddyData, curHiLine)
  curBuddyData.notes = member(pNotesTextMem).text
  mCallSaveBuddyData(me)
  sendSprite(pNotesTextSpr, #mCleanField)
end

on mCheckForRegisteredUser me, emailInput
  repeat with curBuddy in oPrefsClass.pBuddyData
    if emailInput = curBuddy.email then
      abort()
    end if
  end repeat
  if emailInput = oPrefsClass.pSettingsData.sEmail then
    abort()
  end if
  pCurEmailToCheck = emailInput
  pCurRequest = oRequestMgr.mFindUser(emailInput, me, #interpretServerResponse)
  cursor(kWatchCursor)
  gState = #checkServer
end

on interpretServerResponse me
  cursor(-1)
  gState = #Active
  response = pCurRequest.iData
  myResult = pCurRequest.iResult
  errorType = pCurRequest.iErrorType
  case myResult of
    (-1):
      checkForServerErrors(errorType)
    0:
      case errorType of
        #sEmail:
          if oDialogueClass.mDoDialogue(#friendEmail) then
            oRequestMgr.mInfectUser(pCurEmailToCheck, kMyId)
          end if
        #sIduser:
          oDialogueClass.mDoDialogue(#friendEmail)
      end case
    1:
      mAddNewFriend(me, response)
  end case
  pCurRequest = VOID
end

on mAddNewFriend me, myData
  addProp(myData, #notes, EMPTY)
  append(oPrefsClass.pBuddyData, myData)
  mCallSaveBuddyData(me)
  resetScrollWindow(#friends, pListTextMem)
  sendSprite(pListTextSpr, #resetField)
  newLineNum = getPos(oPrefsClass.pBuddyData, myData)
  sendSprite(pListTextSpr, #doSelect, newLineNum, #friends)
  clearFields([pAddTextMem])
  mCheckButtons(me)
end

on deleteFriend me
  curHiLine = sendSprite(pListTextSpr, #mHiLine)
  deleteAt(oPrefsClass.pBuddyData, curHiLine)
  mCallSaveBuddyData(me)
  clearFields([pAddTextMem, pNotesTextMem, pListTextMem, pNotesTextMem, pEmailTextMem, pNameTextMem])
  resetScrollWindow(#friends, pListTextMem)
  sendSprite(pListTextSpr, #resetField)
  sendSprite(pListTextSpr, #doSelect, 1, #friends)
  mCheckButtons(me)
end

on mCallSaveBuddyData me
  oPrefsClass.saveListData(#friends)
end
