property pMoreInfoCheck, pPrefsTemplateMem, pConnectCheck1, pConnectCheck2, pConnectCheck3, pConnectCheck4, pGenderCheck1, pGenderCheck2, pCurRegReq
global gNavMenu, oPrefsClass, oRequestMgr, oregisterClass, oDialogueClass, gState, kDateObject, kMyId, kWatchCursor

on new me
  pMoreInfoCheck = 13
  pConnectCheck1 = 14
  pConnectCheck2 = 15
  pConnectCheck3 = 16
  pConnectCheck4 = 17
  pGenderCheck1 = 18
  pGenderCheck2 = 19
  pPrefsTemplateMem = "prefs template"
  return me
end

on mInitMyScreen me
  sendSprite(pMoreInfoCheck, #setBoxHiState, 1)
  connectIdx = getPos(["28.8", "33.6", "56k", "T1"], oregisterClass.plRegData.sConnectSpeed)
  sendSprite(pConnectCheck1, #mSelectByIdx, connectIdx)
  if oregisterClass.plRegData.sGender <> "none" then
    sendSprite(pGenderCheck1, #mSelectByIdx, (oregisterClass.plRegData.sGender = #f) + 1)
  end if
end

on mPostRegData me
  optState = sprite(pMoreInfoCheck).pBoxHiState
  if optState then
    optin = "y"
  else
    optin = "n"
  end if
  oregisterClass.plRegData.sOptIn = optin
  oregisterClass.plRegData.sGender = string(oregisterClass.plRegData.sGender)
  pCurRegReq = oRequestMgr.mRegisterUser(oregisterClass.plRegData, me, #interpretServerResponse)
  gState = #checkServer
  cursor(kWatchCursor)
end

on interpretServerResponse me, simRespnonse
  gState = #Active
  cursor(-1)
  response = pCurRegReq.iData
  myResult = pCurRegReq.iResult
  errorType = pCurRegReq.iErrorType
  case myResult of
    (-1):
      checkForServerErrors(errorType)
    0:
      case errorType of
        #sScreenName:
          oDialogueClass.mDoDialogue(#userNameTaken)
          go("register")
        #alreadyRegistered:
          oDialogueClass.mDoDialogue(#alreadyReg)
          go("main")
        #sZipCode:
          oDialogueClass.mDoDialogue(#sZipCode)
          go("register")
        #sEmail:
          oDialogueClass.mDoDialogue(#alreadyReg)
          go("register")
      end case
    1:
      plRegData = VOID
      oregisterClass.plRegData.id = response.id
      kMyId = response.id
      oPrefsClass.mSetPref()
      mCompleteReg(me)
  end case
  pCurRegReq = VOID
end

on stepFrame me
  if oPrefsClass.mTestPrefs() then
    mCompleteReg(me)
  end if
end

on mCompleteReg me
  removeFromActorList(VOID, me)
  startMovie()
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #R_register:
      if mCheckAge(me) then
        mPostRegData(me)
      else
        oDialogueClass.mDoDialogue(#not21)
        halt()
      end if
    #R_cancel:
      oregisterClass.plRegData = VOID
      go("login")
    #R2_prev:
      go("register")
  end case
end

on mCheckEvent me
end

on mCheckAge me
  oldDelim = the itemDelimiter
  the itemDelimiter = "/"
  theirYear = oregisterClass.plRegData.sDOB.item[3]
  theirMonth = oregisterClass.plRegData.sDOB.item[1]
  theirDay = oregisterClass.plRegData.sDOB.item[2]
  the itemDelimiter = oldDelim
  theirYear = integer(theirYear + 1900)
  theirMonth = integer(theirMonth)
  theirDay = integer(theirDay)
  birthday = date(theirYear, theirMonth, theirDay)
  yearDiff = kDateObject.year - birthday.year
  if yearDiff < 21 then
    return 0
  else
    if yearDiff > 21 then
      return 1
    end if
  end if
  monthDiff = kDateObject.month - birthday.month
  if monthDiff < 0 then
    return 0
  else
    if monthDiff > 0 then
      return 1
    end if
  end if
  dayDiff = kDateObject.day - birthday.day
  if dayDiff < 0 then
    return 0
  else
    if dayDiff > 0 then
      return 1
    end if
  end if
  return 1
end

on mFieldCleaned me
  mDeactiveButtons([1])
end

on mFieldDirtied me
  mActivateButtons([1])
end

on mLeaveMyScreen me
end

on mErrorAlert me, errorType, special
  case errorType of
  end case
end
