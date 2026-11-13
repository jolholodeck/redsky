global oFriendsClass, oDialogueClass, klScreenButtonBank, gCurScreen, oMeetings, gAdjTime, gProxyStr, gPortStr

on sniffProxy
  proxyCall = EMPTY
  null1 = EMPTY
  null2 = EMPTY
  buffer = EMPTY
  proxyMgr = new(xtra("glu32"))
  GLURegister("R100-71-73810374")
  err = GLUNew(proxyMgr, "GetProxy.dll", "GetProxyAddress", "I", "@S", 0, 0)
  proxyCall = GLUCall(proxyMgr, buffer)
  proxyCallError = GLUGetLastError(proxyMgr)
  proxyResult = GLUGetResults(proxyMgr)[1]
  if proxyResult <> EMPTY then
    oldDelim = the itemDelimiter
    the itemDelimiter = ":"
    gProxyStr = proxyResult.item[1]
    gPortStr = proxyResult.item[2]
    the itemDelimiter = oldDelim
  end if
end

on adjustTextForPC
  case gCurScreen of
    "invite2":
      sprite(37).loc = point(155, 100)
    "register":
      sprite(3).loc = point(132, 65)
      sprite(4).loc = point(132, 82)
      sprite(5).loc = point(129, 100)
      sprite(6).loc = point(157, 100)
      sprite(7).loc = point(157, 100)
    "prefs":
      sprite(34).loc = point(127, 102)
    "login":
      sprite(30).loc = point(131, 100)
      sprite(31).loc = point(131, 82)
  end case
end

on checkForServerErrors errorType
  case errorType of
    #noConnection:
      if gCurScreen contains "invite" then
        oDialogueClass.mDoDialogue(#noNetworkCI)
      else
        oDialogueClass.mDoDialogue(#noNetwork)
      end if
    #timeout, #serverBusy, #NetLingo:
      if gCurScreen contains "invite" then
        oDialogueClass.mDoDialogue(#serverBusyCI)
      else
        oDialogueClass.mDoDialogue(#serverBusy)
      end if
    otherwise:
      put errorType
      nothing()
  end case
end

on testy
  repeat with i = 1 to 100
    oDialogueClass.mConstruct()
    updateStage()
    oDialogueClass.mDoMouseDown(1)
    updateStage()
  end repeat
  put "done"
  X = [#settings: [#sound: 1, #autocheck: 1, #showLogin: 0, #id: 13, #sFirstName: "dfgd", #sLastName: "dgfdfg", #sDOB: "1/1/1", #sZipCode: "94122", #sEmail: "mario@redsky.com", #sScreenName: "mario", #sPassword: "1111", #sOptIn: "y", #sConnectSpeed: "56k", #sGender: "M"], #friends: [[#name: "bob", #id: 23, #email: "bob@redsky.com", #notes: "Type general notes here"], [#name: "greg", #id: 22, #email: "greg@redsky.com", #notes: "Type general notes here"], [#name: "papakane", #id: 24, #email: "adam@redsky.com", #notes: "Type general notes here"], [#name: "jill", #id: 25, #email: "jill@redsky.com", #notes: "Type general notes here"]], #places: [[#name: "aaaa", #where: "next to Red sky", #notes: "Type general notes here."], [#name: "ffff", #where: "next to Red sky", #notes: "Type general notes here."], [#name: "gjkfgj", #where: "next to Red sky", #notes: "Type general notes here."], [#name: "hhh", #where: "next to Red sky", #notes: "Type general notes here."], [#name: "hhhh", #where: "next to Red sky", #notes: "Type general notes here."], [#name: "iiii", #where: "next to Red sky", #notes: "Type general notes here."], [#name: "jjj", #where: "next to Red sky", #notes: "Type general notes here."], [#name: "Red Sky", #where: "next to Red sky", #notes: "Type general notes here."], [#name: "zzzz", #where: "next to Red sky", #notes: "Type general notes here."], [#name: "hhhhh", #where: "next to Red sky", #notes: "Type general notes here."]], #inBox: [[#idUser: 22, #sUserName: "greg", #yAttendStatus: "y", #sMessage: EMPTY, #yCreator: "0", #timeStamp: 941915399, #iID: "28", #dirty: 0], [#idUser: 22, #sUserName: "greg", #yAttendStatus: "y", #sMessage: EMPTY, #yCreator: "0", #timeStamp: 941915869, #iID: "32", #dirty: 0]]]
end

on sortPList propList, propToSortBy, changeOrig
  cnt = count(propList)
  tempList = [:]
  repeat with X = 1 to cnt
    subList = getAt(propList, X)
    addProp(tempList, getProp(subList, propToSortBy), X)
  end repeat
  sort(tempList)
  resultList = []
  repeat with recordNum in tempList
    add(resultList, getAt(propList, recordNum))
  end repeat
  if changeOrig <> VOID then
    propList = resultList
  else
    return resultList
  end if
end

on screenType
  if getPos(["tuner", "tuner2", "calendar", "calendar2", "prefs", "help", "friends", "places"], gCurScreen) then
    return #dataScreen
  else
    if getPos(["invite", "invite2", "invite3"], gCurScreen) then
      return #invite
    else
      if gCurScreen = "main" then
        return #main
      end if
    end if
  end if
end

on resp thisWay
  doStr = "o" & gCurScreen & "Class.interpretServerResponse(" & string(thisWay) & ")"
  do(doStr)
end

on yearTrim myDate
  oldDelim = the itemDelimiter
  the itemDelimiter = "/"
  delete myDate.item[3]
  the itemDelimiter = oldDelim
  return myDate
end

on militaryToCivilianTime milTime
  oldDelim = the itemDelimiter
  the itemDelimiter = ":"
  newTime = milTime
  h = milTime.item[1]
  if char 1 of h = "0" then
    delete char 1 of h
  end if
  if h > 12 then
    h = integer(h - 12)
    AMPM = "PM"
  else
    AMPM = "AM"
  end if
  put AMPM into item 3 of newTime
  put h into item 1 of newTime
  the itemDelimiter = oldDelim
  return newTime
end

on timeMyWay
  timeLikeILikesIt = gAdjTime
  numChars = the number of chars in timeLikeILikesIt - 2
  put ":" into char numChars of timeLikeILikesIt
  return timeLikeILikesIt
end

on mGetTimeDiff time1, time2
  oldDelim = the itemDelimiter
  the itemDelimiter = ":"
  minsDiff = abs(mTimetoMins(time1) - mTimetoMins(time2))
  h = string(minsDiff / 60)
  M = string(minsDiff mod 60)
  the itemDelimiter = oldDelim
  return minsDiff
end

on addToCurTime curTime, mins
  curTimeInMins = mTimetoMins(curTime)
  newTimeInMins = curTimeInMins + mins
  if newTimeInMins > 1439 then
    newTimeInMins = 1439
  end if
  newTime = minsToTime(newTimeInMins)
  return newTime
end

on minsToTime mins
  h = mins / 60
  if h > 12 then
    AMPM = "PM"
    h = h - 12
  else
    AMPM = "AM"
  end if
  if h = 0 then
    h = 12
  end if
  M = mins mod 60
  if M = 0 then
    M = "00"
  else
    if M < 10 then
      M = "0" & M
    end if
  end if
  myTime = h & ":" & M & ":" & AMPM
  return myTime
end

on mTimetoMins myTime
  oldDelim = the itemDelimiter
  the itemDelimiter = ":"
  h = value(myTime.item[1])
  M = value(myTime.item[2])
  p = myTime.item[3] = "PM"
  if p then
    h = h + 12
  else
    if h = 12 then
      h = 0
    end if
  end if
  mins = (h * 60) + M
  the itemDelimiter = oldDelim
  return mins
end

on mGetMaxDayNum curMonthNum, curYearNum
  case curMonthNum of
    1, 3, 5, 7, 8, 10, 12:
      maxDayNum = 31
    4, 6, 9, 11:
      maxDayNum = 30
    2:
      if (curYearNum mod 4) = 0 then
        maxDayNum = 29
      else
        maxDayNum = 28
      end if
  end case
  return maxDayNum
end

on renameMembers
  idx = 1
  repeat with memNum = 1825 to 1855
    member(memNum).name = "calendar_B_" & string(idx)
    idx = idx + 1
  end repeat
end

on constructScroll scrollData
  repeat with curSpr in scrollData
    sprite(curSpr).loc = point(150, 150)
  end repeat
end

on deConstructScroll scrollData
  repeat with curSpr in scrollData
    sprite(curSpr).loc = point(-100, -100)
  end repeat
end

on mDeactiveButtons whichButtons
  repeat with buttonNum in whichButtons
    buttonSpr = getAt(klScreenButtonBank, buttonNum)
    sendSprite(buttonSpr, #mDeActivate)
  end repeat
end

on mActivateButtons whichButtons
  repeat with buttonNum in whichButtons
    buttonSpr = getAt(klScreenButtonBank, buttonNum)
    sendSprite(buttonSpr, #mActivate)
  end repeat
end

on respond How
  oFriendsClass.interpretServerResponse(How)
end

on SearchAndReplace input, stringToFind, stringToInsert
  output = EMPTY
  findLen = length(stringToFind) - 1
  repeat while input contains stringToFind
    currOffset = offset(stringToFind, input)
    output = output & char 1 to currOffset of input
    delete char -30000 of output
    output = output & stringToInsert
    delete char 1 to (currOffset + findLen) of input
  end repeat
  output = output & input
  return output
end

on showNew me
  mShowProps(oMeetings.lActiveMeetings[1])
end

on mShowProps obj
  repeat with propNum = 1 to count(obj)
    propName = getPropAt(obj, propNum)
    propVal = getProp(obj, propName)
    propText = propName & " : " & propVal
    put propText
  end repeat
end

on waitForTimer myTicks, condition
  waitTime = the timer + myTicks
  repeat while the timer < waitTime
    case condition of
      #mouseUp:
        if the mouseUp then
          exit repeat
        end if
      otherwise:
    end case
  end repeat
end

on addToActorList dummy, object
  if not objectp(object) then
    alert("Not an objects" && object)
    exit
  end if
  if getPos(the actorList, object) = 0 then
    add(the actorList, object)
  end if
end

on removeFromActorList dummy, object
  offset = getPos(the actorList, object)
  if offset then
    deleteAt(the actorList, offset)
  end if
end
