property ancestor, iPlatform, iCPUType, iOSType, iFreeBytesAtInit, iPhysicalRAM, iAppBytes, iMonitorCnt, iColorDepth, iScreenRes, iBlnHasSndCard, iOSDir, iPrefFilePath, iPathDelim, iHDsysVol, iHDfreeKbytes, iMachineMetric, iOldClrDepth, iOldScreenRes, iOldSndLevel

on new me
  ancestor = new(script("DebugRoot.class"))
  mProfilePlatform(me)
  return me
end

on mProfilePlatform me
  if the platform contains "Windows" then
    iPlatform = #win
    iCPUType = baCpuInfo("type")
    iOSType = baVersion("os")
    iFreeBytesAtInit = the freeBytes
    iPhysicalRAM = the memorysize
    iAppBytes = the memorysize
    iColorDepth = the colorDepth
    ldtr = the deskTopRectList
    iMonitorCnt = count(ldtr)
    iScreenRes = list(ldtr[1][3] - ldtr[1][1], ldtr[1][4] - ldtr[1][2])
    iBlnHasSndCard = baSoundCard()
    iPathDelim = "\"
    iOSDir = getOSDirectory()
    iPrefFilePath = iOSDir & iPathDelim
    iHDsysVol = iOSDir.char[1]
    iHDfreeKbytes = baDiskInfo(iHDsysVol, "free")
  else
    if the platform contains "Macintosh" then
      iPlatform = #mac
      the itemDelimiter = ","
      iCPUType = (the environment).platform.item[2]
      iOSType = baVersion("os")
      iFreeBytesAtInit = the freeBytes
      iPhysicalRAM = baGestalt("ram ")
      iAppBytes = the memorysize
      iColorDepth = the colorDepth
      ldtr = the deskTopRectList
      iMonitorCnt = count(ldtr)
      iScreenRes = list(ldtr[1][3] - ldtr[1][1], ldtr[1][4] - ldtr[1][2])
      iBlnHasSndCard = 1
      iPathDelim = ":"
      iOSDir = getOSDirectory()
      iPrefFilePath = baSysFolder("prefs")
      the itemDelimiter = ":"
      iHDsysVol = iOSDir.item[1]
      iHDfreeKbytes = baDiskInfo(iHDsysVol, "free")
    else
      alert("This is an unsupported platform.")
      quit()
    end if
  end if
  iMachineMetric = mMachineMetric(me)
  iOldClrDepth = iColorDepth
  iOldScreenRes = iScreenRes
end

on mMachineMetric me
  i = 0
  t = the milliSeconds
  repeat while the milliSeconds < (t + 1000)
    i = i + 1
    temp = 1 / 1.0
    temp = 1 / 1
    temp = "a"
    temp = "a" & "b"
    temp = [1]
    temp = ["1"]
  end repeat
  return i
end

on mSetDisplay me, targetWidth, targetHeight, targetDepth
  if (targetWidth = iScreenRes[1]) and (targetHeight = iScreenRes[2]) and (targetDepth = iColorDepth) then
    return 0
  end if
  if iPlatform = #mac then
    set the colorDepth to targetDepth
    if the colorDepth = targetDepth then
      iColorDepth = targetDepth
      return 0
    else
      return -1
    end if
  else
    if iPlatform = #win then
      exit
      err = baSetDisplay(targetWidth, targetHeight, targetDepth, "test", 0)
      if err < 0 then
        return err
      else
        if err > 0 then
          return 0
        end if
      end if
      err = baSetDisplay(targetWidth, targetHeight, targetDepth, "temp", 0)
      if err < 0 then
        return err
      else
        iColorDepth = targetDepth
        iScreenRes = [targetWidth, targetHeight]
        return 0
      end if
    end if
  end if
end

on mRestoreDisplay me
  if (iOldClrDepth = iColorDepth) and (iOldScreenRes = iScreenRes) then
    exit
  else
    mSetDisplay(me, iOldScreenRes[1], iOldScreenRes[2], iOldClrDepth)
  end if
end

on mSetSoundLevel me, theLevel
  iOldSndLevel = the soundLevel
  set the soundLevel to theLevel
  if the soundLevel <> theLevel then
    if the soundLevel = 0 then
      return -1
    end if
    return -2
  end if
  return 0
end

on mRestoreSoundLevel me
  set the soundLevel to iOldSndLevel
end
