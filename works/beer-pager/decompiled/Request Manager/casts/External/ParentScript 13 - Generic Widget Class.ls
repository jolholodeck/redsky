property ancestor, ioWidgetQueueMgr, iklTags, iklSoundEvents, ilCurTag, iCurTagName, ikSpr, ikBgSpr, ikDummyMbr, iCurFrame, iNbFrames, iLoopbackFrame, iNbRepeats, iCurRepeat, iDir, iSameFrame, iLoopTag, iSyncFromInterrupt, ikCastLibNum, iCallBack, fullID
global koConstants, oWidget, oSoundMgr, gState

on new me, oModule, widgetID, spr, canInterrupt, ikFullID, castLibNum, callback
  fullID = ikFullID
  ikCastLibNum = castLibNum
  iCallBack = callback
  ancestor = new(script("WidgetRoot.class"), oModule, widgetID, spr, canInterrupt, fullID)
  animDataMbr = "wdgData_" & fullID
  iklTags = value(member(animDataMbr, ikCastLibNum).text)
  sndDataMbr = "sndData_" & fullID
  iklSoundEvents = value(member(sndDataMbr, ikCastLibNum).text)
  if voidp(iklTags) or voidp(iklSoundEvents) then
    put "Couldn't find animation and/or sound data member for widget: " & fullID
    halt()
  end if
  ikSpr = spr
  ikBgSpr = ikSpr - 1
  ikDummyMbr = 116
  oWidget = me
  return me
end

on mTrigger me, Selector, source
  if (me.iState = #syncing) or (me.iState = #synced) then
    exit
  end if
  if ilCurTag.trig = #Dead then
    exit
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
      sprite(ikBgSpr).member = member(ilCurTag.bg, ikCastLibNum)
    else
      sprite(ikBgSpr).member = member(ikDummyMbr, ikCastLibNum)
    end if
  else
    ilCurTag.exit = ilCurTag.trig
    ilCurTag.trig = #Dead
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
      me.mSetStepFrameHook(0)
      exit
    end if
    if ilCurTag.exit = #callback then
      me.mSetStepFrameHook(0)
      me.mDoCallBack()
      exit
    end if
    sameFrame = iSameFrame
    if me.iState = #syncing then
      if ilCurTag.sync = #done then
        if iSyncFromInterrupt then
          me.iState = #stopped
          me.mSetStepFrameHook(0)
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
  end if
  if iklSoundEvents <> 0 then
    lSoundEvents = iklSoundEvents.getaProp(ilCurTag.name)[2][iCurFrame]
    if lSoundEvents <> 0 then
      repeat with event in lSoundEvents
        if not voidp(oSoundMgr) then
          oSoundMgr.mPostEvent(event)
        end if
      end repeat
    end if
  end if
  sprite(ikSpr).member = member(ilCurTag.anim[iCurFrame], ikCastLibNum)
  if ilCurTag.bg <> 0 then
    sprite(ikBgSpr).member = member(ilCurTag.bg, ikCastLibNum)
  else
    sprite(ikBgSpr).member = member(ikDummyMbr, ikCastLibNum)
  end if
end

on mSetNextTag me, reason
  case reason of
    #exit:
      TAGNAME = ilCurTag.exit
      if listp(TAGNAME) then
        TAGNAME = getAt(TAGNAME, random(TAGNAME.count))
      end if
      if TAGNAME = #callback then
        me.mDoCallBack()
        exit
      end if
    #trigger:
      TAGNAME = ilCurTag.trig
    #startup:
      TAGNAME = getPropAt(iklTags, 1)
    #sync:
      TAGNAME = ilCurTag.sync
  end case
  newTag = duplicate(iklTags[TAGNAME])
  iCurTagName = TAGNAME
  newTag[#name] = iCurTagName
  iSameFrame = newTag.sameFrame
  if iCurTagName = newTag.exit then
    iLoopTag = 1
  else
    iLoopTag = 0
    iNbRepeats = newTag.repeat
    iCurRepeat = 1
  end if
  iDir = newTag.Dir
  if ilk(newTag.anim) = #point then
    lMbrs = buildList(newTag.anim[1], newTag.anim[2])
    newTag.anim = lMbrs
  end if
  iNbFrames = newTag.anim.count
  if iDir = 1 then
    iLoopbackFrame = 1
  else
    iLoopbackFrame = iNbFrames
  end if
  if iklSoundEvents <> 0 then
    if reason <> #startup then
      if not voidp(oSoundMgr) then
        oSoundMgr.mStopLoops(fullID, ilCurTag.name)
      end if
    end if
    LloopEvents = iklSoundEvents.getaProp(newTag.name)[1]
    if LloopEvents.count > 0 then
      LloopEvents = duplicate(LloopEvents)
      repeat with Levent in LloopEvents
        Levent.addProp(#srcID, fullID)
        Levent.addProp(#tag, newTag.name)
        if not voidp(oSoundMgr) then
          oSoundMgr.mPostEvent(Levent)
        end if
      end repeat
    end if
  end if
  ilCurTag = newTag
end

on mSync me
  me.iState = #syncing
  iSyncFromInterrupt = 0
  me.mSetStepFrameHook(1)
end

on mStartup me
  iCurTagName = #none
  me.mSetNextTag(#startup)
  iCurFrame = 0
  if ilCurTag.bg <> 0 then
    sprite(ikBgSpr).member = member(ilCurTag.bg, ikCastLibNum)
    bgMbrNum = ilCurTag.bg
  end if
  sprite(ikBgSpr).loc = point(0, 0)
  sprite(ikSpr).member = member(ilCurTag.anim[1], ikCastLibNum)
  sprite(ikSpr).loc = point(0, 0)
  if ilCurTag.exit <> #stop then
    me.mSetStepFrameHook(1)
    me.iState = #running
  else
    me.iState = #stopped
  end if
  gState = #anim
end

on mShutdown me
  if not voidp(oSoundMgr) then
    oSoundMgr.mStopLoops(fullID)
  end if
  (the actorList).deleteOne(me)
  gState = #Active
end

on mHello me
  alert("Hi!  My name is " & string(me) & ".  What's your name?")
end

on mGetCursorState me
  if (me.iState = #syncing) or (ilCurTag.trig = #Dead) then
    return 0
  else
    return 1
  end if
end

on mDoCallBack me
  me.mShutdown()
  if iCallBack <> EMPTY then
    if ilk(value(iCallBack)) = #integer then
      go(the frame + value(iCallBack))
    else
      if iCallBack = "#next" then
        go(#next)
      else
        go(iCallBack)
      end if
    end if
  end if
end
