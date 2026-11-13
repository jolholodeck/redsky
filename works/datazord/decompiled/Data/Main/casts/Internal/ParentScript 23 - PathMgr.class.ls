property ancestor, ikHDassetPath, ikCDassetPath, ikMacSigStr, ikWinSigStr, iklInstalledModules, ilkHDassets, iHasHDassets
global goShellConstants, goDataStore

on new me, dummyLibPath, startLibNum, nbLibs
  ikMacSigStr = "RIFX"
  ikWinSigStr = "XFIR"
  ikHDassetPath = goShellConstants.ikUpdatesPath
  ikCDassetPath = goShellConstants.ikCDlibsPath
  iHasHDassets = 0
  ilkHDassets = []
  if stringp(ikHDassetPath) then
    if DirectoryExists(ikHDassetPath) = 0 then
      ilkHDassets = DirectoryToList(ikHDassetPath)
      if ilkHDassets.count > 0 then
        iHasHDassets = 1
      end if
    else
      put "PathMgr:new: updates folder not found"
      goDataStore.mSetData(#updatesPath, 0)
    end if
  end if
  iklInstalledModules = me.mScanForModules()
  return me
end

on mScanForModules me
  lStructure = [[[1], [1], [1, 1], [1], [1], [1], [1, 1], [1], [1, 1]], [[1], [1], [1, 1], [1], [1], [1], [1, 1], [1], [1, 1]], [[1], [1], [1, 1], [1], [1], [1], [1, 1], [1], [1, 1]], [[1], [1], [1, 1], [1], [1], [1], [1, 1], [1], [1, 1]], [[1], [1], [1, 1], [1], [1], [1], [1, 1], [1], [1, 1]], [[1]]]
  lDefault = []
  dzIdx = 0
  repeat with dzData in lStructure
    dzIdx = dzIdx + 1
    libPath = ikCDassetPath & "dz" & dzIdx & "base"
    lCurDZ = []
    repeat with fsetData in dzData
      lCurFset = []
      repeat with moduleFlag in fsetData
        if moduleFlag then
          lCurFset.add(libPath)
          next repeat
        end if
        lCurFset.add(0)
      end repeat
      lCurDZ.add(duplicate(lCurFset))
    end repeat
    lDefault.add(duplicate(lCurDZ))
  end repeat
  if not iHasHDassets then
    return lDefault
  end if
  repeat with curModule in ilkHDassets
    lModID = me.mGetModuleID(curModule)
    if not listp(lModID) then
      next repeat
    end if
    fsetID = lModID[1]
    frameID = lModID[2]
    modID = lModID[3]
    lDefault[fsetID][frameID][modID] = ikHDassetPath & curModule
  end repeat
  return lDefault
end

on mGetInstalledModules me
  return iklInstalledModules
end

on mGetModuleID me, fName
  if fName = EMPTY then
    return 0
  end if
  oldDelim = the itemDelimiter
  the itemDelimiter = "."
  fileRoot = item 1 of fName
  fileExt = item 2 of fName
  if fileRoot = EMPTY then
    return 0
  end if
  if (fileExt <> "cst") and (fileExt <> "cxt") then
    return 0
  end if
  the itemDelimiter = "_"
  if item 1 of fileRoot <> "dz" then
    return 0
  end if
  fsetID = value(item 2 of fileRoot)
  frameID = value(item 3 of fileRoot)
  modID = value(item 4 of fileRoot)
  if not integerp(fsetID) then
    return 0
  end if
  if not integerp(frameID) then
    return 0
  end if
  if not integerp(modID) then
    return 0
  end if
  if fsetID < 1 then
    return 0
  end if
  if fsetID > 6 then
    return 0
  end if
  if frameID < 1 then
    return 0
  end if
  if modID < 1 then
    return 0
  end if
  return [fsetID, frameID, modID]
end

on mIsValidCastFile me, fPath
  if fPath = EMPTY then
    return 0
  end if
  str = loadFile(fPath)
  if not stringp(str) then
    return 0
  end if
  sig = str.char[1..4]
  if (sig = ikMacSigStr) or (sig = ikWinSigStr) then
    return 1
  end if
  return 0
end
