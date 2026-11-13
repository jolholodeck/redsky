property pGridSpr, pSquareW, pSquareH, pHalfSquareW, pHalfSquareH, pGridSprMin, pGridDaySprMin, pGridHiSpr, pGridOrigin
global oCurMeeting, kDateObject, gCurScreen

on new me
  pGridHiSpr = 0
  return me
end

on mSetUpGrid me
  dayList = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  idx = getPos(dayList, getDayOfTheWeek(kDateObject))
  repeat with dayNum = 1 to 7
    sprite(pGridDaySprMin + (dayNum - 1)).member = gCurScreen & "_" & getAt(dayList, idx)
    idx = idx + 1
    if idx > 7 then
      idx = 1
    end if
  end repeat
  newLoc = pGridOrigin
  repeat with dayNum = 1 to 14
    sprite(pGridSprMin + (dayNum - 1)).loc = newLoc
    sprite(pGridSprMin + (dayNum - 1)).member = gCurScreen & "_A_" & string((kDateObject + (dayNum - 1)).day)
    newLoc = newLoc + point(pSquareW + 1, 0)
    if dayNum = 7 then
      newLoc = pGridOrigin + point(0, pSquareH + 2)
    end if
  end repeat
end

on mErrorAlert me, errorType
  case errorType of
    #errorType:
      alert("ERROR MESSAGE")
  end case
end
