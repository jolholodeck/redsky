property pMySpr, pCalCurHiIdx, pMyMemName
global oInvite2Class, oCalendarClass, gCurScreen

on beginSprite me
  pMySpr = me.spriteNum
  pMyState = 0
  pCalCurHiIdx = 0
end

on mouseUp me
  case gCurScreen of
    "invite2":
      if pMySpr = oInvite2Class.pGridHiSpr then
        exit
      end if
      deSelect(me)
      dayIdx = me.spriteNum - oInvite2Class.pGridSprMin
      playSound(#calendar)
      oInvite2Class.mSelectDay(dayIdx)
    "calendar":
      pMyMem = sprite(pMySpr).member
      pMyMemName = pMyMem.name
      oCalendarClass.mGridMouseDown(pMySpr, pMyMemName)
  end case
end

on deSelect me
  curMem = (the member of sprite oInvite2Class.pGridHiSpr).name
  oSet = the number of chars in gCurScreen + 2
  put "A" into char oSet of curMem
  sprite(oInvite2Class.pGridHiSpr).member = curMem
end

on deHiliteCalendar me
  oCalendarClass.mDeselectGrid(me)
end
