property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, ioDissolve, iMinDripDelay, iMaxDripDelay, iDripTimer, iDripDelay, ilDripNotes

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #water
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#snowmelt: 0, #creek: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  ioDissolve = new(script("Dissolve.class"), [[20, 4000], [21, 4000]])
  iMinDripDelay = 400
  iMaxDripDelay = 2000
  iDripTimer = the milliSeconds
  ilDripNotes = [12, 36, 60, 84, 108, 123]
  return me
end

on mPoll me, msecs
  Levents = me.mProcessEventQueue(msecs)
  if msecs < (iTimer + iDelay) then
    return Levents
  else
    iTimer = msecs
  end if
  if me.iBlnEnabled then
    if me.iLblnElementEnabled.snowmelt then
      Levents.addProp(#vol, [me.ilchannels[1], integer(1.27000000000000002 * me.iLcurMixVals[1])])
      Levents.addProp(#vol, [me.ilchannels[2], integer(1.27000000000000002 * me.iLcurMixVals[2])])
      data = ioDissolve.mStep()
      if ilk(data, #list) then
        Levents.addProp(#play, [#chn: me.ilchannels[1], #pgm: data[2], #note: data[1], #vel: 127, #dur: 5000])
      end if
      if msecs >= iDripTimer then
        note = ilDripNotes[random(ilDripNotes.count)] - 1 + random(3)
        Levents.addProp(#play, [#chn: me.ilchannels[2], #pgm: 22, #note: note, #vel: 100 + random(27), #dur: 3000])
        iDripTimer = the milliSeconds + iDripDelay
      end if
    end if
    if me.iLblnElementEnabled.creek then
      Levents.addProp(#vol, [me.ilchannels[3], integer(1.27000000000000002 * me.iLcurMixVals[3])])
    end if
  end if
  return Levents
end

on mSetValFromSlider me, val, key
  case key of
    #i:
      iLsliderVals.i = val
      me.mUpdateMixLevels(val)
      if ilk(me.ioDiorama, #instance) then
        me.ioDiorama.Change([[#name: iTag, #State: [0: #off, 1: #on].getaProp(me.iBlnEnabled), #intensity: val]])
      end if
      iDripDelay = integer((iMaxDripDelay - iMinDripDelay) / 100.0 * (100 - iLsliderVals.i)) + iMinDripDelay
  end case
end

on mTrigger me
end

on mSetEnabled me, blnEnabled
  if me.iBlnEnabled = blnEnabled then
    exit
  end if
  me.iBlnEnabled = blnEnabled
  if ilk(me.ioDiorama, #instance) then
    me.ioDiorama.Change([[#name: iTag, #State: [0: #off, 1: #on].getaProp(me.iBlnEnabled), #intensity: iLsliderVals.i]])
  end if
  me.mSwitchLoops()
end

on mSetElementEnabled me, idx, blnEnabled
  if me.iLblnElementEnabled[idx] = blnEnabled then
    exit
  end if
  me.iLblnElementEnabled[idx] = blnEnabled
  me.mSwitchLoops(me.iLblnElementEnabled.getPropAt(idx))
end

on mSwitchLoops me, tag
  if me.iBlnEnabled then
    if voidp(tag) then
      Ltags = []
      repeat with n = 1 to me.iLblnElementEnabled.count
        append(Ltags, me.iLblnElementEnabled.getPropAt(n))
      end repeat
    else
      Ltags = [tag]
    end if
    repeat with tag in Ltags
      if me.iLblnElementEnabled.getaProp(tag) then
        case tag of
          #snowmelt:
          #creek:
            me.mQueueEvent([#start: [#chn: me.ilchannels[3], #pgm: 19, #note: 58 + random(3), #vel: 127]], 50)
        end case
        next repeat
      end if
      case tag of
        #snowmelt:
        #creek:
          me.mQueueEvent([#stop: me.ilchannels[3]])
      end case
    end repeat
  else
    me.mQueueEvent([#stop: iTag])
  end if
end
