global kFreeBytesAtInit, goDiagnostics, gAlerts, gDebug, gBlnWritePrefs, gBlnHasQuit, goClosebox, goSysEnvirons, goDataStore, goK, goCurs, goColl, goEmail, goPanel, goSongMgr, goSndScape, gxBeatnik, goDiorama

on prepareMovie
  if voidp(gDebug) then
    if the runMode = "Projector" then
      gDebug = 0
    else
      gDebug = 1
    end if
  end if
  if (the runMode = "Projector") and (the platform contains "Macintosh") then
    installMenu(53)
  end if
  if voidp(kFreeBytesAtInit) then
    kFreeBytesAtInit = the freeBytes
  end if
  gAlerts = #default
  the alertHook = script("Alert script")
  the actorList = []
  cursor(4)
  set the keyDownScript to EMPTY
  set the mouseDownScript to EMPTY
  gBlnWritePrefs = 1
  gBlnHasQuit = 0
end

on startMovie
  err = CheckXtrasAvailable()
  if err then
    AlertError(1)
  end if
  goSysEnvirons = new(script("SysEnvirons.class"), kFreeBytesAtInit)
  if gDebug then
    goDiagnostics = new(script("Diagnostics.class"), goSysEnvirons.ikFreeBytesAtInit)
    sprite(95).loc = point(208, 3)
    sprite(96).loc = point(283, 165)
    updateStage()
  end if
  err = checkMinSysReqs()
  if err then
    case err of
      (-11):
        AlertError(3)
      (-12):
        AlertError(4)
      (-13):
        AlertError(5)
      (-21):
        AlertError(6)
      (-22):
        AlertError(7)
      (-23):
        AlertError(8)
      (-31):
        AlertError(9)
      (-32):
        AlertError(10)
      (-33):
        AlertError(14, 0)
    end case
  end if
  goK = new(script("Constants.class"), goSysEnvirons.iPlatform)
  goDataStore = new(script("DataStore.class"), goSysEnvirons.iPrefFilePath & goK.iPrefsFileName)
  case goSysEnvirons.iPlatform of
    #win:
      err = goSysEnvirons.mSetSoundLevel(7)
      if err = -1 then
      end if
    #mac:
      err = goSysEnvirons.mSetSoundLevel(7)
      if err = -1 then
      end if
  end case
  err = DirectoryExists(goK.iCollPath)
  if err then
    AlertError(1)
  end if
  err = DirectoryExists(goK.iSndPath)
  if err then
    AlertError(1)
  end if
  err = FileExists(goK.iPatchesPath)
  if err then
    AlertError(1)
  end if
  regNum = "BXP-ALL-1-510219-17092267-01167"
  goSongMgr = new(script("Song Manager.class"), goK.iPatchesPath, regNum)
  goColl = new(script("Collection Manager.class"))
  goCurs = new(script("Cursor Manager.class"))
  goEmail = new(script("Email Manager.class"))
  goPanel = new(script("Elements Panel Manager.class"))
  gxBeatnik = new(xtra("beatnik"))
  if not objectp(gxBeatnik) then
    AlertError(2)
  else
    register(gxBeatnik, regNum)
    strVersion = getVersion(gxBeatnik)
    if strVersion contains "Unregistered" then
      AlertError(2)
    end if
  end if
  setSliceSize(gxBeatnik, 1)
  setSampleLibrary(gxBeatnik, goK.iPatchesPath)
  setReady(gxBeatnik)
  err = isReady(gxBeatnik)
  if not err then
    AlertError(2)
  end if
  err = play(gxBeatnik, 0, goK.iUIrmfPath)
  gxBeatnik.setVolume(66)
  if goSysEnvirons.iPlatform = #mac then
    goClosebox = new(script("Closebox.class"), goSysEnvirons.iOSType)
  else
    startQuitMsg()
  end if
  if not gDebug then
    gAlerts = #suppress
  end if
end

on stopMovie
  if not gBlnHasQuit then
    DoQuit()
  end if
end

on DoQuit
  if the runMode = "Projector" then
    (the stage).visible = 0
  end if
  the actorList = []
  if ilk(goDataStore, #instance) and gBlnWritePrefs then
    if ilk(goColl, #instance) then
      goDataStore.mSetData(#curcollname, goColl.iCurCollName)
      goDataStore.mSetData(#collnames, goColl.iLcollNames)
      goDataStore.mSetData(#sndscapedata, goColl.iLsndScapeData)
    end if
    if ilk(goEmail, #instance) then
      goDataStore.mSetData(#yourname, goEmail.iStrYourName)
    end if
    if ilk(goPanel, #instance) then
      goDataStore.mSetData(#mute, goPanel.iBlnMute)
      goDataStore.mSetData(#vol, goPanel.iCurVolume)
    end if
    goDataStore.mSaveData()
  end if
  if ilk(goSysEnvirons, #instance) then
    goSysEnvirons.mRestoreSoundLevel()
  end if
  if ilk(goSndScape, #instance) then
    goSndScape.mdispose()
    goSndScape = VOID
  end if
  if ilk(goSongMgr, #instance) then
    goSongMgr.mdispose()
    goSongMgr = VOID
  end if
  if ilk(gxBeatnik, #instance) then
    stop(gxBeatnik)
    closeBeatnik(gxBeatnik)
    gxBeatnik = VOID
  end if
  if the platform contains "Windows" then
    closeQuitMsg()
  end if
  gBlnHasQuit = 1
  if (the runMode = "Projector") and (the platform contains "Windows") then
    quit()
  else
    halt()
  end if
end

on quitMsg
  DoQuit()
end

on CheckXtrasAvailable
  lCurXtraData = duplicate(the xtraList)
  if the platform contains "Windows" then
    strXtraData = member("xtras list-Win", 1).text
  else
    strXtraData = member("xtras list-Mac", 1).text
  end if
  lXtraData = value(strXtraData)
  if not ilk(lXtraData, #linearList) then
    return -1
  end if
  if the runMode = "Projector" then
    if lXtraData.count <> lCurXtraData.count then
      return -4
    end if
  end if
  repeat with n = 1 to lXtraData.count
    blnFound = 0
    repeat with i = 1 to lCurXtraData.count
      if lXtraData[n].name = lCurXtraData[i].name then
        blnFound = 1
        if lXtraData[n].version <> lCurXtraData[i].version then
          return -2
        end if
      end if
    end repeat
    if not blnFound then
      return -3
    end if
  end repeat
  return 0
end

on checkMinSysReqs
  if goSysEnvirons.iPlatform = #win then
    if goSysEnvirons.iCPUType < 5 then
      return -11
    end if
    if (goSysEnvirons.iPhysicalRAM / 1024) < 32000 then
      return -13
    end if
  end if
  if goSysEnvirons.iPlatform = #mac then
    the itemDelimiter = "."
    versRoot = integer(goSysEnvirons.iMacOSvers.item[1])
    if not integerp(versRoot) then
      return -22
    end if
    if versRoot = 7 then
      vers2 = integer(goSysEnvirons.iMacOSvers.item[2])
      if not integerp(vers2) then
        return -22
      end if
      if vers2 = 6 then
        vers3 = integer(goSysEnvirons.iMacOSvers.item[3])
        if not integerp(vers3) then
          return -22
        end if
        if vers3 < 1 then
          return -22
        end if
      else
        if vers2 < 6 then
          return -22
        end if
      end if
    else
      if versRoot < 7 then
        return -22
      end if
    end if
    if (goSysEnvirons.iPhysicalRAM / 1024) < 64000 then
      return -23
    end if
  end if
  if goSysEnvirons.iHDfreeKbytes < 64000 then
    return -31
  end if
  if not goSysEnvirons.iBlnHasSndCard then
    return -32
  end if
  if goSysEnvirons.iColorDepth < 16 then
    return -33
  end if
  return 0
end

on GetErrorMsg msgID
  case msgID of
    14:
      case goSysEnvirons.iColorDepth of
        8:
          strDepth = "Your monitor is currently displaying 256 colors."
        4:
          strDepth = "Your monitor is currently displaying 16 colors."
        otherwise:
          strDepth = EMPTY
      end case
      errorMessage = strDepth && "MoodMaker looks best in thousands."
      errorMessage = errorMessage && "It is recommended that you switch to thousands before running MoodMaker."
      return errorMessage
    otherwise:
      errorMessage = member("error messages").line[msgID]
      if errorMessage = EMPTY then
        return EMPTY
      else
        errorMessage = errorMessage.char[5..errorMessage.length]
        return errorMessage
      end if
  end case
end

on AlertError msgID, abortFlg, errCode
  if voidp(abortFlg) then
    abortFlg = 1
  end if
  oldAlertState = gAlerts
  gAlerts = #default
  errStr = GetErrorMsg(msgID)
  if not voidp(errCode) then
    put " (" & string(errCode) & ")" after oldAlertState
  end if
  alert(errStr)
  gAlerts = oldAlertState
  if abortFlg then
    gBlnWritePrefs = 0
    DoQuit()
  end if
end

on FadeSprite spr, Dir, fadeTime
  incr = 100.0 / fadeTime
  elapsedTime = 0
  startTime = the milliSeconds
  if Dir = 1 then
    curBlend = 0
    repeat while curBlend < 100
      elapsedTime = the milliSeconds - startTime
      newBlend = integer(incr * elapsedTime)
      if newBlend > 100 then
        newBlend = 100
      end if
      if newBlend <> curBlend then
        curBlend = newBlend
        spr.blend = curBlend
        updateStage()
      end if
    end repeat
  else
    if Dir = -1 then
      curBlend = 100
      repeat while curBlend > 0
        elapsedTime = the milliSeconds - startTime
        newBlend = 100 - integer(incr * elapsedTime)
        if newBlend < 0 then
          newBlend = 0
        end if
        if newBlend <> curBlend then
          curBlend = newBlend
          spr.blend = curBlend
          updateStage()
        end if
      end repeat
    end if
  end if
end

on SlideSprite LsprNums, hOff, steps, slideTime
  Loffsets = []
  repeat with sprNum in LsprNums
    Loffsets.append(sprite(sprNum).locH)
  end repeat
  stepIncr = hOff / float(steps)
  timeIncr = slideTime / float(steps)
  t = the milliSeconds
  curStep = 0
  repeat while curStep < steps
    if the milliSeconds >= (t + integer(timeIncr * curStep)) then
      curStep = curStep + 1
      newPos = integer(stepIncr * curStep)
      repeat with n = 1 to LsprNums.count
        newPos = integer(stepIncr * curStep)
        sprite(LsprNums[n]).locH = newPos + Loffsets[n]
      end repeat
      updateStage()
    end if
  end repeat
end

on FlipBook Lspr, LmemNums, LcstNum, animDur
  steps = LmemNums[1].count
  timeIncr = animDur / float(steps)
  t = the milliSeconds
  curStep = 0
  repeat while curStep < steps
    if the milliSeconds >= (t + integer(timeIncr * curStep)) then
      curStep = curStep + 1
      repeat with n = 1 to Lspr.count
        Lspr[n].member = member(LmemNums[n][curStep], LcstNum[n])
        updateStage()
      end repeat
    end if
  end repeat
end

on makeList bgnNum, cnt
  Ltemp = []
  repeat with n = 1 to cnt
    Ltemp.append(bgnNum + n - 1)
  end repeat
  return Ltemp
end

on ReverseList theList
  newList = []
  repeat with n = theList.count down to 1
    newList.append(theList[n])
  end repeat
  return newList
end

on MergeLists Llists
  cnt = Llists[1].count
  repeat with n = 1 to Llists.count
    if Llists[n].count <> cnt then
      return -1
    end if
  end repeat
  Lmerged = []
  repeat with n = 1 to cnt
    Ltemp = []
    repeat with i = 1 to Llists.count
      Ltemp.append(Llists[i][n])
    end repeat
    Lmerged.append(Ltemp)
  end repeat
  return Lmerged
end

on FlattenList Lin
  lOut = []
  repeat with n = 1 to Lin.count
    case 1 of
      ilk(Lin[n], #integer):
        lOut.append(Lin[n])
      ilk(Lin[n], #list):
        bgnVal = Lin[n][1]
        endVal = Lin[n][2]
        repeat with i = bgnVal to endVal
          lOut.append(i)
        end repeat
    end case
  end repeat
  return lOut
end

on KeyFilter
  keyNum = charToNum(key())
  if (goSysEnvirons.iPlatform = #win) and the commandDown and (keyNum = 113) then
    DoQuit()
  end if
  if goEmail.iBlnEmailActive then
    if goEmail.iLcharFilters[goEmail.iCurFld].getPos(keyNum) then
      case keyNum of
        9:
          goEmail.mTabField()
          stopEvent()
          exit
        28:
          goEmail.mMoveCursor(-1)
          stopEvent()
          exit
        29:
          goEmail.mMoveCursor(1)
          stopEvent()
          exit
      end case
    else
      stopEvent()
      exit
    end if
    case goEmail.iCurFld of
      1:
        str = goEmail.iMbrFriendsAddr.text
      2:
        str = goEmail.iMbrFriendsName.text
      3:
        str = goEmail.iMbrYourName.text
    end case
    if str.length >= 128 then
      if (keyNum <> 8) and (the selStart = the selEnd) then
        beep()
        stopEvent()
      end if
    end if
  end if
end

on BtnClick_Mute State
  if ilk(goPanel, #instance) then
    goPanel.mToggleMute(State)
  end if
end

on BtnClick_Logo
  Wait(500)
  gotoNetPage("http://www.sutterhome.com")
end

on BtnClick_Toggle toggleNum, State
  goPanel.mToggleClick(toggleNum, State)
end

on BtnClick_SwitchBlend idx
  goPanel.mSwitchBlend(integer(idx))
end

on BtnClick_ResetBlend
  goPanel.mResetBlend()
end

on BtnClick_Random State
  goPanel.mToggleRndPlay(State)
end
