property iCurCursor, iCurRef, iBlnLock

on new me
  iCurCursor = 0
  iCurRef = 0
  iBlnLock = 0
  return me
end

on mChange me, newCursor, Ref
  if iBlnLock then
    exit
  end if
  if newCursor = #arrow then
    if Ref = iCurRef then
      iCurRef = 0
      me.mSet(newCursor)
    end if
  else
    iCurRef = Ref
    me.mSet(newCursor)
  end if
end

on mLock me, newCursor
  iCurRef = 0
  iBlnLock = 1
  me.mSet(newCursor)
end

on mUnLock me, newCursor
  iCurRef = 0
  iBlnLock = 0
  me.mSet(newCursor)
end

on mSet me, newCursor
  if newCursor = iCurCursor then
    exit
  end if
  iCurCursor = newCursor
  case newCursor of
    #hand:
      cursor(260)
    #closedhand:
      cursor(290)
    #finger:
      cursor(280)
    #watch:
      cursor(4)
    #arrow:
      cursor(0)
  end case
end
