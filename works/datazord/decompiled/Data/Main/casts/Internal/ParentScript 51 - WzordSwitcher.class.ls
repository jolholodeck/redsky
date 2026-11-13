property ancestor, ioConsole, iCurZordID, ikTargetZordID, iklLoopAnim, iklTriggerAnim, ikSpr, ikOffPt, ikNbLoopFrames, ikNbTriggerFrames, iCurFrame, iMode, iklActiveSnd, iklInactiveSnd, ikIsPinkZord
global goConsole, gIsPinkZord

on new me, oModule, widgetID, lSprs
  ancestor = new(script("WidgetRoot.class"), oModule, widgetID, lSprs)
  ioConsole = me.ioModule.ioFrameset.ioConsole
  iklActiveSnd = [#bank: 2, #pgm: 31, #vel: 100, #action: #play, #note: 48, #dur: 500]
  iklInactiveSnd = [#bank: 2, #pgm: 34, #vel: 100, #action: #play, #note: 69, #dur: 500]
  ikTargetZordID = me.iklWidgetData.zordID
  ikIsPinkZord = 0
  if ikTargetZordID > 6 then
    ikTargetZordID = 4
    ikIsPinkZord = 1
  end if
  iCurZordID = me.ioModule.ioFrameset.ikFramesetID
  if ikTargetZordID = iCurZordID then
    iMode = #targetZord
  else
    targetZordState = me.ioModule.ioFrameset.ioConsole.mGetFramesetState(ikTargetZordID)
    if targetZordState then
      iMode = #enabled
    else
      iMode = #disabled
    end if
  end if
  case iMode of
    #enabled:
      iklLoopAnim = me.iklWidgetData.enabledLoop
      iklTriggerAnim = me.iklWidgetData.enabledAnim
    #disabled:
      iklLoopAnim = me.iklWidgetData.disabledLoop
      iklTriggerAnim = me.iklWidgetData.disabledAnim
    #targetZord:
      iklLoopAnim = me.iklWidgetData.targetZordLoop
      iklTriggerAnim = []
  end case
  ikNbLoopFrames = iklLoopAnim.count
  ikNbTriggerFrames = iklTriggerAnim.count
  iCurFrame = 0
  ikSpr = lSprs[1]
  return me
end

on mStartup me
  me.iState = #running
  iCurFrame = 1
  sprite(ikSpr).member = member(iklLoopAnim[iCurFrame], me.ikCastLibNum)
  sprite(ikSpr).loc = me.ikOrgPt
  if iMode = #targetZord then
    me.mSetStepFrameHook(1)
  end if
end

on mTrigger me, Selector, source
  if me.iState <> #running then
    exit
  end if
  if iMode = #targetZord then
    exit
  end if
  if me.ioModule.ioFrameset.iState <> #running then
    exit
  end if
  if me.ioModule.iState <> #running then
    exit
  end if
  me.iState = #triggered
  if iMode = #enabled then
    me.ioModule.ioFrameset.mPrepareFramesetSwitch()
    ioConsole.ioSong.mPostEvent(iklActiveSnd)
  else
    ioConsole.ioSong.mPostEvent(iklInactiveSnd)
  end if
  me.mSetStepFrameHook(1)
  iCurFrame = 0
  gIsPinkZord = ikIsPinkZord
end

on mGetCursorState me
  if me.iState <> #running then
    return 0
  end if
  if me.ioModule.ioFrameset.iState <> #running then
    return 0
  end if
  if iMode = #targetZord then
    return 0
  end if
  return 1
end

on stepFrame me
  case me.iState of
    #running:
      iCurFrame = iCurFrame + 1
      if iCurFrame > ikNbLoopFrames then
        iCurFrame = 1
      end if
      sprite(ikSpr).member = member(iklLoopAnim[iCurFrame], me.ikCastLibNum)
    #triggered:
      iCurFrame = iCurFrame + 1
      if iCurFrame > ikNbTriggerFrames then
        case iMode of
          #enabled:
            me.mSetStepFrameHook(0)
            me.ioModule.ioFrameset.ioConsole.mgotoframeset(ikTargetZordID)
          #disabled:
            sprite(ikSpr).member = member(iklLoopAnim[1], me.ikCastLibNum)
            me.mSetStepFrameHook(0)
            me.iState = #running
        end case
        exit
      end if
      sprite(ikSpr).member = member(iklTriggerAnim[iCurFrame], me.ikCastLibNum)
  end case
end

on mSync me
  sprite(ikSpr).member = member(iklLoopAnim[1], me.ikCastLibNum)
  me.mSyncNotify()
end
