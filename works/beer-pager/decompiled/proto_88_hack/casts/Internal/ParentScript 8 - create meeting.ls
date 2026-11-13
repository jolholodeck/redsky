property iID, iWhen, iWhere, iWhy, iMessage, iLWho, ancestor, pInvite, iWhenDate, iLWhy
global oPrefsClass, oRequestMgr, kDateObject, kMyId

on new me
  iID = 0
  iWhen = 0
  iWhere = 0
  iWhy = 1
  iMessage = EMPTY
  iLWho = []
  pInvite = [:]
  iWhenDate = 0
  iLWhy = [#millerTime, #afterWork, #theGame, #whyNot]
  ancestor = new(script("Root"))
  return me
end

on mUpdateMeetingData me, whichProp, whatData
  case whichProp of
    #iID:
      iID = whatData
    #iWhen:
      iWhen = whatData
    #iWhere:
      iWhere = whatData
    #iWhy:
      iWhy = whatData
    #iMessage:
      iMessage = whatData
    #iLWho:
      iLWho = whatData
    #iWhenDate:
      iWhenDate = whatData
  end case
end

on mClearMeetingData me, whichProp
  case whichProp of
    #iID:
      iID = 0
    #iWhen:
      iWhen = 0
    #iWhere:
      iWhere = EMPTY
    #iWhy:
      iWhy = 1
    #iMessage:
      iMessage = EMPTY
    #iLWho:
      iLWho = []
    #iWhenDate:
      iWhenDate = 0
  end case
end

on mAddToWhoList me, whatToAdd
  if getPos(iLWho, whatToAdd) = 0 then
    append(iLWho, whatToAdd)
  end if
end

on mKillFromWhoList me, whatToKill
  offset = getPos(iLWho, whatToKill)
  if offset then
    deleteAt(iLWho, offset)
  end if
end

on mVerifyInput me, stage
  case stage of
    1:
      if iLWho = [] then
        mErrorAlert(me, #noFriend)
        abort()
      end if
      if iWhere = EMPTY then
        mErrorAlert(me, #noPlace)
        abort()
      end if
    2:
  end case
end

on mPrepareInviteToPost me
  whereName = getProp(getAt(oPrefsClass.pPlacesData, iWhere), #name)
  whereAddress = getProp(getAt(oPrefsClass.pPlacesData, iWhere), #where)
  why = getAt(iLWhy, iWhy)
  whoList = []
  tempList = [#idUser: kMyId, #sUserName: oPrefsClass.pSettingsData.sScreenName, #yAttendStatus: #accepted, #sMessage: iMessage, #yCreator: 1]
  append(whoList, tempList)
  repeat with curID in iLWho
    repeat with curBuddy in oPrefsClass.pBuddyData
      if curBuddy.id = curID then
        tempList = [#idUser: curBuddy.id, #sUserName: curBuddy.name, #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: 0]
      end if
    end repeat
    append(whoList, tempList)
  end repeat
  pInvite = [#idMeeting: 0, #dWhenTime: iWhen, #dWhenDate: convertDate(kDateObject + iWhenDate), #sWhereName: whereName, #sWhereAddress: whereAddress, #yWhy: why, #sMessage: iMessage, #lWho: whoList]
  return pInvite
end

on mErrorAlert me, error
  case error of
    #noFriend:
      alert("You must invite at least one FRIEND to the meeting.")
    #noPlace:
      alert("You must pick a PLACE for the meeting.")
    #noFriendORPlace:
      alert("You must invite at least one FRIEND to the meeting and pick a PLACE for the meeting.")
  end case
end

on mShowProps me
  repeat with propNum = 1 to count(me)
    propName = getPropAt(me, propNum)
    propVal = getProp(me, propName)
    propText = "oCurMeeting." & propName
    put propText
  end repeat
end
