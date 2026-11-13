property ioModule, ioWidgetQueueMgr, ancestor, ilkSprs, ikWidgetID, ikFullID, ikOrgPt, iklWidgetData, ikCastLibNum, ikCanInterrupt, iStepFrameEnabled, iState, iCurTagName

on new me, oModule, widgetID, lSprs, canInterrupt
  iCurTagName = #undefined
  ioModule = oModule
  ioWidgetQueueMgr = ioModule.ioFrameset.ioConsole.ioWidgetQueueMgr
  ikWidgetID = widgetID
  ikFullID = ioModule.ikFullID & "." & string(ikWidgetID)
  ikOrgPt = ioModule.ikOrgPt
  ikCastLibNum = ioModule.ikCastLibNum
  ilkSprs = lSprs
  ikCanInterrupt = canInterrupt
  iStepFrameEnabled = 0
  fldName = "wdgData_" & me.ikFullID
  mbrType = member(fldName, me.ikCastLibNum).type
  if (mbrType = #field) or (mbrType = #text) then
    iklWidgetData = parseListData(member(fldName, me.ikCastLibNum), 1)
  else
    iklWidgetData = 0
  end if
  if not listp(iklWidgetData) then
    iklWidgetData = 0
  end if
  iState = #ready
  return me
end

on mSyncNotify me
  iState = #synced
  me.mSetStepFrameHook(0)
  ioModule.mSyncCallback(ikWidgetID)
  ioWidgetQueueMgr.mUnregisterWidget(me)
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

on mShutdown me
  ioWidgetQueueMgr.mUnregisterWidget(me)
  me.mSetStepFrameHook(0)
  if getPos(the actorList, me) then
    put "error in widgetroot mShutdown: obj still in actorlist"
  end if
  iklWidgetData = 0
  ilkSprs = 0
  ikWidgetID = 0
  ikFullID = 0
  ikOrgPt = 0
  iklWidgetData = 0
  ikCastLibNum = 0
  ikCanInterrupt = 0
  iStepFrameEnabled = 0
  iState = 0
  iCurTagName = 0
end

on mGetCursorState me
  return iState = #running
end

on mStartup me
end

on mTrigger me, Selector, source
end

on mInterrupt me
end

on mSync me
end

on stepFrame me
end
