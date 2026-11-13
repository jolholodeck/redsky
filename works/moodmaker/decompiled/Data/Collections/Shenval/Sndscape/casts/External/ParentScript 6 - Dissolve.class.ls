property iLsamples, iLpgmPool, iTimer, iDelay, iState, iCurNote

on new me, Lsamples
  iLsamples = Lsamples
  iLpgmPool = duplicate(iLsamples)
  iCurNote = 60
  iState = #start
  iTimer = the milliSeconds
  iDelay = 0
  return me
end

on mStep me
  msecs = the milliSeconds
  case iState of
    #start:
      idx = random(iLpgmPool.count)
      pgm = iLpgmPool[idx][1]
      dur = iLpgmPool[idx][2]
      note = 60 + getAt([-1, 0, 1], random(3))
      if note = iCurNote then
        if note <= 60 then
          note = note + 1
        else
          note = note - 1
        end if
      end if
      iCurNote = note
      iLpgmPool.deleteAt(idx)
      if iLpgmPool.count = 0 then
        iLpgmPool = duplicate(iLsamples)
      end if
      iTimer = msecs
      iDelay = dur - 300
      iState = #Wait
      return [note, pgm]
    #Wait:
      if the milliSeconds >= (iTimer + iDelay) then
        iState = #start
      end if
      return 0
  end case
end
