property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, iLpgmNums, iLrmfFileInfo, iLrmfExpireTimers

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #machines
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#plane: 0, #car: 0, #tractor: 0, #bike: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLpgmNums = [38, 37]
  iLprb = [#plane: [500, 3000, 500], #car: [500, 3000, 500], #tractor: [500, 2000, 500], #bike: [100, 1000, 100]]
  iLrmfFileInfo = [#car: [["car1.rmf", 15], ["car2.rmf", 15]], #plane: [["plane1.rmf", 25], ["plane2.rmf", 25]]]
  iLrmfExpireTimers = [#car: the milliSeconds, #plane: the milliSeconds]
  me.mInitFade(#tractor, 1, 1, 127, 5, 10, 5)
  me.mInitFade(#bike, 2, 1, 127, 3, 2, 3)
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
      repeat with n = 1 to iLprb.count
        iLprb[n][3] = iLprb[n][2] - integer((iLprb[n][2] - iLprb[n][1]) / 100.0 * val)
      end repeat
  end case
end

on mTrigger me, tag
  if voidp(tag) then
    Ltags = [#plane, #car, #tractor, #bike]
  else
    Ltags = [tag]
  end if
  msecs = the milliSeconds
  repeat with n = 1 to Ltags.count
    tag = Ltags[n]
    if me.iLblnElementEnabled.getaProp(tag) then
      case tag of
        #plane, #car:
          if the milliSeconds > iLrmfExpireTimers.getaProp(tag) then
            LtagInfo = iLrmfFileInfo.getaProp(tag)
            LrmfFileInfo = LtagInfo[random(LtagInfo.count)]
            rmfFileName = LrmfFileInfo[1]
            rmfDuration = LrmfFileInfo[2] * 1000
            me.mQueueEvent([#playrmf: [tag, rmfFileName, rmfDuration]])
            me.mQueueEvent([#stoprmf: [tag]], rmfDuration)
            iLrmfExpireTimers.setaProp(tag, the milliSeconds + rmfDuration)
          end if
        #tractor:
          idx = me.iLblnElementEnabled.findPos(tag) - 2
          err = me.mQueueFade(tag, [#pgm: iLpgmNums[idx], #note: 60, #vel: 127])
          if err = 1 then
            if ilk(me.ioDiorama, #instance) then
              me.ioDiorama.Change([[#name: #tractor, #State: #on, #intensity: iLsliderVals.i, #duration: 20000]])
            end if
          end if
        #bike:
          idx = me.iLblnElementEnabled.findPos(tag) - 2
          err = me.mQueueFade(tag, [#pgm: iLpgmNums[idx], #note: 60, #vel: 127])
      end case
    end if
  end repeat
end

on mSetEnabled me, blnEnabled
  me.iBlnEnabled = blnEnabled
  if not me.iBlnEnabled then
    me.mPurgeEventQueue()
    me.mQueueEvent([#stop: iTag])
    me.mQueueEvent([#stoprmf: [#plane]])
    me.mQueueEvent([#stoprmf: [#car]])
  end if
end

on mSetElementEnabled me, idx, blnEnabled
  me.iLblnElementEnabled[idx] = blnEnabled
end
