property ancestor, ioConsole, iklAnimMbrs, ikNbAnimFrames, ikNbFlashFrames, iCurFrame, ikSpr, ikOffPt, iklFlashMbrs, iTriggerMode, ikFlashCue, iNextFlashTime, ikCanSwitch, iklClickSnd, iklBlinkSnd

on new me, oModule, widgetID, lSprs
  ancestor = new(script("WidgetRoot.class"), oModule, widgetID, lSprs)
  if not listp(me.iklWidgetData) then
    return -1
  end if
  ioConsole = me.ioModule.ioFrameset.ioConsole
  iklClickSnd = [#bank: 2, #pgm: 27, #vel: 100, #action: #play, #note: 60, #dur: 500]
  iklBlinkSnd = [#bank: 2, #pgm: 25, #vel: 100, #action: #play, #note: 43, #dur: 500]
  ikCanSwitch = me.ioModule.ioFrameset.mHasAltModule(me.ioModule.ikFrameID)
  iklAnimMbrs = me.iklWidgetData.animMbrs
  ikNbAnimFrames = iklAnimMbrs.count
  iklFlashMbrs = me.iklWidgetData.flashMbrs
  ikNbFlashFrames = iklFlashMbrs.count
  ikSpr = lSprs[1]
  ikOffPt = point(0, 0)
  iCurFrame = 1
  ikFlashCue = 1000 / 3
  iNextFlashTime = 0
  iTriggerMode = #ready
  return me
end

on mTrigger me, Selector, source
  if not ikCanSwitch then
    exit
  end if
  if me.ioModule.ioFrameset.iState <> #running then
    exit
  end if
  if me.iState = #triggered then
    exit
  end if
  me.iState = #triggered
  iTriggerMode = #animating
  iCurFrame = 0
  me.ioModule.ioFrameset.mSwitchModule(me.ioModule.ikFrameID)
  me.mSetStepFrameHook(1)
  ioConsole.ioSong.mPostEvent(iklClickSnd)
end

on stepFrame me
  case iTriggerMode of
    #animating:
      iCurFrame = iCurFrame + 1
      if iCurFrame > ikNbAnimFrames then
        iCurFrame = 0
        iTriggerMode = #waiting
        exit
      end if
      sprite(ikSpr).member = member(iklAnimMbrs[iCurFrame], me.ikCastLibNum)
    #waiting:
      iCurFrame = iCurFrame + 1
      if iCurFrame > ikNbFlashFrames then
        iCurFrame = 1
        ioConsole.ioSong.mPostEvent(iklBlinkSnd)
      end if
      sprite(ikSpr).member = member(iklFlashMbrs[iCurFrame], me.ikCastLibNum)
      if me.ioModule.iNbUnsyncedWidgets <= 1 then
        if iCurFrame = 1 then
          sprite(ikSpr).member = member(iklAnimMbrs[1], me.ikCastLibNum)
          me.mSyncNotify()
          exit
        end if
      end if
  end case
end

on mSync me
end

on mStartup me
  sprite(ikSpr).member = member(iklAnimMbrs[1], me.ikCastLibNum)
  sprite(ikSpr).loc = me.ikOrgPt + ikOffPt
  me.iState = #running
end

on mGetCursorState me
  if me.ioModule.ioFrameset.iState <> #running then
    return 0
  end if
  if not ikCanSwitch then
    return 0
  end if
  return me.iState = #running
end
