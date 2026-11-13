property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, iLoCluster, iChairState, iChairTimer, ilDelayRange

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #indoors
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#chair: 0, #fireplace: 0, #book: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#book: [600, 1200, 600]]
  iLoCluster = [:]
  LpgmNums = [[33, 540], [34, 410]]
  iLoCluster.setaProp(#book, new(script("Cluster.class"), me, me.ilchannels[4], LpgmNums, 1, 1))
  iChairState = #off
  iChairTimer = the milliSeconds
  longTime = 1000 * 60 * 60 * 48
  ilDelayRange = [#on: [0: 60, 99: 240, 100: longTime], #off: [0: 240, 99: 60, 100: 0]]
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
    if me.iLblnElementEnabled.chair then
      if msecs >= iChairTimer then
        if iChairState = #on then
          iChairState = #off
        else
          iChairState = #on
        end if
        delaySecs = integer(me.mGetValFromRange(iLsliderVals.i, ilDelayRange[iChairState]))
        delayOffset = [1, -1][random(2)] * random(20)
        iChairTimer = the milliSeconds + ((delaySecs + delayOffset) * 1000)
        me.mSwitchLoops(#chair)
      end if
      if iChairState = #on then
        Levents.addProp(#vol, [me.ilchannels[1], integer(1.27000000000000002 * me.iLcurMixVals[1])])
      end if
    end if
    if me.iLblnElementEnabled.fireplace then
      Levents.addProp(#vol, [me.ilchannels[2], integer(1.27000000000000002 * me.iLcurMixVals[2])])
      Levents.addProp(#vol, [me.ilchannels[3], integer(1.27000000000000002 * me.iLcurMixVals[3])])
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
      delaySecs = integer(me.mGetValFromRange(iLsliderVals.i, ilDelayRange[iChairState]))
      iChairTimer = the milliSeconds + (delaySecs * 1000)
  end case
end

on mTrigger me
  if me.iLblnElementEnabled.book then
    me.mQueueEvent([#vol: [me.ilchannels[4], integer(1.27000000000000002 * me.iLcurMixVals[4])]])
    oCluster = iLoCluster.book
    oCluster.mQueueCluster(iLsliderVals.i)
  end if
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
      Ltags = [#chair, #fireplace]
    else
      Ltags = [tag]
    end if
    repeat with tag in Ltags
      if me.iLblnElementEnabled[tag] then
        case tag of
          #chair:
            if iChairState = #on then
              me.mQueueEvent([#start: [#chn: me.ilchannels[1], #pgm: 35, #note: 58 + random(3), #vel: 100 + random(27)]], 50)
            else
              me.mQueueEvent([#stop: me.ilchannels[1]])
            end if
          #fireplace:
            me.mQueueEvent([#start: [#chn: me.ilchannels[2], #pgm: 31, #note: 58 + random(3), #vel: 127], 2: [#chn: me.ilchannels[3], #pgm: 32, #note: 58 + random(3), #vel: 127]], 50)
        end case
        next repeat
      end if
      case tag of
        #chair:
          me.mQueueEvent([#stop: me.ilchannels[1]])
        #fireplace:
          me.mQueueEvent([#stop: me.ilchannels[2], 2: me.ilchannels[3]])
      end case
    end repeat
  else
    me.mQueueEvent([#stop: iTag])
  end if
end
