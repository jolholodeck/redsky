property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, iLchntag, iLoCluster

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #animals
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#dog: 0, #horse: 0, #squirrel: 0, #cows: 0]
  iLchntag = [#dog, #horse, #horse_clstr, #squirrel, #cows]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#dog: [240, 600, 600], #horse: [240, 600, 600], #horse_clstr: [10, 100, 10], #squirrel: [240, 600, 600], #cows: [140, 400, 400]]
  iLoCluster = [:]
  LpgmNums = [[22, 200], [23, 220], [24, 220], [25, 230]]
  chnIDX = iLchntag.getPos(#dog)
  iLoCluster.setaProp(#dog, new(script("Cluster.class"), me, me.ilchannels[chnIDX], LpgmNums, 1, 3))
  LpgmNums = [[28, 2300], [29, 1230], [30, 2070], [31, 1340], [32, 1050], [33, 540], [34, 2130], [35, 1480]]
  chnIDX = iLchntag.getPos(#horse_clstr)
  iLoCluster.setaProp(#horse_clstr, new(script("Cluster.class"), me, me.ilchannels[chnIDX], LpgmNums, 1, 3))
  LpgmNums = [[36, 1080], [37, 1330], [38, 1010]]
  chnIDX = iLchntag.getPos(#squirrel)
  iLoCluster.setaProp(#squirrel, new(script("Cluster.class"), me, me.ilchannels[chnIDX], LpgmNums, 1, 2))
  LpgmNums = [[18, 1470], [19, 2040], [20, 2330], [21, 2290]]
  chnIDX = iLchntag.getPos(#cows)
  iLoCluster.setaProp(#cows, new(script("Cluster.class"), me, me.ilchannels[chnIDX], LpgmNums, 1, 2))
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
      #horse_clstr:
        elementTag = #horse
      otherwise:
        elementTag = tag
    end case
    if me.iLblnElementEnabled[elementTag] then
      idx = me.iLchntag.getPos(tag)
      case tag of
        #dog, #squirrel, #cows:
          me.mQueueEvent([#vol: [me.ilchannels[idx], integer(1.27000000000000002 * me.iLcurMixVals[idx])]])
          oCluster = iLoCluster[tag]
          oCluster.mQueueCluster(iLsliderVals.i)
        #horse:
          if the milliSeconds > me.iLfadeExpireTimers[tag] then
            case random(2) of
              1:
                pgm = 26
                fadeDur = 5 + random(5)
              2:
                pgm = 27
                fadeDur = 10 + random(5)
            end case
            me.mInitFade(#horse, iLchntag.getPos(#horse), 1, 127, fadeDur, 1, fadeDur)
            me.mInitFade(#horse_clstr, iLchntag.getPos(#horse_clstr), 1, 127, fadeDur, 1, fadeDur)
            result = me.mQueueFade(#horse, [#pgm: pgm, #note: 58 + random(3), #vel: 100 + random(27)])
            pgm = 50
            result = me.mQueueFade(#horse_clstr, [#pgm: pgm, #note: 58 + random(3), #vel: 100 + random(27)])
          end if
        #horse_clstr:
          if the milliSeconds <= me.iLfadeExpireTimers[tag] then
            iLoCluster.horse_clstr.mQueueCluster(iLsliderVals.i)
          end if
      end case
    end if
  end repeat
end
