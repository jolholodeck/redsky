property ancestor, iTag, iLsliderVals, iFPS, iTimer, iDelay, iMinChimesDelay, iMaxChimesDelay, iChimesTimer, ilChimesNotes, iBlnHasChimed

on new me, mode, Lchannels
  me.ancestor = new(script("Barrel Ancestor.class"), me, mode, Lchannels)
  iTag = #bells
  iLsliderVals = [#i: 0]
  me.iLblnElementEnabled = [#chimes: 0, #churchbell: 0, #clock: 0]
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iMinChimesDelay = 300
  iMaxChimesDelay = 3000
  iChimesTimer = the milliSeconds
  ilChimesNotes = [60, 62, 64, 67, 69]
  iBlnHasChimed = 0
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
    if me.iLblnElementEnabled.chimes then
      Levents.addProp(#vol, [me.ilchannels[1], integer(1.27000000000000002 * me.iLcurMixVals[1])])
      if msecs >= iChimesTimer then
        note = ilChimesNotes[random(ilChimesNotes.count)]
        me.mQueueEvent([#play: [#chn: me.ilchannels[1], #pgm: 29, #note: note, #vel: 100, #dur: 3000]], iMaxChimesDelay)
        theDelay = integer((iMaxChimesDelay - iMinChimesDelay) / 100.0 * (100 - iLsliderVals.i)) + iMinChimesDelay
        theDelay = theDelay + ([1, -1][random(2)] * random(integer(theDelay * 0.69999999999999996)))
        iChimesTimer = the milliSeconds + theDelay
      end if
    end if
    if me.iLblnElementEnabled.churchbell or me.iLblnElementEnabled.clock then
      lTime = me.mParseTime()
      if lTime[2] = 0 then
        if not iBlnHasChimed then
          iBlnHasChimed = 1
          me.mTrigger()
        end if
      else
        if iBlnHasChimed then
          iBlnHasChimed = 0
        end if
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
  end case
end

on mTrigger me
  lTime = me.mParseTime()
  if me.iLblnElementEnabled.churchbell then
    chimeDur = 3720
    spaceDur = 1000
    repeat with n = 1 to lTime[1]
      me.mQueueEvent([#vol: [me.ilchannels[2], integer(1.27000000000000002 * me.iLcurMixVals[2])]], ((n - 1) * (chimeDur + spaceDur)) - 500)
      me.mQueueEvent([#play: [#chn: me.ilchannels[2], #pgm: 28, #note: 60, #vel: 127, #dur: chimeDur]], (n - 1) * (chimeDur + spaceDur))
    end repeat
  end if
  if me.iLblnElementEnabled.clock then
    chimeDur = 3010
    spaceDur = 100
    repeat with n = 1 to lTime[1]
      me.mQueueEvent([#vol: [me.ilchannels[3], integer(1.27000000000000002 * me.iLcurMixVals[3])]], ((n - 1) * (chimeDur + spaceDur)) - 500)
      me.mQueueEvent([#play: [#chn: me.ilchannels[3], #pgm: 30, #note: 60, #vel: 127, #dur: chimeDur]], (n - 1) * (chimeDur + spaceDur))
    end repeat
  end if
end

on mParseTime me
  strTime = the abbr time
  offsetMin = offset(":", strTime)
  strMins = strTime.char[offsetMin + 1..offsetMin + 2]
  strHrs = strTime.char[1..offsetMin - 1]
  hrs = integer(strHrs)
  mins = integer(strMins)
  if hrs > 12 then
    hrs = hrs - 12
  end if
  return [hrs, mins]
end
