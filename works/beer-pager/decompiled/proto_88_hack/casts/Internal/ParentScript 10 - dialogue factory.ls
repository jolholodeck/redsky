property pBgSpr, pTextSpr, pTextInputSpr, pMisc1Spr, pMisc2Spr, pButton1Spr, pButton2Spr, pDimSpr, pCenterOfScreenLoc, plDialogues, pCurDialogue
global gState, gCurDialog, oCalendarClass, oLoginClass, oCalendar2Class, gCurScreen, oPlacesClass, oFriendsClass, oTunerClass, oTuner2Class, gProxyUserName, gProxyUserPassword, gProxyMode

on new me
  pDimSpr = 69
  pBgSpr = 70
  pTextSpr = 71
  pTextInputSpr = 72
  pMisc1Spr = 73
  pMisc2Spr = 74
  pButton1Spr = 75
  pButton2Spr = 76
  pCenterOfScreenLoc = point(150, 150)
  pCurDialogue = 0
  plDialogues = [:]
  allDialogue = [#noNetwork: [1875, 0, 0, 1876, 0, 1923, 1941, 0, 0, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #alert], #sZipCode: [1875, 0, 0, 1889, 0, 1923, 1941, 0, 0, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #alert], #serverBusy: [1875, 0, 0, 1877, 0, 1923, 1941, 0, 0, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #alert], #noNetworkCI: [1896, 0, 0, 0, 0, 1923, 1941, 0, 0, [point(187, 150), 0, 0, 0, 0, point(219, 183), point(166, 188)], #alert], #serverBusyCI: [1897, 0, 0, 0, 0, 1923, 1941, 0, 0, [point(187, 150), 0, 0, 0, 0, point(219, 183), point(166, 188)], #alert], #userName: [1875, 0, 0, 1878, 0, 1923, 1941, 0, 0, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #alert], #alreadyReg: [1875, 0, 0, 1886, 0, 1923, 1941, 0, 0, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #alert], #userNameTaken: [1875, 0, 0, 1887, 0, 1923, 1941, 0, 0, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #alert], #not21: [1875, 0, 0, 1888, 0, 1923, 1941, 0, 0, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #alert], #forgotPword: [1885, 0, 1586, 0, 0, 1921, 1941, 0, 1, [pCenterOfScreenLoc, 0, point(79, 147), 0, 0, point(182, 193), point(129, 198)], #input], #APS: [1898, 0, 1903, 0, 0, 0, 0, 0, 1, [pCenterOfScreenLoc, 0, point(91, 134), 0, 0, 0, 0], #input], #Password: [1875, 0, 0, 1879, 0, 1923, 1941, 0, 0, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #alert], #loginFail: [1875, 0, 0, 1880, 0, 1923, 1941, 0, 0, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #alert], #cancelMtg: [1892, 0, 1582, 0, 0, 1911, 1931, 0, 1, [pCenterOfScreenLoc, 0, point(55, 130), 0, 0, point(182, 193), point(129, 198)], #input], #acceptMtg: [1893, 0, 1581, 0, 0, 1911, 1931, 0, 1, [pCenterOfScreenLoc, 0, point(55, 130), 0, 0, point(182, 193), point(129, 198)], #input], #addFriend: [1894, 0, 1583, 0, 0, 1921, 1941, 0, 1, [pCenterOfScreenLoc, 0, point(79, 138), 0, 0, point(182, 193), point(129, 198)], #input], #friendEmail: [1875, 0, 0, 1881, 0, 1921, 1941, 0, 1, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #boolean], #passWordReg: [1875, 0, 0, 1882, 0, 1923, 1941, 0, 0, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #alert], #colorDepth: [1875, 0, 0, 1883, 0, 1923, 1941, 0, 0, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #alert], #remindMeeting: [1875, 0, 0, 1884, 0, 1921, 1941, 0, 1, [pCenterOfScreenLoc, 0, 0, pCenterOfScreenLoc, 0, point(182, 182), point(129, 187)], #boolean], #addPlace: [1895, 0, 1584, 1595, 0, 1911, 1931, 0, 1, [pCenterOfScreenLoc, 0, point(104, 128), point(104, 146), 0, point(182, 182), point(129, 187)], #input]]
  repeat with idx = 1 to count(allDialogue)
    curName = getPropAt(allDialogue, idx)
    curParams = getProp(allDialogue, curName)
    tempDialogueObject = new(script("dialogue class"), curParams)
    setaProp(plDialogues, curName, tempDialogueObject)
  end repeat
  return me
end

on mDoDialogue me, whichDialogue
  gCurDialog = whichDialogue
  pCurDialogue = getProp(plDialogues, whichDialogue)
  mConstruct(me)
  updateStage()
  case pCurDialogue.pDialogType of
    #input:
      gState = #dialogue
      if pCurDialogue.pTextInputMem then
        member(pCurDialogue.pTextInputMem).text = EMPTY
        forceFieldFocus(pTextInputSpr)
      end if
      if pCurDialogue.pMisc1Mem then
        member(pCurDialogue.pMisc1Mem).text = EMPTY
      end if
    #boolean:
      gState = #dialogue
      keepGoing = VOID
      repeat while keepGoing = VOID
        if rollOver(pButton1Spr) and the mouseDown then
          sprite(pButton1Spr).member = pCurDialogue.pButton1Mem + 1
          updateStage()
          repeat while the stillDown
            doIdle()
          end repeat
          keepGoing = 0
          mDeconstruct(me)
          return keepGoing
          next repeat
        end if
        if rollOver(pButton2Spr) and the mouseDown then
          sprite(pButton2Spr).member = pCurDialogue.pButton2Mem + 1
          updateStage()
          repeat while the stillDown
            doIdle()
          end repeat
          keepGoing = 1
          mDeconstruct(me)
          return keepGoing
          next repeat
        end if
        doIdle()
      end repeat
    #alert:
      gState = #dialogue
      keepGoing = VOID
      repeat while keepGoing = VOID
        if rollOver(pButton2Spr) and the mouseDown then
          sprite(pButton2Spr).member = pCurDialogue.pButton2Mem + 1
          playSound(#read)
          updateStage()
          repeat while the stillDown
            doIdle()
          end repeat
          keepGoing = 1
          mDeconstruct(me)
          return keepGoing
          next repeat
        end if
        doIdle()
      end repeat
  end case
end

on mDoMyMouseDown me, whichButton
  case whichButton of
    #Di_Button1:
      callback = pCurDialogue.pButton1CallBack
      retValue = 0
    #Di_Button2:
      callback = pCurDialogue.pButton2CallBack
      retValue = 1
  end case
  dialogName = getOne(plDialogues, pCurDialogue)
  mDeconstruct(me)
  gState = #Active
  if callback = 1 then
    case dialogName of
      #cancelMtg:
        message = trimSpaces(member(pCurDialogue.pTextInputMem).text)
        case gCurScreen of
          "tuner":
            obj = oTunerClass
          "tuner2":
            obj = oTuner2Class
          "calendar":
            obj = oCalendarClass
          "calendar2":
            obj = oCalendar2Class
        end case
        call(#mCallToCancelMeeting, obj, message)
      #forgotPword:
        message = trimSpaces(member(pCurDialogue.pTextInputMem).text)
        oLoginClass.mSendPassWordEmail(message)
      #acceptMtg:
        message = trimSpaces(member(pCurDialogue.pTextInputMem).text)
        oTuner2Class.mAcceptMeeting(message)
      #addPlace:
        name = trimSpaces(member(pCurDialogue.pTextInputMem).text)
        where = trimSpaces(member(pCurDialogue.pMisc1Mem).text)
        if name = EMPTY then
          abort()
        end if
        member(pCurDialogue.pTextInputMem).text = name
        member(pCurDialogue.pMisc1Mem).text = where
        oPlacesClass.mAddPlace(name, where)
      #addFriend:
        emailInput = member(pCurDialogue.pTextInputMem).text
        oFriendsClass.mCheckForRegisteredUser(emailInput)
      #APS:
        gProxyUserName = member("APS name").text
        gProxyUserPassword = sprite(82).mReturnPassword()
        gProxyMode = #authProxy
    end case
  else
    if callback = 0 then
    else
      do(callback)
    end if
  end if
end

on mDeconstruct me
  member("APS pword").editable = 0
  sprite(82).editable = 0
  gState = #Active
  repeat with curSprite in [pBgSpr, pTextSpr, pTextInputSpr, pMisc1Spr, pMisc2Spr, pButton1Spr, pButton2Spr]
    sprite(curSprite).visible = 0
    sprite(curSprite).member = "dot"
    sprite(curSprite).loc = point(-1000, -1000)
  end repeat
  sprite(pDimSpr).loc = point(-1000, -1000)
  if gCurDialog = #APS then
    sprite(80).member = "dot"
    sprite(81).member = "dot"
    sprite(80).loc = point(-1000, -1000)
    sprite(81).loc = point(-1000, -1000)
    sprite(82).loc = point(-1000, -1000)
    forceFieldFocus(31)
  end if
  gCurDialog = 0
  repeat with curSprite in [pBgSpr, pTextSpr, pTextInputSpr, pMisc1Spr, pMisc2Spr, pButton1Spr, pButton2Spr]
    sprite(curSprite).visible = 1
  end repeat
end

on mConstruct me
  sprite(pBgSpr).member = pCurDialogue.pBgMem
  sprite(pTextInputSpr).member = pCurDialogue.pTextInputMem
  sprite(pMisc1Spr).member = pCurDialogue.pMisc1Mem
  sprite(pMisc2Spr).member = pCurDialogue.pMisc2Mem
  sprite(pButton1Spr).member = pCurDialogue.pButton1Mem
  sprite(pButton2Spr).member = pCurDialogue.pButton2Mem
  sprite(pBgSpr).loc = pCurDialogue.pBgMemLoc
  sprite(pTextInputSpr).loc = pCurDialogue.pTextInputMemLoc
  sprite(pMisc1Spr).loc = pCurDialogue.pMisc1MemLoc
  sprite(pMisc2Spr).loc = pCurDialogue.pMisc2MemLoc
  sprite(pButton1Spr).loc = pCurDialogue.pButton1MemLoc
  sprite(pButton2Spr).loc = pCurDialogue.pButton2MemLoc
  sprite(pDimSpr).loc = point(150, 150)
  if gCurDialog = #APS then
    sprite(80).member = 1899
    sprite(81).member = 1901
    sprite(80).loc = point(99, 207)
    sprite(81).loc = point(192, 207)
    sprite(82).loc = point(91, 163)
    member("APS pword").editable = 1
    sprite(82).editable = 1
  end if
end

on mErrorAlert me, errorType
  case errorType of
    #errorType:
      alert("ERROR MESSAGE")
  end case
end
