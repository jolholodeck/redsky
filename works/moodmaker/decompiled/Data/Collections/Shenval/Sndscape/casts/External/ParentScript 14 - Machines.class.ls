property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, iLchntag, iTruckState, iBlnTruckOn, ioFade, iTruckTimer, iCurTruckNote, iPumpState, iPumpTimer

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #machines
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#truck: 0, #pump: 0]
  iLchntag = [#truck, #pump]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#truck: [800, 2000, 2000], #pump: [150, 600, 600]]
  iTruckState = #Ready
  iBlnTruckOn = 0
  iPumpState = #off
  ioFade = new(script("Fade.class"))
  return me
end

on mPoll me, msecs
  Levents = me.mProcessEventQueue(msecs)
  Levents = me.mProcessTruckState(msecs, Levents)
  if msecs < (iTimer + iDelay) then
    return Levents
  else
    iTimer = msecs
  end if
  if (iPumpState = #on) and (msecs >= iPumpTimer) then
    iPumpState = #off
    me.mQueueEvent([#stop: me.ilchannels[2]])
  end if
  if me.iBlnEnabled then
    if me.iLblnElementEnabled.pump then
      if random(iLprb[2][3]) = iLprb[2][3] then
        me.mTrigger(iLprb.getPropAt(2))
      end if
      if iPumpState = #on then
        Levents.addProp(#vol, [me.ilchannels[2], integer(1.27000000000000002 * me.iLcurMixVals[2])])
      end if
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
      case tag of
        #truck:
          if me.iBlnEnabled and (iTruckState = #Ready) then
            iTruckState = #init_fadein
          end if
        #pump:
          if iPumpState = #off then
            me.mQueueEvent([#start: [#chn: me.ilchannels[2], #pgm: 6, #note: 59 + random(3), #vel: 127]])
            iPumpState = #on
            iPumpTimer = the milliSeconds + ((5 + random(5)) * 1000)
          end if
      end case
    end if
  end repeat
end

on mProcessTruckState me, msecs, Levents
  chnIDX = iLchntag.getPos(#truck)
  case iTruckState of
    #Ready:
      if me.iBlnEnabled and me.iLblnElementEnabled.truck then
        if random(iLprb[1][3]) = iLprb[1][3] then
          me.mTrigger(iLprb.getPropAt(1))
        end if
      end if
    #init_fadein:
      fadeSecs = 5 + random(5)
      ioFade.mInit(15, fadeSecs, 0, 100)
      iTruckTimer = msecs + ((fadeSecs + 2 + random(5)) * 1000)
      iCurTruckNote = 58 + random(3)
      me.mQueueEvent([#start: [#chn: me.ilchannels[chnIDX], #pgm: 41, #note: iCurTruckNote, #vel: 127]])
      ioFade.mStart()
      iTruckState = #Fade
    #init_fadeout:
      fadeSecs = 5 + random(5)
      ioFade.mInit(15, fadeSecs, 100, 0)
      ioFade.mStart()
      iTruckState = #Fade
    #Wait:
      if msecs >= iTruckTimer then
        if me.iBlnEnabled and me.iLblnElementEnabled.truck then
          iTruckState = #startup
        end if
      end if
    #sustain:
      if msecs >= iTruckTimer then
        if iBlnTruckOn then
          iTruckState = #init_fadeout
        else
          iBlnTruckOn = 1
          iTruckState = #shutoff
        end if
      end if
    #shutoff:
      me.mQueueEvent([#stop: me.ilchannels[chnIDX]])
      me.mQueueEvent([#play: [#chn: me.ilchannels[chnIDX], #pgm: 42, #note: iCurTruckNote, #vel: 127, #dur: 3040]], 10)
      iTruckTimer = msecs + ((60 + random(30)) * 1000)
      iTruckState = #Wait
    #startup:
      iCurTruckNote = 58 + random(3)
      me.mQueueEvent([#start: [#chn: me.ilchannels[chnIDX], #pgm: 40, #note: iCurTruckNote, #vel: 127]])
      iTruckTimer = msecs + ((2 + random(5)) * 1000)
      iTruckState = #sustain
    #Fade:
      result = ioFade.mStep(msecs)
      if symbolp(result) then
        if iBlnTruckOn then
          iBlnTruckOn = 0
          iTruckState = #stop
        else
          iTruckState = #sustain
        end if
      else
        val = me.iLcurMixVals[chnIDX] * 1.27000000000000002 * (result / 100)
        Levents.addProp(#vol, [me.ilchannels[chnIDX], val])
      end if
    #stop:
      me.mQueueEvent([#vol: [me.ilchannels[chnIDX], 0]])
      me.mQueueEvent([#stop: me.ilchannels[chnIDX]])
      iTruckState = #Ready
  end case
  return Levents
end
