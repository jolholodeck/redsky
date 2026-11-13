global gdmoCrntMode, gdmoActiveObjectList, gdmoNumActiveObjects, gdmoDemoConfigs, gdmoCrntDemoCategory, gdmoDemoMenus, gdmoCrntMenu, gdmoLaunchDemo, gdmoTextPoof, gdmoFiniteBottle, gdmoInfiniteBottle, gdmoMadBottle, gdmoEyeGuy, gdmoTheQuill, gdmoTheAnt, gdmoTheLantern, gdmoCricket, gdmoCandle, gMenuCenterX, gMenuLeftColX, gMenuRghtColX, gdmoQuillCharTable, gdmoQuillAsciiMap, gdmoMaxCharHeight, gdmoBaselineIncline, gdmoLeftArrowOnscreen, gdmoRghtArrowOnscreen, gdmoFiniteSprite, gdmoInfiniteSprite, gdmoMadSprite, gdmoMenuTitleSprite, gdmoQuillSprite, gdmoLanternSprite, gdmoCricketSprite, gdmoCandleSprite, gdmoWaxSprite, gdmoAntHeadSprite, gdmoantBodySprite, gdmoEyeGuySprite, gdmoLeftArrowSprite, gdmoRghtArrowSprite, gdmoPrestoSplash, gdmoInfMainSndChan, gdmoInfEvntSndChan, gdmoFinMainSndChan, gdmoFinEvntSndChan, gdmoMadMainSndChan, gdmoMadEvntSndChan, gdmoCandleSndChan, gdmoCricketSndChan, gdmoEyeGuySndChan, gdmoQuillSndChan, gdmoQuillAltSndChan, gdmoAmbiantSndChan, gdmoAntSndChan, gdmoPaperRasterMap, gdmoPaperLftX, gdmoPaperRgtX, gdmoPaperTopY, gdmoPaperBotY, gdmoMenuAreaTopY, gdmoMenuAreaBotY, gdmoPaperCurveY, gdmoPaperCurveSlope, gdmoNumAnimsRunning, gdmoLastMouseH, gdmoLastMouseV, g.obj.SystemManager, gdmoShellPuppets, gdmoPathDelimiter, gdmoShellRunPath, gdmoExternalDataPath, gdmoSmokeIsPlaying, gdmoDEBUG, gdmoCursorList, gdmoCursorIndex, gdmoDEBUGdemoLaunch, gdmoPrestoSplashPuppeted

on initShellGlobals
  set gdmoNumAnimsRunning to 0
  set gdmoLaunchDemo to 0
  set gdmoSmokeIsPlaying to 0
  set gdmoLeftArrowOnscreen to 0
  set gdmoRghtArrowOnscreen to 0
  set gdmoPrestoSplashPuppeted to 0
  set gdmoMenuTitleSprite to 16
  set gdmoQuillSprite to 18
  set gdmoantBodySprite to 26
  set gdmoAntHeadSprite to 27
  set gdmoPrestoSplash to 29
  set gdmoCricketSprite to 31
  set gdmoEyeGuySprite to 32
  set gdmoCandleSprite to 33
  set gdmoWaxSprite to 34
  set gdmoInfiniteSprite to 37
  set gdmoFiniteSprite to 38
  set gdmoMadSprite to 39
  set gdmoLanternSprite to 41
  set gdmoLeftArrowSprite to 43
  set gdmoRghtArrowSprite to 44
  if the machineType = 256 then
    set gdmoPathDelimiter to "\"
    set gdmoCandleSndChan to 3
    set gdmoAntSndChan to 3
    set gdmoCricketSndChan to 3
    set gdmoQuillSndChan to 3
    set gdmoQuillAltSndChan to 3
    set gdmoEyeGuySndChan to 1
    set gdmoAmbiantSndChan to 1
    set gdmoInfMainSndChan to 2
    set gdmoFinMainSndChan to 2
    set gdmoMadMainSndChan to 2
    set gdmoInfEvntSndChan to 1
    set gdmoFinEvntSndChan to 1
    set gdmoMadEvntSndChan to 1
  else
    set gdmoPathDelimiter to ":"
    set gdmoAntSndChan to 1
    set gdmoCandleSndChan to 2
    set gdmoEyeGuySndChan to 2
    set gdmoCricketSndChan to 3
    set gdmoQuillSndChan to 4
    set gdmoQuillAltSndChan to 5
    set gdmoAmbiantSndChan to 6
    set gdmoInfMainSndChan to 7
    set gdmoFinMainSndChan to 8
    set gdmoMadMainSndChan to 9
    set gdmoInfEvntSndChan to 10
    set gdmoFinEvntSndChan to 11
    set gdmoMadEvntSndChan to 12
  end if
  if the machineType = 256 then
    set gdmoShellRunPath to the pathName
  else
    set gdmoShellRunPath to the pathName
  end if
  set gdmoExternalDataPath to gdmoShellRunPath & "external" & gdmoPathDelimiter
  append(the searchPath, gdmoExternalDataPath)
  if gdmoDEBUG then
    put ">>> the pathname:      <" & the pathName & ">"
    put ">>> ShellRunPath:      <" & gdmoShellRunPath & ">"
    put ">>> ExternalDataPath:  <" & gdmoExternalDataPath & ">"
  end if
  set gdmoPaperLftX to 193
  set gdmoPaperRgtX to 532
  set gdmoPaperTopY to 95
  set gdmoPaperBotY to 426
  set gdmoMenuAreaTopY to 160
  set gdmoMenuAreaBotY to 342
  set gdmoPaperCurveY to 310
  set gdmoPaperCurveSlope to 0.10000000000000001
end

on createEngineObjects
  initPaperRasterMap()
  initQuill()
  initMenus()
  initTextPoof()
  initAnimationCycles()
  initAnt()
  initCricket()
  initEyeGuy()
  initCandle()
  initLantern()
  initBottles()
  pauseAllAnimations()
  hideAllAnimations()
end

on startShellEngine
  if the machineType = 256 then
    cursor([member "moonCursor", member "moonCursor.mask"])
  else
    openResFile(gdmoExternalDataPath & "RSICURS.RSC")
    set gdmoCursorIndex to 1
    set gdmoCursorList to [132, 135, 280, 131, 144, 136, 129, 128, 130, 133, 134, 137, 138, 139, 140, 141, 142, 143, -1]
    cursor(getAt(gdmoCursorList, gdmoCursorIndex))
  end if
  puppetSound(gdmoAmbiantSndChan, "wind+creak.aiff")
end

on preloadObjectData
  set the idleReadChunkSize to 65536
  if gdmoDEBUG then
    put "preloading all cast members"
  end if
  set st to the timer
  preLoad("Init", "EndOfScore")
  set en1 to the timer
  preloadMember("intro.mov", "distill.pict")
  preloadMember("ant.head.a.00001", "ant.dead.c.00016")
  preloadMember("abc.default", "abc.o. .1")
  preloadMember("cricketnew00000", "cricketnew00069")
  preloadMember("new new candle special00010", "blowright00119")
  preloadMember("candle.ignites", "ant.crush")
  preloadMember("crazy lantern pict00000", "crazy lantern pict00057")
  preloadMember("lpoof01", "rpoof14.pic")
  preloadMember("discreteroll00000", "madnessroll00049")
  preloadMember("eyeguy00000", "eyeguy00037")
  set en2 to the timer
  if gdmoDEBUG then
    put " (preload time = " & float(en2 - st) / 60.0 & " secs,  score in " & float(en1 - st) / 60.0 & " secs)"
  end if
end

on initAnt
  set gdmoTheAnt to new(script "AntClass", gdmoAntHeadSprite, gdmoantBodySprite, gdmoAntSndChan)
end

on initBottles
  global gdmoFiniteRollInCycle, gdmoFiniteRollLoopCycle, gdmoFiniteRollOutCycle, gdmoInfiniteRollInCycle, gdmoInfiniteRollLoopCycle, gdmoInfiniteRollOutCycle, gdmoMadRollInCycle, gdmoMadRollLoopCycle, gdmoMadRollOutCycle, gdmoInfiniteSmokeCycle, gdmoFiniteSmokeCycle, gdmoMadnessSmokeCycle
  set infEventQueue to [[member "infinite00000", #infInSound], [member "infinite00210", #putTitleUp], [member "infinite00227", #infOutSound], [member "infinite00228", #launchMenu], [-99, 0]]
  set gdmoInfiniteBottle to new(script "BottleClass", gdmoInfiniteSprite, gdmoInfMainSndChan, gdmoInfEvntSndChan, gdmoInfiniteRollInCycle, gdmoInfiniteRollLoopCycle, gdmoInfiniteRollOutCycle, gdmoInfiniteSmokeCycle, infEventQueue)
  set finEventQueue to [[member "finite00000", #finInSound], [member "finite00218", #putTitleUp], [member "finite00226", #finOutSound], [member "finite00239", #launchMenu], [-99, 0]]
  set gdmoFiniteBottle to new(script "BottleClass", gdmoFiniteSprite, gdmoFinMainSndChan, gdmoFinEvntSndChan, gdmoFiniteRollInCycle, gdmoFiniteRollLoopCycle, gdmoFiniteRollOutCycle, gdmoFiniteSmokeCycle, finEventQueue)
  set madEventQueue to [[member "madness00000", #madInSound], [member "madness00058", #madSkull], [member "madness00253", #putTitleUp], [member "madness00254", #madOutSound], [member "madness00255", #launchMenu], [-99, 0]]
  set gdmoMadBottle to new(script "BottleClass", gdmoMadSprite, gdmoMadMainSndChan, gdmoMadEvntSndChan, gdmoMadRollInCycle, gdmoMadRollLoopCycle, gdmoMadRollOutCycle, gdmoMadnessSmokeCycle, madEventQueue)
end

on initEyeGuy
  set gdmoEyeGuy to new(script "EyeGuyClass", gdmoEyeGuySprite, gdmoEyeGuySndChan)
end

on initTextPoof
  set gdmoTextPoof to new(script "TextPoofClass", gdmoQuillSprite, gdmoQuillSndChan)
end

on initLantern
  set gdmoTheLantern to new(script "LanternClass", gdmoLanternSprite)
end

on initCricket
  set gdmoCricket to new(script "CricketClass", gdmoCricketSprite, gdmoCricketSndChan)
end

on initCandle
  set gdmoCandle to new(script "CandleClass", gdmoCandleSprite, gdmoWaxSprite)
end

on initPaperRasterMap
  set antSubSample to 3
  set dx to 16
  set dy to 16
  set x1 to gdmoPaperLftX - dx
  set x2 to gdmoPaperRgtX + dx
  set y1 to gdmoPaperTopY - dy
  set y2 to gdmoPaperBotY + dy
  set gdmoPaperRasterMap to new(script "RasterMap Class", x1, y1, x2, y2, dx, dy)
  setValForArea(gdmoPaperRasterMap, x1, y1, x2, y1 + dy, #paperEdge)
  setValForArea(gdmoPaperRasterMap, x1, y1, x1 + dx, y2, #paperEdge)
  setValForArea(gdmoPaperRasterMap, x2 - dx, y1, x2, y2, #paperEdge)
  setValForArea(gdmoPaperRasterMap, x1 - dx, y2 - dy, x2, y2, #paperEdge)
end

on displayCurrentMenuTitle
  puppetSprite(gdmoMenuTitleSprite, 1)
  set the member of sprite gdmoMenuTitleSprite to the titleCast of gdmoCrntMenu
  set the loc of sprite gdmoMenuTitleSprite to the titleLoc of gdmoCrntMenu
  set the visible of sprite gdmoMenuTitleSprite to 1
end

on getRegionOfSprite sptChn
  set lc to the loc of sprite sptChn
  set sptMember to the member of sprite sptChn
  set rp to the regPoint of member sptMember
  set x1 to getAt(lc, 1) - getAt(rp, 1)
  set y1 to getAt(lc, 2) - getAt(rp, 2)
  set x2 to x1 + the width of member sptMember
  set y2 to y1 + the height of member sptMember
  return rect(x1, y1, x2, y2)
end

on getBaselineDroop x, y
  set percentDownY to (y - gdmoMenuAreaTopY) / float(gdmoMenuAreaBotY - gdmoMenuAreaTopY)
  set percentRghtX to (x - gdmoPaperLftX) / float(gdmoPaperRgtX - gdmoPaperLftX)
  return percentDownY * percentRghtX * 15
end

on charTableGetIndex chr
  set a to charToNum(chr)
  if (a > 29) and (a < 127) then
    set i to getAt(gdmoQuillAsciiMap, a - 29)
  else
    set i to 1
  end if
  return i
end

on charTableDump
  repeat with i = 0 to 255
    set c to numToChar(i)
    set idx to charTableGetIndex(c)
    put i, c, idx, the name of member getAt(getAt(gdmoQuillCharTable, idx), 2)
  end repeat
end

on initMenuScreenMode
  set gdmoLeftArrowOnscreen to 0
  set gdmoRghtArrowOnscreen to 0
  playAllAnimations()
  showAllAnimations()
  objPause(gdmoTheAnt)
  objHide(gdmoTheAnt)
  if objectp(gdmoCrntMenu) and (gdmoSmokeIsPlaying = 0) and (the quillMode of gdmoTheQuill <> #erasing) then
    quillQueueMenu(gdmoTheQuill, gdmoCrntMenu)
  end if
  set gdmoCrntMode to #onMenuScreen
end

on hideAllAnimations
  if objectp(gdmoTheAnt) then
    objHide(gdmoTheAnt)
  end if
  if objectp(gdmoTheQuill) then
    objHide(gdmoTheQuill)
  end if
  if objectp(gdmoCricket) then
    objHide(gdmoCricket)
  end if
  if objectp(gdmoEyeGuy) then
    objHide(gdmoEyeGuy)
  end if
  if objectp(gdmoCandle) then
    objHide(gdmoCandle)
  end if
  if objectp(gdmoTheLantern) then
    objHide(gdmoTheLantern)
  end if
  if objectp(gdmoFiniteBottle) then
    objHide(gdmoFiniteBottle)
  end if
  if objectp(gdmoInfiniteBottle) then
    objHide(gdmoInfiniteBottle)
  end if
  if objectp(gdmoMadBottle) then
    objHide(gdmoMadBottle)
  end if
  set the visible of sprite gdmoMenuTitleSprite to 0
  set the puppet of sprite gdmoMenuTitleSprite to 0
  set the visible of sprite gdmoLeftArrowSprite to 0
  set the puppet of sprite gdmoLeftArrowSprite to 0
  set the visible of sprite gdmoRghtArrowSprite to 0
  set the puppet of sprite gdmoRghtArrowSprite to 0
  if gdmoPrestoSplashPuppeted then
    set the visible of sprite gdmoPrestoSplash to 0
    set the puppet of sprite gdmoPrestoSplash to 0
  end if
end

on showAllAnimations
  if objectp(gdmoTheAnt) then
    objShow(gdmoTheAnt)
  end if
  if objectp(gdmoTheQuill) then
    objShow(gdmoTheQuill)
  end if
  if objectp(gdmoCricket) then
    objShow(gdmoCricket)
  end if
  if objectp(gdmoEyeGuy) then
    objShow(gdmoEyeGuy)
  end if
  if objectp(gdmoCandle) then
    objShow(gdmoCandle)
  end if
  if objectp(gdmoTheLantern) then
    objShow(gdmoTheLantern)
  end if
  if objectp(gdmoFiniteBottle) then
    objShow(gdmoFiniteBottle)
  end if
  if objectp(gdmoInfiniteBottle) then
    objShow(gdmoInfiniteBottle)
  end if
  if objectp(gdmoMadBottle) then
    objShow(gdmoMadBottle)
  end if
  set the visible of sprite gdmoMenuTitleSprite to 1
  set the puppet of sprite gdmoMenuTitleSprite to 1
  if gdmoLeftArrowOnscreen then
    set the visible of sprite gdmoLeftArrowSprite to 1
    set the puppet of sprite gdmoLeftArrowSprite to 1
  end if
  if gdmoRghtArrowOnscreen then
    set the visible of sprite gdmoRghtArrowSprite to 1
    set the puppet of sprite gdmoRghtArrowSprite to 1
  end if
  if gdmoPrestoSplashPuppeted then
    set the visible of sprite gdmoPrestoSplash to 1
    set the puppet of sprite gdmoPrestoSplash to 1
  end if
end

on playAllAnimations
  if objectp(gdmoTheAnt) then
    objPlay(gdmoTheAnt)
  end if
  if objectp(gdmoTheQuill) then
    objPlay(gdmoTheQuill)
  end if
  if objectp(gdmoCricket) then
    objPlay(gdmoCricket)
  end if
  if objectp(gdmoEyeGuy) then
    objPlay(gdmoEyeGuy)
  end if
  if objectp(gdmoCandle) then
    objPlay(gdmoCandle)
  end if
  if objectp(gdmoTheLantern) then
    objPlay(gdmoTheLantern)
  end if
  if objectp(gdmoFiniteBottle) then
    objPlay(gdmoFiniteBottle)
  end if
  if objectp(gdmoInfiniteBottle) then
    objPlay(gdmoInfiniteBottle)
  end if
  if objectp(gdmoMadBottle) then
    objPlay(gdmoMadBottle)
  end if
end

on pauseAllAnimations
  if objectp(gdmoTheAnt) then
    objPause(gdmoTheAnt)
  end if
  if objectp(gdmoTheQuill) then
    objPause(gdmoTheQuill)
  end if
  if objectp(gdmoCricket) then
    objPause(gdmoCricket)
  end if
  if objectp(gdmoEyeGuy) then
    objPause(gdmoEyeGuy)
  end if
  if objectp(gdmoCandle) then
    objPause(gdmoCandle)
  end if
  if objectp(gdmoTheLantern) then
    objPause(gdmoTheLantern)
  end if
  if objectp(gdmoFiniteBottle) then
    objPause(gdmoFiniteBottle)
  end if
  if objectp(gdmoInfiniteBottle) then
    objPause(gdmoInfiniteBottle)
  end if
  if objectp(gdmoMadBottle) then
    objPause(gdmoMadBottle)
  end if
end

on stopAllAnimations
  hideAllAnimations()
  if objectp(gdmoTheAnt) then
    objDelete(gdmoTheAnt)
  end if
  if objectp(gdmoTheQuill) then
    objDelete(gdmoTheQuill)
  end if
  if objectp(gdmoCricket) then
    objDelete(gdmoCricket)
  end if
  if objectp(gdmoEyeGuy) then
    objDelete(gdmoEyeGuy)
  end if
  if objectp(gdmoCandle) then
    objDelete(gdmoCandle)
  end if
  if objectp(gdmoTheLantern) then
    objDelete(gdmoTheLantern)
  end if
  if objectp(gdmoFiniteBottle) then
    objDelete(gdmoFiniteBottle)
  end if
  if objectp(gdmoInfiniteBottle) then
    objDelete(gdmoInfiniteBottle)
  end if
  if objectp(gdmoMadBottle) then
    objDelete(gdmoMadBottle)
  end if
  set gdmoTheAnt to 0
  set gdmoTheQuill to 0
  set gdmoCricket to 0
  set gdmoCandle to 0
  set gdmoTheLantern to 0
  set gdmoFiniteBottle to 0
  set gdmoInfiniteBottle to 0
  set gdmoMadBottle to 0
end
