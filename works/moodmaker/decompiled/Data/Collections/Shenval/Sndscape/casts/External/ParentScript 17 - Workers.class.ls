property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, iLchntag, iLoCluster, ioDissolve

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #workers
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#voices: 0, #harvesting: 0]
  iLchntag = [#voices, #cart, #steps1, #steps2, #harvest1, #harvest2]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#cart: [50, 150, 150], #harvest1: [50, 150, 150], #harvest2: [50, 150, 150]]
  iLoCluster = [:]
  LpgmNums = [[60, 2040], [61, 2250], [62, 2110], [63, 350], [64, 260], [65, 430]]
  chnIDX = iLchntag.getPos(#harvest1)
  iLoCluster.setaProp(#harvest1, new(script("Cluster.class"), me, me.ilchannels[chnIDX], LpgmNums, 1, 4))
  LpgmNums = [[46, 1320], [47, 550], [48, 1380], [49, 1030], [50, 1200], [51, 370], [52, 300], [53, 320], [54, 250], [55, 490], [58, 130], [59, 120]]
  chnIDX = iLchntag.getPos(#harvest2)
  iLoCluster.setaProp(#harvest2, new(script("Cluster.class"), me, me.ilchannels[chnIDX], LpgmNums, 1, 4))
  ioDissolve = new(script("Dissolve.class"), [[66, 4000], [67, 4000], [68, 4000], [69, 4000]])
  return me
end

on mPoll me, msecs
  Levents = me.mProcessEventQueue(msecs)
  if me.iBlnEnabled then
    if me.iLblnElementEnabled.voices then
      Levents.addProp(#vol, [me.ilchannels[1], integer(1.27000000000000002 * me.iLcurMixVals[1])])
      data = ioDissolve.mStep()
      if ilk(data, #list) then
        Levents.addProp(#play, [#chn: me.ilchannels[1], #pgm: data[2], #note: data[1], #vel: 127, #dur: 4000])
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
    elementTag = #harvesting
    if me.iLblnElementEnabled[elementTag] then
      idx = me.iLchntag.getPos(tag)
      case tag of
        #harvest1, #harvest2:
          me.mQueueEvent([#vol: [me.ilchannels[idx], integer(1.27000000000000002 * me.iLcurMixVals[idx])]])
          oCluster = iLoCluster[tag]
          oCluster.mQueueCluster(iLsliderVals.i)
        #cart:
          if the milliSeconds > me.iLfadeExpireTimers[tag] then
            LpgmMap = [#cart: 39, #steps1: 56, #steps2: 57]
            LpgmPool = duplicate(LpgmMap)
            LfadeTags = []
            idx = 1 + random(2)
            tag = LpgmPool.getPropAt(idx)
            LfadeTags.append(tag)
            LpgmPool.deleteProp(tag)
            case random(3) of
              1:
              2:
                idx = random(2)
                tag = LpgmPool.getPropAt(idx)
                LfadeTags.append(tag)
              3:
                repeat with n = 1 to LpgmPool.count
                  tag = LpgmPool.getPropAt(n)
                  LfadeTags.append(tag)
                end repeat
            end case
            fadeDur = 10 + random(5)
            repeat with n = 1 to LfadeTags.count
              fadetag = LfadeTags[n]
              me.mInitFade(fadetag, iLchntag.getPos(fadetag), 1, 127, fadeDur, 1, fadeDur)
              result = me.mQueueFade(fadetag, [#pgm: LpgmMap[fadetag], #note: 58 + random(3), #vel: 100 + random(27)])
            end repeat
          end if
      end case
    end if
  end repeat
end
