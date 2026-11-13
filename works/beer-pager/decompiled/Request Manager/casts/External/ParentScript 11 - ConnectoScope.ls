property iState, iLastConnectionResult, iTestGif, iNetID, pStatusFieldMem, iNextCheckTime, iCueCheckTime, iStartTime, iCurTime, iMaxTime

on new me, gifUrl, maxTime, statusFieldMem
  iState = #connecting
  iLastConnectionResult = 0
  if the platform contains "Win" then
    dcRegister(111890840)
  else
    dcRegister(102155997)
  end if
  iTestGif = gifUrl
  iNetID = -1
  iMaxTime = maxTime
  pStatusFieldMem = statusFieldMem
  mUpdateStatus(me, "ConnectoScope Ready")
  iCueCheckTime = 600
  iNextCheckTime = the timer
  return me
end

on mVerifyConnection me
  return 1
end

on mCheckConnection me
  clearCache()
  mUpdateStatus(me, "CS: Checking Connection...")
  iNetID = preloadNetThing(iTestGif)
  iStartTime = the timer / 60
  addToActorList(VOID, me)
end

on mConnectionCheckDone me
  if netDone(iNetID) or mDialupConnected(me) then
    iLastConnectionResult = 1
    return 1
  else
    iLastConnectionResult = 0
    return 0
  end if
end

on mConnected me
  return iLastConnectionResult
end

on mDialupConnected me
  if listp(dcGetActiveConnections()) then
    if count(dcGetActiveConnections()) > 0 then
      return 1
    else
      return 0
    end if
  else
    return 0
  end if
end

on mLanConnected me
  if mDialupConnected(me) then
    return 0
  end if
  if netDone(iNetID) and ((netError(iNetID) = "OK") or (netError(iNetID) = 0)) then
    return 1
  else
    return 0
  end if
end

on mUpdateStatus me, myText
end

on stepFrame me
  nothing()
  if iState = #connecting then
    if mConnectionCheckDone(me) then
      if mConnected(me) then
        newText = "CS: ...Connection found."
      else
        newText = "CS: ...No connection found."
      end if
      me.mCheckConnection()
      iState = #idle
    else
      iCurTime = the timer / 60
      elapsedTime = iCurTime - iStartTime
      if elapsedTime < iMaxTime then
        newText = "CS:...Waiting."
      else
        newText = "CS:...Timed out attempting to check connection status."
      end if
      me.mCheckConnection()
      iState = #idle
    end if
    mUpdateStatus(me, newText)
  else
    if the timer < iNextCheckTime then
      exit
    end if
    iNextCheckTime = iNextCheckTime + iCueCheckTime
    if mConnectionCheckDone(me) then
      if me.mConnected() then
        me.mCheckConnection()
      else
        put "oops connection dropped."
      end if
    end if
  end if
end
