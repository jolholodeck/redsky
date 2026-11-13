property pUserNameMem, pPasswordMem, pShowLoginCheckSpr, pPassWordTextSpr, pUserNameTextSpr, pCurRequest
global oPrefsClass, oDialogueClass, oRequestMgr, oMeetings, gState, kMyId, kWatchCursor, gProxyStr, gPortStr, gStartOver, gCurScreen, oSoundMgr, gProxyMode, gProxyUserName, gProxyUserPassword, gDoneWithInitialNet

on new me
  pUserNameMem = "in_L_username"
  pPasswordMem = "in_L_password"
  pShowLoginCheckSpr = 11
  pPassWordTextSpr = 31
  pUserNameTextSpr = 30
  return me
end

on mInitMyScreen me
  if gState <> #dialogue then
    member("APS pword").editable = 0
    sprite(82).editable = 0
  end if
  if gStartOver then
    if gProxyMode = #authProxy then
      rememberflag = 1
      rememberProxyMode = gProxyMode
      rememberProxyString = gProxyStr
      rememberPortString = gPortStr
      rememberProxyUserName = gProxyUserName
      rememberProxyUserPassword = gProxyUserPassword
    else
      rememberflag = 0
    end if
    clearGlobals()
    if rememberflag then
      gProxyMode = rememberProxyMode
      gProxyStr = rememberProxyString
      gPortStr = rememberPortString
      gProxyUserName = rememberProxyUserName
      gProxyUserPassword = rememberProxyUserPassword
    end if
    gCurScreen = "login"
    startMovie(1)
  end if
  clearFields([pUserNameMem, pPasswordMem])
  if oPrefsClass.pLocalPrefData.showLogin then
    member(pUserNameMem).text = oPrefsClass.pLocalPrefData.sScreenName
    pWord = oPrefsClass.pLocalPrefData.sPassword
    if pWord <> EMPTY then
      pWord = SearchAndReplace(pWord, "QUOTE", QUOTE)
      pWord = deEncode(pWord)
    end if
    sprite(pPassWordTextSpr).mFillInPassword(pWord)
    if gState = #dialogue then
      forceFieldFocus(40)
    else
      forceFieldFocus(pUserNameTextSpr)
    end if
  end if
  sendSprite(pShowLoginCheckSpr, #setBoxHiState, oPrefsClass.pLocalPrefData.showLogin)
  mCheckButtons(me)
end

on mCheckLogin me
  usernameEntered = member(pUserNameMem).text
  passwordEntered = sendSprite(pPassWordTextSpr, #mReturnPassword)
  if the number of chars in passwordEntered < 4 then
    mErrorAlert(me, #Password)
    abort()
  end if
  if the number of chars in usernameEntered < 1 then
    mErrorAlert(me, #userName)
    abort()
  end if
  gState = #checkServer
  cursor(kWatchCursor)
  mInitSession(me)
end

on mAssertProxy me
  if not stringp(gProxyStr) then
    exit
  end if
  if gProxyStr = EMPTY then
    exit
  end if
  if not stringp(gPortStr) then
    exit
  end if
  if gPortStr = EMPTY then
    exit
  end if
  portNum = value(gPortStr)
  if not integerp(portNum) then
    exit
  end if
  if portNum < 1 then
    exit
  end if
  case gProxyMode of
    #proxy:
      proxyServer(#http, gProxyStr, portNum)
    #authProxy:
      SetProxyNamePort()
      SetProxyUserNameAndPassword()
    otherwise:
      nothing()
  end case
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #L_newuser:
      go("register")
    #L_forgot:
      oDialogueClass.mDoDialogue(#forgotPword)
    #L_cancel:
      halt()
    #login:
      mCheckLogin(me)
  end case
end

on mSendPassWordEmail me, message
  gState = #checkServer
  cursor(kWatchCursor)
  pCurRequest = oRequestMgr.mForgotPassword(message, me, #interpretPwordResponse)
end

on interpretPwordResponse me
  gState = #Active
  cursor(-1)
  response = pCurRequest.iData
  myResult = pCurRequest.iResult
  errorType = pCurRequest.iErrorType
  case myResult of
    (-1):
      checkForServerErrors(errorType)
    0:
      case errorType of
        #error:
      end case
    1:
  end case
  pCurRequest = VOID
end

on mCheckEvent me
end

on interpretServerResponse me
  gState = #Active
  cursor(-1)
  response = pCurRequest.iData
  myResult = pCurRequest.iResult
  errorType = pCurRequest.iErrorType
  case myResult of
    (-1):
      checkForServerErrors(errorType)
    0:
      case errorType of
        #loginFailure:
          oDialogueClass.mDoDialogue(#loginFail)
        #sScreenName:
          oDialogueClass.mDoDialogue(#loginFail)
        #sPassword:
          oDialogueClass.mDoDialogue(#loginFail)
      end case
    1:
      mInitSession(me, response)
  end case
  pCurRequest = VOID
end

on mInitSession me, response
  usernameEntered = member(pUserNameMem).text
  passwordEntered = sendSprite(pPassWordTextSpr, #mReturnPassword)
  if usernameEntered <> oPrefsClass.pLocalPrefData.sScreenName then
    oPrefsClass.pLocalPrefData.sound = 0
    oPrefsClass.pLocalPrefData.autocheck = 1
  end if
  oPrefsClass.pLocalPrefData.showLogin = sprite(pShowLoginCheckSpr).pBoxHiState
  if sprite(pShowLoginCheckSpr).pBoxHiState then
    oPrefsClass.pLocalPrefData.sScreenName = usernameEntered
    encodedPassword = encode(passwordEntered)
    encodedPasswordNoQuotes = SearchAndReplace(encodedPassword, QUOTE, "QUOTE")
    oPrefsClass.pLocalPrefData.sPassword = encodedPasswordNoQuotes
  end if
  if gProxyMode = #proxy then
    if voidp(gProxyStr) then
      proxySetting = EMPTY
    else
      proxySetting = [#http, gProxyStr, value(gPortStr)]
    end if
    oPrefsClass.pLocalPrefData.proxy = proxySetting
  end if
  oPrefsClass.mSetLocalPref()
  kMyId = 17606
  cursor(kWatchCursor)
  soundMode = oPrefsClass.pLocalPrefData.sound
  if soundMode then
    if not voidp(oSoundMgr) then
      oSoundMgr.mMute()
    end if
  else
    if not soundMode then
      if not voidp(oSoundMgr) then
        oSoundMgr.mUnMute()
      end if
    end if
  end if
  oPrefsClass.mGetPref()
  if not voidp(kMyId) then
    oRequestMgr.mTimeSync(kMyId)
  end if
  oMeetings.mGetMeetings()
  gDoneWithInitialNet = 0
end

on mFininshLogin me
  gState = #Active
  cursor(-1)
  go(the frame - 1)
end

on mLeaveMyScreen me
end

on mCheckButtons me, buttonComing
  usernameEntered = member(pUserNameMem).text
  if buttonComing <> VOID then
    usernameEntered = "x"
  end if
  passwordEntered = sendSprite(pPassWordTextSpr, #mReturnPassword)
  if (usernameEntered = EMPTY) or (passwordEntered = EMPTY) then
    mDeactiveButtons([1])
  else
    mActivateButtons([1])
  end if
end

on mFieldCleaned me
  mCheckButtons(me)
end

on mFieldDirtied me, buttonComing
  mCheckButtons(me, buttonComing)
end

on mErrorAlert me, errorType
  oDialogueClass.mDoDialogue(#loginFail)
end
