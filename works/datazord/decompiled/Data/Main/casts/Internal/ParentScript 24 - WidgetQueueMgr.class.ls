property ancestor, iloWidgets, ikMaxNbWidgets

on new me, maxNbWidgets
  ikMaxNbWidgets = maxNbWidgets
  iloWidgets = []
  return me
end

on mRegisterWidget me, oWidget
  if iloWidgets.getPos(oWidget) then
    return -1
  end if
  iloWidgets.add(oWidget)
  if iloWidgets.count > ikMaxNbWidgets then
    iloWidgets[1].mInterrupt()
    iloWidgets.deleteAt(1)
  end if
  return 0
end

on mUnregisterWidget me, oWidget
  pos = iloWidgets.getPos(oWidget)
  if not pos then
    return -1
  end if
  iloWidgets.deleteAt(pos)
  return 0
end

on mResetQueue me
  iloWidgets = []
end

on mIsQueueFull me
  return iloWidgets.count >= ikMaxNbWidgets
end
