global gCurScreen, gOldScreen

on initScoreSection markerName
  initScriptToDo = "o" & markerName & "Class.mInitMyScreen()"
  gOldScreen = gCurScreen
  gCurScreen = markerName
  do(initScriptToDo)
  if gCurScreen <> "tuner2" then
    go(#next)
  end if
end

on leaveScoreSection
  fieldList = []
  repeat with curSpr = 30 to 37
    if sprite(curSpr).member.type = #field then
      myMem = sprite(curSpr).member
      append(fieldList, myMem)
    end if
  end repeat
  if count(fieldList) > 0 then
    clearFields(fieldList)
  end if
  leaveScriptToDo = "o" & gCurScreen & "Class.mLeaveMyScreen()"
  do(leaveScriptToDo)
end
