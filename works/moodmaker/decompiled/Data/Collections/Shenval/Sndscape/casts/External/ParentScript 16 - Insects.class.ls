property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, iBeeTimer, iBeeState, iBeeFadeIncr, iBeeFadeStep, iLcurAmps, ioMod, iBase

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #insects
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#bee: 0, #cicada: 0, #katydid: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#bee: [350, 1000, 350]]
  iBeeTimer = the milliSeconds
  iBeeState = #off
  iBeeFadeIncr = 0
  iBeeFadeStep = 0
  iLcurAmps = [20, 5]
  Ldat1 = [new(script("Sine LFO.class"), 10, 1), iLcurAmps[1], 1, 1]
  Ldat2 = [new(script("Sine LFO.class"), 5, 1), iLcurAmps[2], 1, 1]
  ioMod = new(script("Modulator.class"), [Ldat1, Ldat2])
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
    if me.iLblnElementEnabled.bee then
      case iBeeState of
        #off:
          if random(iLprb[1][3]) = iLprb[1][3] then
            me.mTrigger()
          end if
        #fadeIn:
          iBeeFadeStep = iBeeFadeStep + 1
          beeFade = iBeeFadeStep * iBeeFadeIncr
          if beeFade >= 1 then
            iBeeState = #on
          end if
        #on:
          beeFade = 1
          if msecs >= iBeeTimer then
            iBeeState = #fadeOut
          end if
        #fadeOut:
          iBeeFadeStep = iBeeFadeStep - 1
          beeFade = iBeeFadeStep * iBeeFadeIncr
          if beeFade <= 0 then
            iBeeState = #off
            me.mQueueEvent([#vol: [me.ilchannels[1], 0]])
            me.mQueueEvent([#stop: me.ilchannels[1]])
          end if
      end case
      if iBeeState <> #off then
        val = integer(ioMod.mStep())
        val = integer((val + (iBase * me.iLcurMixVals[1] / 100.0)) * beeFade)
        Levents.addProp(#vol, [me.ilchannels[1], val])
      end if
    end if
    if me.iLblnElementEnabled.cicada then
      Levents.addProp(#vol, [me.ilchannels[2], integer(1.27000000000000002 * me.iLcurMixVals[2])])
    end if
    if me.iLblnElementEnabled.katydid then
      Levents.addProp(#vol, [me.ilchannels[3], integer(1.27000000000000002 * me.iLcurMixVals[3])])
    end if
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
      iBase = 127 - (iLcurAmps[1] + iLcurAmps[2])
  end case
end

on mSwitchLoops me, tag
  if me.iBlnEnabled then
    if voidp(tag) then
      Ltags = []
      repeat with n = 1 to me.iLblnElementEnabled.count
        append(Ltags, me.iLblnElementEnabled.getPropAt(n))
      end repeat
    else
      Ltags = [tag]
    end if
    repeat with tag in Ltags
      if me.iLblnElementEnabled.getaProp(tag) then
        case tag of
          #cicada:
            me.mQueueEvent([#start: [#chn: me.ilchannels[2], #pgm: 44, #note: 60, #vel: 127]], 50)
          #katydid:
            me.mQueueEvent([#start: [#chn: me.ilchannels[3], #pgm: 45, #note: 60, #vel: 127]], 50)
        end case
        next repeat
      end if
      case tag of
        #bee:
          iBeeState = #off
          me.mQueueEvent([#vol: [me.ilchannels[1], 0]])
          me.mQueueEvent([#stop: me.ilchannels[1]])
        #cicada:
          me.mQueueEvent([#stop: me.ilchannels[2]])
        #katydid:
          me.mQueueEvent([#stop: me.ilchannels[3]])
      end case
    end repeat
  else
    iBeeState = #off
    me.mQueueEvent([#vol: [me.ilchannels[1], 0]])
    me.mQueueEvent([#stop: iTag])
  end if
end

on mTrigger me
  iBeeState = #fadeIn
  iBeeTimer = the milliSeconds + (random(4) * 1000)
  iBeeFadeStep = 0
  frameIncr = 1000 / float(iFPS)
  fadeTime = (iBeeTimer - the milliSeconds) / 3
  nbSteps = fadeTime / frameIncr
  iBeeFadeIncr = 1 / nbSteps
  me.mQueueEvent([#start: [#chn: me.ilchannels[1], #pgm: 43, #note: 60, #vel: 127]])
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
