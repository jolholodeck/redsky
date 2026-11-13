property ioBarrel, iChn, iLsmpDat, iMinDensity, iMaxDensity, iCurClusterExpireTime

on new me, oBarrel, chn, LsmpDat, minDensity, maxDensity
  ioBarrel = oBarrel
  iChn = chn
  iMinDensity = minDensity
  iMaxDensity = maxDensity
  defaultDuration = 200
  iLsmpDat = []
  repeat with n = 1 to LsmpDat.count
    if ilk(LsmpDat[n], #integer) then
      iLsmpDat.append([LsmpDat[n], defaultDuration])
      next repeat
    end if
    iLsmpDat.append(LsmpDat[n])
  end repeat
  iCurClusterExpireTime = the milliSeconds
  return me
end

on mQueueCluster me, intensity
  if the milliSeconds < iCurClusterExpireTime then
    exit
  end if
  density = integer((iMaxDensity - iMinDensity) / 100.0 * intensity) + iMinDensity
  totalDur = 0
  repeat with n = 1 to density
    LsmpDat = iLsmpDat[random(iLsmpDat.count)]
    pgm = LsmpDat[1]
    dur = LsmpDat[2]
    vel = random(50) + 77
    note = 60 + getAt([-1, 0, 1], random(3))
    Levent = [#play: [#chn: iChn, #pgm: pgm, #note: note, #vel: vel, #dur: dur]]
    startDelay = totalDur + random(50)
    ioBarrel.mQueueEvent(Levent, startDelay)
    totalDur = startDelay + dur
  end repeat
  iCurClusterExpireTime = the milliSeconds + totalDur
end
