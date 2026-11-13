property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, iLoCluster, iLoDissolve, iMinPopcornDelay, iMaxPopcornDelay, iPopcornTimer, iPopcornDelay, ilPopcornNotes, ilPopcornDelayRange, iPopcornState, iPopcornMstrTimer

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #people
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#party: 0, #steps: 0, #wine: 0, #popcorn: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#steps: [100, 1000, 100], #wine1: [100, 1000, 100], #wine2: [100, 1000, 100], #wine3: [100, 1000, 100]]
  iLoCluster = [:]
  LpgmNums = [[58, 420], [59, 1160]]
  iLoCluster.setaProp(#wine1, new(script("Cluster.class"), me, me.ilchannels[3], LpgmNums, 1, 1))
  LpgmNums = [[61, 400], [62, 380]]
  iLoCluster.setaProp(#wine2, new(script("Cluster.class"), me, me.ilchannels[3], LpgmNums, 1, 1))
  LpgmNums = [[63, 2270]]
  iLoCluster.setaProp(#wine3, new(script("Cluster.class"), me, me.ilchannels[3], LpgmNums, 1, 1))
  iLoDissolve = []
  iLoDissolve.append(new(script("Dissolve.class"), [[53, 4010], [54, 4060], [55, 3990], [56, 4130]]))
  iMinPopcornDelay = 150
  iMaxPopcornDelay = 3000
  iPopcornTimer = the milliSeconds
  ilPopcornNotes = [12, 36, 60, 84, 108]
  ilPopcornDelayRange = [0: 480, 100: 120]
  iPopcornState = #off
  iPopcornMstrTimer = the milliSeconds
  me.mInitFade(#popcorn, 4, 1, 127, 15, 15, 15)
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
    if me.iLblnElementEnabled.popcorn then
      if iPopcornState = #off then
        if msecs >= iPopcornMstrTimer then
          iPopcornDelay = iMaxPopcornDelay
          iPopcornState = #rampup
        end if
      end if
    end if
    repeat with n = 1 to iLprb.count
      if random(iLprb[n][3]) = iLprb[n][3] then
        me.mTrigger(iLprb.getPropAt(n))
      end if
    end repeat
  end if
  if iPopcornState <> #off then
    if msecs >= iPopcornTimer then
      note = ilPopcornNotes[random(ilPopcornNotes.count)] - 1 + random(3)
      Levents.addProp(#play, [#chn: me.ilchannels[5], #pgm: 64, #note: note, #vel: 100 + random(27), #dur: 300])
      d = iPopcornDelay / 3
      iPopcornTimer = msecs + d + random(d * 2)
    end if
    Levents.addProp(#vol, [me.ilchannels[5], integer(1.27000000000000002 * me.iLcurMixVals[5])])
    case iPopcornState of
      #rampup:
        iPopcornDelay = iPopcornDelay - integer((iMaxPopcornDelay - iMinPopcornDelay) / 225.0)
        if iPopcornDelay <= iMinPopcornDelay then
          iPopcornDelay = iMinPopcornDelay
          iPopcornState = #queueloop
        end if
      #queueloop:
        if msecs > me.iLfadeExpireTimers.popcorn then
          me.mQueueFade(#popcorn, [#pgm: 57, #note: 58 + random(3), #vel: 127])
          iPopcornState = #on
        end if
      #on:
        if msecs > me.iLfadeExpireTimers.popcorn then
          iPopcornState = #rampdown
        end if
      #rampdown:
        iPopcornDelay = iPopcornDelay + integer((iMaxPopcornDelay - iMinPopcornDelay) / 225.0)
        if iPopcornDelay >= iMaxPopcornDelay then
          delaySecs = integer(me.mGetValFromRange(iLsliderVals.i, ilPopcornDelayRange))
          delayOffset = [1, -1][random(2)] * random(20)
          iPopcornMstrTimer = msecs + ((delaySecs + delayOffset) * 1000)
          iPopcornState = #off
        end if
    end case
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
      delaySecs = integer(me.mGetValFromRange(iLsliderVals.i, ilPopcornDelayRange))
      delayOffset = [1, -1][random(2)] * random(20)
      iPopcornMstrTimer = the milliSeconds + ((delaySecs + delayOffset) * 1000)
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
    case tag of
      #wine1, #wine2, #wine3:
        elementTag = #wine
      otherwise:
        elementTag = tag
    end case
    if me.iLblnElementEnabled[elementTag] then
      case tag of
        #steps:
          if the milliSeconds > me.iLfadeExpireTimers[#steps] then
            me.mInitFade(#steps, 2, 1, 127, 1, 7 + random(3), 1)
            result = me.mQueueFade(#steps, [#pgm: 60, #note: 58 + random(3), #vel: 100 + random(27)])
          end if
        #wine1, #wine2, #wine3:
          me.mQueueEvent([#vol: [me.ilchannels[3], integer(1.27000000000000002 * me.iLcurMixVals[3])]])
          oCluster = iLoCluster.getaProp(tag)
          oCluster.mQueueCluster(iLsliderVals.i)
      end case
    end if
  end repeat
end
