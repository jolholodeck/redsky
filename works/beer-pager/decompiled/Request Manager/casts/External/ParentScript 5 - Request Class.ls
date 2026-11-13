property iState, iProxyMode, iType, iNetDone, iCallBack, iNetID, iID, iArgs, iURL, iResult, iData, iErrorType, iCallBackObj, iStartTime, iEndTime, iMaxTime
global oRequestMgr, gCurScreen, oMeetings, oMeetingFac, oFriendsClass, kNetLiteSpr, oPrefsClass

on new me, type, Args, callBackObj, callback, netID, proxyMode
  iProxyMode = proxyMode
  iMaxTime = 30000
  iStartTime = the milliSeconds
  iType = type
  iArgs = Args
  iNetDone = 0
  iNetID = netID
  iCallBackObj = callBackObj
  iCallBack = callback
  iErrorType = #none
  (the actorList).add(me)
  return me
end

on stepFrame me
  if the shiftDown then
    iResult = -1
    iErrorType = #timeout
    iData = 0
    me.mHandleResponse()
    sendSprite(kNetLiteSpr, #mStopBlinking)
    exit
  end if
  elapsedTime = the milliSeconds - iStartTime
  if elapsedTime > iMaxTime then
    me.mRemove()
    me.mKill()
    iResult = -1
    iErrorType = #timeout
    me.mHandleResponse()
    sendSprite(kNetLiteSpr, #mStopBlinking)
    exit
  end if
  case iProxyMode of
    #noProxy, #proxy:
      if netDone(iNetID) and (iNetID <> 0) then
        netDone = netDone(iNetID)
        netError = netError(iNetID)
        netTextResult = netTextResult(iNetID)
        if (netError <> "OK") or voidp(netTextResult) or (netTextResult = EMPTY) then
          errMsg = getErrorText(netError(iNetID))
          doPut(#netError, errMsg)
        end if
        if netError(iNetID) = "OK" then
          iResult = 1
        else
          iResult = -1
          iErrorType = #NetLingo
        end if
        iNetDone = 1
        iData = netTextResult(iNetID)
        me.mHandleResponse()
        iRequest = 0
        sendSprite(kNetLiteSpr, #mStopBlinking)
      end if
    #authProxy:
      netDone = ProxyServerNetDone(iNetID)
      if netDone and (iNetID <> 0) then
        netError = ProxyServerNetError(iNetID)
        if netError = 0 then
          iResult = 1
        else
          iResult = -1
          iErrorType = #proxyNetError
        end if
        iNetDone = 1
        iData = 0
        iData = AuthenticatedGetText(iNetID)
        me.mHandleResponse()
        iRequest = 0
        sendSprite(kNetLiteSpr, #mStopBlinking)
      end if
  end case
end

on mHandleResponse me
  me.mRemove()
  me.mKill()
  iEndTime = the milliSeconds
  latency = iEndTime - iStartTime
  doPut(#latency, latency)
  doPut(#xml, iData)
  if iResult <> -1 then
    if iData contains "java.lang.NullPointerException" then
      iResult = -1
      iErrorType = #networkerror
    else
      if iData contains "error" then
        iResult = 0
        iErrorType = #generic
      else
        iResult = 1
      end if
    end if
  end if
  if iResult <> -1 then
    case iType of
      "RegisterUser":
        if not (iData contains "Login or Password invalid") then
          if iResult = 1 then
            iData = xmlToLingo("RegisterUser", iData)
          else
            if iData contains "sScreenName" then
              iErrorType = #sScreenName
            end if
            if iData contains "sZipCode" then
              iErrorType = #sZipCode
            end if
            if iData contains "your using that email address already" then
              iErrorType = #sEmail
            end if
          end if
        else
          iErrorType = #noConnection
          iResult = -1
        end if
      "connect":
        if not (iData contains "error") and not (iData contains "Login or Password invalid") then
          iData = xmlToLingo("Connect", iData)
        else
          if iProxyMode = #authProxy then
            iErrorType = #noConnection
            iResult = -1
          else
            iErrorType = #loginFailure
            iResult = 0
          end if
          iData = 0
        end if
      "PostMeeting":
        if not (iData contains "error") then
          iData = xmlToLingo("PostMeeting", iData)
        else
          iData = 0
        end if
      "FindUser":
        if iResult = 1 then
          iData = xmlToLingo("FindUser", iData)
        else
          iErrorType = #sEmail
        end if
      "postMeeting":
        nothing()
      "listMeeting":
        if not (iData contains "error") then
          iData = xmlToLingo("ListMeeting", iData)
        end if
        oPrefsClass.pMeetingData = iData
      "getMeeting":
        if not (iData contains "error") then
          meetingXML = iData
          iData = xmlToLingo("getMeeting", meetingXML)
        end if
      "timeSync":
        if not (iData contains "error") then
          lOffsets = xmlToLingo("timeSync", iData)
          oRequestMgr.iTimeOffset = lOffsets.time
          oRequestMgr.iDateOffset = lOffsets.date
          case gCurScreen of
            "help", "tuner", "tuner2", "friends", "places", "calendar", "calendar2", "main", "prefs":
              setClock()
          end case
        end if
        nothing()
      "GetPrefs":
        if not (iData contains "error") then
          iData = xmlToLingo("GetPrefs", iData)
        end if
      "SavePrefs":
        if not (iData contains "error") then
          iData = iData
        else
          if iData contains "ZipCode" then
            iErrorType = #sZipCode
          end if
        end if
    end case
  end if
  if iData = -1 then
    iResult = -1
    iErrorType = #nonXmlResponse
  end if
  responseInfo = [#result: iResult, #data: iData, #error: iErrorType]
  doPut(#parsing, responseInfo)
  if not voidp(iCallBack) then
    if iCallBack <> 0 then
      call(iCallBack, iCallBackObj)
    end if
  end if
end

on mKill me
  (the actorList).deleteOne(me)
end

on mRemove me
  oRequestMgr.mRemove(me)
end
