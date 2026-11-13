property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #water
  iLsliderVals = [#i: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
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
    repeat with n = 1 to 2
      Levents.addProp(#vol, [me.ilchannels[n], integer(1.27000000000000002 * me.iLcurMixVals[n])])
    end repeat
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
  end case
end

on mSetEnabled me, blnEnabled
  me.iBlnEnabled = blnEnabled
  if me.iBlnEnabled then
    me.mQueueEvent([#start: [#chn: me.ilchannels[1], #pgm: 8, #note: 60, #vel: 127]])
    me.mQueueEvent([#start: [#chn: me.ilchannels[2], #pgm: 7, #note: 60, #vel: 127]])
  else
    me.mQueueEvent([#stop: iTag])
  end if
end
