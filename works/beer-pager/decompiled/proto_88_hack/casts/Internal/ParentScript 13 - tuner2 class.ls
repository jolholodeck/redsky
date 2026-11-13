property ancestor, pMeetingIdx, pCurMeeting, pScrollData1, pScrollData2, pMessageType, pTextMemFrom, pTextMemWhen, pTextMemWhere, pTextMemWho, pTextMemMessage, pCurUpdateIdx
global oMeetings, kDateObject, gCurScreen, oDialogueClass, oPrefsClass, oTunerClass

on new me
  pTextMemFrom = "pr_T2_From"
  pTextMemWhen = "pr_T2_When"
  pTextMemWhere = "pr_T2_Where"
  pTextMemWho = "prs_T2_who"
  pTextMemMessage = "prs_T2_message"
  pMeetingIdx = 1
  pScrollData1 = [10, 11, 12]
  pScrollData2 = [13, 14, 15]
  ancestor = new(script("Root"))
  return me
end

on findMessageType me, message
  if listp(message) then
    pMessageType = #update
  else
    pMessageType = #invite
  end if
end

on myMessageType me, message
  if listp(message) then
    messageType = #update
  else
    messageType = #invite
  end if
  return messageType
end

on mInitMyScreen me
  findMessageType(me, pCurMeeting)
  clearFields([pTextMemFrom, pTextMemWhen, pTextMemWhere, pTextMemWho, pTextMemMessage])
  mMeetingText(me)
  mAttendeeScroll(me)
  mCheckButtons(me)
  if pMessageType = #invite then
    if the frameLabel = "x" then
      case pCurMeeting.iWhy of
        #millerTime:
          go(the frame - 4)
        #theGame:
          go(the frame - 3)
        #afterWork:
          go(the frame - 2)
        #whyNot:
          go(the frame - 1)
      end case
    else
      case pCurMeeting.iWhy of
        #millerTime:
          go(the frame + 1)
        #theGame:
          go(the frame + 2)
        #afterWork:
          go(the frame + 3)
        #whyNot:
          go(the frame + 4)
      end case
    end if
  else
    if pMessageType = #update then
      go("x")
    end if
  end if
end

on mLeaveMyScreen me
  sprite(61).mShowLite()
  sprite(61).mcheckLiteAfterTuner()
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #T_next:
      cycleMeetings(me, #next)
    #T_last:
      cycleMeetings(me, #last)
    #T2_cancel:
      go("tuner")
    #T2_accept:
      playSound(#accept)
      if pMessageType = #invite then
        oDialogueClass.mDoDialogue(#acceptMtg)
      else
        mDeleteFromInbox(me)
        mDeleteMessage(me)
      end if
    #T2_decline:
      playSound(#decline)
      oDialogueClass.mDoDialogue(#cancelMtg)
  end case
end

on mCheckButtons me
  if count(oTunerClass.pMessages) = 1 then
    mDeactiveButtons([1, 2])
  else
    mActivateButtons([1, 2])
  end if
  if pMessageType = #update then
    mDeactiveButtons([4])
  else
    if pMessageType = #invite then
      mActivateButtons([4])
    end if
  end if
end

on mMeetingText me
  case pMessageType of
    #invite:
      creatorName = findCreator(pCurMeeting.iLWho)
      member(pTextMemFrom).text = creatorName
      member(pTextMemWhen).text = yearTrim(pCurMeeting.iWhenDate) && pCurMeeting.iWhen
      member(pTextMemWhere).text = pCurMeeting.iWhereName & RETURN & pCurMeeting.iWhereAddress
      member(pTextMemMessage).text = pCurMeeting.iMessage
      constructScroll(pScrollData2)
      if pCurMeeting.iMessage <> EMPTY then
        constructScroll(pScrollData1)
      end if
    #update:
      member(pTextMemFrom).text = pCurMeeting.sUserName
      myMtgId = symbol(pCurMeeting.iID)
      member(pTextMemMessage).text = pCurMeeting.sMessage
      if pCurMeeting.sMessage <> EMPTY then
        constructScroll(pScrollData1)
      end if
      if pCurMeeting.yAttendStatus = #Miller then
        exit
      end if
      myMeeting = getProp(oMeetings.lActiveMeetings, myMtgId)
      member(pTextMemWhen).text = yearTrim(myMeeting.iWhenDate) && myMeeting.iWhen
      member(pTextMemWhere).text = myMeeting.iWhereName & RETURN & myMeeting.iWhereAddress
  end case
end

on mDeleteMessage me
  deleteOne(oTunerClass.pMessages, pCurMeeting)
  if count(oTunerClass.pMessages) = 0 then
    go("tuner")
  else
    mCheckButtons(me)
    cycleMeetings(me, #next)
  end if
end

on mDeleteFromInbox me
  deleteOne(oPrefsClass.pInBoxData, pCurMeeting)
  oPrefsClass.saveListData(#inBox)
end

on mCallToCancelMeeting me, message
  mtgId = getPropAt(oMeetings.lNewMeetings, pMeetingIdx)
  oMeetings.mDeleteMeeting(mtgId, #new, message)
end

on findCreator whoList
  repeat with curWho in whoList
    if curWho.yCreator = "1" then
      return curWho.sUserName
    end if
  end repeat
end

on mAcceptMeeting me, message
  mtgId = pCurMeeting.iID
  oMeetings.mAcceptMyMeeting(mtgId, message)
end

on mAttendeeScroll me
  clearScrollWindow(pTextMemWho)
  if pMessageType = #update then
    exit
  end if
  lineNum = 1
  whoList = pCurMeeting.iLWho
  repeat with num = 1 to count(whoList)
    curWho = getAt(whoList, num)
    member(pTextMemWho).line[lineNum] = curWho.sUserName
    lineNum = lineNum + 1
  end repeat
end

on mFieldCleaned me
  nothing()
end

on mFieldDirtied me
  nothing()
end

on cycleMeetings me, whichWay
  if whichWay = #next then
    pMeetingIdx = pMeetingIdx + 1
    if pMeetingIdx > count(oTunerClass.pMessages) then
      pMeetingIdx = 1
    end if
  else
    pMeetingIdx = pMeetingIdx - 1
    if pMeetingIdx < 1 then
      pMeetingIdx = count(oTunerClass.pMessages)
    end if
  end if
  pCurMeeting = getAt(oTunerClass.pMessages, pMeetingIdx)
  mInitMyScreen(me)
end

on setMeetingIdx me, whatNum
  pMeetingIdx = whatNum
  pCurMeeting = getAt(oTunerClass.pMessages, pMeetingIdx)
  findMessageType(me, pCurMeeting)
end
