property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, iLoCluster

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #animals
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#horse: 0, #dog: 0, #frog: 0, #duck: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#horse: [140, 400, 400], #dog1: [240, 600, 240], #dog2: [240, 600, 240], #frog: [40, 200, 200], #duck1: [60, 400, 400], #duck2: [60, 400, 400]]
  iLoCluster = [:]
  LpgmNums = [[33, 2000], [34, 2000], [35, 2000], [36, 2000]]
  iLoCluster.setaProp(#horse, new(script("Cluster.class"), me, me.ilchannels[1], LpgmNums, 1, 2))
  LpgmNums = [22, 24]
  iLoCluster.setaProp(#dog1, new(script("Cluster.class"), me, me.ilchannels[2], LpgmNums, 1, 2))
  LpgmNums = [20, 21, 23]
  iLoCluster.setaProp(#dog2, new(script("Cluster.class"), me, me.ilchannels[2], LpgmNums, 1, 3))
  LpgmNums = [[31, 1000], [32, 1000]]
  iLoCluster.setaProp(#frog, new(script("Cluster.class"), me, me.ilchannels[3], LpgmNums, 1, 2))
  LpgmNums = [25, 26, 27]
  iLoCluster.setaProp(#duck1, new(script("Cluster.class"), me, me.ilchannels[4], LpgmNums, 1, 3))
  LpgmNums = [[28, 500], [29, 500], [30, 500]]
  iLoCluster.setaProp(#duck2, new(script("Cluster.class"), me, me.ilchannels[4], LpgmNums, 1, 3))
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
    repeat with n = 1 to iLprb.count
      if random(iLprb[n][3]) = iLprb[n][3] then
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
      repeat with n = 1 to iLprb.count
        iLprb[n][3] = iLprb[n][2] - integer((iLprb[n][2] - iLprb[n][1]) / 100.0 * val)
      end repeat
  end case
end

on mTrigger me, tag
  if voidp(tag) then
    Ltags = [#horse, #dog1, #dog2, #frog, #duck1, #duck2]
  else
    Ltags = [tag]
  end if
  repeat with n = 1 to Ltags.count
    tag = Ltags[n]
    case tag of
      #dog1, #dog2:
        elementTag = #dog
      #duck1, #duck2:
        elementTag = #duck
      otherwise:
        elementTag = tag
    end case
    if me.iLblnElementEnabled.getaProp(elementTag) then
      idx = me.iLblnElementEnabled.findPos(elementTag)
      me.mQueueEvent([#vol: [me.ilchannels[idx], integer(1.27000000000000002 * me.iLcurMixVals[idx])]])
      oCluster = iLoCluster.getaProp(tag)
      oCluster.mQueueCluster(iLsliderVals.i)
    end if
  end repeat
end
