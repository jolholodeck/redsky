property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iLprb, ioCluster, ilDelayRange, iPlayTimer, iPlayState, iRainTimer, iRainState, ioFade, ilMuteChannels, iBlnFirstRain

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #rain
  iLsliderVals = [#i: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iLprb = [#thunder: [50, 200, 200]]
  LpgmNums = [[7, 5000], [8, 5000]]
  ioCluster = new(script("Cluster.class"), me, me.ilchannels[4], LpgmNums, 1, 1)
  ilDelayRange = [#on: [0: 60, 100: 180], #off: [0: 600, 100: 180]]
  iPlayState = #off
  iPlayTimer = the milliSeconds
  iRainState = #off
  iRainTimer = the milliSeconds
  ioFade = new(script("Fade.class"))
  ilMuteChannels = [9, 11, 15, 16, 21, 22, 23, 24, 27, 28, 29, 30, 31]
  iBlnFirstRain = 1
  return me
end

on mPoll me, msecs
  Levents = me.mProcessEventQueue(msecs)
  if msecs < (iTimer + iDelay) then
    return Levents
  else
    iTimer = msecs
  end if
  case iPlayState of
    #off:
      if me.iBlnEnabled then
        if msecs >= iPlayTimer then
          me.mTrigger()
          iRainTimer = msecs + 10000
          iPlayState = #on
          iRainState = #thunder_in
          iBlnFirstRain = 0
        end if
      end if
    #on:
      if random(iLprb[1][3]) = iLprb[1][3] then
        me.mTrigger()
      end if
      case iRainState of
        #thunder_in:
          if me.iBlnEnabled then
            if msecs >= iRainTimer then
              iRainState = #wait_dio
            end if
          else
            iPlayState = #off
            iRainState = #off
          end if
        #wait_dio:
          if me.iBlnEnabled then
            if ilk(me.ioDiorama, #instance) then
              if me.ioDiorama.mCheckRainStart(iLsliderVals.i) then
                iRainState = #queuefade
              end if
            else
              iRainState = #queuefade
            end if
          else
            iPlayState = #off
            iRainState = #off
            if ilk(me.ioDiorama, #instance) then
              me.ioDiorama.mAbortRainSTart()
            end if
          end if
        #queuefade:
          ioFade.mInit(15, 15, 0, 100)
          delaySecs = integer(me.mGetValFromRange(iLsliderVals.i, ilDelayRange[iPlayState]))
          delaySecs = delaySecs + ([1, -1][random(2)] * random(20))
          iPlayTimer = the milliSeconds + (delaySecs * 1000)
          me.mQueueEvent([#start: [#chn: me.ilchannels[1], #pgm: 4, #note: 60, #vel: 127], 2: [#chn: me.ilchannels[2], #pgm: 5, #note: 60, #vel: 127], 3: [#chn: me.ilchannels[3], #pgm: 6, #note: 60, #vel: 127]])
          me.mQueueEvent([#mutechn: [1, ilMuteChannels]], 10000)
          ioFade.mStart()
          iRainState = #fade_in
        #fade_in:
          result = ioFade.mStep(msecs)
          if symbolp(result) then
            iRainState = #sustain
          else
            repeat with chnIDX = 1 to 3
              val = me.iLcurMixVals[chnIDX] * 1.27000000000000002 * (result / 100)
              Levents.addProp(#vol, [me.ilchannels[chnIDX], val])
            end repeat
          end if
        #sustain:
          repeat with chnIDX = 1 to 3
            val = me.iLcurMixVals[chnIDX] * 1.27000000000000002
            Levents.addProp(#vol, [me.ilchannels[chnIDX], val])
          end repeat
          blnQueueFade = 0
          if me.iBlnEnabled then
            if msecs >= iPlayTimer then
              blnQueueFade = 1
            end if
          else
            blnQueueFade = 1
          end if
          if blnQueueFade then
            ioFade.mInit(15, 15, 100, 0)
            me.mQueueEvent([#mutechn: [0, ilMuteChannels]], 10000)
            ioFade.mStart()
            iRainState = #fade_out
          end if
        #fade_out:
          result = ioFade.mStep(msecs)
          if symbolp(result) then
            iPlayState = #off
            iRainState = #off
            me.mQueueEvent([#stop: me.ilchannels[1], 2: me.ilchannels[2], 3: me.ilchannels[3]])
            delaySecs = integer(me.mGetValFromRange(iLsliderVals.i, ilDelayRange[iPlayState]))
            delaySecs = delaySecs + ([1, -1][random(2)] * random(20))
            iPlayTimer = the milliSeconds + (delaySecs * 1000)
            if ilk(me.ioDiorama, #instance) then
              me.ioDiorama.Change([[#name: iTag, #State: #off, #intensity: iLsliderVals.i]])
            end if
          else
            repeat with chnIDX = 1 to 3
              val = me.iLcurMixVals[chnIDX] * 1.27000000000000002 * (result / 100)
              Levents.addProp(#vol, [me.ilchannels[chnIDX], val])
            end repeat
          end if
      end case
  end case
  return Levents
end

on mSetValFromSlider me, val, key
  case key of
    #i:
      iLsliderVals.i = val
      me.mUpdateMixLevels(val)
      iLprb[1][3] = iLprb[1][2] - integer((iLprb[1][2] - iLprb[1][1]) / 100.0 * val)
      if iBlnFirstRain then
        delaySecs = 10
      else
        delaySecs = integer(me.mGetValFromRange(iLsliderVals.i, ilDelayRange[iPlayState]))
        delaySecs = delaySecs + ([1, -1][random(2)] * random(20))
      end if
      iPlayTimer = the milliSeconds + (delaySecs * 1000)
      if ilk(me.ioDiorama, #instance) then
        if iRainState = #sustain then
          me.ioDiorama.Change([[#name: iTag, #State: #on, #intensity: iLsliderVals.i]])
        end if
      end if
  end case
end

on mTrigger me
  me.mQueueEvent([#vol: [me.ilchannels[4], integer(1.27000000000000002 * me.iLcurMixVals[4])]])
  ioCluster.mQueueCluster(iLsliderVals.i)
end

on mSetEnabled me, blnEnabled
  me.iBlnEnabled = blnEnabled
  if me.iBlnEnabled then
    iBlnFirstRain = 1
    delaySecs = 10
    iPlayTimer = the milliSeconds + (delaySecs * 1000)
  end if
end
