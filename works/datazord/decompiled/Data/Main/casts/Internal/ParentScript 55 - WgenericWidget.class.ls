property ancestor, ioWidgetQueueMgr, ioSong, iklTags, iklSoundEvents, ikLoopID, ilCurTag, iCurTagName, ikSpr, ikBgSpr, iCurFrame, iNbFrames, iLoopbackFrame, iNbRepeats, iCurRepeat, iDir, iSameFrame, iLoopTag, iSyncFromInterrupt
global koConstants, goMemoryMgr

on new me, oModule, widgetID, lSprs, canInterrupt
  ancestor = new(script("WidgetRoot.class"), oModule, widgetID, lSprs, canInterrupt)
  ikLoopID = "mod_" & me.ioModule.ikFullID
  repeat with X = 1 to 2
    put "_" into char ((X * 2) + 4) of ikLoopID
  end repeat
  ikLoopID = symbol(ikLoopID)
  ioWidgetQueueMgr = me.ioModule.ioFrameset.ioConsole.ioWidgetQueueMgr
  iklTags = me.iklWidgetData.iklTags
  fldName = "wdgSoundData_" & me.ikFullID
  iklSoundEvents = 0
  mbrType = member(fldName, me.ikCastLibNum).type
  if (mbrType = #field) or (mbrType = #text) then
    iklSoundEvents = value(member(fldName).text)
  else
    iklSoundEvents = 0
  end if
  if not listp(iklSoundEvents) then
    iklSoundEvents = 0
  end if
  ikBgSpr = lSprs[1]
  ikSpr = lSprs[2]
  return me
end

on mShutdown me
  ioWidgetQueueMgr.mUnregisterWidget(me)
  me.mSetStepFrameHook(0)
  iklTags = 0
  iklSoundEvents = 0
  ilCurTag = 0
  ikLoopID = 0
  ilCurTag = 0
  iCurTagName = 0
  ikSpr = 0
  ikBgSpr = 0
  iCurFrame = 0
  iNbFrames = 0
  iLoopbackFrame = 0
  iNbRepeats = 0
  iCurRepeat = 0
  iDir = 0
  iSameFrame = 0
  iLoopTag = 0
  iSyncFromInterrupt = 0
  me.iklWidgetData = 0
  me.ilkSprs = 0
  me.ikWidgetID = 0
  me.ikFullID = 0
  me.ikOrgPt = 0
  me.iklWidgetData = 0
  me.ikCastLibNum = 0
  me.ikCanInterrupt = 0
  me.iStepFrameEnabled = 0
  me.iState = 0
  me.iCurTagName = 0
end

on mTrigger me, Selector, source
  if (me.iState = #syncing) or (me.iState = #synced) then
    exit
  end if
  if ilCurTag.trig = #dead then
    exit
  end if
  if count(the actorList) >= koConstants.ikMaxThreads then
    exit
  end if
  if me.ikCanInterrupt then
    ioWidgetQueueMgr.mRegisterWidget(me)
  end if
  me.mSetStepFrameHook(1)
  me.iState = #running
  doCut = ilCurTag.cut
  sameFrame = iSameFrame
  if doCut then
    me.mSetNextTag(#trigger)
    if sameFrame then
      iCurFrame = max(min(iCurFrame, iNbFrames), 0)
    else
      if iDir = 1 then
        iCurFrame = 0
      else
        iCurFrame = iNbFrames + 1
      end if
    end if
    if ilCurTag.bg <> 0 then
      sprite(ikBgSpr).member = member(ilCurTag.bg, me.ikCastLibNum)
    else
      sprite(ikBgSpr).member = koConstants.ikDummyMbr
    end if
  else
    ilCurTag.exit = ilCurTag.trig
    iCurRepeat = iNbRepeats
    ilCurTag.trig = #dead
  end if
end

on stepFrame me
  iCurFrame = iCurFrame + iDir
  switchTag = 0
  if (iCurFrame < 1) or (iCurFrame > iNbFrames) then
    if iLoopTag then
      if me.iState = #syncing then
        switchTag = 1
      else
        iCurFrame = iLoopbackFrame
      end if
    else
      if me.iState = #syncing then
        switchTag = 1
      else
        iCurRepeat = iCurRepeat + 1
        if iCurRepeat > iNbRepeats then
          switchTag = 1
        else
          iCurFrame = iLoopbackFrame
        end if
      end if
    end if
  end if
  if switchTag then
    if (ilCurTag.exit = #stop) and (me.iState <> #syncing) then
      ioSong.mStopLoops(ikLoopID, ilCurTag.name)
      me.mSetStepFrameHook(0)
      ioWidgetQueueMgr.mUnregisterWidget(me)
      exit
    end if
    sameFrame = iSameFrame
    if me.iState = #syncing then
      if ilCurTag.sync = #done then
        ioSong.mStopLoops(ikLoopID, ilCurTag.name)
        if iSyncFromInterrupt then
          me.iState = #stopped
          me.mSetStepFrameHook(0)
          ioWidgetQueueMgr.mUnregisterWidget(me)
        else
          me.mSyncNotify()
        end if
        exit
      else
        me.mSetNextTag(#sync)
        if iDir = 1 then
          iCurFrame = 1
        else
          iCurFrame = max(min(iCurFrame, iNbFrames), 1)
        end if
      end if
    else
      me.mSetNextTag(#exit)
      if sameFrame then
        iCurFrame = max(min(iCurFrame, iNbFrames), 1)
      else
        if iDir = 1 then
          iCurFrame = 1
        else
          iCurFrame = iNbFrames
        end if
      end if
    end if
    if ilCurTag.bg <> 0 then
      sprite(ikBgSpr).member = member(ilCurTag.bg, me.ikCastLibNum)
    else
      sprite(ikBgSpr).member = koConstants.ikDummyMbr
    end if
  end if
  if listp(iklSoundEvents) then
    lSoundEvents = iklSoundEvents.getaProp(ilCurTag.name)[2][iCurFrame]
    if lSoundEvents <> 0 then
      repeat with event in lSoundEvents
        ioSong.mPostEvent(event)
      end repeat
    end if
  end if
  sprite(ikSpr).member = member(ilCurTag.anim[iCurFrame], me.ikCastLibNum)
end

on mSetNextTag me, reason
  case reason of
    #exit:
      TAGNAME = ilCurTag.exit
      if listp(TAGNAME) then
        TAGNAME = getAt(TAGNAME, random(TAGNAME.count))
      end if
    #trigger:
      TAGNAME = ilCurTag.trig
      if listp(TAGNAME) then
        TAGNAME = getAt(TAGNAME, random(TAGNAME.count))
      end if
    #startup:
      TAGNAME = getPropAt(iklTags, 1)
    #sync:
      TAGNAME = ilCurTag.sync
  end case
  newTag = duplicate(iklTags[TAGNAME])
  iCurTagName = TAGNAME
  newTag[#name] = iCurTagName
  iSameFrame = newTag.sameFrame
  iDir = newTag.Dir
  if iCurTagName = newTag.exit then
    iLoopTag = 1
  else
    iLoopTag = 0
    iNbRepeats = newTag.repeat
    if iNbRepeats > 1 then
      if iDir = 1 then
        iNbRepeats = iNbRepeats * 5
      end if
    end if
    iCurRepeat = 1
  end if
  if ilk(newTag.anim) = #point then
    lMbrs = makeList(newTag.anim[1], newTag.anim[2])
    newTag.anim = lMbrs
  end if
  iNbFrames = newTag.anim.count
  if iDir = 1 then
    iLoopbackFrame = 1
  else
    iLoopbackFrame = iNbFrames
  end if
  if reason <> #startup then
    ioSong.mStopLoops(ikLoopID, ilCurTag.name)
  end if
  if listp(iklSoundEvents) then
    LloopEvents = iklSoundEvents.getaProp(newTag.name)[1]
    if LloopEvents.count > 0 then
      LloopEvents = duplicate(LloopEvents)
      repeat with Levent in LloopEvents
        Levent.addProp(#srcID, ikLoopID)
        Levent.addProp(#tag, newTag.name)
        ioSong.mPostEvent(Levent)
      end repeat
    end if
  end if
  ilCurTag = newTag
  if reason <> #startup then
    me.mPreloadTag(1)
  end if
end

on mSync me
  ioWidgetQueueMgr.mUnregisterWidget(me)
  if ilCurTag.sync = #done then
    ioSong.mStopLoops(ikLoopID, ilCurTag.name)
    me.mSyncNotify()
    exit
  end if
  me.iState = #syncing
  iSyncFromInterrupt = 0
  me.mSetStepFrameHook(1)
end

on mInterrupt me
  if me.iState <> #running then
    exit
  end if
  me.iState = #syncing
  iSyncFromInterrupt = 1
  me.mSetStepFrameHook(1)
  exit
end

on mStartup me
  iCurTagName = #none
  me.mSetNextTag(#startup)
  iCurFrame = 0
  if ilCurTag.bg <> 0 then
    sprite(ikBgSpr).member = member(ilCurTag.bg, me.ikCastLibNum)
  end if
  sprite(ikBgSpr).loc = me.ikOrgPt
  sprite(ikSpr).member = member(ilCurTag.anim[1], me.ikCastLibNum)
  sprite(ikSpr).loc = me.ikOrgPt
  if ilCurTag.exit <> #stop then
    me.mSetStepFrameHook(1)
    me.iState = #running
  else
    me.iState = #stopped
  end if
  ioSong = me.ioModule.ioFrameset.ioConsole.ioSong
  me.mPreloadTag(0)
end

on mPreloadTag me, doIdleLoad
  tag = ilCurTag.exit
  if symbolp(tag) then
    if tag <> #stop then
      lMbrs = iklTags[tag].anim
      goMemoryMgr.mPreloadMembers(lMbrs, me.ikCastLibNum, 0)
    else
      tag = ilCurTag.trig
      if symbolp(tag) then
        if tag <> #dead then
          lMbrs = iklTags[tag].anim
          goMemoryMgr.mPreloadMembers(lMbrs, me.ikCastLibNum, 0)
        end if
      end if
    end if
  end if
end

on mHello me
  alert("Hi!  My name is " & string(me) & ".  What's your name?")
end

on mGetCursorState me
  if (me.iState = #syncing) or (ilCurTag.trig = #dead) then
    return 0
  else
    if count(the actorList) >= koConstants.ikMaxThreads then
      return 0
    else
      return 1
    end if
  end if
end
