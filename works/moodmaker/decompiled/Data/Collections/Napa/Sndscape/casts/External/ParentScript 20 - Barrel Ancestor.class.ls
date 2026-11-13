property ioDiorama, ioBarrel, iMode, ilchannels, iLmixLevels, iLmixIncrs, iLcurMixVals, iLeventQueue, iBlnEnabled, iLblnElementEnabled, iLfadeData, iLfadeExpireTimers
global goPanel

on new me, oBarrel, mode, Lchannels
  ioBarrel = oBarrel
  iMode = mode
  ilchannels = Lchannels
  iLeventQueue = [:]
  sort(iLeventQueue)
  iBlnEnabled = 0
  iLblnElementEnabled = 0
  if Lchannels.count then
    LmixLevels = []
    Llow = []
    Llow[Lchannels.count] = 0
    LmixLevels.append(Llow)
    Lhigh = []
    repeat with i = 1 to Lchannels.count
      Lhigh.append(100)
    end repeat
    LmixLevels.append(Lhigh)
  else
    LmixLevels = [[0], [100]]
  end if
  me.mInitMixLevels(LmixLevels)
  iLfadeData = [:]
  iLfadeExpireTimers = [:]
  return me
end

on mInitMixLevels me, LmixLevels
  iLmixLevels = duplicate(LmixLevels)
  iLmixIncrs = []
  repeat with n = 1 to ilchannels.count
    append(iLmixIncrs, (iLmixLevels[2][n] - iLmixLevels[1][n]) / 100.0)
  end repeat
  iLcurMixVals = duplicate(iLmixLevels[1])
  if iMode = #editor then
    repeat with n = 1 to ilchannels.count
      goPanel.mSetSliderFromVal(ilchannels[n], iLcurMixVals[n])
    end repeat
  end if
end

on mUpdateMixLevels me, val
  repeat with n = 1 to ilchannels.count
    iLcurMixVals[n] = integer(iLmixIncrs[n] * val) + iLmixLevels[1][n]
    if iMode = #editor then
      goPanel.mSetSliderFromVal(ilchannels[n], iLcurMixVals[n])
    end if
  end repeat
end

on mSetUserMixLevel me, chn, val
  idx = ilchannels.getPos(chn)
  if idx then
    iLcurMixVals[idx] = val
  end if
end

on mProcessEventQueue me, msecs
  Levents = [:]
  repeat while iLeventQueue.count
    if msecs >= iLeventQueue.getPropAt(1) then
      Levents.addProp(iLeventQueue[1][1], iLeventQueue[1][2])
      iLeventQueue.deleteAt(1)
      next repeat
    end if
    exit repeat
  end repeat
  return Levents
end

on mQueueEvent me, Levents, startDelay
  if voidp(startDelay) then
    startDelay = 0
  end if
  msecs = the milliSeconds
  repeat with n = 1 to Levents.count
    iLeventQueue.addProp(msecs + startDelay, [Levents.getPropAt(n), Levents[n]])
  end repeat
end

on mPurgeEventQueue me
  iLeventQueue = [:]
  sort(iLeventQueue)
end

on mToggleEnabled me
  ioBarrel.mSetEnabled(not iBlnEnabled)
end

on mToggleElementEnabled me, idx
  ioBarrel.mSetElementEnabled(idx, not iLblnElementEnabled[idx])
end

on mSetEnabled me, blnEnabled
  iBlnEnabled = blnEnabled
  if ilk(ioDiorama, #instance) then
    ioDiorama.Change([[#name: ioBarrel.iTag, #State: [0: #off, 1: #on].getaProp(iBlnEnabled), #intensity: ioBarrel.iLsliderVals.i]])
  end if
end

on mSetElementEnabled me, idx, blnEnabled
  iLblnElementEnabled[idx] = blnEnabled
  if ilk(ioDiorama, #instance) then
    ioDiorama.Change([[#name: ioBarrel.iLblnElementEnabled.getPropAt(idx), #State: [0: #off, 1: #on].getaProp(blnEnabled), #intensity: ioBarrel.iLsliderVals.i]])
  end if
end

on mInitFade me, tag, chnIDX, startLevel, targetLevel, fadeInSecs, sustainSecs, fadeOutSecs
  FPS = 15
  frameIncr = 1000 / float(FPS)
  valSpan = targetLevel - startLevel
  Ldata = []
  nbSteps = fadeInSecs * 1000 / frameIncr
  valIncr = valSpan / nbSteps
  sinIncr = PI / 2 / nbSteps
  nbSteps = integer(nbSteps)
  curVal = 0
  repeat with n = 1 to nbSteps
    newVal = integer(valSpan * sin(n * sinIncr))
    if newVal <> curVal then
      curVal = newVal
      Ltemp = []
      Ltemp.append(integer(n * frameIncr))
      Ltemp.append(curVal + startLevel)
      Ldata.append(Ltemp)
    end if
  end repeat
  nbSteps = sustainSecs * 1000 / frameIncr
  nbSteps = integer(nbSteps)
  timeOffset = fadeInSecs * 1000
  repeat with n = 1 to nbSteps
    Ldata.append([integer(n * frameIncr) + timeOffset, targetLevel])
  end repeat
  nbSteps = fadeOutSecs * 1000 / frameIncr
  valIncr = valSpan / nbSteps
  sinIncr = PI / 2 / nbSteps
  nbSteps = integer(nbSteps)
  curVal = 0
  timeOffset = (fadeInSecs * 1000) + (sustainSecs * 1000)
  repeat with n = 1 to nbSteps
    newVal = integer(valSpan * (1 - sin(n * sinIncr)))
    if newVal <> curVal then
      curVal = newVal
      Ltemp = []
      Ltemp.append(integer(n * frameIncr) + timeOffset)
      Ltemp.append(curVal + startLevel)
      Ldata.append(Ltemp)
    end if
  end repeat
  iLfadeData.setaProp(tag, [chnIDX, Ldata])
  iLfadeExpireTimers.setaProp(tag, 0)
end

on mQueueFade me, tag, LnoteDat, startDelay
  if the milliSeconds <= iLfadeExpireTimers.getaProp(tag) then
    return 0
  end if
  Levents = []
  msecs = the milliSeconds
  Ldata = iLfadeData.getaProp(tag)
  chnIDX = Ldata[1]
  LfadeData = Ldata[2]
  chn = ilchannels[chnIDX]
  curMixVal = iLcurMixVals[chnIDX]
  Levent = duplicate(LnoteDat)
  Levent.addProp(#chn, chn)
  me.mQueueEvent([#start: Levent], startDelay + LfadeData[1][1] + 100)
  repeat with n = 1 to LfadeData.count
    Levent = [#vol: [chn, integer(curMixVal * LfadeData[n][2] / 100.0)]]
    me.mQueueEvent(Levent, startDelay + LfadeData[n][1])
  end repeat
  me.mQueueEvent([#stop: chn], startDelay + LfadeData[LfadeData.count][1] + 100)
  iLfadeExpireTimers.setaProp(tag, the milliSeconds + startDelay + LfadeData[LfadeData.count][1] + 100)
  return 1
end

on mGetValFromRange me, theSetting, Lrange
  case theSetting of
    0:
      return Lrange.getaProp(0)
    100:
      return Lrange.getaProp(100)
    otherwise:
      repeat with n = 1 to Lrange.count
        thisSetting = Lrange.getPropAt(n)
        nextSetting = Lrange.getPropAt(n + 1)
        if (theSetting >= thisSetting) and (theSetting < nextSetting) then
          loVal = Lrange.getaProp(thisSetting)
          hiVal = Lrange.getaProp(nextSetting)
          exit repeat
        end if
      end repeat
  end case
  return loVal + ((theSetting - thisSetting) * ((hiVal - loVal) / float(nextSetting - thisSetting)))
end

on mdispose me
end
