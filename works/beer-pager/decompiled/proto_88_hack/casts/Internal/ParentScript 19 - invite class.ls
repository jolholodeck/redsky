property pScrollData1, pScrollData2, pWhoListTextMem, pWhereListTextMem, pWhoListSpr, pWhereListSpr
global oCurMeeting, oPrefsClass, oInvite3Class, oInvite2Class

on new me
  pWhoListTextMem = "pr_I_menu2"
  pWhereListTextMem = "pr_I_menu1"
  pWhoListSpr = 30
  pWhereListSpr = 31
  pScrollData1 = [10, 11, 12]
  pScrollData2 = [13, 14, 15]
  return me
end

on mInitMyScreen me
  resetScrollWindow(#places, pWhereListTextMem)
  resetScrollWindow(#friends, pWhoListTextMem)
  if not oCurMeeting then
    oCurMeeting = new(script("create meeting"))
  else
    lWho = []
    repeat with curFriendIdToHi in oCurMeeting.iLWho
      repeat with X = 1 to count(oPrefsClass.pBuddyData)
        if getAt(oPrefsClass.pBuddyData, X).id = curFriendIdToHi then
          append(lWho, X)
        end if
      end repeat
    end repeat
    sendSprite(pWhoListSpr, #selectSome, lWho)
    if oCurMeeting.iWhere then
      sendSprite(pWhereListSpr, #doSelect, oCurMeeting.iWhere, #invite)
    end if
  end if
  constructScroll(pScrollData1)
  constructScroll(pScrollData2)
  mCheckButtons(me)
end

on mLeaveMyScreen me
  oCurMeeting = VOID
end

on mDoMyListSelectCallBack me, lineNum
  mCheckButtons(me)
end

on mCheckButtons me
  if count(oPrefsClass.pBuddyData) = 0 then
    mDeactiveButtons([1, 2, 3, 5])
    deConstructScroll(pScrollData2)
  end if
  if count(oPrefsClass.pPlacesData) = 0 then
    mDeactiveButtons([3, 5])
    deConstructScroll(pScrollData1)
  end if
  curHiLine1 = count(sendSprite(pWhoListSpr, #mHiLines))
  curHiLine2 = sendSprite(pWhereListSpr, #mHiLine)
  if curHiLine1 and curHiLine2 then
    mActivateButtons([3])
    if oInvite3Class.pCI3DirtyBit then
      mActivateButtons([5])
    end if
  else
    mDeactiveButtons([3, 5])
  end if
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #I1_all:
      sendSprite(pWhoListSpr, #selectAll, member(pWhoListTextMem).lineCount)
    #I1_none:
      sendSprite(pWhoListSpr, #selectNone, member(pWhoListTextMem).lineCount)
    #I1_cancel:
      oCurMeeting = VOID
      oInvite3Class.pCI3DirtyBit = 0
      oInvite2Class.mClearHiSpr()
      go("animInviteClose")
    #I1_2:
      go("invite2")
    #I1_3:
      go("invite3")
  end case
end

on mErrorAlert me, errorType
  case errorType of
    #errorType:
      alert("ERROR MESSAGE")
  end case
end
