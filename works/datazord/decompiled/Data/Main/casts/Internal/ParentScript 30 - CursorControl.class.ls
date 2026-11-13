property ancestor, ilkCursors, iCurCursor

on new me, lCursors
  ilkCursors = lCursors
  iCurCursor = #none
  return me
end

on mSetCursor me, cursID
  if cursID = iCurCursor then
    exit
  end if
  iCurCursor = cursID
  cursor(ilkCursors[iCurCursor])
end

on mClearCursor me
  if iCurCursor = #none then
    exit
  end if
  iCurCursor = #none
  cursor(200)
end
