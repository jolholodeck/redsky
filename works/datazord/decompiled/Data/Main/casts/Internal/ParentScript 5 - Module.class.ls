property ioFrameset, ioConsole, ioRegionHandler, ancestor, ikFrameID, ikModuleID, ikFullID, ikCastLibNum, iklModuleData, ilkModuleKeys, iklWidgetSprs, ikFgdSpr, ikBgdSpr, iklRegionTriggers, iklKbdTriggers, ikloWidgets, ikNbWidgets, iklTransitionMbrs, ikNbTransitionFrames, ikBgdMbr, ikOrgPt, ikFrameRect, iklHelpMap, iklInterrupts, iklModuleIntroSnd, iklModuleExtroSnd, iklModuleBgdLoop, iklBgdLoopGroupID, iklBgdLoopNoteID, ikSlideStartFrame, iStepFrameEnabled, iState, ilFreeSprs, iNbUnsyncedWidgets, iCurTransitionFrame
global koConstants, goMemoryMgr, gRolloverWidget

on new me, oFrameset, frameID, moduleID, libNum, lModuleKeys
  ioFrameset = oFrameset
  ioConsole = ioFrameset.ioConsole
  ikFrameID = frameID
  ikModuleID = moduleID
  ikFullID = ioFrameset.ikFullID & "." & string(ikFrameID) & "." & string(ikModuleID)
  ikCastLibNum = libNum
  ilkModuleKeys = lModuleKeys
  iklRegionTriggers = [:]
  iklKbdTriggers = [:]
  ikloWidgets = []
  iNbUnsyncedWidgets = 999
  ikFrameRect = ioFrameset.mGetFrameRect(frameID)
  ikOrgPt = point(ikFrameRect.left, ikFrameRect.top)
  iklWidgetSprs = duplicate(ioFrameset.mGetFrameSprites(frameID))
  sort(iklWidgetSprs)
  cnt = iklWidgetSprs.count()
  ikFgdSpr = iklWidgetSprs[cnt]
  iklWidgetSprs.deleteAt(cnt)
  ikBgdSpr = iklWidgetSprs[1]
  iklWidgetSprs.deleteAt(1)
  ilFreeSprs = duplicate(iklWidgetSprs)
  sort(ilFreeSprs)
  iStepFrameEnabled = 0
  iklModuleData = parseListData(member("modData_" & ikFullID, ikCastLibNum))
  iklTransitionMbrs = iklModuleData.transitionMbrs
  iklHelpMap = iklModuleData.helpMap
  iklInterrupts = iklModuleData.interrupts
  if not listp(iklInterrupts) then
    iklInterrupts = []
    repeat with X = 1 to iklModuleData.widgetClasses.count
      iklInterrupts[X] = 1
    end repeat
  end if
  iCurTransitionFrame = 0
  ikNbTransitionFrames = iklTransitionMbrs.count
  ikBgdMbr = iklTransitionMbrs[ikNbTransitionFrames]
  iklModuleIntroSnd = [#bank: 2, #pgm: 92, #vel: 100, #action: #play, #note: 47, #dur: 1000]
  iklModuleExtroSnd = [#bank: 2, #pgm: 83, #vel: 100, #action: #play, #note: 45, #dur: 1000]
  iklModuleBgdLoop = [#bank: 2, #pgm: 11, #vel: 60, #action: #loop, #note: 43, #dur: 1500]
  iklBgdLoopGroupID = #moduleGroup
  iklBgdLoopNoteID = #moduleNote
  iklModuleBgdLoop.addProp(#srcID, iklBgdLoopGroupID)
  iklModuleBgdLoop.addProp(#tag, iklBgdLoopNoteID)
  ikSlideStartFrame = getaProp(iklModuleData, #startSlideFrame)
  if not integerp(ikSlideStartFrame) then
    ikSlideStartFrame = 3
  end if
  ikSlideStartFrame = ikSlideStartFrame - 1
  me.ioRegionHandler = new(script(koConstants.ikRegionHandlerClass), member(iklModuleData.regionDataMbr, ikCastLibNum))
  me.mBuildWidgets()
  iState = #ready
  return me
end

on mBuildWidgets me
  ikloWidgets = []
  iklRegionTriggers = [:]
  iklKbdTriggers = [:]
  ikNbWidgets = iklModuleData.widgetClasses.count
  repeat with widgetID = 1 to ikNbWidgets
    scriptName = iklModuleData.widgetClasses[widgetID]
    if iklModuleData.widgetClassLocs[widgetID] = #internal then
      libNum = 1
    else
      libNum = ikCastLibNum
    end if
    lSprs = []
    nbSprs = iklModuleData.nbWidgetSprites[widgetID]
    repeat with spr = 1 to nbSprs
      lSprs.add(me.mGetFreeSprite(#bgd))
    end repeat
    canInterrupt = iklInterrupts[widgetID]
    oWidget = new(script(scriptName, libNum), me, widgetID, lSprs, canInterrupt)
    if not objectp(oWidget) then
      alert("Couldn't build widget " & ikFullID & "." & widgetID)
      halt()
    end if
    ikloWidgets[widgetID] = oWidget
  end repeat
  lWidgetKeymap = iklModuleData.widgetKeyMap
  cnt = lWidgetKeymap.count
  if cnt > ilkModuleKeys.count then
    diff = cnt - ilkModuleKeys.count
    alert("Module " & ikFullID & " needs " & diff & " more keys than are currently assigned to its frame.")
    halt()
  end if
  repeat with X = 1 to cnt
    if not listp(lWidgetKeymap[X]) then
      next repeat
    end if
    widgetID = lWidgetKeymap[X][1]
    Selector = lWidgetKeymap[X][2]
    triggerKey = ilkModuleKeys[X]
    oWidget = ikloWidgets[widgetID]
    iklKbdTriggers.addProp(triggerKey, [oWidget, Selector])
  end repeat
  lWidgetRegionMap = iklModuleData.widgetRegionMap
  cnt = lWidgetRegionMap.count
  repeat with X = 1 to cnt
    if not listp(lWidgetRegionMap[X]) then
      next repeat
    end if
    widgetID = lWidgetRegionMap[X][1]
    Selector = lWidgetRegionMap[X][2]
    oWidget = ikloWidgets[widgetID]
    iklRegionTriggers.addProp(X, [oWidget, Selector])
  end repeat
end

on mGetFreeSprite me, layer
  cnt = ilFreeSprs.count()
  if cnt < 1 then
    return 0
  end if
  if layer = #fgd then
    spr = ilFreeSprs[cnt]
    ilFreeSprs.deleteAt(cnt)
  else
    spr = ilFreeSprs[1]
    ilFreeSprs.deleteAt(1)
  end if
  return spr
end

on mHandleClick me, hitPt
  regionIndex = ioRegionHandler.mGetRegionIndex(hitPt)
  widgetData = iklRegionTriggers.getaProp(regionIndex)
  if not listp(widgetData) then
    exit
  end if
  widgetData[1].mTrigger(widgetData[2], regionIndex)
end

on mGetCursorState me, hitPt
  gRolloverWidget = EMPTY
  if iState <> #running then
    return 0
  end if
  regionIndex = ioRegionHandler.mGetRegionIndex(hitPt)
  widgetData = iklRegionTriggers.getaProp(regionIndex)
  if not listp(widgetData) then
    return 0
  end if
  gRolloverWidget = widgetData[1]
  return widgetData[1].mGetCursorState()
end

on mFastStartup me
  sprite(ikBgdSpr).member = member(ikBgdMbr, ikCastLibNum)
  sprite(ikBgdSpr).loc = ikOrgPt
  repeat with oWidget in ikloWidgets
    oWidget.mStartup()
  end repeat
  ioFrameset.ioConsole.ioKbdHandler.mRegisterModule(me, me.iklKbdTriggers)
  ioFrameset.mSetFrameMouseHook(ikFrameID, 1)
  iState = #running
end

on mSlowStartup me
  goMemoryMgr.mPreloadMembers(iklTransitionMbrs, ikCastLibNum, 1)
  iCurTransitionFrame = 1
  sprite(ikFgdSpr).member = member(iklTransitionMbrs[iCurTransitionFrame], ikCastLibNum)
  sprite(ikFgdSpr).loc = ikOrgPt
  iState = #introAnim
  me.mSetStepFrameHook(1)
  ioConsole.ioSong.mPostEvent(iklModuleBgdLoop)
end

on mFastShutdown me
  ioFrameset.ioConsole.ioKbdHandler.mUnregisterModule(me)
  ioFrameset.mSetFrameMouseHook(ikFrameID, 0)
  repeat with oWidget in ikloWidgets
    oWidget.mShutdown()
  end repeat
  me.mReleaseWidgetSprs()
  me.mReleaseSupportSprs()
  repeat with oWidget in ikloWidgets
    oWidget = 0
  end repeat
  ikloWidgets = 0
  ioRegionHandler = 0
  iState = #shutDown
  me.mDeleteAllProps()
end

on mSlowShutdown me
  ioFrameset.ioConsole.ioKbdHandler.mUnregisterModule(me)
  ioFrameset.mSetFrameMouseHook(ikFrameID, 0)
  ioRegionHandler = 0
  goMemoryMgr.mPreloadMembers(iklTransitionMbrs, ikCastLibNum, 1)
  me.iNbUnsyncedWidgets = ikloWidgets.count
  repeat with oWidget in ikloWidgets
    oWidget.mSync()
  end repeat
  iState = #syncing
end

on mDeleteAllProps me
  obj = me
  cnt = count(me)
  repeat with X = 1 to cnt
    curProp = obj.getPropAt(X)
    obj[X] = 0
  end repeat
end

on mSyncCallback me, widgetID
  iNbUnsyncedWidgets = iNbUnsyncedWidgets - 1
  if iNbUnsyncedWidgets > 0 then
    exit
  end if
  iCurTransitionFrame = ikNbTransitionFrames
  sprite(ikFgdSpr).member = member(iklTransitionMbrs[iCurTransitionFrame], ikCastLibNum)
  sprite(ikFgdSpr).loc = ikOrgPt
  ioConsole.ioSong.mPostEvent(iklModuleExtroSnd)
  ioConsole.ioSong.mPostEvent(iklModuleBgdLoop)
  me.mReleaseWidgetSprs()
  repeat with oWidget in ikloWidgets
    oWidget.mShutdown()
  end repeat
  repeat with oWidget in ikloWidgets
    oWidget = 0
  end repeat
  ikloWidgets = 0
  iState = #extroAnim
  me.mSetStepFrameHook(1)
end

on mReleaseWidgetSprs me
  repeat with spr in iklWidgetSprs
    sprite(spr).locH = -1000
    sprite(spr).member = koConstants.ikDummyMbr
  end repeat
end

on mReleaseSupportSprs me
  sprite(ikFgdSpr).locH = -1000
  sprite(ikFgdSpr).member = koConstants.ikDummyMbr
  sprite(ikBgdSpr).locH = -1000
  sprite(ikBgdSpr).member = koConstants.ikDummyMbr
end

on stepFrame me
  case iState of
    #introAnim:
      iCurTransitionFrame = iCurTransitionFrame + 1
      if iCurTransitionFrame = ikSlideStartFrame then
        ioConsole.ioSong.mPostEvent(iklModuleIntroSnd)
      end if
      if iCurTransitionFrame > ikNbTransitionFrames then
        ioConsole.ioSong.mStopLoops(iklBgdLoopGroupID, iklBgdLoopNoteID)
        me.mFastStartup()
        me.mSetStepFrameHook(0)
        sprite(ikBgdSpr).member = member(ikBgdMbr, ikCastLibNum)
        sprite(ikBgdSpr).loc = ikOrgPt
        sprite(ikFgdSpr).locH = -1000
        iState = #running
        ioFrameset.mModuleStartupCallback(ikFrameID, ikModuleID)
        exit
      end if
      sprite(ikFgdSpr).member = member(iklTransitionMbrs[iCurTransitionFrame], ikCastLibNum)
    #extroAnim:
      iCurTransitionFrame = iCurTransitionFrame - 1
      if iCurTransitionFrame < 1 then
        me.mSetStepFrameHook(0)
        iState = #shutDown
        ioFrameset.mModuleShutdownCallback(ikFrameID, ikModuleID)
        me.mDeleteAllProps()
        exit
      end if
      sprite(ikFgdSpr).member = member(iklTransitionMbrs[iCurTransitionFrame], ikCastLibNum)
  end case
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
