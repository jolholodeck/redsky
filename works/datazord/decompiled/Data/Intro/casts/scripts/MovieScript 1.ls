global goSysEnvirons, goShellConstants, goDataStore, goSongMgr, goSndFX, gSndFXid, goSndMus, gSndMusID, gMegaCnt

on startMovie
  gMegaCnt = 0
  set the exitLock to 1
  set the keyDownScript to "FilterKeys"
  set the mouseDownScript to "FilterClicks"
  goSysEnvirons = new(script("SysEnvirons.class"))
  goShellConstants = new(script("ShellConstants.class"), goSysEnvirons.iPathDelim)
  err = checkMinSysReqs()
  if err then
    case err of
      (-1):
        alert("The Datazord requires a Pentium class or better CPU to run.")
      (-2):
        alert("The Datazord requires 32-bit OS to run.")
      (-11):
        alert("The Datazord requires at least 16MB of RAM to run.")
      (-12):
        alert("The Datazord requires at least 20MB of available hard disk space to run.")
      (-21):
        alert("The Datazord requires a PowerPC to run.")
      (-22):
        alert("The Datazord requires MacOS 7.1 or later to run.")
      (-31):
        alert("The Datazord requires a sound card to run.")
    end case
    quit()
  end if
  ofile = new(script("FileUtil.class"))
  tData = ofile.mReadFile(the moviePath & "data.txt")
  ofile = 0
  if not stringp(tData) then
    errCode = tData
    alert("Error reading Data file. (" & string(errCode) & ")")
    quit()
  end if
  goShellConstants.ikCurFrameSetID = integer(tData.char[6])
  if goSysEnvirons.iPlatform = #win then
    goShellConstants.iPrefsFileName = "Datazord.ini"
  else
    if goSysEnvirons.iPlatform = #mac then
      goShellConstants.iPrefsFileName = "Datazord Prefs"
    end if
  end if
  tBlnMDZunlocked = CompareDates(#now, tData.char[22..29])
  goDataStore = new(script("DataStore.class"), goSysEnvirons.iPrefFilePath & goShellConstants.iPrefsFileName)
  repeat with n = 1 to 6
    dzkey = value("#dz" & string(n))
    if n = goShellConstants.ikCurFrameSetID then
      val = 1
    else
      val = goDataStore.mGetData(dzkey)
      if voidp(val) then
        val = 0
      end if
    end if
    goDataStore.mSetData(dzkey, val)
  end repeat
  if the optionDown then
    if the shiftDown then
      Ltemp = []
      cnt = 0
      repeat with n = 1 to 5
        flg = keyPressed(string(n))
        cnt = cnt + flg
        append(Ltemp, flg)
      end repeat
    end if
  end if
  if cnt then
    repeat with n = 1 to Ltemp.count
      if Ltemp[n] then
        goDataStore.mSetData(value("#dz" & string(n)), 1)
      end if
    end repeat
  end if
  repeat with n = 1 to 5
    goDataStore.mSetData(value("#dz" & string(n)), 1)
  end repeat
  val = goDataStore.mGetData(#updatesPath)
  if voidp(val) then
    val = 0
    goDataStore.mSetData(#updatesPath, val)
  end if
  goShellConstants.ikUpdatesPath = val
  if not goDataStore.mGetData(#dz6) then
    if tBlnMDZunlocked then
      goDataStore.mSetData(#dz6, 1)
    else
      sum = 0
      repeat with dzkey in [#dz1, #dz2, #dz3, #dz4, #dz5]
        sum = sum + goDataStore.mGetData(dzkey)
      end repeat
      if sum >= 3 then
        goDataStore.mSetData(#dz6, 1)
      end if
    end if
  end if
  Ltemp = [:]
  repeat with dzkey in [#dz1, #dz2, #dz3, #dz4, #dz5, #dz6]
    Ltemp[dzkey] = goDataStore.mGetData(dzkey)
  end repeat
  goShellConstants.ikLEnabledFrameSets = Ltemp
  case the runMode of
    "Projector":
      err = goSysEnvirons.mSetDisplay(640, 480, 8)
      if err then
        alert("An error occurred while attempting to change the display settings.")
      end if
  end case
  case goSysEnvirons.iPlatform of
    #win:
      err = goSysEnvirons.mSetSoundLevel(4)
      if err = -1 then
      end if
    #mac:
      err = goSysEnvirons.mSetSoundLevel(6)
      if err = -1 then
      end if
  end case
  patchesPath = goShellConstants.ikSndAssetPath & "Patches.hsb"
  regNum = "BXP-ALL-1-510219-17092267-01167"
  goSongMgr = new(script("Song Manager.class"), patchesPath, regNum)
  FPS = 15
  gSndFXid = #introfx
  result = goSongMgr.mAddSong(gSndFXid, FPS)
  if stringp(result) then
    alert("An error occurred while attempting to create a song object." && "(" & string(result) & ")")
    quit()
  else
    goSndFX = goSongMgr.ilsongs.getaProp(gSndFXid)
  end if
  FPS = 15
  gSndMusID = #intromus
  result = goSongMgr.mAddSong(gSndMusID, FPS)
  if stringp(result) then
    alert("An error occurred while attempting to create a song object." && "(" & string(result) & ")")
    quit()
  else
    goSndMus = goSongMgr.ilsongs.getaProp(gSndMusID)
  end if
  goSndFX.mConfigSong(goShellConstants.ikSndAssetPath & "Introbnk.rmf")
  goSndMus.mConfigSong(goShellConstants.ikSndAssetPath & "Intromus.rmf")
  goSndFX.mSetVolume(90)
  goSndMus.mSetVolume(90)
  goSongMgr.mSetReverb(1)
  goSndMus.mStartPlaying()
end

on checkMinSysReqs
  if goSysEnvirons.iPlatform = #win then
    if goSysEnvirons.iCPUType < 5 then
      return -1
    end if
    if goSysEnvirons.iOSType contains "16" then
      return -2
    end if
  else
    if goSysEnvirons.iPlatform = #mac then
      if goSysEnvirons.iCPUType <> "PowerPC" then
        return -21
      end if
    end if
  end if
  if (goSysEnvirons.iPhysicalRAM / 1024) < 17000 then
    return -11
  end if
  if goSysEnvirons.iHDfreeKbytes < 20000 then
    return -12
  end if
  if not goSysEnvirons.iBlnHasSndCard then
    return -31
  end if
  return 0
end

on CompareDates date1, date2
  Lproc = [date1, date2]
  Ldate = []
  repeat with d in Lproc
    Ltemp = []
    case ilk(d) of
      #string:
        Ltemp[1] = integer(d.char[1..2])
        Ltemp[2] = integer(d.char[3..4])
        Ltemp[3] = integer(d.char[5..8])
      #symbol:
        case d of
          #now:
            Ltemp[1] = (the systemDate).month
            Ltemp[2] = (the systemDate).day
            Ltemp[3] = (the systemDate).year
        end case
      otherwise:
        return -1
    end case
    append(Ldate, Ltemp)
  end repeat
  if (Ldate[1][3] > Ldate[2][3]) or ((Ldate[1][3] = Ldate[2][3]) and (Ldate[1][1] > Ldate[2][1])) or ((Ldate[1][3] = Ldate[2][3]) and (Ldate[1][1] = Ldate[2][1]) and (Ldate[1][2] >= Ldate[2][2])) then
    return 1
  else
    return 0
  end if
end

on FilterKeys
  case the key of
    SPACE:
      go("Exit")
  end case
end

on FilterClicks
  go("Exit")
end
