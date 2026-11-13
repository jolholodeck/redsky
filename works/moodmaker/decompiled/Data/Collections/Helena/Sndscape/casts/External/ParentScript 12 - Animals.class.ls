property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, iLchntag, iLoCluster, iCatState, iCatTimer, ilDelayRange

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #animals
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#cat: 0, #dog: 0, #owl: 0]
  iLchntag = [#cat, #catpurr, #dog, #owl]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#cat: [300, 600, 600], #dog: [240, 600, 600], #owl: [600, 1200, 1200]]
  iLoCluster = [:]
  LpgmNums = [[4, 750], [5, 960], [6, 1120]]
  chnIDX = iLchntag.getPos(#cat)
  iLoCluster.setaProp(#cat, new(script("Cluster.class"), me, me.ilchannels[chnIDX], LpgmNums, 1, 2))
  LpgmNums = [[8, 330], [9, 430], [10, 430], [11, 470]]
  chnIDX = iLchntag.getPos(#dog)
  iLoCluster.setaProp(#dog, new(script("Cluster.class"), me, me.ilchannels[chnIDX], LpgmNums, 1, 3))
  LpgmNums = [[12, 880], [13, 740], [14, 490], [15, 340]]
  chnIDX = iLchntag.getPos(#owl)
  iLoCluster.setaProp(#owl, new(script("Cluster.class"), me, me.ilchannels[chnIDX], LpgmNums, 1, 2))
  iCatState = #off
  iCatTimer = the milliSeconds
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
    if me.iLblnElementEnabled.cat then
      if msecs >= iCatTimer then
        if iCatState = #on then
          iCatState = #off
        else
          iCatState = #on
        end if
        delaySecs = integer(me.mGetValFromRange(iLsliderVals.i, ilDelayRange[iCatState]))
        delayOffset = [1, -1][random(2)] * random(20)
        iCatTimer = the milliSeconds + ((delaySecs + delayOffset) * 1000)
        me.mSwitchLoops()
      end if
      if iCatState = #off then
        Levents.addProp(#vol, [me.ilchannels[2], integer(1.27000000000000002 * me.iLcurMixVals[2])])
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
      if ilk(me.ioDiorama, #instance) then
        me.ioDiorama.Change([[#name: iTag, #State: [0: #off, 1: #on].getaProp(me.iBlnEnabled), #intensity: val]])
      end if
      repeat with n = 1 to iLprb.count
        iLprb[n][3] = iLprb[n][2] - integer((iLprb[n][2] - iLprb[n][1]) / 100.0 * val)
      end repeat
      delaySecs = integer(me.mGetValFromRange(iLsliderVals.i, ilDelayRange[iCatState]))
      iCatTimer = the milliSeconds + (delaySecs * 1000)
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
      idx = me.iLchntag.getPos(tag)
      if (tag = #cat) and (iCatState = #off) then
        next repeat
      end if
      me.mQueueEvent([#vol: [me.ilchannels[idx], integer(1.27000000000000002 * me.iLcurMixVals[idx])]])
      oCluster = iLoCluster[tag]
      oCluster.mQueueCluster(iLsliderVals.i)
    end if
  end repeat
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
      Ltags = [#cat]
    else
      Ltags = [tag]
    end if
    repeat with tag in Ltags
      if me.iLblnElementEnabled[tag] then
        case tag of
          #cat:
            if iCatState = #off then
              me.mQueueEvent([#start: [#chn: me.ilchannels[2], #pgm: 7, #note: 58 + random(3), #vel: 100 + random(27)]], 50)
            else
              me.mQueueEvent([#stop: me.ilchannels[2]])
            end if
        end case
        next repeat
      end if
      case tag of
        #cat:
          me.mQueueEvent([#stop: me.ilchannels[2]])
      end case
    end repeat
  else
    me.mQueueEvent([#stop: iTag])
  end if
end
