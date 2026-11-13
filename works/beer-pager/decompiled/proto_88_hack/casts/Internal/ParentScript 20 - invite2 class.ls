property ancestor, pTimeTextMem, pTimeTextSpr
global oCurMeeting, kDateObject, gCurScreen, oInvite3Class

on new me
  ancestor = new(script("grid class"))
  me.pGridSpr = 4
  me.pSquareW = 19
  me.pSquareH = 21
  me.pHalfSquareW = me.pSquareW / 2
  me.pHalfSquareH = me.pSquareH / 2
  me.pGridSprMin = 5
  me.pGridOrigin = point(127, 148)
  me.pGridDaySprMin = 19
  me.pGridHiSpr = me.pGridSprMin
  me.pTimeTextMem = "in_I_time"
  me.pTimeTextSpr = 37
  return me
end

on mInitMyScreen me
  if not oCurMeeting.iWhen then
    timeText = addToCurTime(timeMyWay(), 30)
  else
    timeText = oCurMeeting.iWhen
  end if
  sendSprite(pTimeTextSpr, #setTimeText, timeText)
  forceFieldFocus(pTimeTextSpr)
  sendSprite(pTimeTextSpr, #selectTextItem, 1)
  mSetUpGrid(me)
  mSelectDay(me, me.pGridHiSpr - me.pGridSprMin)
end

on mClearHiSpr me
  me.pGridHiSpr = 5
end

on mSelectDay me, dayIdx
  datePicked = kDateObject + dayIdx
  dayNum = string(datePicked.day)
  sprNum = me.pGridSprMin + dayIdx
  sprite(sprNum).member = gCurScreen & "_B_" & string(dayNum)
  me.pGridHiSpr = sprNum
  dateString = string(datePicked.month) & "/" & string(datePicked.day) & "/" & chars(string(datePicked.year), 3, 4)
  oCurMeeting.mUpdateMeetingData(#iWhenDate, dayIdx)
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #I2_1:
      member("in_I_time").text = EMPTY
      go("invite")
    #I2_3:
      member("in_I_time").text = EMPTY
      go("invite3")
    #I2_cancel:
      member("in_I_time").text = EMPTY
      oInvite3Class.pCI3DirtyBit = 0
      oCurMeeting = VOID
      mClearHiSpr(me)
      go("animInviteClose")
  end case
end

on mLeaveMyScreen me
end

on mErrorAlert me, errorType
  case errorType of
    #errorType:
      alert("ERROR MESSAGE")
  end case
end
