global gdmoCrntMode, gdmoActiveObjectList, gdmoNumActiveObjects, gdmoDemoConfigs, gdmoCrntDemoCategory, gdmoDemoMenus, gdmoCrntMenu, gdmoLaunchDemo, gdmoTextPoof, gdmoFiniteBottle, gdmoInfiniteBottle, gdmoMadBottle, gdmoEyeGuy, gdmoTheQuill, gdmoTheAnt, gdmoTheLantern, gdmoCricket, gdmoCandle, gMenuCenterX, gMenuLeftColX, gMenuRghtColX, gdmoQuillCharTable, gdmoQuillAsciiMap, gdmoMaxCharHeight, gdmoBaselineIncline, gdmoFiniteSprite, gdmoInfiniteSprite, gdmoMadSprite, gdmoMenuTitleSprite, gdmoQuillSprite, gdmoLanternSprite, gdmoCricketSprite, gdmoCandleSprite, gdmoWaxSprite, gdmoAntHeadSprite, gdmoantBodySprite, gdmoEyeGuySprite, gdmoInfMainSndChan, gdmoInfEvntSndChan, gdmoFinMainSndChan, gdmoFinEvntSndChan, gdmoMadMainSndChan, gdmoMadEvntSndChan, gdmoCandleSndChan, gdmoCricketSndChan, gdmoEyeGuySndChan, gdmoQuillSndChan, gdmoQuillAltSndChan, gdmoAmbiantSndChan, gdmoAntSndChan, gdmoPaperRasterMap, gdmoPaperLftX, gdmoPaperRgtX, gdmoPaperTopY, gdmoPaperBotY, gdmoMenuAreaTopY, gdmoMenuAreaBotY, gdmoPaperCurveY, gdmoPaperCurveSlope, gdmoNumAnimsRunning, gdmoLastMouseH, gdmoLastMouseV, g.obj.SystemManager, gdmoShellPuppets, gdmoPathDelimiter, gdmoExternalDataPath, gdmoSmokeIsPlaying, gdmoCursorList, gdmoCursorIndex

on dumpMemoryState
  put "GLOBAL OBJECT"
  put " obj: ", g.obj.SystemManager
  if objectp(g.obj.SystemManager) then
    put " retkey:  ", the demoReturnKey of g.obj.SystemManager
    put " stored puppet states:  ", count(the puppetStateList of g.obj.SystemManager)
  end if
  put 
  put "STATE VARS"
  put " current mode: ", gdmoCrntMode
  put " demoCategory: ", gdmoCrntDemoCategory
  put " current menu: ", gdmoCrntMenu
  put " launch demo:  ", gdmoLaunchDemo
  put 
  put "GLOBAL VAR TEST"
  put " paper top/bot/lft/rgt: ", gdmoPaperTopY, gdmoPaperBotY, gdmoPaperLftX, gdmoPaperRgtX
  put " cursor index: ", gdmoCursorIndex
  put " cursor list:  ", gdmoCursorList
  put 
  put "WORLD OBJECTS"
  put " gdmoTheQuill:   ", gdmoTheQuill
  put " gdmoTheAnt:     ", gdmoTheAnt
  put " gdmoTheLantern: ", gdmoTheLantern
  put " gdmoCricket:    ", gdmoCricket
  put " gdmoCandle:     ", gdmoCandle
  put " gdmoEyeGuy:     ", gdmoEyeGuy
  put " gdmoTextPoof:   ", gdmoTextPoof
  put 
  put " gdmoFiniteBottle:   ", gdmoFiniteBottle
  put " gdmoInfiniteBottle: ", gdmoInfiniteBottle
  put " gdmoMadBottle:      ", gdmoMadBottle
  put 
  put "so, how'd i do?"
end
