global gdmoCrntMode, gdmoActiveObjectList, gdmoNumActiveObjects, gdmoDemoConfigs, gdmoCrntDemoCategory, gdmoDemoMenus, gdmoCrntMenu, gdmoLaunchDemo, gdmoTextPoof, gdmoFiniteBottle, gdmoInfiniteBottle, gdmoMadBottle, gdmoEyeGuy, gdmoTheQuill, gdmoTheAnt, gdmoTheLantern, gdmoCricket, gdmoCandle, gMenuCenterX, gMenuLeftColX, gMenuRghtColX, gdmoQuillCharTable, gdmoQuillAsciiMap, gdmoMaxCharHeight, gdmoBaselineIncline, gdmoLeftArrowOnscreen, gdmoRghtArrowOnscreen, gdmoFiniteSprite, gdmoInfiniteSprite, gdmoMadSprite, gdmoMenuTitleSprite, gdmoQuillSprite, gdmoLanternSprite, gdmoCricketSprite, gdmoCandleSprite, gdmoWaxSprite, gdmoAntHeadSprite, gdmoantBodySprite, gdmoEyeGuySprite, gdmoLeftArrowSprite, gdmoRghtArrowSprite, gdmoPrestoSplash, gdmoInfMainSndChan, gdmoInfEvntSndChan, gdmoFinMainSndChan, gdmoFinEvntSndChan, gdmoMadMainSndChan, gdmoMadEvntSndChan, gdmoCandleSndChan, gdmoCricketSndChan, gdmoEyeGuySndChan, gdmoQuillSndChan, gdmoQuillAltSndChan, gdmoAmbiantSndChan, gdmoAntSndChan, gdmoPaperRasterMap, gdmoPaperLftX, gdmoPaperRgtX, gdmoPaperTopY, gdmoPaperBotY, gdmoMenuAreaTopY, gdmoMenuAreaBotY, gdmoPaperCurveY, gdmoPaperCurveSlope, gdmoNumAnimsRunning, gdmoLastMouseH, gdmoLastMouseV, g.obj.SystemManager, gdmoShellPuppets, gdmoPathDelimiter, gdmoShellRunPath, gdmoExternalDataPath, gdmoSmokeIsPlaying, gdmoDEBUG, gdmoCursorList, gdmoCursorIndex, gdmoDEBUGdemoLaunch, gdmoPrestoSplashPuppeted, kdmoOStype, g.demoLaunched

on startMovie
  if the machineType = 256 then
    set kdmoOStype to #win
  else
    set kdmoOStype to #mac
  end if
  set the fileName of member 1 of castLib "gfx.General" to the pathName & "intro.mov"
  set g.demoLaunched to 0
  if kdmoOStype = #win then
    if the colorDepth <> 8 then
      alert("Red Sky 97 Demo requires that the screen be set at 256 colors.  Please change the screen to 256 colors and restart the Demo.")
      quit()
    end if
  end if
  set gdmoDEBUG to 0
  if gdmoDEBUG then
    put "*** CLEARING GLOBALS ***"
    cg()
    set gdmoDEBUG to 1
    put "FREEBYTES - startmovie:"
    initFreeMemCheck()
    put "<<shell startmovie>>"
  end if
  set gdmoDEBUGdemoLaunch to 1
  set the exitLock to 0
  set the preLoadEventAbort to 0
end

on preloadAndInit
  set gdmoCrntMode to #startingUp
  if objectp(g.obj.SystemManager) = 0 then
    if gdmoDEBUG then
      put "/--------------------------------------------------------------------\"
      put "|  VERSION 1.8 RELEASE NOTES"
      put "|"
      put "|  cursor  - hitting <spacebar> cycles thru the cursors Gen developed"
      put "|"
      put "\--------------------------------------------------------------------/"
      put 
    end if
    set st to the timer
    initShellGlobals()
    set en1 to the timer
    set g.obj.SystemManager to new(script "SystemManager Class")
    if kdmoOStype = #mac then
      openXLib(gdmoExternalDataPath & "FileIO.mac")
    else
    end if
    createEngineObjects()
    set en2 to the timer
    if gdmoDEBUG then
      put " (init vars time   = " & float(en1 - st) / 60.0 & " secs)"
      put " (create objs time = " & float(en2 - en1) / 60.0 & " secs)"
    end if
  else
    if gdmoDEBUG then
      put "GLOBAL OBJECT ALREADY INITED.  use 'cg' if this is wrong."
    end if
  end if
  startShellEngine()
  puppetSprite(2, 1)
  set the member of sprite 2 to member "distill.pict"
  updateStage()
  if gdmoDEBUG then
    put "FREEBYTES - post-object init: "
    updateFreeMemCheck()
  end if
  preloadObjectData()
  if gdmoDEBUG then
    put "FREEBYTES - post-preload: "
    updateFreeMemCheck()
  end if
  set the loc of sprite 2 to point(-1000, 300)
  puppetSprite(2, 0)
  updateStage()
  if gdmoDEBUG then
    initFramesPerSecTimer()
  end if
end

on updateAllObjects
  objUpdate(gdmoTheAnt)
  objUpdate(gdmoTheLantern)
  objUpdate(gdmoTheQuill)
  objUpdate(gdmoCricket)
  objUpdate(gdmoEyeGuy)
  objUpdate(gdmoCandle)
  objUpdate(gdmoFiniteBottle)
  objUpdate(gdmoInfiniteBottle)
  objUpdate(gdmoMadBottle)
  if the machineType = 256 then
    if soundBusy(gdmoAmbiantSndChan) = 0 then
      puppetSound(gdmoAmbiantSndChan, "wind+creak.aiff")
    end if
  end if
end

on enterFrame
  case gdmoCrntMode of
    #startingUp:
      if objectp(gdmoTheLantern) then
        objUpdate(gdmoTheLantern)
      end if
      if objectp(gdmoCandle) then
        objUpdate(gdmoCandle)
      end if
    #launchingDemo:
    #poofingSelection:
      updateAllObjects()
      objUpdate(gdmoTextPoof)
      if the objAnimMode of gdmoTextPoof = #resting then
        objPause(gdmoTextPoof)
        objHide(gdmoTextPoof)
        set gdmoCrntMode to #launchingDemo
        go("LaunchDemo")
      end if
    #onMenuScreen:
      updateAllObjects()
  end case
end

on exitFrame
  global gdmoExitFrameLastRolloverIdx
  if gdmoDEBUG then
    updateFramesPerSecTimer()
  end if
  case gdmoCrntMode of
    #startingUp:
    #launchingDemo:
    #poofingSelection:
    #onMenuScreen:
      if (the mouseH > 23) and (the mouseH < 122) and ((the mouseV > 363) and (the mouseV < 414)) then
        objrollover(gdmoCricket)
      end if
      if (the mouseH > 531) and (the mouseH < 627) and ((the mouseV > 31) and (the mouseV < 112)) then
        objrollover(gdmoCandle)
      end if
      if (the mouseH > 19) and (the mouseH < 173) and ((the mouseV > 139) and (the mouseV < 240)) then
        if the mouseH < 78 then
          objrollover(gdmoInfiniteBottle)
        else
          if the mouseH < 126 then
            objrollover(gdmoFiniteBottle)
          else
            objrollover(gdmoMadBottle)
          end if
        end if
      end if
      if objectp(gdmoCrntMenu) and (gdmoSmokeIsPlaying = 0) and (the quillMode of gdmoTheQuill <> #erasing) then
        set rastVal to getVal(gdmoPaperRasterMap, the mouseH, the mouseV)
        if (rastVal = #text1) or (rastVal = #text2) then
          set idx to menuGetRollOverIndex(gdmoCrntMenu, the mouseH, the mouseV)
          if gdmoExitFrameLastRolloverIdx <> idx then
            set gdmoExitFrameLastRolloverIdx to idx
            set antPt to menuGetRollOverIconPoint(gdmoCrntMenu, the mouseH, the mouseV)
            set ax to getAt(antPt, 1)
            set ay to getAt(antPt, 2)
            antTeleportToPosition(gdmoTheAnt, ax, ay)
            antSetRandomDestination(gdmoTheAnt)
          end if
        else
          set gdmoExitFrameLastRolloverIdx to 0
        end if
      end if
      set gdmoLastMouseH to the mouseH
      set gdmoLastMouseV to the mouseV
  end case
end

on mouseUp
  case gdmoCrntMode of
    #startingUp:
    #launchingDemo:
    #poofingSelection:
    #onMenuScreen:
      if the antAction of gdmoTheAnt <> #nothing then
        if the shiftDown then
          append(the antWayPointList of gdmoTheAnt, point(the mouseH, the mouseV))
        else
          antSetDestination(gdmoTheAnt, point(the mouseH, the mouseV))
        end if
      end if
      set dx to abs(the mouseH - the antX of gdmoTheAnt)
      set dy to abs(the mouseV - the antY of gdmoTheAnt)
      if (dx + dy) < 20 then
        objClicked(gdmoTheAnt)
      end if
      if (the mouseH > 23) and (the mouseH < 122) and ((the mouseV > 363) and (the mouseV < 414)) then
        objClicked(gdmoCricket)
      end if
      if (the mouseH > 533) and (the mouseH < 614) and ((the mouseV > 293) and (the mouseV < 377)) then
        objClicked(gdmoEyeGuy)
      end if
      if gdmoLeftArrowOnscreen and rollOver(gdmoLeftArrowSprite) then
        menuJumpRelativePage(gdmoCrntMenu, -1)
      end if
      if gdmoRghtArrowOnscreen and rollOver(gdmoRghtArrowSprite) then
        menuJumpRelativePage(gdmoCrntMenu, 1)
      end if
      if gdmoSmokeIsPlaying = 0 then
        if (the mouseH > 19) and (the mouseH < 173) and ((the mouseV > 139) and (the mouseV < 240)) then
          if the mouseH < 78 then
            set gdmoCrntDemoCategory to 1
            objClicked(gdmoInfiniteBottle)
          else
            if the mouseH < 126 then
              set gdmoCrntDemoCategory to 2
              objClicked(gdmoFiniteBottle)
            else
              set gdmoCrntDemoCategory to 3
              objClicked(gdmoMadBottle)
            end if
          end if
          quillQueueRasterValErase(gdmoTheQuill, #menuTitle)
          quillEmptyWritingQueues(gdmoTheQuill)
          quillEraseCurrentMenu(gdmoTheQuill)
          set gdmoCrntMenu to getAt(gdmoDemoMenus, gdmoCrntDemoCategory)
        end if
      end if
      if objectp(gdmoCrntMenu) and (gdmoSmokeIsPlaying = 0) and (the quillMode of gdmoTheQuill <> #erasing) then
        set rastVal to getVal(gdmoPaperRasterMap, the mouseH, the mouseV)
        if (rastVal = #text1) or (rastVal = #text2) then
          set idx to menuGetRollOverIndex(gdmoCrntMenu, the mouseH, the mouseV)
          set cfg to getAt(gdmoDemoConfigs, gdmoCrntDemoCategory)
          set demo to getAt(cfg, idx)
          if gdmoDEBUGdemoLaunch then
            put ">>>DEMO SELECTED<<<"
            dump(demo)
          end if
          if the mediaType of demo <> #unknown then
            if the mediaType of demo = #dirMovie then
              set gdmoLaunchDemo to demo
              clearValFromMap(gdmoPaperRasterMap, #text1)
              clearValFromMap(gdmoPaperRasterMap, #text2)
              quillEmptyWritingQueues(gdmoTheQuill)
              quillHideQuillSprites(gdmoTheQuill)
              set tpx to the txtX of getAt(the itemList of gdmoCrntMenu, idx)
              set tpy to the txtY of getAt(the itemList of gdmoCrntMenu, idx)
              set crntPage to getAt(the pageList of gdmoCrntMenu, the crntPageIndex of gdmoCrntMenu)
              if the numColumns of crntPage = 2 then
                set goLeftFlag to tpx < gMenuCenterX
              else
                set goLeftFlag to random(2) = 1
              end if
              case goLeftFlag of
                1:
                  set tpx to gdmoPaperLftX
                0:
                  set tpx to gdmoPaperRgtX
              end case
              set the trails of sprite gdmoQuillSprite to 0
              launchTextPoof(gdmoTextPoof, tpx, tpy, goLeftFlag)
              set gdmoCrntMode to #poofingSelection
            else
              if gdmoDEBUGdemoLaunch then
                put "DemoLaunch:  The shell can only handle Director movies currently."
                put "DemoLaunch:  " & the demoTitle of demo & " is of type:  " & the mediaType of demo
              end if
            end if
          end if
        end if
      end if
  end case
end

on keyDown
  case gdmoCrntMode of
    #startingUp:
    #launchingDemo:
    #poofingSelection:
    #quitDemo:
    #onMenuScreen:
      set categoryIndex to 0
      if the antAction of gdmoTheAnt <> #nothing then
        antSetRandomDestination(gdmoTheAnt)
      end if
      case charToNum(the key) of
        32:
          if the machineType <> 256 then
            set gdmoCursorIndex to gdmoCursorIndex + 1
            if gdmoCursorIndex > count(gdmoCursorList) then
              set gdmoCursorIndex to 1
            end if
            cursor(getAt(gdmoCursorList, gdmoCursorIndex))
          end if
        13:
          go("ShellQuit")
        49:
          set categoryIndex to 1
        50:
          set categoryIndex to 2
        51:
          set categoryIndex to 3
      end case
      if (categoryIndex > 0) and (gdmoSmokeIsPlaying = 0) then
        if categoryIndex <> gdmoCrntDemoCategory then
          quillQueueRasterValErase(gdmoTheQuill, #menuTitle)
        end if
        set gdmoCrntDemoCategory to categoryIndex
        set gdmoCrntMenu to getAt(gdmoDemoMenus, gdmoCrntDemoCategory)
        quillEmptyWritingQueues(gdmoTheQuill)
        quillQueueMenu(gdmoTheQuill, gdmoCrntMenu)
      end if
  end case
end

on stopMovie
  if the machineType <> 256 then
    if gdmoDEBUG then
      put "closing RSICURS"
    end if
    closeResFile()
  end if
end
