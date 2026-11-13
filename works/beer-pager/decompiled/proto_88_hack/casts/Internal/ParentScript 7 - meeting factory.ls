property lActiveMeetings, lNewMeetings, pMeetingCount, pCurMtgIdToAlert, plTodaysAlreadyAlerted, pCurMessage, pCurCancelReqType, pCurCancelReq, pCurAcceptReq, pCurAcceptReqType, pCurGetMeetingReq, pNewMessages
global oPrefsClass, oDialogueClass, kDateObject, oCalendar2Class, kMyId, gState, oRequestMgr, gTimeStamp, gCurScreen, oTunerClass, oCalendarClass, gPingFreq, gPingTimer, kWatchCursor, oTuner2Class, oLoginClass, gDoneWithInitialNet

on new me
  lActiveMeetings = [:]
  lNewMeetings = [:]
  pCurMtgIdToAlert = 0
  plTodaysAlreadyAlerted = []
  return me
end

on mRemindMeetings me, curTime
  repeat with curMeeting in lActiveMeetings
    if (curMeeting.iDateObj - kDateObject) = 0 then
      if getPos(plTodaysAlreadyAlerted, curMeeting.iID) then
        next repeat
      end if
      if mGetTimeDiff(curMeeting.iWhen, curTime) <= 15 then
        pCurMtgIdToAlert = curMeeting.iID
        if screenType() = #dataScreen then
          mMeetingAlert(me)
          next repeat
        end if
        addToActorList(VOID, me)
        if gCurScreen = "main" then
          append(plTodaysAlreadyAlerted, pCurMtgIdToAlert)
          go("animshake")
        end if
      end if
    end if
  end repeat
end

on mMeetingAlert me
  removeFromActorList(VOID, me)
  if not getPos(plTodaysAlreadyAlerted, pCurMtgIdToAlert) then
    append(plTodaysAlreadyAlerted, pCurMtgIdToAlert)
  end if
  if oDialogueClass.mDoDialogue(#remindMeeting) then
    sprite(55).mDoTopNav()
    theMeeting = getaProp(lActiveMeetings, pCurMtgIdToAlert)
    if objectp(theMeeting) then
      oCalendar2Class.setMeetingIdxById(pCurMtgIdToAlert)
      pCurMtgIdToAlert = 0
      go("calendar2")
    end if
  end if
end

on stepFrame me
  if screenType() = #dataScreen then
    mMeetingAlert(me)
  end if
end

on addMeetingToList me, meetingData, whatList
  oMeeting = new(script("meeting"), meetingData)
  meetingID = symbol(string(oMeeting.iID))
  addProp(whatList, meetingID, oMeeting)
end

on mDeleteMeeting me, whichMeeting, whatList, message
  pCurCancelReq = oRequestMgr.mDeclineMeeting(whichMeeting, kMyId, message, me, #interpretCancelResponse)
  pCurCancelReqType = [whatList, whichMeeting]
  gState = #checkServer
  cursor(kWatchCursor)
end

on mAcceptMyMeeting me, whichMeeting, message
  pCurAcceptReq = oRequestMgr.mAcceptMeeting(whichMeeting, kMyId, message, me, #interpretAcceptResponse)
  pCurAcceptReqType = whichMeeting
  pCurMessage = message
  gState = #checkServer
  cursor(kWatchCursor)
end

on interpretAcceptResponse me
  gState = #Active
  cursor(-1)
  response = pCurAcceptReq.iData
  myResult = pCurAcceptReq.iResult
  errorType = pCurAcceptReq.iErrorType
  case myResult of
    (-1):
      checkForServerErrors(errorType)
    0:
      case errorType of
        #error:
      end case
    1:
      mtgId = symbol(pCurAcceptReqType)
      mtg = getProp(lNewMeetings, mtgId)
      repeat with curWho in mtg.iLWho
        if curWho.idUser = kMyId then
          curWho.yAttendStatus = #accepted
          curWho.sMessage = pCurMessage
        end if
        pCurMessage = " "
      end repeat
      addProp(lActiveMeetings, mtgId, mtg)
      deleteProp(lNewMeetings, mtgId)
      pCurAcceptReqType = 0
      if gCurScreen = "tuner2" then
        oTuner2Class.mDeleteMessage()
      end if
  end case
  pCurAcceptReq = VOID
end

on interpretCancelResponse me
  gState = #Active
  cursor(-1)
  response = pCurCancelReq.iData
  myResult = pCurCancelReq.iResult
  errorType = pCurCancelReq.iErrorType
  case myResult of
    (-1):
      checkForServerErrors(errorType)
    0:
      case errorType of
        #error:
      end case
    1:
      whatList = pCurCancelReqType[1]
      whichMeeting = pCurCancelReqType[2]
      pCurCancelReqType = 0
      if whatList = #Active then
        myList = lActiveMeetings
        oPrefsClass.mKillAllRefs(string(whichMeeting))
      else
        if whatList = #new then
          myList = lNewMeetings
        end if
      end if
      deleteProp(myList, whichMeeting)
      if gCurScreen = "tuner" then
        oTunerClass.mCleanUpAfterDelete()
      end if
      if gCurScreen = "tuner2" then
        oTuner2Class.mDeleteMessage()
      end if
      if gCurScreen = "calendar" then
        oCalendarClass.mInitMyScreen()
      end if
      if gCurScreen = "calendar2" then
        if count(lActiveMeetings) = 0 then
          oCalendar2Class.mDoMyMouseDown(#C2_back)
        else
          oCalendar2Class.mCheckButtons()
          oCalendar2Class.cycleMeetings(#next)
        end if
      end if
  end case
  pCurCancelReq = VOID
end

on mGetMeetings me, auto
  cursor(kWatchCursor)
  response = [#meetingData: [[#idMeeting: "4274", #dWhenDate: "1/30/2000", #dWhenTime: "1:42:AM", #sWhereName: "26 Mix", #sWhereAddress: "Deep Mission", #yWhy: #millerTime, #sMessage: "What up!", #lWho: [[#idUser: 17606, #sUserName: "Muskrat", #yAttendStatus: #accepted, #sMessage: "What up!", #yCreator: "1", #timeStamp: 949083206], [#idUser: 237, #sUserName: "Adam", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949083206], [#idUser: 45, #sUserName: "BILL", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949083206], [#idUser: 10, #sUserName: "jillB", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949083206]], #timeStamp: 949083206], [#idMeeting: "4306", #dWhenDate: "2/9/2000", #dWhenTime: "11:59:PM", #sWhereName: "Yancys Saloon", #sWhereAddress: "Irving Street", #yWhy: #millerTime, #sMessage: "Yeah, yeah, yeah!", #lWho: [[#idUser: 784, #sUserName: "SunBunny", #yAttendStatus: #accepted, #sMessage: "Yeah, yeah, yeah!", #yCreator: "1", #timeStamp: 949089832], [#idUser: 237, #sUserName: "Adam", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089832], [#idUser: 10, #sUserName: "jillB", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089832], [#idUser: 17606, #sUserName: "Muskrat", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089832], [#idUser: 193, #sUserName: "tfowl", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089832]], #timeStamp: 949089832], [#idMeeting: "4304", #dWhenDate: "2/10/2000", #dWhenTime: "1:59:PM", #sWhereName: "Yancys Saloon", #sWhereAddress: "Irving Street", #yWhy: #afterWork, #sMessage: "Time to get our drink on!", #lWho: [[#idUser: 784, #sUserName: "SunBunny", #yAttendStatus: #accepted, #sMessage: "Time to get our drink on!", #yCreator: "1", #timeStamp: 949089727], [#idUser: 237, #sUserName: "Adam", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089727], [#idUser: 10, #sUserName: "jillB", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089727], [#idUser: 17606, #sUserName: "Muskrat", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089727], [#idUser: 193, #sUserName: "tfowl", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089727]], #timeStamp: 949089727], [#idMeeting: "4317", #dWhenDate: "2/10/2000", #dWhenTime: "2:59:PM", #sWhereName: "Grumpys", #sWhereAddress: "212 Vallejo", #yWhy: #whyNot, #sMessage: "Hey hey Kids. Hoo hoo he haa ha ha!", #lWho: [[#idUser: 17606, #sUserName: "Muskrat", #yAttendStatus: #accepted, #sMessage: "Hey hey Kids. Hoo hoo he haa ha ha!", #yCreator: "1", #timeStamp: 949091455], [#idUser: 237, #sUserName: "Adam", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949091455], [#idUser: 45, #sUserName: "BILL", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949091455], [#idUser: 10, #sUserName: "jillB", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949091455], [#idUser: 784, #sUserName: "SunBunny", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949091455], [#idUser: 193, #sUserName: "tfowl", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949091455]], #timeStamp: 949091455], [#idMeeting: "4302", #dWhenDate: "2/10/2000", #dWhenTime: "3:29:PM", #sWhereName: "The Office", #sWhereAddress: "921 Front Stree", #yWhy: #millerTime, #sMessage: "S U P E R B O W L this is gonna be so awesome!", #lWho: [[#idUser: 784, #sUserName: "SunBunny", #yAttendStatus: #accepted, #sMessage: "S U P E R B O W L this is gonna be so awesome!", #yCreator: "1", #timeStamp: 949089682], [#idUser: 237, #sUserName: "Adam", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089682], [#idUser: 10, #sUserName: "jillB", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089682], [#idUser: 17606, #sUserName: "Muskrat", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089682], [#idUser: 193, #sUserName: "tfowl", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089682]], #timeStamp: 949089682], [#idMeeting: "4305", #dWhenDate: "2/10/2000", #dWhenTime: "9:59:PM", #sWhereName: "Yancys Saloon", #sWhereAddress: "Irving Street", #yWhy: #theGame, #sMessage: "F O O T B A L  L !", #lWho: [[#idUser: 784, #sUserName: "SunBunny", #yAttendStatus: #accepted, #sMessage: "F O O T B A L  L !", #yCreator: "1", #timeStamp: 949089799], [#idUser: 237, #sUserName: "Adam", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089799], [#idUser: 10, #sUserName: "jillB", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089799], [#idUser: 17606, #sUserName: "Muskrat", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089799], [#idUser: 193, #sUserName: "tfowl", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 949089799]], #timeStamp: 949089799]], #timeStamp: 949091472, #pingfrequency: 120, #messagefrommiller: "none", #messageFromMillerTimeStamp: 0]
  mConvertMeetingData(me, response)
  if gDoneWithInitialNet = 0 then
    gDoneWithInitialNet = 1
  end if
end

on interpretServerResponse me
  gState = #Active
  cursor(-1)
  response = pCurGetMeetingReq.iData
  myResult = pCurGetMeetingReq.iResult
  errorType = pCurGetMeetingReq.iErrorType
  case myResult of
    (-1):
      checkForServerErrors(errorType)
    0:
      case errorType of
        #error:
      end case
    1:
      mConvertMeetingData(me, response)
  end case
  pCurGetMeetingReq = VOID
  if gDoneWithInitialNet = 0 then
    gDoneWithInitialNet = 1
  end if
end

on mConvertMeetingData me, response
  meetingData = response.meetingData
  gPingFreq = response.pingfrequency
  gPingTimer = the timer + (60 * gPingFreq)
  MillerMessage = response.messagefrommiller
  millerMessageTS = response.messageFromMillerTimeStamp
  lActiveMeetings = [:]
  lNewMeetings = [:]
  repeat with curMeeting in meetingData
    whoList = curMeeting.lWho
    repeat with curWho in whoList
      if curWho.idUser = kMyId then
        if curWho.yAttendStatus = #accepted then
          addMeetingToList(me, curMeeting, lActiveMeetings)
        else
          if curWho.yAttendStatus = #unknown then
            addMeetingToList(me, curMeeting, lNewMeetings)
            if curMeeting.timeStamp > gTimeStamp then
              newMessageFlag = 1
            end if
          end if
        end if
        next repeat
      end if
      next repeat
    end repeat
  end repeat
  repeat with curMeeting in lActiveMeetings
    whoList = curMeeting.iLWho
    repeat with curWho in whoList
      if curWho.yAttendStatus <> #unknown then
        if curWho.idUser = kMyId then
          next repeat
        end if
        if (curWho.yCreator = "1") and (curWho.yAttendStatus = #accepted) then
          next repeat
        end if
        if curWho.timeStamp > gTimeStamp then
          newMessageFlag = 1
          addProp(curWho, #iID, curMeeting.iID)
          append(oPrefsClass.pInBoxData, curWho)
        end if
      end if
    end repeat
  end repeat
  if stringp(MillerMessage) then
    if trimSpaces(MillerMessage) <> EMPTY then
      if millerMessageTS > gTimeStamp then
        newMessageFlag = 1
        mm = [#idUser: -1, #sUserName: "Miller Brewing", #yAttendStatus: #Miller, #sMessage: EMPTY, #yCreator: "0", #timeStamp: 0, #iID: EMPTY]
        mm.sMessage = MillerMessage
        append(oPrefsClass.pInBoxData, mm)
      end if
    end if
  end if
  gTimeStamp = value(response.timeStamp)
  if newMessageFlag then
    oPrefsClass.saveListData(#inBox)
  end if
  case gCurScreen of
    "login":
      oLoginClass.mFininshLogin()
    "tuner":
      oTunerClass.mListMessages()
      oTunerClass.mCheckButtons()
    "calendar":
      oCalendarClass.mInitMyScreen()
  end case
  case gCurScreen of
    "help", "prefs", "main", "calendar", "calendar2", "friends", "places":
      sprite(61).checkMessageLite()
  end case
  if newMessageFlag then
    newMessageFlag = 0
    mNewMessages(me)
  end if
end

on mNewMessages
  playSound(#newMessage)
  if gCurScreen contains "tuner" then
    exit
  end if
  pNewMessages = 1
  if screenType() = #dataScreen then
    sprite(61).mStartBlinking()
  end if
  if gCurScreen = "main" then
    sprite(61).mStartBlinking()
    go("animshake")
  end if
end
