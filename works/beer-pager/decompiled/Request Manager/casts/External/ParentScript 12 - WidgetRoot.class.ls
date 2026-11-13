property ioModule, ioWidgetQueueMgr, ancestor, ilkSprs, ikWidgetID, ikFullID, ikOrgPt, iklWidgetData, ikCastLibNum, iStepFrameEnabled, iState
global oSoundMgr

on new me, oModule, widgetID, spr, canInterrupt, fullID
  if not voidp(oSoundMgr) then
    ioModule = [#ioFrameset: [#ioSong: oSoundMgr]]
  end if
  ikWidgetID = 1
  ikOrgPt = point(0, 0)
  ilkSprs = [1, 2]
  iStepFrameEnabled = 0
  fldName = "wdgData_" & fullID
  if the number of member fldName > 0 then
    if member(fldName, ikCastLibNum).type = #field then
      iklWidgetData = parseListData(member(fldName, ikCastLibNum))
    else
      iklWidgetData = 0
    end if
  else
    iklWidgetData = 0
  end if
  iState = #ready
  return me
end

on mSyncNotify me
  iState = #synced
  me.mSetStepFrameHook(0)
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
