property ioKbdHandler, ioSysEnvirons, ioCastLibMgr, ioPathMgr, ioWidgetQueueMgr, ioZordTransition, ioGlobalUI, ioProfiler, ioCursorControl, ioSongMgr, ioSong, iSongID, ioMemoryMgr, ancestor, ikDummyLibPath, ilkModuleLibPaths, iCurFrameSetID, ioCurFrameset, ilEnabledFramesets, ilSavedModuleIDs
global koConstants, goShellConstants, goMemoryMgr, goSongMgr, goSong, gSongID, gDebug

on new me
  if gDebug then
    ioProfiler = new(script("Profiler.class"), member("devFeedback", 1))
  end if
  goMemoryMgr = new(script("memoryMgr.class"))
  iCurFrameSetID = goShellConstants.ikCurFrameSetID
  ilEnabledFramesets = goShellConstants.ikLEnabledFrameSets
  ioZordTransition = new(script("ZordTransition.class"), me)
  ioZordTransition.mAssertPalette(iCurFrameSetID)
  go(the frame)
  lCursors = [#Active: [91, 92], #inactive: [93, 94], #wait: [95, 96]]
  ioCursorControl = new(script("CursorControl.class"), lCursors)
  ioSongMgr = goSongMgr
  ioSong = goSong
  iSongID = gSongID
  goSong = VOID
  gSongID = VOID
  ioSong.mConfigSong(goShellConstants.ikSndAssetPath & "Mainbank.rmf")
  append(the actorList, ioSongMgr)
  ioGlobalUI = new(script("GlobalUI.class"), me)
  ioKbdHandler = new(script("KbdHandler.class"), me)
  ikDummyLibPath = goShellConstants.ikCDlibsPath & koConstants.ikDummyLibName
  ioCastLibMgr = new(script("CastLibMgr.class"), ikDummyLibPath, 3, 16)
  ioPathMgr = new(script("PathMgr.class"))
  ioWidgetQueueMgr = new(script("WidgetQueueMgr.class"), koConstants.ikMaxNbWidgets)
  ilSavedModuleIDs = [0, 0, 0, 0, 0, 0]
  ilkModuleLibPaths = ioPathMgr.mGetInstalledModules()
  if koConstants.ikPrelinkLibs then
    me.prelinkLibs()
  end if
  me.mBuildCurFrameset()
  return me
end

on prelinkLibs me
  repeat with fsetData in ilkModuleLibPaths
    repeat with frameData in fsetData
      repeat with libPath in frameData
        if not stringp(libPath) then
          next repeat
        end if
        ms = the milliSeconds
        err = ioCastLibMgr.mLink(libPath)
        if err < 0 then
          alert("Couldn't link castLib " & libPath & RETURN & RETURN & "Error = " & err)
          halt()
        end if
        put string(the milliSeconds - ms) && libPath
      end repeat
    end repeat
  end repeat
end

on mBuildCurFrameset me
  ioCurFrameset = 0
  lModuleLibPaths = ilkModuleLibPaths[iCurFrameSetID]
  ioCurFrameset = new(script("Frameset.class"), me, iCurFrameSetID, lModuleLibPaths)
end

on mgotoframeset me, framesetID
  ioZordTransition.mDoTransition(iCurFrameSetID, framesetID)
end

on mGetFramesetState me, framesetID
  if (framesetID < 1) or (framesetID > ilEnabledFramesets.count) then
    return 0
  end if
  return ilEnabledFramesets[framesetID]
end

on mLoadModuleIDs me, framesetID
  return ilSavedModuleIDs[framesetID]
end

on mSaveModuleIDs me, framesetID, lModuleIDs
  ilSavedModuleIDs[framesetID] = lModuleIDs
end

on mEnableEvents me
  ioCurFrameset.mEnableMouse()
  ioKbdHandler.mEnableKbd()
end

on mDisableEvents me
  ioCursorControl.mClearCursor()
  ioCurFrameset.mDisableMouse()
  ioKbdHandler.mDisableKbd()
end
