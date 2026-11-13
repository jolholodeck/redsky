property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, iLoCluster, iLoDissolve

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #people
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#party: 0, #workers: 0, #kids: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#party1: [50, 200, 200], #party2: [50, 200, 200], #party3: [50, 200, 200], #workers: [50, 200, 200], #kids: [50, 200, 200]]
  iLoCluster = [:]
  LpgmNums = [56, 57]
  iLoCluster.setaProp(#party1, new(script("Cluster.class"), me, me.ilchannels[2], LpgmNums, 1, 1))
  LpgmNums = [[58, 3000]]
  iLoCluster.setaProp(#party2, new(script("Cluster.class"), me, me.ilchannels[2], LpgmNums, 1, 1))
  LpgmNums = [59, 60]
  iLoCluster.setaProp(#party3, new(script("Cluster.class"), me, me.ilchannels[2], LpgmNums, 1, 1))
  LpgmNums = [[61, 3000], [62, 3000], [63, 3000], [64, 3000], [65, 3000]]
  iLoCluster.setaProp(#workers, new(script("Cluster.class"), me, me.ilchannels[3], LpgmNums, 1, 3))
  LpgmNums = [[54, 3000]]
  iLoCluster.setaProp(#kids, new(script("Cluster.class"), me, me.ilchannels[5], LpgmNums, 1, 1))
  iLoDissolve = []
  iLoDissolve.append(new(script("Dissolve.class"), [[46, 4000], [47, 4000], [48, 4000], [49, 4000]]))
  iLoDissolve.append(new(script("Dissolve.class"), [[50, 4000], [51, 4000], [52, 4000], [53, 4000]]))
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
    if me.iLblnElementEnabled.party then
      Levents.addProp(#vol, [me.ilchannels[1], integer(1.27000000000000002 * me.iLcurMixVals[1])])
      data = iLoDissolve[1].mStep()
      if ilk(data, #list) then
        Levents.addProp(#play, [#chn: me.ilchannels[1], #pgm: data[2], #note: data[1], #vel: 127, #dur: 4000])
      end if
    end if
    if me.iLblnElementEnabled.kids then
      Levents.addProp(#vol, [me.ilchannels[4], integer(1.27000000000000002 * me.iLcurMixVals[4])])
      data = iLoDissolve[2].mStep()
      if ilk(data, #list) then
        Levents.addProp(#play, [#chn: me.ilchannels[4], #pgm: data[2], #note: data[1], #vel: 127, #dur: 4000])
      end if
    end if
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
  end case
end

on mTrigger me, tag
  if voidp(tag) then
    Ltags = [#party1, #party2, #party3, #workers, #kids]
  else
    Ltags = [tag]
  end if
  repeat with n = 1 to Ltags.count
    tag = Ltags[n]
    case tag of
      #party1, #party2, #party3:
        elementTag = #party
      otherwise:
        elementTag = tag
    end case
    if me.iLblnElementEnabled.getaProp(elementTag) then
      idx = me.iLblnElementEnabled.findPos(elementTag)
      case elementTag of
        #party:
          idx = 2
        #workers:
          idx = 3
        #kids:
          idx = 5
      end case
      me.mQueueEvent([#vol: [me.ilchannels[idx], integer(1.27000000000000002 * me.iLcurMixVals[idx])]])
      oCluster = iLoCluster.getaProp(tag)
      oCluster.mQueueCluster(iLsliderVals.i)
    end if
  end repeat
end
