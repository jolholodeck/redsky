property ancestor, pMeetingIdx, pCurMeeting, pScrollData1, pScrollData2, pTextMemWhy, pTextMemWhen, pTextMemWhere, pTextMemWho, pTextMemWhoMessage, pTextWhoSpr
global oMeetings, kDateObject, gCurScreen, oDialogueClass

on new me
  pTextMemWhy = "pr_C2_why"
  pTextMemWhen = "pr_C2_when"
  pTextMemWhere = "pr_C2_where"
  pTextMemWho = "prs_C2_who"
  pTextMemWhoMessage = "pr_C2_message"
  pMeetingIdx = 1
  pTextWhoSpr = 30
  pScrollData1 = [10, 11, 12]
  pScrollData2 = [13, 14, 15]
  ancestor = new(script("Root"))
  return me
end

on mInitMyScreen me
  pCurMeeting = getAt(oMeetings.lActiveMeetings, pMeetingIdx)
  mMeetingText(me)
  mAttendeeScroll(me)
  clearFields([pTextMemWhoMessage])
  sendSprite(pTextWhoSpr, #doSelect, 1, #calendar2)
  mCheckButtons(me)
end

on mSelectAtendee me, atendeeNum
  whoList = pCurMeeting.iLWho
  curUser = whoList[atendeeNum]
  curMessage = curUser.sMessage
  if curMessage = VOID then
    curMessage = EMPTY
  end if
  member(pTextMemWhoMessage).text = curMessage
end

on mMeetingText me
  case pCurMeeting.iWhy of
    #millerTime:
      whyText = "Miller Time!"
    #whyNot:
      whyText = "...Why Not?"
    #theGame:
      whyText = "The Game"
    #afterWork:
      whyText = "After Work"
  end case
  member(pTextMemWhy).text = whyText
  member(pTextMemWhen).text = yearTrim(pCurMeeting.iWhenDate) && pCurMeeting.iWhen
  member(pTextMemWhere).text = pCurMeeting.iWhereName & RETURN & pCurMeeting.iWhereAddress
  if pCurMeeting.iMessage = EMPTY then
    deConstructScroll(pScrollData1)
  else
    constructScroll(pScrollData1)
  end if
  constructScroll(pScrollData2)
end

on mAttendeeScroll me
  clearScrollWindow(pTextMemWho)
  lineNum = 1
  whoList = pCurMeeting.iLWho
  repeat with num = 1 to count(whoList)
    curWho = getAt(whoList, num)
    if curWho.yAttendStatus = #accepted then
      attendText = "+ "
    else
      if (curWho.yAttendStatus = #declined) or (curWho.yAttendStatus = #canceled) then
        attendText = "- "
      else
        attendText = "? "
      end if
    end if
    member(pTextMemWho).line[lineNum] = attendText & curWho.sUserName
    lineNum = lineNum + 1
  end repeat
end

on mCallToCancelMeeting me, message
  mtgId = getPropAt(oMeetings.lActiveMeetings, pMeetingIdx)
  if oMeetings.mDeleteMeeting(mtgId, #Active, message) then
  end if
end

on cycleMeetings me, whichWay
  if whichWay = #next then
    pMeetingIdx = pMeetingIdx + 1
    if pMeetingIdx > count(oMeetings.lActiveMeetings) then
      pMeetingIdx = 1
    end if
  else
    pMeetingIdx = pMeetingIdx - 1
    if pMeetingIdx < 1 then
      pMeetingIdx = count(oMeetings.lActiveMeetings)
    end if
  end if
  sendSprite(pTextWhoSpr, #resetField)
  mInitMyScreen(me)
end

on setMeetingIdxById me, mtgId
  pCurMeeting = getProp(oMeetings.lActiveMeetings, mtgId)
  pMeetingIdx = getPos(oMeetings.lActiveMeetings, pCurMeeting)
end

on setMeetingIdx me, whatNum
  pMeetingIdx = whatNum
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #C2_back:
      go("calendar")
    #C2_last:
      cycleMeetings(me, #last)
    #C2_next:
      cycleMeetings(me, #next)
    #C2_cancel:
      playSound(#decline)
      oDialogueClass.mDoDialogue(#cancelMtg)
  end case
end

on mLeaveMyScreen me
end

on mCheckButtons me
  if count(oMeetings.lActiveMeetings) = 1 then
    mDeactiveButtons([1, 2])
  else
    mActivateButtons([1, 2])
  end if
end

on mFieldCleaned me
  nothing()
end

on mFieldDirtied me
  nothing()
end

on mErrorAlert me, errorType
  case errorType of
    #errorType:
      alert("ERROR MESSAGE")
  end case
end
