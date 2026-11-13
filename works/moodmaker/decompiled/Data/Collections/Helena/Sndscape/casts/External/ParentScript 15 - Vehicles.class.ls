property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #vehicles
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#car: 0, #sleigh: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#car: [500, 2000, 2000], #sleigh: [500, 2000, 2000]]
  me.mInitFade(#car, 1, 1, 127, 5, 10, 5)
  me.mInitFade(#sleigh, 2, 1, 127, 5, 10, 5)
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
    elementTag = tag
    if me.iLblnElementEnabled[elementTag] then
      case tag of
        #car:
          if the milliSeconds > me.iLfadeExpireTimers.car then
            result = me.mQueueFade(#car, [#pgm: 17, #note: 58 + random(3), #vel: 100 + random(27)])
          end if
        #sleigh:
          if the milliSeconds > me.iLfadeExpireTimers.sleigh then
            result = me.mQueueFade(#sleigh, [#pgm: 16, #note: 59 + random(2), #vel: 100 + random(27)])
          end if
      end case
    end if
  end repeat
end
