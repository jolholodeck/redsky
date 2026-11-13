global gMetronome, gState, gCurHiLine, gCurNotes, gNavMenuHiSpr, gCurScreen, kNetLiteSpr, klScreenButtonBank, kPlatform, klRadioButts, kDateObject, kKey, kMyId, kWatchCursor, gProxyStr, gPortStr, gProxyMode, gProxyUserName, gProxyUserPassword, gMetronomeTimer, gTimeCheckTmr, gPingTimer, gPingFreq, oMeetingFac, glMtgs, oMeetings, oCurMeeting, oPrefsClass, oLoginClass, oMainClass, ohelpClass, oTunerClass, oTuner2Class, oCalendarClass, oCalendar2Class, oInviteClass, oInvite2Class, oInvite3Class, oFriendsClass, oPlacesClass, oregisterClass, oregister2Class, oClockClass, oDialogueClass, kDialogSprs, oRequestMgr, oXmlParser, oConnectoScope, gAdjTime, oSoundMgr, gDoneWithInitialNet

on prepareMovie
  clearGlobals()
  gDoneWithInitialNet = 0
  castLib(1).preLoadMode = 1
  castLib(2).preLoadMode = 1
  castLib(3).preLoadMode = 1
end

on startMovie startingover
  if offset("Windows", the platform) then
    kPlatform = #win
  else
    kPlatform = #mac
  end if
  member("statusText").text = EMPTY
  oDialogueClass = new(script("dialogue factory"))
  if voidp(startingover) then
    gProxyMode = #noProxy
  end if
  if the shiftDown then
    runProxyDialog()
  end if
  gState = #suspend
  the itemDelimiter = "@"
  InitMovie()
  initGlobals()
  gMetronome = 0
  gMetronomeTimer = 0
  mCheckConnection(oConnectoScope)
  set the mouseDownScript to "megaMouseDown()"
  if kPlatform = #win then
    patchesPath = the moviePath & "xtras/Patches.hsb"
  else
    patchesPath = the moviePath & "xtras:Patches.hsb"
  end if
  regNum = "BXP-ALL-1-510219-17092267-01167"
  oSongMgr = new(script("Song Manager.class"), patchesPath, regNum)
  FPS = 15
  iSongID = #zordSong
  result = oSongMgr.mAddSong(iSongID, FPS)
  if stringp(result) then
  else
    oSoundMgr = oSongMgr.ilsongs.getaProp(iSongID)
  end if
  if not voidp(oSoundMgr) then
    if kPlatform = #win then
      oSoundMgr.mConfigSong(the moviePath & "xtras/BeerPagerSounds.rmf")
    else
      oSoundMgr.mConfigSong(the moviePath & "xtras:BeerPagerSounds.rmf")
    end if
  end if
  put "Sound manager started"
  if the colorDepth < 16 then
    oDialogueClass.mDoDialogue(#colorDepth)
  end if
  gCurScreen = "login"
  go("login")
  if kPlatform = #win then
    proxyResult = GetProxyAddress()
    gProxyMode = #noProxy
    if proxyResult <> EMPTY then
      gProxyMode = #proxy
      oldDelim = the itemDelimiter
      the itemDelimiter = ":"
      gProxyStr = proxyResult.item[1]
      gPortStr = proxyResult.item[2]
      the itemDelimiter = oldDelim
      if voidp(startingover) then
        if voidp(gProxyUserName) then
          APSResult = IsProxyAuthenticating()
        end if
      end if
      if APSResult then
        gPortStr = 80
        oDialogueClass.mDoDialogue(#APS)
      end if
    end if
  end if
end

on InitMovie
  server = "http://www.millerlite.com/servlet/com.redsky.beermailer."
  debugMode = 1
  oRequestMgr = new(script("Request Manager"), server, debugMode)
  put "Request maanger started."
  oXmlParser = new(xtra("xmlparser"))
  put "XML parser started"
  oConnectoScope = new(script("ConnectoScope"), "http://www.mgdblinddate.com/images/clear.gif", 100, "statusText")
  put "Connectoscope started."
  kDateObject = makeDateObject()
  oPrefsClass = new(script("prefs class"))
  oMeetings = new(script("meeting factory"))
  oClockClass = new(script("clock class"))
  oregisterClass = new(script("reg class"))
  oregister2Class = new(script("reg2 class"))
  oMainClass = new(script("main class"))
  oLoginClass = new(script("login class"))
  ohelpClass = new(script("help class"))
  oInviteClass = new(script("invite class"))
  oInvite2Class = new(script("invite2 class"))
  oInvite3Class = new(script("invite3 class"))
  oPlacesClass = new(script("places class"))
  oFriendsClass = new(script("friends class"))
  oTunerClass = new(script("tuner class"))
  oTuner2Class = new(script("tuner2 class"))
  oCalendarClass = new(script("calendar class"))
  oCalendar2Class = new(script("calendar2 class"))
end

on idle
  doIdle()
end

on doIdle
  if gState <> #Active then
    exit
  end if
  if the timer > gTimeCheckTmr then
    gTimeCheckTmr = the timer + (60 * 60)
    gAdjTime = oRequestMgr.mGetTime()
    setClock()
    oMeetings.mRemindMeetings(timeMyWay())
  end if
  if the timer > gMetronomeTimer then
    gMetronomeTimer = the timer + 60
    gMetronome = not gMetronome
  end if
  if not gPingFreq then
    exit
  end if
  if oPrefsClass.pLocalPrefData.autocheck then
    if the timer > gPingTimer then
      gPingTimer = the timer + (60 * gPingFreq)
    end if
  end if
end

on setClock
  oClockClass.mSetTime(oRequestMgr.mGetTime())
  kDateObject = makeDateObject()
end

on megaMouseDown
  case gState of
    #dialogue:
      if getPos(kDialogSprs, the clickOn) then
        pass()
      else
        stopEvent()
      end if
    #checkServer:
      stopEvent()
    otherwise:
      pass()
  end case
end

on initGlobals
  gCurHiLine = VOID
  gCurScreen = VOID
  gNavMenuHiSpr = VOID
  oCurMeeting = VOID
  gTimeCheckTmr = 0
  klRadioButts = ["radio1", "radio2", "radio3", "radio4"]
  klScreenButtonBank = [44, 45, 46, 47, 48]
  kKey = "sparkles"
  kWatchCursor = [58, 57]
  kNetLiteSpr = 59
  kDialogSprs = [oDialogueClass.pTextInputSpr, oDialogueClass.pButton1Spr, oDialogueClass.pButton2Spr, oDialogueClass.pMisc1Spr, oDialogueClass.pMisc2Spr, 80, 81, 82]
end

on invite
  meetingData = [#idMeeting: "A_11", #sWhen: "07:3:99:9:30", #sWhere: "Grumpy's (11th & Folsom", #yWhy: #millerTime, #sMessage: "This is going to be great!", #lWho: [[#idUser: 9999, #sName: "BillyBoy", #yAttending: #unknown, #sMessage: "I hope there's girls there"]]]
  glMtgs = call(#addMeetingToList, oMeetingFac, meetingData)
  makeMessage(glMtgs.A_11)
end

on makeDateObject
  myDate = oRequestMgr.mGetDate()
  return myDate
end

on getDayOfTheWeek theDate
  iday = theDate.day
  imonth = theDate.month
  iyear = theDate.year
  days = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  val1 = iday.value
  val2 = imonth
  val2x = imonth
  val3 = iyear
  if val2 = 1 then
    val2x = 13
    val3 = val3 - 1
  end if
  if val2 = 2 then
    val2x = 14
    val3 = val3 - 1
  end if
  val4 = (val2x + 1) * 3 / 5
  val5 = val3 / 4
  val6 = val3 / 100
  val7 = val3 / 400
  val8 = val1 + (val2x * 2) + val4 + val3 + val5 - val6 + val7 + 2
  val9 = val8 / 7
  val0 = val8 - (val9 * 7)
  return getAt(days, val0 + 1)
end

on getLongDate theDate
  dayString = getDayOfTheWeek(theDate)
  dayNumString = theDate.day
  monthList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  monthString = getAt(monthList, theDate.month)
  yearString = string(theDate.year)
  longDateString = dayString & ", " & monthString && dayNumString & ", " & yearString
  return longDateString
end

on sortByDate origList, dateProp
  repeat with curItem in origList
    oldDate = getProp(origList, dateProp)
    setProp(origList, dateProp, convertDate(oldDate))
  end repeat
  origList = sortPList(origList, dateProp)
  repeat with curItem in origList
    oldDate = getProp(origList, dateProp)
    setProp(origList, dateProp, convertDate(oldDate))
  end repeat
  return origList
end

on convertDate myDate
  if objectp(myDate) then
    newdate = string(myDate.month) & "/" & string(myDate.day) & "/" & string(myDate.year)
    return newdate
  else
    if stringp(myDate) and (myDate contains "/") then
      oldDelim = the itemDelimiter
      the itemDelimiter = "/"
      newdate = date(value(myDate.item[3]), value(myDate.item[1]), value(myDate.item[2]))
      the itemDelimiter = oldDelim
      return newdate
    else
      alert("date conversion didn't work")
    end if
  end if
end

on encode inputStr
  encryptedText = baEncryptText(inputStr, "BeerPagerKey")
  return encryptedText
end

on deEncode inputStr
  decryptedText = baDecryptText(inputStr, "BeerPagerKey")
  return decryptedText
end

on xorencode inputStr, key
  key = kKey
  strLen = length(inputStr)
  keyLen = length(key)
  result = EMPTY
  keyPos = 1
  repeat with X = 1 to strLen
    thisChar = char X of inputStr
    keyChar = char keyPos of key
    newChar = xor(thisChar, keyChar)
    put newChar after strLen
    keyPos = keyPos + 1
    if keyPos > keyLen then
      keyPos = 1
    end if
  end repeat
  return result
end

on charToBin character
  return decToBin(charToNum(character), 256)
end

on decToBin num, divisor
  hiNum = num / divisor
  loNum = num mod divisor
  divisor = sqrt(divisor)
  opStr = EMPTY
  if divisor > 1 then
    opStr = opStr & decToBin(hiNum, divisor)
    opStr = opStr & decToBin(loNum, divisor)
  else
    return string(hiNum) & string(loNum)
  end if
  return opStr
end

on trimBinary binStr
  startPosn = offset("1", binStr)
  if startPosn then
    opStr = char startPosn to length(binStr) of binStr
  else
    opStr = "0"
  end if
  return opStr
end

on binToDec binStr
  binStr = trimBinary(binStr)
  len = length(binStr)
  binMultiplier = 1
  outcome = 0
  repeat with X = len down to 1
    thisBit = char X of binStr
    if thisBit = "1" then
      outcome = outcome + binMultiplier
    end if
    binMultiplier = binMultiplier * 2
  end repeat
  return outcome
end

on binToChar binStr
  return numToChar(binToDec(binStr))
end

on xor char1, char2
  num1 = charToBin(char1)
  num2 = charToBin(char2)
  len = length(num1)
  result = EMPTY
  repeat with X = 1 to len
    if char X of num1 <> char X of num2 then
      put "1" after num1
      next repeat
    end if
    put "0" after num1
  end repeat
  return binToChar(result)
end
