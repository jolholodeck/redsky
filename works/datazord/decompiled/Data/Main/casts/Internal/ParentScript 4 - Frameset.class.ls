property ioConsole, ioGlobalUI, ioCursorControl, ioSong, ancestor, ikFullID, ikFramesetID, ilkFrameRects, ilkFrameSprs, ilkFrameKeys, ilkFrameOrgs, ikNbFrames, iloModules, iState, iSwitchModuleID, iSwitchFrameID, iSongID, iLastClickFlushTime, iMouseEnabled, ilFrameMouseHooks, ilkModuleLibPaths, ilkModuleCounts, ilCurModuleIDs, ilCurModuleLibPaths, ilCurModuleLibNums
global koConstants, goShellConstants

on new me, oConsole, framesetID, lModuleLibPaths
  ioConsole = oConsole
  ioCursorControl = ioConsole.ioCursorControl
  ioGlobalUI = ioConsole.ioGlobalUI
  ikFramesetID = framesetID
  ikFullID = string(ikFramesetID)
  ilkModuleLibPaths = lModuleLibPaths
  lFramesetData = parseListData(member("fsetData_" & ikFramesetID, 1))
  ilkFrameRects = lFramesetData.frameRects
  ilkFrameKeys = lFramesetData.frameKeys
  lFrameSprs = lFramesetData.frameSprs
  curSpr = koConstants.ikModuleBaseSpr
  ilkFrameSprs = []
  repeat with nbSprs in lFrameSprs
    Ltemp = []
    repeat with X = 1 to nbSprs
      Ltemp.add(curSpr)
      curSpr = curSpr + 1
    end repeat
    ilkFrameSprs.add(duplicate(Ltemp))
  end repeat
  me.mBuildFrameOrigins()
  ikNbFrames = count(ilkFrameRects)
  iloModules = []
  iloModules[ikNbFrames] = 0
  iLastClickFlushTime = 20
  me.mDisableMouse()
  ilFrameMouseHooks = []
  repeat with X = 1 to ikNbFrames
    ilFrameMouseHooks.add(1)
  end repeat
  ilkModuleCounts = []
  repeat with curFrameData in ilkModuleLibPaths
    ilkModuleCounts.add(count(curFrameData))
  end repeat
  lCurModuleIDs = ioConsole.mLoadModuleIDs(ikFramesetID)
  if listp(lCurModuleIDs) then
    ilCurModuleIDs = duplicate(lCurModuleIDs)
  else
    ilCurModuleIDs = []
    repeat with cnt in ilkModuleCounts
      if cnt then
        ilCurModuleIDs.add(1)
        next repeat
      end if
      ilCurModuleIDs.add(0)
    end repeat
  end if
  ilCurModuleLibNums = []
  ilCurModuleLibNums[ikNbFrames] = 0
  ilCurModuleLibPaths = []
  X = 0
  repeat with curFrameData in ilkModuleLibPaths
    X = X + 1
    moduleID = ilCurModuleIDs[X]
    if moduleID = 0 then
      ilCurModuleLibPaths.add(0)
      next repeat
    end if
    ilCurModuleLibPaths.add(curFrameData[moduleID])
  end repeat
  iSwitchModuleID = 0
  iSwitchFrameID = 0
  iState = #ready
  return me
end

on mLinkModuleLibs me
  ilCurModuleLibNums = []
  ilCurModuleLibNums[ikNbFrames] = 0
  idx = 0
  repeat with libPath in ilCurModuleLibPaths
    idx = idx + 1
    if not stringp(libPath) then
      ilCurModuleLibNums[idx] = 0
      next repeat
    end if
    libNum = ioConsole.ioCastLibMgr.mGetLibNum(libPath)
    if not libNum then
      libNum = ioConsole.ioCastLibMgr.mLink(libPath)
    end if
    if libNum < 1 then
      alert("Couldn't link castLib " & libPath & " Err=" & libNum)
      quit()
    end if
    ilCurModuleLibNums[idx] = libNum
  end repeat
end

on mBuildModules me
  iloModules = []
  repeat with frameID = 1 to ikNbFrames
    libNum = ilCurModuleLibNums[frameID]
    moduleID = ilCurModuleIDs[frameID]
    if (libNum = 0) or (moduleID = 0) then
      iloModules[frameID] = 0
      next repeat
    end if
    lModuleKeys = ilkFrameKeys[frameID]
    oModule = new(script("Module.class", 1), me, frameID, moduleID, libNum, lModuleKeys)
    if not objectp(oModule) then
      alert("Couldn't build module " & ikFullID & "." & string(frameID) & "." & string(moduleID))
      halt()
    end if
    iloModules[frameID] = oModule
  end repeat
end

on mStartup me
  ioConsole.ioWidgetQueueMgr.mResetQueue()
  me.mLinkModuleLibs()
  me.mBuildModules()
  ioGlobalUI.mUpdateArt()
  repeat with oModule in iloModules
    if objectp(oModule) then
      oModule.mFastStartup()
    end if
  end repeat
  me.mEnableMouse()
  iState = #running
end

on mShutdown me
  me.mDisableMouse()
  repeat with oModule in iloModules
    if objectp(oModule) then
      oModule.mFastShutdown()
    end if
  end repeat
  repeat with oModule in iloModules
    oModule = 0
  end repeat
  iloModules = []
  iState = #shutDown
  repeat with frameID = 1 to ikNbFrames
    libNum = ilCurModuleLibNums[frameID]
    moduleID = ilCurModuleIDs[frameID]
    if (libNum = 0) or (moduleID = 0) then
      next repeat
    end if
    ioConsole.ioCastLibMgr.mUnlinkByLibNum(libNum)
  end repeat
  me.mDeleteAllProps()
end

on mDeleteAllProps me
  obj = me
  cnt = count(me)
  repeat with X = 1 to cnt
    curProp = obj.getPropAt(X)
    obj[X] = 0
  end repeat
end

on mSwitchModule me, frameID
  if iState = #switchingModule then
    exit
  end if
  if (frameID < 1) or (frameID > ikNbFrames) then
    exit
  end if
  nbModules = ilkModuleCounts[frameID]
  if nbModules < 2 then
    exit
  end if
  lFrameLibs = ilkModuleLibPaths[frameID]
  searching = 1
  dstModule = ilCurModuleIDs[frameID]
  repeat while searching
    dstModule = dstModule + 1
    if dstModule > nbModules then
      dstModule = 1
    end if
    if stringp(lFrameLibs[dstModule]) then
      searching = 0
      exit repeat
    end if
  end repeat
  iSwitchFrameID = frameID
  iSwitchModuleID = dstModule
  iState = #switchingModule
  iloModules[frameID].mSlowShutdown()
end

on mPrepareFramesetSwitch me
  me.mDisableMouse()
  repeat with oModule in iloModules
    if objectp(oModule) then
      ioConsole.ioKbdHandler.mUnregisterModule(oModule)
    end if
  end repeat
  iState = #switchingFrameset
end

on mModuleShutdownCallback me, frameID, moduleID
  iloModules[iSwitchFrameID] = 0
  ilCurModuleIDs[iSwitchFrameID] = iSwitchModuleID
  ioConsole.mSaveModuleIDs(ikFramesetID, duplicate(ilCurModuleIDs))
  libPath = ilkModuleLibPaths[iSwitchFrameID][iSwitchModuleID]
  ilCurModuleLibPaths[frameID] = libPath
  libNum = ioConsole.ioCastLibMgr.mGetLibNum(libPath)
  if not libNum then
    libNum = ioConsole.ioCastLibMgr.mLink(libPath)
  end if
  if libNum < 1 then
    alert("Couldn't link castLib " & libPath & " error=" & libNum)
    halt()
  end if
  ilCurModuleLibNums[iSwitchFrameID] = libNum
  lModuleKeys = ilkFrameKeys[iSwitchFrameID]
  oModule = new(script("Module.class", 1), me, iSwitchFrameID, iSwitchModuleID, libNum, lModuleKeys)
  if not objectp(oModule) then
    alert("Couldn't build module " & ikFullID & "." & string(iSwitchFrameID) & "." & string(iSwitchModuleID))
    halt()
  end if
  iloModules[iSwitchFrameID] = oModule
  oModule.mSlowStartup()
end

on mModuleStartupCallback me, frameID, moduleID
  iState = #running
end

on mHandleClick
  if not iMouseEnabled then
    exit
  end if
  if the lastClick > iLastClickFlushTime then
    exit
  end if
  clickPos = the clickLoc
  if ioGlobalUI.mHandleClick() then
    exit
  end if
  idx = 0
  hit = 0
  repeat with curRect in ilkFrameRects
    idx = idx + 1
    if inside(clickPos, curRect) then
      hit = 1
      exit repeat
    end if
  end repeat
  if not hit then
    exit
  end if
  if not ilFrameMouseHooks[idx] then
    exit
  end if
  oModule = iloModules[idx]
  if not objectp(oModule) then
    exit
  end if
  org = ilkFrameOrgs[idx]
  clickPos = clickPos - org
  oModule.mHandleClick(clickPos)
end

on mTrackCursor me
  if not iMouseEnabled then
    exit
  end if
  if (iState <> #running) and (iState <> #switchingModule) then
    ioCursorControl.mSetCursor(#wait)
    exit
  end if
  if ioGlobalUI.mTrackCursor() then
    exit
  end if
  mLoc = the mouseLoc
  idx = 0
  hit = 0
  repeat with curRect in ilkFrameRects
    idx = idx + 1
    if inside(mLoc, curRect) then
      hit = 1
      exit repeat
    end if
  end repeat
  if not hit then
    ioCursorControl.mSetCursor(#inactive)
    exit
  end if
  if not ilFrameMouseHooks[idx] then
    ioCursorControl.mSetCursor(#inactive)
    exit
  end if
  oModule = iloModules[idx]
  if not objectp(oModule) then
    ioCursorControl.mSetCursor(#inactive)
    exit
  end if
  org = ilkFrameOrgs[idx]
  mLoc = mLoc - org
  if oModule.mGetCursorState(mLoc) then
    ioCursorControl.mSetCursor(#Active)
  else
    ioCursorControl.mSetCursor(#inactive)
  end if
end

on mSetFrameMouseHook me, frameID, State
  ilFrameMouseHooks[frameID] = State
end

on mDisableMouse me
  iMouseEnabled = 0
end

on mEnableMouse me
  iMouseEnabled = 1
end

on mBuildFrameOrigins me
  ilkFrameOrgs = []
  repeat with curRect in ilkFrameRects
    ilkFrameOrgs.add(point(curRect[1], curRect[2]))
  end repeat
end

on mGetFrameRect me, frameID
  if (frameID < 1) or (frameID > ikNbFrames) then
    return 
  end if
  return ilkFrameRects[frameID]
end

on mGetFrameSprites me, frameID
  if (frameID < 1) or (frameID > ikNbFrames) then
    return 
  end if
  return ilkFrameSprs[frameID]
end

on mHasAltModule me, frameID
  if (frameID < 1) or (frameID > ikNbFrames) then
    return 0
  end if
  return ilkModuleCounts[frameID] >= 2
end

on mKillSong me
  ioConsole.ioSongMgr.mKillSong(ioConsole.iSongID)
end
