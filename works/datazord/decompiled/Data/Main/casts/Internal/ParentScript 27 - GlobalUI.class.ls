property ancestor, ioConsole, ioRegionHandler, ioCursorControl, ioSong, ikUIbgdSpr, ikVolumeSpr, ikUIbgdMbr, ikOrgPt, ikUIrect, ikHelpScreenshotMbr, ikHelpMaskMbr, ikHelpTextMbr, iklHelpKeyMbrs, ikFgdUtilSpr, ikHelpMaskSpr, ikHelpStampPictSpr, ikHelpStampTextSpr, ikHelpHiliteMbr, ikQuitHiliteMbr, iklVolumeMbrs, iklVolumeHiliteMbrs, iklVolumeMap, ikNbVolumeSteps, ikQuitDlogMbr, ikScreenMaskSpr, ikScreenMaskMbr, ikMDZhelpKeyOffset, iklVolumeSnd, iklHelpLoop, iklHelpGroupID, iklHelpNoteID, ikVolKey, ikQuitKey, ikHelpKey, ikEscKey, iStepFrameEnabled, iHelpState, ilSavedActorList, iCurVolumeIdx
global koConstants

on new me, oConsole, zordID
  ioConsole = oConsole
  ioCursorControl = ioConsole.ioCursorControl
  ikScreenMaskMbr = 102
  ikUIbgdSpr = 110
  ikUIbgdMbr = 131
  iklVolumeSnd = [#bank: 2, #pgm: 2, #vel: 100, #action: #play, #note: 62, #dur: 500]
  iklHelpLoop = [#bank: 2, #pgm: 35, #vel: 100, #action: #on, #note: 59, #dur: 500]
  iklHelpGroupID = #helpGroup
  iklHelpNoteID = #helpNote
  ikOrgPt = point(201, 441)
  ikUIrect = offset(member(ikUIbgdMbr, 2).rect, ikOrgPt[1], ikOrgPt[2])
  regionMbr = member(121, 2)
  ioRegionHandler = new(script(koConstants.ikRegionHandlerClass), regionMbr)
  ikHelpHiliteMbr = 151
  ikQuitHiliteMbr = 152
  ikQuitDlogMbr = 141
  iklVolumeMbrs = [153, 154, 155, 156]
  iklVolumeHiliteMbrs = [157, 158, 159, 160]
  iklVolumeMap = [0, 30, 60, 100]
  ikNbVolumeSteps = 4
  iCurVolumeIdx = 4
  ikVolumeSpr = 111
  ioConsole.ioSong.mSetVolume(iklVolumeMap[iCurVolumeIdx])
  iklHelpKeyMbrs = ["a": 501, "b": 502, "c": 503, "d": 504, "e": 505, "f": 506, "g": 507, "h": 508, "i": 509, "j": 510, "k": 511, "l": 512, "m": 513, "n": 514, "o": 515, "p": 516, "q": 517, "r": 518, "s": 519, "t": 520, "u": 521, "v": 522, "w": 523, "x": 524, "y": 525, "z": 526, "[": 527, "]": 528, "\": 529, ";": 530, ",": 531, ".": 532, "/": 533, "`": 534, "1": 535, "2": 536, "3": 537, "4": 538, "5": 539, "6": 540, "7": 541, "8": 542, "9": 543, "0": 544, "-": 545, "=": 546, "'": 547]
  sort(iklHelpKeyMbrs)
  ikMDZhelpKeyOffset = 60
  ikHelpScreenshotMbr = 552
  ikHelpMaskMbr = 551
  ikHelpTextMbr = 553
  ikFgdUtilSpr = 112
  ikHelpMaskSpr = 113
  ikHelpStampPictSpr = 114
  ikHelpStampTextSpr = 115
  ikScreenMaskSpr = 119
  sprite(ikHelpStampPictSpr).trails = 1
  sprite(ikHelpStampTextSpr).trails = 1
  ikVolKey = 9
  ikQuitKey = 12
  ikHelpKey = 34
  ikEscKey = 53
  iHelpState = 0
  ilSavedActorList = []
  iStepFrameEnabled = 0
  me.mUpdateArt()
  return me
end

on mUpdateArt me
  off = ioConsole.iCurFrameSetID - 1
  sprite(ikUIbgdSpr).member = member(ikUIbgdMbr + off, 2)
  sprite(ikUIbgdSpr).loc = ikOrgPt
  sprite(ikVolumeSpr).member = member(iklVolumeMbrs[iCurVolumeIdx] + (off * 10), 2)
  sprite(ikVolumeSpr).loc = ikOrgPt
end

on mShowHelp me
  if iHelpState then
    exit
  end if
  iHelpState = 1
  off = 10 * (ioConsole.iCurFrameSetID - 1)
  sprite(ikFgdUtilSpr).member = member(ikHelpHiliteMbr + off, 2)
  sprite(ikFgdUtilSpr).loc = ikOrgPt
  updateStage()
  ilFrameKeys = ioConsole.ioCurFrameset.ilkFrameKeys
  ilFrameOrgs = ioConsole.ioCurFrameset.ilkFrameOrgs
  ilHelpLayoutData = []
  iloModules = ioConsole.ioCurFrameset.iloModules
  idx = 0
  repeat with oModule in iloModules
    idx = idx + 1
    if objectp(oModule) then
      ilHelpLayoutData[idx] = oModule.iklHelpMap
      next repeat
    end if
    ilHelpLayoutData[idx] = 0
  end repeat
  ioConsole.ioSong.mSuspend()
  ilSavedActorList = duplicate(the actorList)
  the actorList = [ioConsole.ioSongMgr]
  sprite(ikHelpMaskSpr).member = member(ikHelpMaskMbr, 2)
  sprite(ikHelpMaskSpr).loc = point(0, 0)
  sprite(ikHelpMaskSpr).ink = 32
  sprite(ikHelpMaskSpr).blend = 70
  iklHelpNoteID = ioConsole.ioSong.mPostEvent(iklHelpLoop)
  updateStage()
  ioCursorControl.mSetCursor(#inactive)
  mbrOffset = 0
  if ioConsole.iCurFrameSetID = 6 then
    mbrOffset = ikMDZhelpKeyOffset
  end if
  modIdx = 0
  repeat with lModuleData in ilHelpLayoutData
    modIdx = modIdx + 1
    if not listp(lModuleData) then
      next repeat
    end if
    lModuleKeys = ilFrameKeys[modIdx]
    orgPt = ilFrameOrgs[modIdx]
    keyIdx = 0
    repeat with lKeyData in lModuleData
      ms = the milliSeconds
      keyIdx = keyIdx + 1
      if not listp(lKeyData) then
        next repeat
      end if
      keyChar = lModuleKeys[keyIdx]
      keyMbr = iklHelpKeyMbrs.getaProp(keyChar) + mbrOffset
      if voidp(keyMbr) then
        next repeat
      end if
      sprite(ikHelpStampPictSpr).member = member(keyMbr, 2)
      sprite(ikHelpStampPictSpr).loc = orgPt + lKeyData[3]
      updateStage()
      sprite(ikHelpStampPictSpr).locH = -1000
      updateStage()
      repeat while the milliSeconds < (ms + 50)
      end repeat
    end repeat
  end repeat
  lOffLoop = duplicate(iklHelpLoop)
  lOffLoop.setaProp(#noteID, iklHelpNoteID)
  lOffLoop.setaProp(#action, #off)
  lOffLoop.setaProp(#offTime, the milliSeconds)
  ioConsole.ioSong.mPostEvent(lOffLoop)
end

on mHideHelp me
  if not iHelpState then
    exit
  end if
  iHelpState = 0
  sprite(ikFgdUtilSpr).locH = -1000
  sprite(ikHelpMaskSpr).ink = 36
  sprite(ikHelpMaskSpr).blend = 100
  sprite(ikHelpMaskSpr).locH = -1000
  sprite(ikFgdUtilSpr).locH = -1000
  the actorList = duplicate(ilSavedActorList)
  ilSavedActorList = []
  ioConsole.ioSong.mResume()
  updateStage()
end

on mTrackCursor me
  if iHelpState then
    return 1
  end if
  mPt = the mouseLoc
  if not inside(mPt, ikUIrect) then
    return 0
  end if
  mPt = mPt - ikOrgPt
  regionIndex = ioRegionHandler.mGetRegionIndex(mPt)
  if (regionIndex < 1) or (regionIndex > 3) then
    return 0
  end if
  ioCursorControl.mSetCursor(#Active)
  return 1
end

on mHandleClick me, clickPos
  if iHelpState then
    me.mHideHelp()
    return 1
  end if
  mPt = the clickLoc
  if not inside(mPt, ikUIrect) then
    return 0
  end if
  mPt = mPt - ikOrgPt
  regionIndex = ioRegionHandler.mGetRegionIndex(mPt)
  if (regionIndex < 1) or (regionIndex > 3) then
    return 0
  end if
  case regionIndex of
    1:
      me.mShowHelp()
      return 1
    2:
      me.mStepVolume()
      return 1
    3:
      me.mDoQuitBtn()
      return 1
    otherwise:
      return 0
  end case
end

on mStepVolume me
  off = 10 * (ioConsole.iCurFrameSetID - 1)
  sprite(ikVolumeSpr).member = member(iklVolumeHiliteMbrs[iCurVolumeIdx] + off, 2)
  sprite(ikVolumeSpr).loc = ikOrgPt
  ioConsole.ioSong.mPostEvent(iklVolumeSnd)
  updateStage()
  iCurVolumeIdx = iCurVolumeIdx + 1
  if iCurVolumeIdx > ikNbVolumeSteps then
    iCurVolumeIdx = 1
  end if
  ioConsole.ioSong.mSetVolume(iklVolumeMap[iCurVolumeIdx])
  cue = the milliSeconds + 20
  repeat while the milliSeconds < cue
  end repeat
  repeat while the mouseDown
  end repeat
  sprite(ikVolumeSpr).member = member(iklVolumeMbrs[iCurVolumeIdx] + off, 2)
  sprite(ikVolumeSpr).loc = ikOrgPt
  updateStage()
end

on mDoQuitBtn me
  ioConsole.ioSong.mSuspend()
  ilSavedActorList = duplicate(the actorList)
  the actorList = [ioConsole.ioSongMgr]
  off = 10 * (ioConsole.iCurFrameSetID - 1)
  sprite(ikFgdUtilSpr).member = member(ikQuitHiliteMbr + off, 2)
  sprite(ikFgdUtilSpr).loc = ikOrgPt
  updateStage()
  ioCursorControl.mSetCursor(#inactive)
  pictMbr = ikQuitDlogMbr + ioConsole.iCurFrameSetID - 1
  lCBdata = [me, #mQuitCallback, #confirmQuit]
  runQuitDialog(pictMbr, lCBdata)
end

on mQuitCallback me, Selector, btnClicked
  sprite(ikFgdUtilSpr).locH = -1000
  updateStage()
  if btnClicked = #cancel then
    the actorList = duplicate(ilSavedActorList)
    ilSavedActorList = []
    ioConsole.ioSong.mResume()
    exit
  end if
  the actorList = []
  ioConsole.mDisableEvents()
  sprite(ikScreenMaskSpr).member = member(ikScreenMaskMbr, 1)
  sprite(ikScreenMaskSpr).loc = point(0, 0)
  updateStage()
  go("black")
end

on mHandleKey me, aKeyCode
  if iHelpState then
    me.mHideHelp()
    return 1
  end if
  cmd = the commandDown
  case aKeyCode of
    ikEscKey:
      me.mDoQuitBtn()
      return 1
    ikHelpKey:
      if cmd then
        me.mShowHelp()
        return 1
      else
        return 0
      end if
    ikQuitKey:
      if cmd then
        me.mDoQuitBtn()
        return 1
      else
        return 0
      end if
    ikVolKey:
      if cmd then
        me.mStepVolume()
        return 1
      else
        return 0
      end if
    otherwise:
      return 0
  end case
  return 0
end

on stepFrame me
end

on mSetStepFrameHook me, State
  if State = iStepFrameEnabled then
    exit
  end if
  iStepFrameEnabled = State
  if iStepFrameEnabled then
    add(the actorList, me)
  else
    deleteOne(the actorList, me)
  end if
end
