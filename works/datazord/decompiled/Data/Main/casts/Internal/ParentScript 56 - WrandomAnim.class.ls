property ancestor, ioConsole, iklAnims, ilCurAnim, iCurAnimIdx, ikNbAnims, ikNbFrames, iCurFrame, ikSpr, ikMinCue, ikMaxCue, ikRndCue, iNextCue, iMode, iklRndSnd, iklRndPgms, iklRndNotes

on new me, oModule, widgetID, lSprs
  ancestor = new(script("WidgetRoot.class"), oModule, widgetID, lSprs)
  ioConsole = me.ioModule.ioFrameset.ioConsole
  if not listp(me.iklWidgetData) then
    return -1
  end if
  iklRndSnd = [#bank: 2, #pgm: 31, #vel: 100, #action: #play, #note: 48, #dur: 500]
  iklRndPgms = [59, 60, 61]
  iklRndNotes = [50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]
  ikSpr = lSprs[1]
  iCurFrame = 1
  iklAnims = me.iklWidgetData.anims
  ikNbAnims = iklAnims.count
  iCurAnimIdx = 0
  ikMinCue = me.iklWidgetData.minCue
  ikMaxCue = me.iklWidgetData.maxCue
  ikRndCue = me.ikMaxCue - ikMinCue
  iNextCue = the milliSeconds + ikMinCue
  me.iState = #ready
  me.iMode = #waiting
  return me
end

on mSetNextAnim me
  newIdx = iCurAnimIdx
  repeat while iCurAnimIdx = newIdx
    iCurAnimIdx = random(ikNbAnims)
  end repeat
  ilCurAnim = iklAnims[iCurAnimIdx]
  ikNbFrames = ilCurAnim.count
end

on mTrigger me, Selector, source
end

on stepFrame me
  case iMode of
    #animating:
      iCurFrame = iCurFrame + 1
      if iCurFrame > ikNbFrames then
        sprite(ikSpr).locH = -1000
        me.mSetNextAnim()
        iNextCue = the milliSeconds + ikMinCue + random(ikRndCue)
        iMode = #waitForCue
        exit
      end if
      sprite(ikSpr).member = member(ilCurAnim[iCurFrame], me.ikCastLibNum)
    #waitForCue:
      if the milliSeconds < iNextCue then
        exit
      end if
      iCurFrame = 1
      sprite(ikSpr).member = member(ilCurAnim[iCurFrame], me.ikCastLibNum)
      sprite(ikSpr).loc = me.ikOrgPt
      iklRndSnd.pgm = iklRndPgms[random(iklRndPgms.count)]
      iklRndSnd.note = iklRndNotes[random(iklRndNotes.count)]
      ioConsole.ioSong.mPostEvent(iklRndSnd)
      iMode = #animating
  end case
end

on mSync me
  sprite(ikSpr).locH = -1000
  me.mSyncNotify()
end

on mStartup me
  me.mSetNextAnim()
  iNextCue = the milliSeconds + ikMinCue + random(ikRndCue)
  iMode = #waitForCue
  me.mSetStepFrameHook(1)
end

on mGetCursorState me
  return 0
end
