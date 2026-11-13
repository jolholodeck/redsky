property ancestor, pDateNumMemRange, pDateLetterMemRange, pMeetingListTextMem, pMeetingListTextSpr, pSortTypeTextMem, pCurSortType, pScrollData1, plActiveDays, plMeetingDays, pDayNum, pCurrentlyDisplayedMtgLst
global oMeetings, kDateObject, oDialogueClass, oCalendar2Class, gCalGridHiSpr

on new me
  ancestor = new(script("grid class"))
  me.pSquareW = 33
  me.pSquareH = 22
  me.pGridSprMin = 8
  me.pGridDaySprMin = 22
  me.pHalfSquareW = me.pSquareW / 2
  me.pGridOrigin = point(54, 85)
  me.pGridHiSpr = 0
  plMeetingDays = []
  pSortTypeTextMem = "pr_C_sort"
  pMeetingListTextMem = "prs_C_meetings"
  pMeetingListTextSpr = 29
  pScrollData1 = [4, 5, 6]
  return me
end

on mInitMyScreen me
  plActiveDays = []
  repeat with X = 0 to 13
    append(plActiveDays, (kDateObject + X).day)
  end repeat
  pCurSortType = #all
  mSetUpGrid(me)
  mCheckButtons(me)
  clearScrollWindow(pMeetingListTextMem)
  mHiliteGridNums(me)
  pDayNum = 0
  mListMeetings(me)
  gCalGridHiSpr = 0
end

on mListMeetings me, sprNum
  mCheckButtons(me)
  sendSprite(pMeetingListTextSpr, #resetField)
  case pCurSortType of
    #all:
      pDayNum = 0
      meetingList = oMeetings.lActiveMeetings
      sendSprite(me.pGridSprMin, #deHiliteCalendar)
    #date:
      meetingList = []
      if sprNum then
        idx = sprNum - me.pGridSprMin + 1
        pDayNum = getAt(plActiveDays, idx)
      end if
      the itemDelimiter = "/"
      repeat with num = 1 to count(oMeetings.lActiveMeetings)
        curNewMeeting = getAt(oMeetings.lActiveMeetings, num)
        meetingDay = curNewMeeting.iWhenDate.item[2]
        if value(meetingDay) = pDayNum then
          append(meetingList, curNewMeeting)
        end if
      end repeat
  end case
  pCurrentlyDisplayedMtgLst = meetingList
  member(pMeetingListTextMem).text = EMPTY
  member(pMeetingListTextMem).fontStyle = "plain"
  lineNum = 1
  repeat with num = 1 to count(meetingList)
    curNewMeeting = getAt(meetingList, num)
    meetingInfo = yearTrim(curNewMeeting.iWhenDate) & " | " & curNewMeeting.iWhen & " | " & curNewMeeting.iWhereName
    member(pMeetingListTextMem).line[lineNum] = meetingInfo
    lineNum = lineNum + 1
  end repeat
  member(pMeetingListTextMem).scrollTop = 0
  constructScroll(pScrollData1)
  mCheckButtons(me)
end

on mGridMouseDown me, mySpr, MyMemName
  if not getPos(plMeetingDays, mySpr) then
    exit
  end if
  if gCalGridHiSpr <> mySpr then
    playSound(#calendar)
    mDeselectGrid(me)
    curMemName = MyMemName
    put "B" into char 10 of curMemName
    sprite(mySpr).member = curMemName
    sprite(mySpr + 22).member = "calendar_B_mtg1"
    pCurSortType = #date
    mListMeetings(me, mySpr)
    gCalGridHiSpr = mySpr
  end if
end

on mDeselectGrid me
  if gCalGridHiSpr then
    curMemName = (the member of sprite gCalGridHiSpr).name
    put "A" into char 10 of curMemName
    sprite(gCalGridHiSpr).member = curMemName
    sprite(gCalGridHiSpr + 22).member = "calendar_A_mtg1"
    gCalGridHiSpr = 0
  end if
end

on mHiliteGridNums me
  repeat with curSpr = 30 to 43
    sprite(curSpr).member = "dot"
    sprite(curSpr).loc = point(-1000, -1000)
  end repeat
  the itemDelimiter = "/"
  repeat with num = 1 to count(oMeetings.lActiveMeetings)
    curNewMeeting = getAt(oMeetings.lActiveMeetings, num)
    dayNum = value(curNewMeeting.iWhenDate.item[2])
    dayPos = getOne(plActiveDays, dayNum)
    if dayPos then
      spr = me.pGridSprMin + (dayPos - 1)
      hiliteSpr = spr + 22
      sprite(hiliteSpr).member = "calendar_A_mtg1"
      sprite(hiliteSpr).loc = sprite(spr).loc
      append(plMeetingDays, spr)
    end if
  end repeat
end

on mCallToCancelMeeting me, message
  curHiLine = sendSprite(pMeetingListTextSpr, #mHiLine)
  mtg = pCurrentlyDisplayedMtgLst[curHiLine]
  pos = getPos(oMeetings.lActiveMeetings, mtg)
  mtgId = getPropAt(oMeetings.lActiveMeetings, pos)
  oMeetings.mDeleteMeeting(mtgId, #Active, message)
end

on checkNewMessages me
  newMeetings = oMeetings.lNewMeetings
  if newMeetings = [:] then
    return 0
  else
    pCurNewMeetings = newMeetings
    return 1
  end if
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #C_read:
      go("calendar2")
    #C_all:
      pCurSortType = #all
      mListMeetings(me)
    #C_delete:
      playSound(#decline)
      oDialogueClass.mDoDialogue(#cancelMtg)
  end case
end

on mLeaveMyScreen me
  plMeetingDays = []
end

on mDoMyListSelectCallBack me, lineNum
  case pCurSortType of
    #all:
      num = lineNum
    #date:
      mtg = pCurrentlyDisplayedMtgLst[lineNum]
      num = getPos(oMeetings.lActiveMeetings, mtg)
  end case
  oCalendar2Class.setMeetingIdx(num)
  mCheckButtons(me)
end

on mCheckButtons me
  if oMeetings.lActiveMeetings = [:] then
    mDeactiveButtons([1, 2, 3])
    deConstructScroll(pScrollData1)
    exit
  end if
  curHiLine = sendSprite(pMeetingListTextSpr, #mHiLine)
  if not curHiLine then
    mDeactiveButtons([2, 3])
  else
    mActivateButtons([2, 3])
  end if
  if pCurSortType = #all then
    mDeactiveButtons([1])
  else
    mActivateButtons([1])
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
