property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLmaxAmps, iLminAmps, iLcurAmps, iLampIncrs, iLmaxSteps, iLminSteps, iLcurSteps, iLstepIncrs, iLoMod, iMasterVal, iBase, iLprb, iLchntag, iLoCluster

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #wind
  iLsliderVals = [#i: 0]
  iLchntag = [#wind_loop1, #wind_loop2, #gust, #creak]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#gust: [50, 2000, 2000]]
  iLoCluster = [:]
  LpgmNums = [[2, 4280]]
  chnIDX = iLchntag.getPos(#gust)
  iLoCluster.setaProp(#gust, new(script("Cluster.class"), me, me.ilchannels[chnIDX], LpgmNums, 1, 1))
  iMasterVal = 0
  iLmaxAmps = [30, 5]
  iLminAmps = [5, 2]
  iLcurAmps = duplicate(iLminAmps)
  iLampIncrs = [(iLmaxAmps[1] - iLminAmps[1]) / 100.0, (iLmaxAmps[2] - iLminAmps[2]) / 100.0]
  iLmaxSteps = [60, 15]
  iLminSteps = [80, 20]
  iLcurSteps = duplicate(iLminSteps)
  iLstepIncrs = [(iLmaxSteps[1] - iLminSteps[1]) / 100.0, (iLmaxSteps[2] - iLminSteps[2]) / 100.0]
  iLoMod = []
  repeat with n = 1 to 2
    Ldat1 = [new(script("Sine LFO.class"), iLcurSteps[1], 1), iLcurAmps[1], 1, 1]
    Ldat2 = [new(script("Sine LFO.class"), iLcurSteps[2], 1), iLcurAmps[2], 1, 1]
    iLoMod.append(new(script("Modulator.class"), [Ldat1, Ldat2]))
  end repeat
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
      val = integer(iLoMod[n].mStep())
      if n = 1 then
        iMasterVal = val
      end if
      val = (val + iMasterVal) / 2
      val = integer(val + (iBase * me.iLcurMixVals[n] / 100.0))
      Levents.addProp(#vol, [me.ilchannels[n], val])
    end repeat
    repeat with n = 1 to iLprb.count
      if random(iLprb[1][3]) = iLprb[1][3] then
        me.mTrigger(iLprb.getPropAt(n))
      end if
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
      me.mUpdateMods(val)
      iBase = 127 - (iLcurAmps[1] + iLcurAmps[2])
      repeat with n = 1 to iLprb.count
        iLprb[n][3] = iLprb[n][2] - integer((iLprb[n][2] - iLprb[n][1]) / 100.0 * val)
      end repeat
  end case
end

on mTrigger me, tag
  if voidp(tag) then
    Ltags = []
    repeat with n = 1 to iLprb.count
      Ltags.append(iLprb.getPropAt(n))
    end repeat
  else
    Ltags = [tag]
  end if
  repeat with n = 1 to Ltags.count
    tag = Ltags[n]
    idx = me.iLchntag.getPos(tag)
    me.mQueueEvent([#vol: [me.ilchannels[idx], integer(1.27000000000000002 * me.iLcurMixVals[idx])]])
    oCluster = iLoCluster.getaProp(tag)
    oCluster.mQueueCluster(iLsliderVals.i)
  end repeat
end

on mUpdateMods me, val
  repeat with n = 1 to 2
    iLcurAmps[n] = integer(iLampIncrs[n] * val) + iLminAmps[n]
  end repeat
  repeat with n = 1 to 2
    iLcurSteps[n] = integer(iLstepIncrs[n] * val) + iLminSteps[n]
  end repeat
  repeat with n = 1 to 2
    repeat with i = 1 to 2
      iLoMod[n].mSetAmp(i, iLcurAmps[i])
      iLoMod[n].mSetStepsPerCycle(i, iLcurSteps[i])
    end repeat
  end repeat
end

on mSetEnabled me, blnEnabled
  me.iBlnEnabled = blnEnabled
  if me.iBlnEnabled then
    me.mQueueEvent([#start: [#chn: me.ilchannels[iLchntag.getPos(#wind_loop1)], #pgm: 0, #note: 60, #vel: 127], #start: [#chn: me.ilchannels[iLchntag.getPos(#wind_loop2)], #pgm: 1, #note: 60, #vel: 127]])
  else
    me.mQueueEvent([#stop: iTag])
  end if
  if ilk(me.ioDiorama, #instance) then
    me.ioDiorama.Change([[#name: iTag, #State: [0: #off, 1: #on].getaProp(me.iBlnEnabled), #intensity: iLsliderVals.i]])
  end if
end
