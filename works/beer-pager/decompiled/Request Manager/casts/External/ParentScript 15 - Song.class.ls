property ixBeatnik, iFPS, iLeventQueue, iCurNoteID, ilchannels, ilactiveLoops, ilactivenotes, iLctrlResets, iCurVolume, iLactiveLoopEvents, iState

on new me, xBeatnik, FPS
  ixBeatnik = xBeatnik
  iFPS = FPS
  iLeventQueue = [:]
  iCurNoteID = 0
  ilactiveLoops = [:]
  ilactivenotes = [:]
  ilchannels = []
  iLactiveLoopEvents = [:]
  repeat with n = 1 to 16
    append(ilchannels, [])
  end repeat
  iLctrlResets = [1: 0, 7: 127, 10: 64]
  iState = #soundOn
  return me
end

on mMute me
  me.mStopAllNotes()
  iState = #soundOff
end

on mUnMute me
  iState = #soundOn
end

on mConfigSong me, songFilePath
  result = play(ixBeatnik, 0, songFilePath)
  return result
end

on mDisposeSong me
  stop(ixBeatnik)
  closeBeatnik(ixBeatnik)
end

on mSetVolume me, newVal
  if newVal = iCurVolume then
    exit
  end if
  iCurVolume = newVal
  err = setVolume(ixBeatnik, iCurVolume)
end

on mPostEvent me, Levent
  if iState = #soundOff then
    exit
  end if
  Levent = duplicate(Levent)
  Levent.addProp(#postTime, the milliSeconds)
  case Levent.action of
    #on:
      result = me.mSetUpOn(Levent)
      if result < 0 then
        return result
      end if
      noteID = result
      iLeventQueue.setaProp(me.mGetID(iLeventQueue), Levent)
      return noteID
    #off:
      iLeventQueue.setaProp(me.mGetID(iLeventQueue), Levent)
    #play:
      LeventOn = duplicate(Levent)
      result = me.mSetUpOn(LeventOn)
      if result < 0 then
        exit
      end if
      noteID = result
      LeventOn.deleteProp(#dur)
      LeventOn.action = #on
      iLeventQueue.setaProp(me.mGetID(iLeventQueue), LeventOn)
      LeventOff = [:]
      LeventOff.addProp(#action, #off)
      LeventOff.addProp(#noteID, noteID)
      LeventOff.addProp(#offTime, Levent.postTime + Levent.dur)
      iLeventQueue.setaProp(me.mGetID(iLeventQueue), LeventOff)
    #loop:
      LstoredEvent = duplicate(Levent)
      result = me.mSetUpOn(Levent)
      if result < 0 then
        exit
      end if
      noteID = result
      LstoredEvent.deleteProp(#postTime)
      iLactiveLoopEvents.addProp(noteID, LstoredEvent)
      Levent = duplicate(Levent)
      Levent.action = #on
      iLeventQueue.setaProp(me.mGetID(iLeventQueue), Levent)
      LsrcLoops = ilactiveLoops.getaProp(Levent.srcID)
      if voidp(LsrcLoops) then
        Ltemp = [:]
        Ltemp.setaProp(Levent.tag, [noteID])
        ilactiveLoops.setaProp(Levent.srcID, Ltemp)
      else
        LtagLoops = LsrcLoops.getaProp(Levent.tag)
        if voidp(LtagLoops) then
          LsrcLoops.setaProp(Levent.tag, [noteID])
        else
          append(LtagLoops, noteID)
        end if
      end if
  end case
end

on mSetUpOn me, Levent
  if voidp(Levent.getaProp(#rnd)) then
    Levent.addProp(#rnd, 0)
  end if
  if voidp(Levent.getaProp(#ctrl)) then
    Levent.addProp(#ctrl, 0)
  end if
  if ilk(Levent.rnd) = #propList then
    Lrnd = Levent.rnd
    strNoteRnd = Lrnd.getaProp(#note)
    if not voidp(strNoteRnd) then
      result = me.mGetRndVal(Levent.note, strNoteRnd)
      if result >= 0 then
        Levent.note = result
      end if
    end if
    strPgmRnd = Lrnd.getaProp(#pgm)
    if not voidp(strPgmRnd) then
      result = me.mGetRndVal(Levent.pgm, strPgmRnd)
      if result >= 0 then
        Levent.pgm = result
      end if
    end if
    strVelRnd = Lrnd.getaProp(#vel)
    if not voidp(strVelRnd) then
      result = me.mGetRndVal(Levent.vel, strVelRnd)
      if result >= 0 then
        Levent.vel = result
      end if
    end if
  end if
  chn = me.mGetFreeChn(Levent.note, Levent.vel, Levent.ctrl)
  if chn = 0 then
    return -2
  end if
  Levent.addProp(#chn, chn)
  noteID = me.mGetID(ilactivenotes)
  LnoteDat = [#note: Levent.note, #chn: chn, #vel: Levent.vel, #ctrl: 0]
  if ilk(Levent.ctrl) = #propList then
    Lctrl = Levent.ctrl
    LnoteDat.setaProp(#ctrl, Lctrl.ctrl)
    bgnVal = Lctrl.bgnVal
    endVal = Lctrl.endVal
    strCtrlRnd = Lctrl.getaProp(#rnd)
    if not voidp(strCtrlRnd) then
      result = me.mGetRndVal(bgnVal, strCtrlRnd)
      if result >= 0 then
        bgnVal = result
      end if
      result = me.mGetRndVal(endVal, strCtrlRnd)
      if result >= 0 then
        endVal = result
      end if
    end if
    LctrlEvent = [#action: #ctrl, #chn: chn, #ctrl: Lctrl.ctrl, #val: bgnVal]
    LctrlEvent.addProp(#procTime, (1000 / iFPS * Lctrl.bgnFrm) + the milliSeconds)
    frameCnt = Lctrl.endFrm - Lctrl.bgnFrm
    if bgnVal <> endVal then
      valRange = endVal - bgnVal
      if frameCnt > 0 then
        incr = valRange / float(frameCnt)
        LctrlEvent.addProp(#incr, incr)
        LctrlEvent.addProp(#endVal, endVal)
      end if
    end if
    iLeventQueue.setaProp(me.mGetID(iLeventQueue), LctrlEvent)
  end if
  ilactivenotes.setaProp(noteID, LnoteDat)
  append(ilchannels[chn], noteID)
  return noteID
end

on mGetRndVal me, val, strRnd
  case strRnd.char[1] of
    "+":
      delete char 1 of strRnd
      rndVal = integer(strRnd)
      if integerp(rndVal) then
        return min(127, val + random(rndVal) - 1)
      else
        return -1
      end if
    "-":
      delete char 1 of strRnd
      rndVal = integer(strRnd)
      if integerp(rndVal) then
        return max(0, val - random(rndVal) + 1)
      else
        return -1
      end if
    otherwise:
      rndVal = integer(strRnd)
      if integerp(rndVal) then
        Dir = [1, -1][random(2)]
        if Dir = 1 then
          return min(127, val + random(rndVal) - 1)
        else
          return max(0, val - random(rndVal) + 1)
        end if
      else
        return -1
      end if
  end case
end

on mProcessQueue me
  if iLeventQueue.count = 0 then
    exit
  end if
  LprocessedEvents = []
  repeat with n = 1 to iLeventQueue.count
    Levent = iLeventQueue[n]
    case Levent.action of
      #on:
        mPlayNote(me, Levent)
        append(LprocessedEvents, getPropAt(iLeventQueue, n))
      #off:
        if Levent.offTime <= the milliSeconds then
          mStopNote(me, Levent.noteID)
          append(LprocessedEvents, getPropAt(iLeventQueue, n))
        end if
      #ctrl:
        if Levent.procTime <= the milliSeconds then
          mSetController(me, Levent)
          append(LprocessedEvents, getPropAt(iLeventQueue, n))
        end if
    end case
  end repeat
  repeat with id in LprocessedEvents
    iLeventQueue.deleteProp(id)
  end repeat
end

on mPlayNote me, Levent
  noteOn(ixBeatnik, Levent.chn, Levent.bank, Levent.pgm, Levent.note, Levent.vel)
end

on mStopNote me, noteID
  LnoteDat = ilactivenotes.getaProp(noteID)
  if voidp(LnoteDat) then
    exit
  end if
  err = noteOff(ixBeatnik, LnoteDat.chn, LnoteDat.note, LnoteDat.vel)
  ilchannels[LnoteDat.chn].deleteAt(getPos(ilchannels[LnoteDat.chn], noteID))
  if LnoteDat.ctrl then
    me.mResetController(LnoteDat.chn, LnoteDat.ctrl)
  end if
  ilactivenotes.deleteProp(noteID)
  return 0
end

on mSetController me, LctrlEvent
  err = setController(ixBeatnik, LctrlEvent.chn, LctrlEvent.ctrl, LctrlEvent.val)
  incr = LctrlEvent.getaProp(#incr)
  if not voidp(incr) then
    LnewCtrlEvent = [#action: #ctrl, #chn: LctrlEvent.chn, #ctrl: LctrlEvent.ctrl]
    newVal = LctrlEvent.val + incr
    if incr > 0 then
      if newVal >= LctrlEvent.endVal then
        LnewCtrlEvent.addProp(#val, LctrlEvent.endVal)
      else
        LnewCtrlEvent.addProp(#val, newVal)
        LnewCtrlEvent.addProp(#endVal, LctrlEvent.endVal)
        LnewCtrlEvent.addProp(#incr, incr)
      end if
    else
      if incr < 0 then
        if newVal <= LctrlEvent.endVal then
          LnewCtrlEvent.addProp(#val, LctrlEvent.endVal)
        else
          LnewCtrlEvent.addProp(#val, newVal)
          LnewCtrlEvent.addProp(#endVal, LctrlEvent.endVal)
          LnewCtrlEvent.addProp(#incr, incr)
        end if
      end if
    end if
    LnewCtrlEvent.addProp(#procTime, (1000 / iFPS) + the milliSeconds)
    iLeventQueue.setaProp(me.mGetID(iLeventQueue), LnewCtrlEvent)
  end if
end

on mResetController me, chn, ctrl
  setController(ixBeatnik, chn, ctrl, iLctrlResets.getaProp(ctrl))
end

on mGetID me, whichPropList
  repeat with id = 1 to the maxinteger
    if voidp(getaProp(whichPropList, id)) then
      return id
    end if
  end repeat
end

on mGetFreeChn me, note, vel, ctrl
  chn = ilchannels.getOne([])
  if chn then
    return chn
  end if
  if ilk(ctrl) = #propList then
    return 0
  else
    repeat with chn = 1 to 16
      blnShareable = 1
      repeat with noteID in ilchannels[chn]
        Levent = ilactivenotes.getaProp(noteID)
        if Levent.ctrl then
          blnShareable = 0
          exit repeat
        end if
        if (Levent.note = note) and (Levent.vel = vel) then
          blnShareable = 0
          exit repeat
        end if
      end repeat
      if blnShareable then
        return chn
      end if
    end repeat
    return 0
  end if
end

on mStopLoops me, srcID, tag
  if voidp(srcID) then
    scope = #all
  else
    if voidp(tag) then
      scope = #src
    else
      scope = #tag
    end if
  end if
  case scope of
    #tag:
      LsrcLoops = ilactiveLoops.getaProp(srcID)
      if not voidp(LsrcLoops) then
        LtagLoops = LsrcLoops.getaProp(tag)
        if not voidp(LtagLoops) then
          repeat with noteID in LtagLoops
            iLactiveLoopEvents.deleteProp(noteID)
            me.mStopNote(noteID)
          end repeat
          LsrcLoops.deleteProp(tag)
          if LsrcLoops.count = 0 then
            ilactiveLoops.deleteProp(srcID)
          end if
        end if
      end if
    #src:
      LsrcLoops = ilactiveLoops.getaProp(srcID)
      if not voidp(LsrcLoops) then
        repeat with LtagLoops in LsrcLoops
          repeat with noteID in LtagLoops
            iLactiveLoopEvents.deleteProp(noteID)
            me.mStopNote(noteID)
          end repeat
        end repeat
        ilactiveLoops.deleteProp(srcID)
      end if
    #all:
      repeat with LsrcLoops in ilactiveLoops
        repeat with LtagLoops in LsrcLoops
          repeat with noteID in LtagLoops
            iLactiveLoopEvents.deleteProp(noteID)
            me.mStopNote(noteID)
          end repeat
        end repeat
      end repeat
      ilactiveLoops = [:]
  end case
end

on mSuspend me
  LnoteIDs = []
  repeat with n = 1 to ilactivenotes.count()
    append(LnoteIDs, ilactivenotes.getPropAt(n))
  end repeat
  repeat with noteID in LnoteIDs
    me.mStopNote(noteID)
  end repeat
  ilactiveLoops = [:]
end

on mResume me
  LactiveLoopEvents = duplicate(iLactiveLoopEvents)
  iLactiveLoopEvents = [:]
  repeat with Levent in LactiveLoopEvents
    me.mPostEvent(Levent)
  end repeat
end

on mStopAllNotes me
  LnoteIDs = []
  repeat with n = 1 to ilactivenotes.count()
    append(LnoteIDs, ilactivenotes.getPropAt(n))
  end repeat
  repeat with noteID in LnoteIDs
    me.mStopNote(noteID)
  end repeat
  iLactiveLoopEvents = [:]
  ilactiveLoops = [:]
end
