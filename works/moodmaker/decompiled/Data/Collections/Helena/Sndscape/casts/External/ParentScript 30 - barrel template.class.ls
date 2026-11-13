property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #tmpl
  iLsliderVals = [#i: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  return me
end

on mPoll me, msecs
  Levents = me.mProcessEventQueue(msecs)
  if not me.iBlnEnabled then
    return Levents
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

on mTrigger me
end
