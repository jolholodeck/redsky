property iLcollDirContents, iLcollNames, iLoldCollNames, iCollCnt, iCurCollName, iCurCollTag, iCurCollIDX, iCurPvwCollIDX, iCurCollDirPath, iTimer, iDelay, ioHotSpot, iLsndScapeData, iLcurSndScapeData
global goK, goCurs, goSndScape, goDataStore, goPanel, goDiorama, gDebug, gxBeatnik

on new me
  ioHotSpot = new(script("Hotspot.class"), member(2, goK.iLibNumAssets), 0.5, [35])
  iLcollDirContents = DirectoryToList(goK.iCollPath)
  iCollCnt = iLcollDirContents.count
  if not iCollCnt then
    AlertError(11)
  end if
  iLcollNames = []
  repeat with n = 1 to iCollCnt
    dirName = iLcollDirContents[n]
    collName = dirName.char[1..dirName.length - 1]
    iLcollNames.append(collName)
  end repeat
  iLoldCollNames = goDataStore.mGetData(#collnames)
  if voidp(iLoldCollNames) then
    if iLcollNames.count = 3 then
      LnotFound = []
      repeat with collName in iLcollNames
        if not goK.iDefaultCollOrder.getPos(collName) then
          LnotFound.append(collName)
        end if
      end repeat
      if not LnotFound.count then
        iLcollNames = duplicate(goK.iDefaultCollOrder)
      end if
    end if
  else
    if iLcollNames.count > iLoldCollNames.count then
      Ltemp = duplicate(iLoldCollNames)
      repeat with collName in iLcollNames
        if not Ltemp.getPos(collName) then
          Ltemp.append(collName)
          newCollName = collName
        end if
      end repeat
      iLcollNames = Ltemp
    else
      if iLcollNames.count = iLoldCollNames.count then
        LnotFound = []
        repeat with collName in iLcollNames
          if not iLoldCollNames.getPos(collName) then
            LnotFound.append(collName)
          end if
        end repeat
        if not LnotFound.count then
          iLcollNames = iLoldCollNames
        end if
      else
        if iLcollNames.count < iLoldCollNames.count then
        end if
      end if
    end if
  end if
  iLcollDirContents = []
  repeat with collName in iLcollNames
    iLcollDirContents.append(collName & goK.iPathDelim)
  end repeat
  if voidp(newCollName) then
    iCurCollName = goDataStore.mGetData(#curcollname)
    if voidp(iCurCollName) then
      iCurCollName = goK.iDefaultCollOrder[1]
    end if
  else
    iCurCollName = newCollName
  end if
  if not iLcollNames.getOne(iCurCollName) then
    iCurCollName = goK.iDefaultCollOrder[1]
    if not iLcollNames.getOne(iCurCollName) then
      iCurCollName = iLcollNames[1]
    end if
  end if
  iCurCollTag = value("#" & iCurCollName)
  if voidp(goDataStore.mGetData(#sndscapedata)) then
    iLsndScapeData = [:]
  else
    iLsndScapeData = duplicate(goDataStore.mGetData(#sndscapedata))
  end if
  iCurCollDirPath = EMPTY
  iTimer = 0
  iDelay = 3000
  append(the actorList, me)
  return me
end

on stepFrame me
  if iTimer then
    if ioHotSpot.mGetSpot(the mouseLoc) and rollOver(goK.iLsprNum.main.PANEL.preview) then
      goCurs.mChange(#finger, me)
    else
      goCurs.mChange(#arrow, me)
    end if
    if the milliSeconds >= (iTimer + iDelay) then
      me.mDoAutoLoad()
    end if
  end if
end

on mLoadNow me
  if ioHotSpot.mGetSpot(the mouseLoc) then
    me.mDoAutoLoad()
  end if
  stopEvent()
end

on mDoAutoLoad me
  iTimer = 0
  set the mouseDownScript to EMPTY
  if iCurPvwCollIDX = iCurCollIDX then
    sprite(goK.iLsprNum.main.PANEL.preview).member = goK.iMbrDot
    sprite(goK.iLsprNum.main.PANEL.preview).blend = 100
    sendAllSprites(#PushButton_ToggleActive, 1)
  else
    me.mLoadCollection(iCurPvwCollIDX)
  end if
end

on mColl_clickArrow me, Ref, sprNum
  case sprNum of
    goK.iLsprNum.main.PANEL.leftarrow:
      Dir = -1
    goK.iLsprNum.main.PANEL.rightarrow:
      Dir = 1
  end case
  me.mIncrCollection(Dir)
end

on mIncrCollection me, Dir
  newCollidx = iCurPvwCollIDX + Dir
  if newCollidx <= 0 then
    newCollidx = iCollCnt
  end if
  if newCollidx > iCollCnt then
    newCollidx = 1
  end if
  if newCollidx = iCurPvwCollIDX then
    mbr = member("tooltip-- coming soon", goK.iLibNumAssets)
    sendSprite(goK.iLsprNum.main.PANEL.tooltip, #mDisplay, mbr, 1)
    exit
  end if
  iTimer = the milliSeconds
  set the mouseDownScript to "goColl.mLoadNow()"
  me.mPreviewCollection(newCollidx)
end

on mPreviewCollection me, newCollidx, fadeTime
  if newCollidx = iCurPvwCollIDX then
    exit
  end if
  if voidp(fadeTime) then
    fadeTime = 0
  end if
  goCurs.mLock(#watch)
  sendAllSprites(#PushButton_ToggleActive, 0)
  if (iCurPvwCollIDX <> iCurCollIDX) and (newCollidx <> iCurCollIDX) then
    goK.iMbrPvwBuff.picture = member(1, goK.iLibNumCollUI).picture
    goK.iMbrPvwBuff.regPoint = member(1, goK.iLibNumCollUI).regPoint
    goK.iMbrPvwBuff.dither = 1
    sprite(goK.iLsprNum.main.PANEL.preview).member = goK.iMbrPvwBuff
    updateStage()
  end if
  repeat with sprNum in goK.iLsprNum.main.PANEL
    if sprite(sprNum).castLibNum = goK.iLibNumCollUI then
      sprite(sprNum).member = goK.iMbrDot
    end if
  end repeat
  updateStage()
  castLib(goK.iLibNumCollUI).fileName = goK.iEmptyCstPath
  UIcstPath = goK.iCollPath & iLcollDirContents[newCollidx] & "UI"
  castLib(goK.iLibNumCollUI).fileName = UIcstPath
  mbr = member(2, goK.iLibNumCollUI)
  sendSprite(goK.iLsprNum.main.PANEL.tooltip, #mDisplay, mbr, 1)
  if newCollidx = iCurCollIDX then
    sprite(goK.iLsprNum.main.PANEL.preview).member = goK.iMbrDot
    sprite(goK.iLsprNum.main.PANEL.preview).blend = 100
  else
    spr = sprite(goK.iLsprNum.main.PANEL.preview)
    spr.blend = 0
    spr.member = member(1, goK.iLibNumCollUI)
    if fadeTime then
      FadeSprite(spr, 1, fadeTime)
    else
      spr.blend = 100
    end if
  end if
  sendSprite(goK.iLsprNum.main.PANEL.leftarrow, #PushButton_ToggleActive, 1)
  sendSprite(goK.iLsprNum.main.PANEL.rightarrow, #PushButton_ToggleActive, 1)
  goCurs.mUnLock(#arrow)
  iCurPvwCollIDX = newCollidx
end

on mLoadCollection me, newCollidx, fadeTime
  if newCollidx = iCurCollIDX then
    exit
  end if
  iCurCollIDX = newCollidx
  iCurCollName = iLcollNames[iCurCollIDX]
  iCurCollTag = value("#" & iCurCollName)
  if voidp(fadeTime) then
    fadeTime = 2000
  end if
  goCurs.mChange(#watch, me)
  sendAllSprites(#PushButton_ToggleActive, 0)
  mbr = member("tooltip-- loading", goK.iLibNumAssets)
  sendSprite(goK.iLsprNum.main.PANEL.tooltip, #mSetDefault, mbr)
  updateStage()
  iCurCollDirPath = goK.iCollPath & iLcollDirContents[newCollidx]
  if iCurPvwCollIDX <> newCollidx then
    repeat with sprNum in goK.iLsprNum.main.PANEL
      if sprite(sprNum).castLibNum = goK.iLibNumCollUI then
        sprite(sprNum).member = goK.iMbrDot
      end if
    end repeat
    updateStage()
    castLib(goK.iLibNumCollUI).fileName = goK.iEmptyCstPath
    castLib(goK.iLibNumCollUI).fileName = iCurCollDirPath & "UI"
    iCurPvwCollIDX = newCollidx
  end if
  if ilk(goDiorama, #instance) then
    goDiorama.Dispose()
    goDiorama = VOID
  end if
  repeat with sprNum in goK.iLsprNum.diorama
    if sprite(sprNum).castLibNum = goK.iLibNumCollDio then
      sprite(sprNum).member = goK.iMbrDot
    end if
  end repeat
  updateStage()
  castLib(goK.iLibNumCollDio).fileName = goK.iEmptyCstPath
  if ilk(goSndScape, #instance) then
    goSndScape.mdispose()
    goSndScape = VOID
  end if
  castLib(goK.iLibNumSndScape).fileName = goK.iEmptyCstPath
  err = gxBeatnik.noteOn(8, 2, 1, 60, 80)
  castLib(goK.iLibNumCollDio).fileName = iCurCollDirPath & "Diorama"
  castLib(goK.iLibNumSndScape).fileName = iCurCollDirPath & "SndScape"
  goDiorama = script("Diorama Class").new()
  goDiorama.SetupAnims()
  goDiorama.pause()
  FadeSprite(sprite(goK.iLsprNum.main.PANEL.preview), -1, fadeTime)
  sprite(goK.iLsprNum.main.PANEL.preview).member = goK.iMbrDot
  sprite(goK.iLsprNum.main.PANEL.preview).blend = 100
  goDiorama.Resume()
  rmfPath = iCurCollDirPath & "Snd" & goK.iPathDelim
  goSndScape = new(script("SoundScape.class"), #moodmaker, rmfPath)
  goSndScape.mSetDioramaRef(goDiorama)
  iLcurSndScapeData = iLsndScapeData.getaProp(iCurCollTag)
  if ilk(iLcurSndScapeData, #void) then
    iLcurSndScapeData = [#curBlend: 1]
    iLcurSndScapeData.setaProp(#rndplay, 0)
    Lblends = []
    repeat with n = 1 to 5
      Lblends.append(value(member("blend" && string(n), goK.iLibNumSndScape).text))
    end repeat
    iLcurSndScapeData.setaProp(#blendsettings, Lblends)
    iLsndScapeData.setaProp(iCurCollTag, iLcurSndScapeData)
  end if
  Lblend = iLcurSndScapeData.blendsettings[iLcurSndScapeData.curBlend]
  err = gxBeatnik.noteOff(8, 60, 80)
  err = goSndScape.mLoadBlend(Lblend)
  if err then
    AlertError(12, 1, err)
  end if
  goSndScape.mSetSndScapeVolume(goPanel.iCurVolume)
  goSndScape.mMuteAll(goPanel.iBlnMute)
  goPanel.mInitElements()
  goPanel.mToggleRndPlay(iLcurSndScapeData.rndplay)
  goPanel.mResetRndPlayTimer()
  mbr = member(2, goK.iLibNumCollUI)
  sendSprite(goK.iLsprNum.main.PANEL.tooltip, #mSetDefault, mbr)
  sendAllSprites(#PushButton_ToggleActive, 1)
  goCurs.mChange(#arrow, me)
end
