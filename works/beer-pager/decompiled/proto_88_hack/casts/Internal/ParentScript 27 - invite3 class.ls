property pScrollData1, pCI3DirtyBit, pCurInviteReq, pTimeTextMem, pTimeTextSpr, pFirstWhySpr, pNotesTextMem, pPropListToPost
global oCurMeeting, kDateObject, oInvite3Class, oRequestMgr, gState, oInvite2Class, oDialogueClass, oPrefsClass, kMyId, kWatchCursor, oMeetings

on new me
  pFirstWhySpr = 11
  pCI3DirtyBit = 0
  pNotesTextMem = "in_I_notes"
  pScrollData1 = [8, 9, 10]
  return me
end

on mInitMyScreen me
  sendSprite(pFirstWhySpr, #mSelectByIdx, oCurMeeting.iWhy)
  member(pNotesTextMem).text = oCurMeeting.iMessage
  if oCurMeeting.iMessage = EMPTY then
    deConstructScroll(pScrollData1)
  else
    constructScroll(pScrollData1)
  end if
  pCI3DirtyBit = 1
end

on mPostInviteData me
  pPropListToPost = oCurMeeting.mPrepareInviteToPost()
  oCurMeeting = VOID
  pCI3DirtyBit = 0
  oInvite2Class.mClearHiSpr()
  addProp(pPropListToPost, #iID, random(500))
  oMeetings.addMeetingToList(pPropListToPost, oMeetings.lActiveMeetings)
  go("animSendFlapClose")
  exit
  pCurInviteReq = oRequestMgr.mPostMeeting(pPropListToPost, kMyId, me, #interpretServerResponse)
  gState = #checkServer
  cursor(kWatchCursor)
end

on interpretServerResponse me
  gState = #Active
  response = pCurInviteReq.iData
  cursor(-1)
  response = pCurInviteReq.iData
  myResult = pCurInviteReq.iResult
  errorType = pCurInviteReq.iErrorType
  case myResult of
    (-1):
      checkForServerErrors(errorType)
    0:
      case errorType of
        #error:
      end case
    1:
      oCurMeeting = VOID
      pCI3DirtyBit = 0
      oInvite2Class.mClearHiSpr()
      addProp(pPropListToPost, #iID, response.id)
      oMeetings.addMeetingToList(pPropListToPost, oMeetings.lActiveMeetings)
      go("animSendFlapClose")
  end case
  pPropListToPost = VOID
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #I3_1:
      go(the frame - 2)
    #I3_2:
      go(the frame - 1)
    #I3_cancel:
      oInvite3Class.pCI3DirtyBit = 0
      oCurMeeting = VOID
      oInvite2Class.mClearHiSpr()
      go("animSendflapClose")
  end case
end

on mLeaveMyScreen me
end

on mFieldCleaned me
  deConstructScroll(pScrollData1)
end

on mFieldDirtied me
  constructScroll(pScrollData1)
end

on mErrorAlert me, errorType
  case errorType of
    #errorType:
      alert("ERROR MESSAGE")
  end case
end
