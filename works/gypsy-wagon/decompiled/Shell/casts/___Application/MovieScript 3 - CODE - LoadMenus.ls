global gdmoCrntMode, gdmoActiveObjectList, gdmoNumActiveObjects, gdmoDemoConfigs, gdmoCrntDemoCategory, gdmoDemoMenus, gdmoCrntMenu, gdmoLaunchDemo, gdmoTextPoof, gdmoFiniteBottle, gdmoInfiniteBottle, gdmoMadBottle, gdmoEyeGuy, gdmoTheQuill, gdmoTheAnt, gdmoTheLantern, gdmoCricket, gdmoCandle, gMenuCenterX, gMenuLeftColX, gMenuRghtColX, gdmoQuillCharTable, gdmoQuillAsciiMap, gdmoMaxCharHeight, gdmoBaselineIncline, gdmoLeftArrowOnscreen, gdmoRghtArrowOnscreen, gdmoFiniteSprite, gdmoInfiniteSprite, gdmoMadSprite, gdmoMenuTitleSprite, gdmoQuillSprite, gdmoLanternSprite, gdmoCricketSprite, gdmoCandleSprite, gdmoWaxSprite, gdmoAntHeadSprite, gdmoantBodySprite, gdmoEyeGuySprite, gdmoLeftArrowSprite, gdmoRghtArrowSprite, gdmoPrestoSplash, gdmoInfMainSndChan, gdmoInfEvntSndChan, gdmoFinMainSndChan, gdmoFinEvntSndChan, gdmoMadMainSndChan, gdmoMadEvntSndChan, gdmoCandleSndChan, gdmoCricketSndChan, gdmoEyeGuySndChan, gdmoQuillSndChan, gdmoQuillAltSndChan, gdmoAmbiantSndChan, gdmoAntSndChan, gdmoPaperRasterMap, gdmoPaperLftX, gdmoPaperRgtX, gdmoPaperTopY, gdmoPaperBotY, gdmoMenuAreaTopY, gdmoMenuAreaBotY, gdmoPaperCurveY, gdmoPaperCurveSlope, gdmoNumAnimsRunning, gdmoLastMouseH, gdmoLastMouseV, g.obj.SystemManager, gdmoShellPuppets, gdmoPathDelimiter, gdmoShellRunPath, gdmoExternalDataPath, gdmoSmokeIsPlaying, gdmoDEBUG, gdmoCursorList, gdmoCursorIndex, gdmoDEBUGdemoLaunch, gdmoPrestoSplashPuppeted

on initQuill
  initAlphabet()
  set gdmoTheQuill to new(script "QuillManager Class", gdmoQuillSprite, gdmoQuillSndChan)
end

on initMenus
  set gMenuCenterX to (gdmoPaperLftX + gdmoPaperRgtX) / 2
  set gMenuLeftColX to ((gdmoPaperLftX + gMenuCenterX) / 2) + 10
  set gMenuRghtColX to ((gdmoPaperRgtX + gMenuCenterX) / 2) - 10
  set infiniteDemos to loadDemoConfigData("infinite")
  set finiteDemos to loadDemoConfigData("finite")
  set madnessDemos to loadDemoConfigData("madness")
  closeXLib()
  set gdmoDemoConfigs to list(infiniteDemos, finiteDemos, madnessDemos)
  set gdmoDemoMenus to []
  repeat with i = 1 to 3
    set iList to []
    set crntDemoList to getAt(gdmoDemoConfigs, i)
    set c to count(crntDemoList)
    repeat with k = 1 to c
      append(iList, new(script "GraphicTextClass", the demoTitle of getAt(crntDemoList, k)))
    end repeat
    set newMenu to new(script "Menu Class", iList)
    case i of
      1:
        set the titleCast of newMenu to member "title.infinite"
        set the titleLoc of newMenu to point(384, 112)
      2:
        set the titleCast of newMenu to member "title.finite"
        set the titleLoc of newMenu to point(371, 107)
      3:
        set the titleCast of newMenu to member "title.madness"
        set the titleLoc of newMenu to point(368, 114)
    end case
    append(gdmoDemoMenus, newMenu)
  end repeat
  set gdmoCrntDemoCategory to 0
  set gdmoCrntMenu to 0
end

on loadDemoConfigData catName
  if the machineType = 256 then
    set configPath to gdmoShellRunPath & catName & gdmoPathDelimiter
    set configFnam to configPath & "config.pc"
  else
    set configPath to gdmoShellRunPath & catName & gdmoPathDelimiter
    set configFnam to configPath & "config.mac"
  end if
  set fileReadSuccess to 0
  if gdmoDEBUG then
    put "mac & pc fileopen: <" & configFnam & ">"
  end if
  set gdmoConfigFptr to new(xtra("fileio"))
  openFile(gdmoConfigFptr, configFnam, 1)
  set fileStatus to status(gdmoConfigFptr)
  if fileStatus = 0 then
    set fileReadSuccess to 1
    set configText to readFile(gdmoConfigFptr)
    closeFile(gdmoConfigFptr)
    set gdmoConfigFptr to 0
  else
    put "*** Error opening file <" & configFnam & "> (" & fileStatus & " - " & error(gdmoConfigFptr, fileStatus) & ")"
  end if
  if fileReadSuccess then
    set demolist to []
    repeat with i = 1 to the number of lines in configText
      set cline to line i of configText
      if (cline <> EMPTY) and (char 1 of cline <> "#") then
        set newDemo to new(script "DemoConfigClass")
        set mtype to cleanSpaces(item 1 of cline)
        set the demoTitle of newDemo to cleanSpaces(item 2 of cline)
        set the demoPathName of newDemo to configPath & cleanSpaces(item 3 of cline)
        set the assocApp of newDemo to cleanSpaces(item 4 of cline)
        set the colrDepth of newDemo to integer(cleanSpaces(item 5 of cline))
        set the memRequired of newDemo to integer(cleanSpaces(item 6 of cline))
        case mtype of
          "DIR":
            set the mediaType of newDemo to #dirMovie
          "APP":
            set the mediaType of newDemo to #application
          "QTM":
            set the mediaType of newDemo to #QTmovie
          "AVI":
            set the mediaType of newDemo to #AVImovie
          "HTML":
            set the mediaType of newDemo to #HTML
          "PICT":
            set the mediaType of newDemo to #PICT
          otherwise:
            set the mediaType of newDemo to #unknown
        end case
        append(demolist, newDemo)
      end if
    end repeat
  else
    set failMsg to "Could not open config file!" && string(fileStatus)
    set demolist to []
    repeat with i = 1 to the number of words in failMsg
      set newDemo to new(script "DemoConfigClass")
      set the demoTitle of newDemo to word i of failMsg
      set the mediaType of newDemo to #unknown
      append(demolist, newDemo)
    end repeat
  end if
  return demolist
end

on cleanSpaces inString
  set lg to the length of inString
  set i1 to 1
  set i2 to lg
  repeat while char i1 of inString = " "
    set i1 to i1 + 1
    if i1 > lg then
      exit repeat
    end if
  end repeat
  repeat while char i2 of inString = " "
    set i2 to i2 - 1
    if i2 < 1 then
      exit repeat
    end if
  end repeat
  return chars(inString, i1, i2)
end
