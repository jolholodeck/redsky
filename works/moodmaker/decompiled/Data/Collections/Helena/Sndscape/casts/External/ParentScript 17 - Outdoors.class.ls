property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, iLoCluster, ilShovelPgmA, ilShovelPgmB, iShovelTimer, ilShovelCntRange, ilShovelDelayRange

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #outdoors
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#shoveling: 0, #skiier: 0, #chopping: 0, #boots: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#skiier: [100, 1000, 100], #boots: [100, 1000, 100], #chopping: [1000, 3000, 1000]]
  iLoCluster = [:]
  LpgmNums = [[36, 170 + 300], [37, 260 + 300], [38, 130 + 300], [39, 700 + 300], [40, 480 + 300]]
  iLoCluster.setaProp(#chopping, new(script("Cluster.class"), me, me.ilchannels[3], LpgmNums, 3, 8))
  me.mInitFade(#skiier, 2, 1, 127, 3, 2, 3)
  me.mInitFade(#boots, 4, 1, 127, 15, 1, 15)
  ilShovelPgmA = [[43, 550], [43, 770], [44, 710], [45, 540], [46, 530]]
  ilShovelPgmB = [[47, 440], [48, 340], [49, 460], [50, 320], [51, 250]]
  iShovelTimer = 0
  ilShovelCntRange = [0: 3, 100: 8]
  ilShovelDelayRange = [0: 120, 100: 30]
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
    if me.iLblnElementEnabled.shoveling then
      if msecs > iShovelTimer then
        cnt = integer(me.mGetValFromRange(iLsliderVals.i, ilShovelCntRange)) + ([1, -1][random(2)] * random(2))
        t = 0
        repeat with n = 1 to cnt
          lPgmData = ilShovelPgmA[random(ilShovelPgmA.count)]
          me.mQueueEvent([#play: [#chn: me.ilchannels[1], #pgm: lPgmData[1], #note: 58 + random(3), #vel: 127, #dur: lPgmData[2]]], t)
          t = t + lPgmData[2] + (100 * random(4))
          lPgmData = ilShovelPgmB[random(ilShovelPgmB.count)]
          me.mQueueEvent([#play: [#chn: me.ilchannels[1], #pgm: lPgmData[1], #note: 58 + random(3), #vel: 127, #dur: lPgmData[2]]], t)
          t = t + lPgmData[2] + (100 * random(4))
        end repeat
        delaySecs = integer(me.mGetValFromRange(iLsliderVals.i, ilShovelDelayRange))
        delayOffset = [1, -1][random(2)] * random(10)
        iShovelTimer = the milliSeconds + ((delaySecs + delayOffset) * 1000) + t
      end if
      Levents.addProp(#vol, [me.ilchannels[1], integer(1.27000000000000002 * me.iLcurMixVals[1])])
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
      if ilk(me.ioDiorama, #instance) then
        me.ioDiorama.Change([[#name: iTag, #State: [0: #off, 1: #on].getaProp(me.iBlnEnabled), #intensity: val]])
      end if
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
    elementTag = tag
    if me.iLblnElementEnabled[elementTag] then
      case tag of
        #skiier:
          if the milliSeconds > me.iLfadeExpireTimers.skiier then
            result = me.mQueueFade(#skiier, [#pgm: 52, #note: 58 + random(3), #vel: 100 + random(27)])
          end if
        #boots:
          if the milliSeconds > me.iLfadeExpireTimers.boots then
            result = me.mQueueFade(#boots, [#pgm: 41, #note: 59 + random(2), #vel: 100 + random(27)])
          end if
        #chopping:
          me.mQueueEvent([#vol: [me.ilchannels[3], integer(1.27000000000000002 * me.iLcurMixVals[3])]])
          oCluster = iLoCluster.chopping
          oCluster.mQueueCluster(iLsliderVals.i)
      end case
    end if
  end repeat
end
