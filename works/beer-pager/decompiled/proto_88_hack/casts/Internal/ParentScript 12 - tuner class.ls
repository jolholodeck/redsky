property pTunerMenuSpr, pMessageListTextMem, pMessageListTextSpr, pScrollData1, pMessages
global oMeetings, oTuner2Class, oDialogueClass, oPrefsClass, gOldScreen, gNavMenuHiSpr

on new me
  pMessages = []
  pMessageListTextMem = "prs_T_messages"
  pMessageListTextSpr = 30
  pScrollData1 = [10, 11, 12]
  pTunerMenuSpr = 54
  return me
end

on mInitMyScreen me
  if gOldScreen = "main" then
    sprite(pTunerMenuSpr).memberNum = sprite(pTunerMenuSpr).memberNum + 1
    gNavMenuHiSpr = pTunerMenuSpr
  end if
  oMeetings.pNewMessages = 0
  sprite(61).mHideLite()
  clearScrollWindow(pMessageListTextMem)
  mListMessages(me)
  mCheckButtons(me)
  setClock()
end

on mLeaveMyScreen me
  sprite(61).mShowLite()
  sprite(61).mcheckLiteAfterTuner()
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #T_Read:
      go("tuner2")
    #T_delete:
      if oTuner2Class.pMessageType = #invite then
        playSound(#decline)
        oDialogueClass.mDoDialogue(#cancelMtg)
      else
        oTuner2Class.mDeleteFromInbox(me)
        mCleanUpAfterDelete(me)
      end if
    #T_check:
      oMeetings.mGetMeetings()
  end case
end

on mDoMyListSelectCallBack me, lineNum
  oTuner2Class.setMeetingIdx(lineNum)
  mCheckButtons(me)
end

on mCheckButtons me
  if count(pMessages) = 0 then
    mDeactiveButtons([1, 2])
    deConstructScroll(pScrollData1)
    exit
  end if
  curHiLine = sendSprite(pMessageListTextSpr, #mHiLine)
  if not curHiLine then
    mDeactiveButtons([1, 2])
  else
    mActivateButtons([1, 2])
  end if
end

on mErrorAlert me, errorType
  case errorType of
    #errorType:
      alert("ERROR MESSAGE")
  end case
end

on mCallToCancelMeeting me, message
  curHiLine = sendSprite(pMessageListTextSpr, #mHiLine)
  mtgId = getPropAt(oMeetings.lNewMeetings, curHiLine)
  if oMeetings.mDeleteMeeting(mtgId, #new, message) then
    mCleanUpAfterDelete(me)
  end if
end

on mCleanUpAfterDelete me
  mListMessages(me)
  curHiLine = sendSprite(pMessageListTextSpr, #mHiLine)
  newLineToHi = curHiLine - 1
  if newLineToHi < 1 then
    newLineToHi = 1
  end if
  sendSprite(pMessageListTextSpr, #resetField)
  numOfLines = member(pMessageListTextMem).lineCount
  if numOfLines > 0 then
    sendSprite(pMessageListTextSpr, #doSelect, newLineToHi, #tuner)
  end if
  mCheckButtons(me)
end

on checkLineLenth me, textMem
  aMember = member(textMem)
  aString = aMember.text
  aLastChar1 = locToCharPos(aMember, point(185, 0))
  aLastChar2 = locToCharPos(aMember, point(195, 0))
  if (aLastChar2 - aLastChar1) >= 3 then
    aEnd = aLastChar1
    aDisplayString = char 1 to aEnd of aString
    aDisplayString = aDisplayString & "..."
  else
    aDisplayString = aString
  end if
  return aDisplayString
end

on mListMessages me
  pMessages = []
  repeat with curMeeting in oMeetings.lNewMeetings
    append(pMessages, curMeeting)
  end repeat
  oPrefsClass.cleanInBox()
  repeat with curMeeting in oPrefsClass.pInBoxData
    append(pMessages, curMeeting)
  end repeat
  messageList = pMessages
  member(pMessageListTextMem).text = EMPTY
  member(pMessageListTextMem).fontStyle = "plain"
  lineNum = 1
  repeat with num = 1 to count(messageList)
    curNewMessage = getAt(messageList, num)
    testIfInvite = listp(curNewMessage)
    case testIfInvite of
      1:
        userName = curNewMessage.sUserName
        case curNewMessage.yAttendStatus of
          #accepted:
            statusText = "Accepted."
          #declined:
            statusText = "Declined."
          #Miller:
            statusText = "Special Message"
        end case
        messageInfo = userName & "." & statusText
        member(pMessageListTextMem).line[lineNum] = messageInfo
      0:
        userName = findCreator(curNewMessage.iLWho)
        messageInfo = userName & "." & yearTrim(curNewMessage.iWhenDate) & "." & "Invite!"
        member(pMessageListTextMem).line[lineNum] = messageInfo
    end case
    lineNum = lineNum + 1
  end repeat
  member(pMessageListTextMem).scrollTop = 0
  constructScroll(pScrollData1)
end

on mFieldCleaned me
  nothing()
end

on mFieldDirtied me
  nothing()
end

on findCreator whoList
  repeat with curWho in whoList
    if curWho.yCreator = "1" then
      return curWho.sUserName
    end if
  end repeat
end
