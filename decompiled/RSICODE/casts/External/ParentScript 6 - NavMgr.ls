property ikWorkKey, ikEntertainmentKey, ikSpeakerKey, ikExitKey, ikQuitKey, ikRunningFromCD, ikWorkFilePath, ikEntertainmentFilePath, ikSpeakerFilePath, ikExitFilePath, ikPrjFilePath, iPrevModuleID, ikOStype, ikDriveName, ikSystemDrive, ikFileSep, ikWorkFolder, ikEntertainmentFolder, ikSpeakerFolder, ikExitFolder, ikWorkFile, ikEntertainmentFile, ikSpeakerFile, ikExitFile, ilkModuleIDs, iCurModuleID, ikDXRfiles, ikColDepth, ikVolume
global goStateMgr, goFlickerMgr, goNavMgr

on mRestoreSystem me
  if ikVolume >= 0 then
    set the soundLevel to ikVolume
  end if
  if ikOStype <> #mac then
    exit
  end if
  if ikColDepth < 0 then
    exit
  end if
  set the colorDepth to ikColDepth
end

on new me, origColorDepth, origVolume
  set ikColDepth to -1
  if integerp(origColorDepth) then
    set ikColDepth to origColorDepth
  end if
  set ikVolume to -1
  if integerp(origVolume) then
    set ikVolume to origVolume
  end if
  set ikDXRfiles to 0
  if ikDXRfiles then
    set fileExt to ".DXR"
  else
    set fileExt to ".DIR"
  end if
  if the machineType = 256 then
    set ikOStype to #win
    set ikFileSep to "\"
  else
    set ikOStype to #mac
    set ikFileSep to ":"
  end if
  set ikPrjFilePath to the pathName
  set oldDelim to the itemDelimiter
  set the itemDelimiter to ikFileSep
  set ikDriveName to item 1 of (the pathName)
  set the itemDelimiter to oldDelim
  set ikRunningFromCD to 1
  if mIsXtraAvailable(me, "fileXtra") then
    if DriveIsCDROM(ikDriveName) = -61 then
      set ikRunningFromCD to 0
    end if
  end if
  if not mIsXtraAvailable(me, "fileIO") then
    alert("Xtra FileIO not found.")
    halt()
  end if
  set osPath to getOSDirectory()
  set oldDelim to the itemDelimiter
  set the itemDelimiter to ikFileSep
  set ikSystemDrive to item 1 of osPath
  set the itemDelimiter to oldDelim
  set ikWorkFolder to "WORK_MODULE" & ikFileSep
  set ikEntertainmentFolder to "ENTERTAINMENT_MODULE" & ikFileSep
  set ikSpeakerFolder to "SPEAKER_MODULE" & ikFileSep
  set ikExitFolder to "EXIT_MODULE" & ikFileSep
  set ikWorkFile to "WORK" & fileExt
  set ikEntertainmentFile to "ENTERTAINMENT" & fileExt
  set ikSpeakerFile to "SHOWMAN" & fileExt
  set ikExitFile to "EXIT" & fileExt
  set curPath to the pathName
  set ikWorkFilePath to curPath & ikWorkFolder & ikWorkFile
  set ikEntertainmentFilePath to curPath & ikEntertainmentFolder & ikEntertainmentFile
  set ikSpeakerFilePath to curPath & ikSpeakerFolder & ikSpeakerFile
  set ikExitFilePath to curPath & ikExitFolder & ikExitFile
  set ikWorkKey to 13
  set ikEntertainmentKey to 14
  set ikSpeakerKey to 1
  set ikExitKey to 7
  set ikQuitKey to 12
  set iCurModuleID to #startup
  set iPrevModuleID to iCurModuleID
  set ilkModuleIDs to [:]
  addProp(ilkModuleIDs, #work, ikWorkFilePath)
  addProp(ilkModuleIDs, #entertainment, ikEntertainmentFilePath)
  addProp(ilkModuleIDs, #speaker, ikSpeakerFilePath)
  addProp(ilkModuleIDs, #exit, ikExitFilePath)
  return me
end

on mCheckModuleKey me
  if not (the controlDown) then
    return #none
  end if
  set curKey to the keyCode
  set curMovie to the movie
  case curKey of
    ikWorkKey:
      if curMovie <> ikWorkFile then
        return #work
      end if
    ikEntertainmentKey:
      if curMovie <> ikEntertainmentFile then
        return #entertainment
      end if
    ikSpeakerKey:
      if curMovie <> ikSpeakerFile then
        return #speaker
      end if
    ikExitKey:
      if curMovie <> ikExitFile then
        return #exit
      end if
    ikQuitKey:
      return #quit
    otherwise:
      return #none
  end case
  return #none
end

on mGotoModule me, moduleID
  if not symbolp(moduleID) then
    exit
  end if
  set dstPath to getaProp(ilkModuleIDs, moduleID)
  if not stringp(dstPath) then
    exit
  end if
  set iPrevModuleID to iCurModuleID
  set iCurModuleID to moduleID
  set tempStateObj to goStateMgr
  set tempFlickerMgr to goFlickerMgr
  set tempNavMgr to me
  clearGlobals()
  set the actorList to []
  set the keyDownScript to EMPTY
  set the keyUpScript to EMPTY
  set the mouseDownScript to EMPTY
  set the mouseUpScript to EMPTY
  set the timeoutScript to EMPTY
  cursor(200)
  set goStateMgr to tempStateObj
  set goFlickerMgr to tempFlickerMgr
  set goNavMgr to tempNavMgr
  repeat with x = 1 to 4
    puppetSound(x, 0)
    sound stop x
    sound close x
  end repeat
  go(1, dstPath)
  abort()
end

on mFadeToBlack me
  set fadeSpr to 120
  set dotMbr to the number of member "DotMbr" of castLib "RSIcode"
  set maskMbr to the number of member "ScreenMask" of castLib "RSIcode"
  set maskRect to offset(the rect of the stage, -(the stageLeft), -(the stageTop))
  set fadeTime to 27
  puppetSprite(fadeSpr, 1)
  set the blend of sprite fadeSpr to 20
  set the memberNum of sprite fadeSpr to dotMbr
  set the rect of sprite fadeSpr to maskRect
  updateStage()
  puppetPalette("nearBlackPalette", fadeTime)
  updateStage()
  set the blend of sprite fadeSpr to 100
  updateStage()
  repeat with x = 1 to 119
    puppetSprite(x, 0)
  end repeat
  go("dmo_black")
  updateStage()
end

on mPurgeAllSounds me
  set volInc to 2
  set volList to []
  repeat with chan = 1 to 4
    add(volList, the volume of sound chan)
  end repeat
  repeat while volList <> [0, 0, 0, 0]
    repeat with chan = 1 to 4
      if soundBusy(chan) then
        set vol to getAt(volList, chan)
        set vol to max(vol - volInc, 0)
        setAt(volList, chan, vol)
        next repeat
      end if
      setAt(volList, chan, 0)
    end repeat
    set chan to 0
    repeat with vol in volList
      set chan to chan + 1
      set the volume of sound chan to vol
    end repeat
    updateStage()
  end repeat
  repeat with chan = 1 to 4
    puppetSound(chan, 0)
    sound stop chan
    sound close chan
  end repeat
  updateStage()
  repeat with chan = 1 to 4
    set the volume of sound chan to 255
  end repeat
end

on mIsXtraAvailable me, xtraName
  set nbXtras to the number of xtras
  repeat with i = 1 to nbXtras
    if the name of xtra(i) contains xtraName then
      return 1
    end if
  end repeat
  return 0
end

on mGetPropList me
  set cnt to count(me)
  set lProps to [:]
  repeat with x = 1 to cnt
    set curProp to getPropAt(me, x)
    set curVal to getaProp(me, curProp)
    addProp(lProps, curProp, curVal)
  end repeat
  return lProps
end

on mDumpPropList me
  set lProps to mGetPropList(me)
  set cnt to count(lProps)
  set outStr to EMPTY
  repeat with x = 1 to cnt
    set curProp to getPropAt(me, x)
    set curVal to getaProp(me, curProp)
    put string(curProp) & " = " & string(curVal) & RETURN after outStr
  end repeat
  return outStr
end
