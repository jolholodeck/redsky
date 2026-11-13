property ancestor, ikSndAssetPath, ikCDlibsPath, ikCurFrameSetID, ikLEnabledFrameSets, iPrefsFileName, ikUpdatesPath

on new me, pathdelim
  ancestor = new(script("DebugRoot.class"))
  ikCDlibsPath = the moviePath & "assets" & pathdelim & "lib" & pathdelim
  ikSndAssetPath = the moviePath & "assets" & pathdelim & "snd" & pathdelim
  return me
end
