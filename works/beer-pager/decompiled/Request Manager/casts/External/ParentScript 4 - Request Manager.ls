property iServerURL, iRequest, iNetID, iNetDone, iNetError, iNetTextResult, ilRequestQueue, iidUser, iTimeOffset, iDateOffset, iPingMode, iNextPing, iPingTime, iDebugMode
global kNetLiteSpr, oRequestMgr, gProxyMode

on new me, server, debugMode, proxyMode
  iDebugMode = 1
  iServerURL = server
  iRequest = 0
  iTimeOffset = 0
  iDateOffset = 0
  iPingMode = #on
  iPingTime = 2000
  iNextPing = the milliSeconds
  ilRequestQueue = []
  oRequestMgr = me
  doPut(#starting)
  case gProxyMode of
    #noProxy:
      nothing()
    #proxy:
    #authProxy:
      put "Doing setup for authenticated proxy"
  end case
  return me
end

on mCreateRequest me, requestType, Args, callBackObj, callback
  doPut(#creating, Args, requestType)
  me.mVerifyProps(requestType, Args)
  case requestType of
    "PostMeeting":
      Args = lingoToXml("postMeeting", Args)
  end case
  if Args <> 0 then
  else
  end if
  if Args <> 0 then
    case requestType of
      "postmeeting":
        requestURL = iServerURL & requestType
        Args = [#meeting: Args]
      otherwise:
        requestURL = iServerURL & requestType
    end case
  else
    requestURL = iServerURL & requestType
  end if
  doPut(#sending, requestURL)
  if gProxyMode <> #authProxy then
    iNetID = postNetText(requestURL, Args)
  else
    args2 = urlEncode(Args)
    iNetID = 0
    iNetID = AuthenticatedPostNetText(requestURL, args2)
    put "Request url=" & requestURL
  end if
  iRequest = script("Request Class").new(requestType, Args, callBackObj, callback, iNetID, gProxyMode)
  ilRequestQueue.add(iRequest)
  sendSprite(kNetLiteSpr, #mStartBlinking)
  return iRequest
end

on mHello me, Args, callback, requestor
  me.mCreateRequest("Hello", Args, 0, 0)
end

on mTimeSync me, id
  thisDate = beGetDate()
  systemDate = thisDate.month & "/" & thisDate.day & "/" & thisDate.centuryYear
  thisTime = beGetTime()
  systemTime = thisTime.hours24 & ":" & thisTime.minutes & ":" & thisTime.seconds
end

on mGetTime me
  mins = timeToMins(the long time)
  offsetMins = mins + iTimeOffset
  thisTime = minsToTime(offsetMins)
  return thisTime
end

on mGetDate me
  date = beGetDate()
  dateObj = date(date.centuryYear, date.month, date.day)
  dateObj = dateObj + iDateOffset
  return dateObj
end

on mRegisterUser me, Args, callBackObj, callback
  request = me.mCreateRequest("RegisterUser", Args, callBackObj, callback)
  return request
end

on mConnect me, sScreenName, sPassword, callBackObj, callback
  Args = [#sScreenName: sScreenName, #sPassword: sPassword]
  request = me.mCreateRequest("Connect", Args, callBackObj, callback)
  return request
end

on mFindUser me, sEmail, callBackObj, callback
  Args = [#sEmail: sEmail]
  request = me.mCreateRequest("FindUser", Args, callBackObj, callback)
  return request
end

on mInfectUser me, sFriendEmail, idUser, callBackObj, callback
  Args = [#sEmail: sFriendEmail, #idUser: idUser]
  request = me.mCreateRequest("InfectUser", Args, callBackObj, callback)
  return request
end

on mPostMeeting me, mtg, idUser, callBackObj, callback
  Args = [#mtg: mtg, #idUser: idUser]
  civilianTime = Args.mtg.dWhenTime
  militaryTime = civilianToMilitary(civilianTime)
  Args.mtg.dWhenTime = militaryTime
  request = me.mCreateRequest("PostMeeting", Args, callBackObj, callback)
  return request
end

on mGetMeeting me, id, callBackObj, callback
  request = me.mCreateRequest("GetMeeting", [#idMeeting: id], callBackObj, callback)
  return request
end

on mListMeetings me, idUser, callBackObj, callback
  Args = [#idUser: idUser]
  request = me.mCreateRequest("ListMeeting", Args, callBackObj, callback)
  return request
end

on mCancelMeeting me, idMeeting, idUser, sMessage, callBackObj, callback
  Args = [#idMeeting: idMeeting, #idUser: idUser, #sMessage: sMessage]
  request = me.mCreateRequest("CancelMeeting", Args, callBackObj, callback)
  return request
end

on mAcceptMeeting me, idMeeting, idUser, sMessage, callBackObj, callback
  Args = [#idMeeting: idMeeting, #idUser: idUser, #sMessage: sMessage]
  request = me.mCreateRequest("AcceptMeeting", Args, callBackObj, callback)
  return request
end

on mDeclineMeeting me, idMeeting, idUser, sMessage, callBackObj, callback
  Args = [#idMeeting: idMeeting, #idUser: idUser, #sMessage: sMessage]
  request = me.mCreateRequest("DeclineMeeting", Args, callBackObj, callback)
  return request
end

on mForgotPassword me, sEmail, callBackObj, callback
  Args = [#sEmail: sEmail]
  request = me.mCreateRequest("ForgotPassword", Args, callBackObj, callback)
  return request
end

on mSavePrefs me, idUser, sPrefs, sPassword, sZipCode, callBackObj, callback
  sPrefs = SearchAndReplace(sPrefs, "&", "&amp;")
  Args = [#idUser: idUser, #sPrefs: sPrefs, #sPassword: sPassword, #sZipCode: sZipCode]
  request = me.mCreateRequest("SavePrefs", Args, callBackObj, callback)
  return request
end

on mGetPrefs me, idUser, callBackObj, callback
  Args = [#idUser: idUser]
  request = me.mCreateRequest("GetPrefs", Args, callBackObj, callback)
  return request
end

on mRemove me, request
  ilRequestQueue.deleteOne(request)
end

on stepFrame me
  if iPingMode = #on then
    thisMilli = the milliSeconds
    thisPing = iNextPing
    if the milliSeconds < iNextPing then
      exit
    end if
    iNextPing = the milliSeconds + iPingTime
    doPut(#ping)
  end if
end

on mVerifyProps me, requestType, Args
  case requestType of
    "Connect":
      err = checkForProps(Args, [#sScreenName, #sPassword])
    "RegisterUser":
      err = checkForProps(Args, [#sFirstName, #sLastName, #sDOB, #sZipCode, #sEmail, #sScreenName, #sPassword, #sOptIn, #sConnectSpeed, #sGender])
  end case
  if err <> 0 then
    put "Missing required parameter:" & string(err) & RETURN
    halt()
  end if
end
