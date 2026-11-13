property ikFreeBytesAtInit, iCurFreeBytes, iCurFPS, iCurHitCnt, iTimer, iDelay, iMbrDiagnotics

on new me, freeBytesAtInit
  ikFreeBytesAtInit = freeBytesAtInit
  iCurFreeBytes = the freeBytes
  iCurFPS = 0
  iCurHitCnt = 0
  iMbrDiagnotics = member("diagnotics", 1)
  iTimer = the milliSeconds
  iDelay = 5000
  append(the actorList, me)
  me.mUpdateField()
  return me
end

on stepFrame me
  iCurHitCnt = iCurHitCnt + 1
  if the milliSeconds < (iTimer + iDelay) then
    exit
  end if
  flg = 0
  FPS = integer(1000 / (iDelay / float(iCurHitCnt)))
  if FPS <> iCurFPS then
    flg = 1
    iCurFPS = FPS
  end if
  curFreeBytes = the freeBytes
  if curFreeBytes <> iCurFreeBytes then
    flg = 1
    iCurFreeBytes = curFreeBytes
  end if
  if flg then
    me.mUpdateField()
  end if
  iTimer = the milliSeconds
  iCurHitCnt = 0
end

on mUpdateField me
  strMem = string(max(0, ikFreeBytesAtInit - iCurFreeBytes) / 1024)
  iMbrDiagnotics.text = "mem:" & strMem && "| fps:" & string(iCurFPS)
end
