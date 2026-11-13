property ancestor, iTag, iLsliderVals, iLmaxAmps, iLminAmps, iLcurAmps, iLampIncrs, iLmaxSteps, iLminSteps, iLcurSteps, iLstepIncrs, iLoMod, iMasterVal, iBase, iLprb, ioCluster

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #wind
  iLsliderVals = [#i: 0]
  iMasterVal = 0
  iLprb = [#gust: [50, 2000, 2000]]
  LpgmNums = [[1, 4000], [2, 5000]]
  ioCluster = new(script("Cluster.class"), me, me.ilchannels[4], LpgmNums, 1, 1)
  iLmaxAmps = [30, 5]
  iLminAmps = [5, 2]
  iLcurAmps = duplicate(iLminAmps)
  iLampIncrs = [(iLmaxAmps[1] - iLminAmps[1]) / 100.0, (iLmaxAmps[2] - iLminAmps[2]) / 100.0]
  iLmaxSteps = [10, 2]
  iLminSteps = [80, 20]
  iLcurSteps = duplicate(iLminSteps)
  iLstepIncrs = [(iLmaxSteps[1] - iLminSteps[1]) / 100.0, (iLmaxSteps[2] - iLminSteps[2]) / 100.0]
  iLoMod = []
  repeat with n = 1 to 3
    Ldat1 = [new(script("Sine LFO.class"), iLcurSteps[1], 1), iLcurAmps[1], 1, 1]
    Ldat2 = [new(script("Sine LFO.class"), iLcurSteps[2], 1), iLcurAmps[2], 1, 1]
    iLoMod.append(new(script("Modulator.class"), [Ldat1, Ldat2]))
  end repeat
  return me
end

on mPoll me, msecs
  Levents = me.mProcessEventQueue(msecs)
  if not me.iBlnEnabled then
    return Levents
  end if
  repeat with n = 1 to 3
    val = integer(iLoMod[n].mStep())
    if n = 1 then
      iMasterVal = val
    end if
    val = (val + iMasterVal) / 2
    val = integer(val + (iBase * me.iLcurMixVals[n] / 100.0))
    Levents.addProp(#vol, [me.ilchannels[n], val])
  end repeat
  if random(iLprb[1][3]) = iLprb[1][3] then
    me.mTrigger()
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
      me.mUpdateMods(val)
      iBase = 127 - (iLcurAmps[1] + iLcurAmps[2])
      iLprb[1][3] = iLprb[1][2] - integer((iLprb[1][2] - iLprb[1][1]) / 100.0 * val)
  end case
end

on mUpdateMods me, val
  repeat with n = 1 to 2
    iLcurAmps[n] = integer(iLampIncrs[n] * val) + iLminAmps[n]
  end repeat
  repeat with n = 1 to 2
    iLcurSteps[n] = integer(iLstepIncrs[n] * val) + iLminSteps[n]
  end repeat
  repeat with n = 1 to 3
    repeat with i = 1 to 2
      iLoMod[n].mSetAmp(i, iLcurAmps[i])
      iLoMod[n].mSetStepsPerCycle(i, iLcurSteps[i])
    end repeat
  end repeat
end

on mTrigger me
  me.mQueueEvent([#vol: [me.ilchannels[4], integer(1.27000000000000002 * me.iLcurMixVals[4])]])
  ioCluster.mQueueCluster(iLsliderVals.i)
end

on mSetEnabled me, blnEnabled
  me.iBlnEnabled = blnEnabled
  if me.iBlnEnabled then
    me.mQueueEvent([#start: [#chn: me.ilchannels[1], #pgm: 3, #note: 60, #vel: 127], #start: [#chn: me.ilchannels[2], #pgm: 0, #note: 50, #vel: 127], #start: [#chn: me.ilchannels[3], #pgm: 0, #note: 60, #vel: 127]])
  else
    me.mQueueEvent([#stop: iTag])
  end if
  if ilk(me.ioDiorama, #instance) then
    me.ioDiorama.Change([[#name: iTag, #State: [0: #off, 1: #on].getaProp(me.iBlnEnabled), #intensity: iLsliderVals.i]])
  end if
end
