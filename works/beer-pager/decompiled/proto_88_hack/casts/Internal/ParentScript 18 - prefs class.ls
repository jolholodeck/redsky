property ancestor, pBuddyData, pPlacesData, pSettingsData, pMeetingData, pNewMeetingData, pInBoxData, pBuddyLineNum, pPlacesLineNum, pPrefsLineNum, pMeetingLineNum, pNewMeetingLineNum, pPrefsFileName, pPrefs, pNewUser, pRealPrefsFileName, pAutoSpr, pShowLoginSpr, pMuteSpr, pRealNameMem, pUserNameMem, pEmailMem, pZipCodeMem, pPasswordMem, pPassword2Mem, pPassWordSpr, pPassWord2Spr, pLocalPrefData, pCurGetPrefReq, pCurSetPrefReq
global kDateObject, oDialogueClass, oRequestMgr, kMyId, oregisterClass, gTimeStamp, gCurScreen, oMeetings, oSoundMgr, gProxyStr, gPortStr, gAdjTime, kWatchCursor, gProxyMode

on new me
  pInBoxData = []
  pPrefsFileName = "prefs.txt"
  pRealPrefsFileName = "prefs.txt"
  pBuddyLineNum = 10
  pPlacesLineNum = 15
  pPrefsLineNum = 5
  pMeetingLineNum = 20
  pNewMeetingLineNum = 25
  pAutoSpr = 11
  pMuteSpr = 15
  pUserNameMem = "in_S_username"
  pEmailMem = "in_S_email"
  pZipCodeMem = "in_S_zipcode"
  pPasswordMem = "in_S_password"
  pPassword2Mem = "in_S_password2"
  pPassWordSpr = 30
  pPassWord2Spr = 31
  ancestor = new(script("Root"))
  if mTestPrefs(me) then
    pLocalPrefData = mGetLocalPref(me)
  else
    pLocalPrefData = [#sound: 0, #autocheck: 1, #showLogin: 1, #sScreenName: EMPTY, #sPassword: EMPTY, #proxy: EMPTY]
  end if
  if voidp(gProxyStr) or (gProxyStr = EMPTY) then
    if pLocalPrefData.proxy <> EMPTY then
      gProxyStr = pLocalPrefData.proxy[2]
      gPortStr = pLocalPrefData.proxy[3]
      gProxyMode = #proxy
    end if
  end if
  return me
end

on mKillAllRefs me, mtgId
  newList = []
  repeat with curItem in pInBoxData
    if curItem.iID <> mtgId then
      append(newList, curItem)
    end if
  end repeat
  pInBoxData = newList
  sprite(61).checkMessageLite()
  saveListData(me, #inBox)
end

on cleanInBox me
  checkListOfMtgIds = []
  repeat with curMtg in oMeetings.lActiveMeetings
    ActiveMtgId = curMtg.iID
    if not getPos(checkListOfMtgIds, ActiveMtgId) then
      append(checkListOfMtgIds, ActiveMtgId)
    end if
  end repeat
  repeat with curMessage in pInBoxData
    id = curMessage.iID
    if id = EMPTY then
      exit
    end if
    if not getPos(checkListOfMtgIds, id) then
      mKillAllRefs(me, id)
    end if
  end repeat
end

on mInitMyScreen me
  sendSprite(pAutoSpr, #setBoxHiState, getProp(pLocalPrefData, #autocheck))
  sendSprite(pMuteSpr, #setBoxHiState, getProp(pLocalPrefData, #sound))
  clearFields([pUserNameMem, pEmailMem, pZipCodeMem, pPasswordMem, pPassword2Mem])
  member(pUserNameMem).text = getProp(pSettingsData, #sScreenName)
  member(pEmailMem).text = getProp(pSettingsData, #sEmail)
  member(pZipCodeMem).text = getProp(pSettingsData, #sZipCode)
  member(pPasswordMem).text = EMPTY
  member(pZipCodeMem).editable = 1
  member(pPasswordMem).editable = 1
  mDeactiveButtons([1, 2])
end

on saveSettings me
  passWord1 = sendSprite(pPassWordSpr, #mReturnPassword)
  passWord2 = sendSprite(pPassWord2Spr, #mReturnPassword)
  if not ((passWord1 = EMPTY) and (passWord2 = EMPTY)) then
    if the number of chars in passWord1 < 4 then
      mErrorAlert(me, #Password)
      abort()
    end if
    if passWord1 <> passWord2 then
      mErrorAlert(me, #passWordReg)
      abort()
    end if
    setProp(pSettingsData, #sPassword, passWord1)
  end if
  setProp(pSettingsData, #sEmail, member(pEmailMem).text)
  setProp(pSettingsData, #sZipCode, member(pZipCodeMem).text)
  cursor(kWatchCursor)
  mSetPref(me)
  gState = #checkServer
end

on mSetLocalPref me, whatPref, whatValue
  saveString = "-- Preferences file for Miller Lite Beer Mailer" & RETURN & "-- Last saved:" & getLongDate(kDateObject) && gAdjTime & RETURN & string(pLocalPrefData)
  SetPref(pRealPrefsFileName, saveString)
end

on mGetLocalPref me
  prefString = getPref(pRealPrefsFileName)
  return value(prefString.line[3])
end

on saveListData me, whichOne
  case whichOne of
    #friends:
      lineNum = pBuddyLineNum
      whatData = pBuddyData
    #places:
      lineNum = pPlacesLineNum
      whatData = pPlacesData
    #settings:
      lineNum = pPrefsLineNum
      whatData = pSettingsData
    #inBox:
      lineNum = pPrefsLineNum
      whatData = pInBoxData
    #Active:
      lineNum = pMeetingLineNum
      whatData = pMeetingData
    #new:
      lineNum = pNewMeetingLineNum
      whatData = pNewMeetingData
  end case
  setProp(pPrefs, whichOne, whatData)
  mSetPref(me)
end

on initPrefs me
  pBuddyData = value(pPrefs.friends)
  pPlacesData = value(pPrefs.places)
  pSettingsData = value(pPrefs.settings)
  pInBoxData = value(pPrefs.inBox)
end

on mTestPrefs me
  if voidp(getPref(pRealPrefsFileName)) then
    prefsThere = 0
  else
    prefsThere = 1
  end if
  return prefsThere
end

on mSetPref me
  return 
  if oregisterClass.plRegData <> VOID then
    messagetext = "Welcome to the Miller Lite Beer Pager." & RETURN & RETURN & "The Beer Pager's interface is fairly self-explanatory, and you can click on the help button at any time for details on how to use a feature." & RETURN & RETURN & "Note that before you can plan your own Miller Times, you need to add a few friends and hang outs to your list." & RETURN & RETURN & "Thanks for using the Miller Lite Beer Pager. Have fun!"
    welcomeMessage = [#idUser: -1, #sUserName: "Miller Lite", #yAttendStatus: #Miller, #sMessage: messagetext, #yCreator: "0", #timeStamp: 0, #iID: EMPTY]
    pCurSetPrefReq = oRequestMgr.mSavePrefs(kMyId, [#settings: oregisterClass.plRegData, #friends: [], #places: [], #inBox: [welcomeMessage]], oregisterClass.plRegData.sPassword, oregisterClass.plRegData.sZipCode, me, #interpretSetPrefResponse)
    if not voidp(kMyId) then
      oRequestMgr.mTimeSync(kMyId)
    end if
  else
    pCurSetPrefReq = oRequestMgr.mSavePrefs(kMyId, pPrefs, pSettingsData.sPassword, pSettingsData.sZipCode, me, #interpretSetPrefResponse)
    if not voidp(kMyId) then
      oRequestMgr.mTimeSync(kMyId)
    end if
  end if
  gState = #checkServer
end

on interpretSetPrefResponse me
  gState = #Active
  if pCurSetPrefReq = VOID then
    exit
  end if
  response = pCurSetPrefReq.iData
  myResult = pCurSetPrefReq.iResult
  errorType = pCurSetPrefReq.iErrorType
  cursor(-1)
  case myResult of
    (-1):
      checkForServerErrors(errorType)
    0:
      case errorType of
        #sZipCode:
          oDialogueClass.mDoDialogue(#sZipCode)
      end case
    1:
      if gCurScreen = "prefs" then
        mCleanFields(me)
        repeat with sprNum = 30 to 34
          sendSprite(sprNum, #mCleanField)
        end repeat
        sendSprite(11, #mCleanField)
        sendSprite(13, #mCleanField)
        sendSprite(15, #mCleanField)
        clearFields([pPasswordMem, pPassword2Mem])
        if not voidp(kMyId) then
          oRequestMgr.mTimeSync(kMyId)
        end if
      end if
  end case
  pCurSetPrefReq = VOID
end

on mCheckEvent me
  if sprite(pMuteSpr).pBoxHiState then
    if not voidp(oSoundMgr) then
      oSoundMgr.mMute()
    end if
  else
    if not sprite(pMuteSpr).pBoxHiState then
      if not voidp(oSoundMgr) then
        oSoundMgr.mUnMute()
      end if
    end if
  end if
  pLocalPrefData.autocheck = sprite(pAutoSpr).pBoxHiState
  pLocalPrefData.sound = sprite(pMuteSpr).pBoxHiState
  mSetLocalPref(me)
end

on mGetPref me
  pPrefs = [#settings: [#sound: 1, #autocheck: 1, #showLogin: 0, #id: 17606, #sFirstName: "John", #sLastName: "Doe", #sDOB: "3/19/73", #sZipCode: "94111", #sEmail: "johnny@redsky.com", #sScreenName: "Muskrat", #sPassword: "redsky", #sOptIn: "y", #sConnectSpeed: "T1", #sGender: "M"], #friends: [[#name: "Adam", #id: 237, #email: "adam@redsky.com", #notes: "555-1212          Blah, blah, blah."], [#name: "BILL", #id: 45, #email: "bbrock@redsky.com", #notes: "Don't forget to pay him back for Knicks tickets."], [#name: "jillB", #id: 10, #email: "jillb@redsky.com", #notes: "Blah, blah blah"], [#name: "SunBunny", #id: 784, #email: "jmuscat@redsky.com", #notes: EMPTY], [#name: "tfowl", #id: 193, #email: "tfowl@thegrid.net", #notes: EMPTY]], #places: [[#name: "26 Mix", #where: "Deep Mission", #notes: "Open Mic night Wednesdays"], [#name: "Grumpys", #where: "212 Vallejo", #notes: EMPTY], [#name: "My House", #where: "1379 7th Avenue", #notes: "Yo!"], [#name: "The Mad Dog", #where: "lower Haight", #notes: "Awesome fish and chips."]], #inBox: [[#idUser: -1, #sUserName: "Miller Lite", #yAttendStatus: #Miller, #sMessage: "Welcome to the Miller Lite Beer Pager. The Beer Pager's interface is fairly self-explanatory, and you can click on the help button at any time for details on how to use a feature. Note that before you can plan your own Miller Times, you need to add a few friends and hang outs to your list. Thanks for using the Miller Lite Beer Pager. Have fun!", #yCreator: "0", #timeStamp: 0, #iID: EMPTY], [#idUser: -1, #sUserName: "Miller Brewing", #yAttendStatus: #Miller, #sMessage: "Greetings! Just a note to let you know we have completed a newer, more imporved Miller Lite Beer Pager. You can get Version 1.01 at www.millerlite.com. Thanks for using the Beer Pager!  -Your friends at Miller Brewing", #yCreator: "0", #timeStamp: 0, #iID: EMPTY], [#idUser: 784, #sUserName: "SunBunny", #yAttendStatus: #accepted, #sMessage: "test 1", #yCreator: "0", #timeStamp: 949004174, #iID: "4148"]]]
  gTimeStamp = 949008382
  initPrefs(me)
end

on interpretGetPrefResponse me
  gState = #Active
  response = pCurGetPrefReq.iData
  myResult = pCurGetPrefReq.iResult
  errorType = pCurGetPrefReq.iErrorType
  case myResult of
    (-1):
      checkForServerErrors(errorType)
    0:
      case errorType of
        #sZipCode:
          oDialogueClass.mDoDialogue(#sZipCode)
      end case
    1:
      pPrefs = response.sPrefs
      gTimeStamp = value(response.timeStamp)
      initPrefs(me)
  end case
  pCurGetPrefReq = VOID
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #S_cancel:
      mCleanFields(me)
      mInitMyScreen(me)
    #S_save:
      saveSettings(me)
  end case
end

on mCleanFields me
  sprite(pPassWordSpr).mSetPassword(EMPTY)
  sprite(pPassWord2Spr).mSetPassword(EMPTY)
  sprite(pPassWordSpr).mCleanField()
  sprite(pPassWord2Spr).mCleanField()
  sprite(34).mCleanField()
end

on mLeaveMyScreen me
end

on mCheckButtons me
end

on mFieldCleaned me
  mDeactiveButtons([1, 2])
end

on mFieldDirtied me
  mActivateButtons([1, 2])
end

on mErrorAlert me, errorType
  oDialogueClass.mDoDialogue(errorType)
end
