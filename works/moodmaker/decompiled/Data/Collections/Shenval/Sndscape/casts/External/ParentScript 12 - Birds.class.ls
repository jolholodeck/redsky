property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, iLchntag, iLoCluster, ioDissolve

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #birds
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#hawk: 0, #Geese: 0, #songbirds: 0]
  iLchntag = [#hawk, #Geese, #songbirds_dislv, #songbirds_clstr]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#hawk: [30, 300, 300], #Geese: [30, 300, 300], #songbirds_clstr: [30, 300, 300]]
  iLoCluster = [:]
  LpgmNums = [[16, 1080]]
  chnIDX = iLchntag.getPos(#hawk)
  iLoCluster.setaProp(#hawk, new(script("Cluster.class"), me, me.ilchannels[chnIDX], LpgmNums, 1, 2))
  LpgmNums = [[13, 2310], [14, 1300], [15, 1310], [74, 3020], [75, 1310], [76, 1220]]
  chnIDX = iLchntag.getPos(#songbirds_clstr)
  iLoCluster.setaProp(#songbirds_clstr, new(script("Cluster.class"), me, me.ilchannels[chnIDX], LpgmNums, 2, 4))
  ioDissolve = new(script("Dissolve.class"), [[9, 5000], [10, 5000], [11, 5000], [12, 5000]])
  me.mInitFade(#Geese, iLchntag.getPos(#Geese), 1, 127, 5, 10, 5)
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
    if me.iLblnElementEnabled.songbirds then
      Levents.addProp(#vol, [me.ilchannels[3], integer(1.27000000000000002 * me.iLcurMixVals[3])])
      data = ioDissolve.mStep()
      if ilk(data, #list) then
        Levents.addProp(#play, [#chn: me.ilchannels[3], #pgm: data[2], #note: data[1], #vel: 127, #dur: 5000])
      end if
    end if
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
    case tag of
      #songbirds_clstr:
        elementTag = #songbirds
      otherwise:
        elementTag = tag
    end case
    if me.iLblnElementEnabled[elementTag] then
      idx = me.iLchntag.getPos(tag)
      case tag of
        #hawk, #songbirds_clstr:
          me.mQueueEvent([#vol: [me.ilchannels[idx], integer(1.27000000000000002 * me.iLcurMixVals[idx])]])
          oCluster = iLoCluster[tag]
          oCluster.mQueueCluster(iLsliderVals.i)
        otherwise:
          if the milliSeconds > me.iLfadeExpireTimers[tag] then
            me.mInitFade(tag, iLchntag.getPos(tag), 1, 127, 10 + random(5), 15 + random(15), 10 + random(5))
            result = me.mQueueFade(tag, [#pgm: 17, #note: 58 + random(3), #vel: 100 + random(27)])
          end if
      end case
    end if
  end repeat
end
