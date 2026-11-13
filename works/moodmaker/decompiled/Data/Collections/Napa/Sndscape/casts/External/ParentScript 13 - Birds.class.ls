property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, ioCluster, ioDissolve

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #birds
  iLsliderVals = [#i: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#birds: [30, 300, 300]]
  LpgmNums = [10, 12, 13, 14, 15, 16, 17, 18, 19]
  ioCluster = new(script("Cluster.class"), me, me.ilchannels[2], LpgmNums, 2, 6)
  ioDissolve = new(script("Dissolve.class"), [[70, 5000], [71, 5000], [72, 5000], [73, 5000]])
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
    Levents.addProp(#vol, [me.ilchannels[1], integer(1.27000000000000002 * me.iLcurMixVals[1])])
    data = ioDissolve.mStep()
    if ilk(data, #list) then
      Levents.addProp(#play, [#chn: me.ilchannels[1], #pgm: data[2], #note: data[1], #vel: 127, #dur: 5000])
    end if
    if random(iLprb[1][3]) = iLprb[1][3] then
      me.mTrigger()
    end if
  end if
  return Levents
end

on mSetValFromSlider me, val, key
  case key of
    #i:
      iLsliderVals.i = val
      me.mUpdateMixLevels(val)
      iLprb[1][3] = iLprb[1][2] - integer((iLprb[1][2] - iLprb[1][1]) / 100.0 * val)
  end case
end

on mTrigger me
  me.mQueueEvent([#vol: [me.ilchannels[2], integer(1.27000000000000002 * me.iLcurMixVals[2])]])
  ioCluster.mQueueCluster(iLsliderVals.i)
end
