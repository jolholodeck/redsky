on exitFrame
  global goK, goColl
  prefsCollidx = goColl.iLcollNames.getPos(goColl.iCurCollName)
  goColl.mPreviewCollection(prefsCollidx, 2000)
  goColl.mLoadCollection(goColl.iCurPvwCollIDX)
  sprite(goK.iLsprNum.main.PANEL.tooltip).mBlnLockDisplay = 0
  go("Main")
end
