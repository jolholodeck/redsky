property ixBeatnik, iCurVolume, iLctrlResets, ilactivenotes, ilchannels, iLeventQueue

on new me, xBeatnik
  ixBeatnik = xBeatnik
  iLctrlResets = [#mod: 0, #vol: 127, #pan: 64]
  ilactivenotes = [:]
  iLeventQueue = [:]
  sort(iLeventQueue)
  ilchannels = []
  repeat with n = 1 to 16
    append(ilchannels, 0)
  end repeat
  mSetVolume(me, 100)
  return me
end

on mProcessEventQueue me, msecs
  Levents = [:]
  repeat while iLeventQueue.count
    if msecs >= iLeventQueue.getPropAt(1) then
      Levents.addProp(iLeventQueue[1][1], iLeventQueue[1][2])
      iLeventQueue.deleteAt(1)
      next repeat
    end if
    exit repeat
  end repeat
  if Levents.count then
    repeat with n = 1 to Levents.count
      eventType = Levents.getPropAt(n)
      eventData = Levents[n]
      case eventType of
        #stop:
          ilactivenotes.deleteProp(eventData)
      end case
    end repeat
  end if
end

on mConfigSong me, songFilePath, blnLoop
  if voidp(blnLoop) then
    blnLoop = 0
  end if
  result = play(ixBeatnik, blnLoop, songFilePath)
  return result
end

on mStartPlaying me
  result = play(ixBeatnik)
  return result
end

on mStopPlaying me
  result = stop(ixBeatnik)
  return result
end

on mDisposeSong me
  stop(ixBeatnik)
  closeBeatnik(ixBeatnik)
  ixBeatnik = VOID
  iCurVolume = VOID
  iLctrlResets = VOID
  ilactivenotes = VOID
  ilchannels = VOID
  iLeventQueue = VOID
end

on mSetVolume me, newVal
  if newVal = iCurVolume then
    exit
  end if
  iCurVolume = newVal
  err = setVolume(ixBeatnik, iCurVolume)
end

on mRequestChannels me, nbChannels
  Lchannels = duplicate(ilchannels)
  Lchn = []
  repeat with n = 1 to nbChannels
    chn = Lchannels.getOne(0)
    if chn then
      append(Lchn, chn)
      Lchannels[chn] = 1
      next repeat
    end if
    return -1
  end repeat
  repeat with chn in Lchannels
    me.mSetController([#chn: chn, #ctrl: iLctrlResets])
  end repeat
  ilchannels = Lchannels
  return Lchn
end

on mReleaseChannels me, Lchannels
  me.mStopChnNotes(Lchannels)
  repeat with chn in Lchannels
    ilchannels[chn] = 0
  end repeat
end

on mStartNote me, Levent
  LnoteIDs = []
  repeat with n = 1 to ilactivenotes.count
    LnoteDat = ilactivenotes[n]
    if (Levent.chn = LnoteDat.chn) and (Levent.note = LnoteDat.note) and (Levent.vel = LnoteDat.vel) then
      return -1
    end if
  end repeat
  noteID = me.mGetID(ilactivenotes)
  ilactivenotes.setaProp(noteID, [#chn: Levent.chn, #bank: Levent.bank, #pgm: Levent.pgm, #note: Levent.note, #vel: Levent.vel])
  err = noteOn(ixBeatnik, Levent.chn, Levent.bank, Levent.pgm, Levent.note, Levent.vel)
  return noteID
end

on mPlayNote me, Levent
  LnoteIDs = []
  repeat with n = 1 to ilactivenotes.count
    LnoteDat = ilactivenotes[n]
    if (Levent.chn = LnoteDat.chn) and (Levent.note = LnoteDat.note) and (Levent.vel = LnoteDat.vel) then
      return -1
    end if
  end repeat
  noteID = me.mGetID(ilactivenotes)
  ilactivenotes.setaProp(noteID, [#chn: Levent.chn, #bank: Levent.bank, #pgm: Levent.pgm, #note: Levent.note, #vel: Levent.vel])
  iLeventQueue.addProp(the milliSeconds + Levent.dur, [#stop, noteID])
  err = playNote(ixBeatnik, Levent.chn, Levent.bank, Levent.pgm, Levent.note, Levent.vel, Levent.dur)
  return noteID
end

on mStopNote me, noteID
  LnoteInfo = ilactivenotes.getaProp(noteID)
  if voidp(LnoteInfo) then
    exit
  end if
  noteOff(ixBeatnik, LnoteInfo.chn, LnoteInfo.note, LnoteInfo.vel)
  ilactivenotes.deleteProp(noteID)
  if iLeventQueue.count then
    repeat with n = 1 to iLeventQueue.count
      if (iLeventQueue[n][1] = #stop) and (iLeventQueue[n][2] = noteID) then
        iLeventQueue.deleteAt(n)
        exit repeat
      end if
    end repeat
  end if
end

on mSetController me, Levent
  chn = Levent.chn
  Lctrl = Levent.ctrl
  repeat with n = 1 to Lctrl.count()
    ctrl = Lctrl.getPropAt(n)
    val = Lctrl[n]
    case ctrl of
      #mod:
        ctrl = 1
      #vol:
        ctrl = 7
      #pan:
        ctrl = 10
    end case
    err = ixBeatnik.setController(chn, ctrl, val)
  end repeat
end

on mGetID me, whichPropList
  repeat with id = 1 to the maxinteger
    if voidp(getaProp(whichPropList, id)) then
      return id
    end if
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
end

on mStopChnNotes me, Lchannels
  LnoteIDs = []
  repeat with n = 1 to ilactivenotes.count
    LnoteDat = ilactivenotes[n]
    if Lchannels.getPos(LnoteDat.chn) then
      append(LnoteIDs, ilactivenotes.getPropAt(n))
    end if
  end repeat
  repeat with noteID in LnoteIDs
    me.mStopNote(noteID)
  end repeat
end

on mKillNotesForMute me
  repeat with LnoteInfo in ilactivenotes
    err = ixBeatnik.noteOff(LnoteInfo.chn, LnoteInfo.note, LnoteInfo.vel)
  end repeat
  repeat with LnoteInfo in ilactivenotes
    err = ixBeatnik.noteOn(LnoteInfo.chn, LnoteInfo.bank, LnoteInfo.pgm, LnoteInfo.note, LnoteInfo.vel)
  end repeat
end
