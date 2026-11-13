property iMode, iRMFpath, iLoSong, iLoBarrels, iLctrlVals, ilchannels, iLchnAlloc, iFPS, iTimer, iDelay, iCurVolume, iBlnMute, iLblnChnMute, iLactiveRMFs
global goSongMgr, goK, gScopeVal, goPanel

on new me, mode, rmfPath
  iMode = mode
  iRMFpath = rmfPath
  iLactiveRMFs = []
  iBlnMute = 0
  result = goSongMgr.mAddSong(#sndscape1)
  if result then
    AlertError(2)
  end if
  result = goSongMgr.mAddSong(#sndscape2)
  if result then
    AlertError(2)
  end if
  iLoSong = [goSongMgr.ilsongs.sndscape1, goSongMgr.ilsongs.sndscape2]
  bank1Name = "Master_a.rmf"
  bank2Name = "Master_b.rmf"
  err = iLoSong[1].mConfigSong(iRMFpath & bank1Name, 1)
  err = iLoSong[2].mConfigSong(iRMFpath & bank2Name, 1)
  goSongMgr.mSetReverb(1)
  me.mSetSndScapeVolume(100)
  err = iLoSong[1].mStartPlaying()
  err = iLoSong[2].mStartPlaying()
  ilchannels = []
  repeat with n = 1 to 2
    result = iLoSong[n].mRequestChannels(16)
    if integerp(result) then
      AlertError(2)
    end if
    append(ilchannels, result)
  end repeat
  iLctrlVals = []
  repeat with n = 1 to 2
    Ltemp = []
    Ltemp[16] = 0
    append(iLctrlVals, Ltemp)
  end repeat
  repeat with n = 1 to 2
    Lchannels = ilchannels[n]
    repeat with chn in Lchannels
      iLoSong[n].mSetController([#chn: chn, #ctrl: [#vol: iLctrlVals[n][chn]]])
    end repeat
  end repeat
  iLblnChnMute = []
  repeat with n = 1 to 2
    Ltemp = []
    Ltemp[16] = 0
    append(iLblnChnMute, Ltemp)
  end repeat
  iLchnAlloc = [:]
  iLchnAlloc.addProp(#wind, [1, 2, 3, 4])
  iLchnAlloc.addProp(#rain, [5, 6, 7, 8])
  iLchnAlloc.addProp(#birds, [9, 11])
  iLchnAlloc.addProp(#animals, [12, 13, 14, 15])
  iLchnAlloc.addProp(#machines, [16, 17])
  iLchnAlloc.addProp(#water, [18, 19])
  iLchnAlloc.addProp(#insects, [21, 22, 23, 24])
  iLchnAlloc.addProp(#people, [27, 28, 29, 30, 31])
  iLoBarrels = [:]
  iLoBarrels.setaProp(#wind, new(script("Wind.class"), iMode, iLchnAlloc.wind))
  iLoBarrels.setaProp(#rain, new(script("Rain.class"), iMode, iLchnAlloc.rain))
  iLoBarrels.setaProp(#birds, new(script("Birds.class"), iMode, iLchnAlloc.birds))
  iLoBarrels.setaProp(#animals, new(script("Animals.class"), iMode, iLchnAlloc.animals))
  iLoBarrels.setaProp(#machines, new(script("Machines.class"), iMode, iLchnAlloc.machines))
  iLoBarrels.setaProp(#water, new(script("Water.class"), iMode, iLchnAlloc.water))
  iLoBarrels.setaProp(#insects, new(script("Insects.class"), iMode, iLchnAlloc.insects))
  iLoBarrels.setaProp(#people, new(script("People.class"), iMode, iLchnAlloc.people))
  iLoBarrels.setaProp(#music, new(script("Music.class"), me))
  if (iMode = #moodmaker) or (iMode = #musicpreview) then
    LmixLevels = value(member("intensity mixer levels", goK.iLibNumSndScape).text)
    me.mLoadIntensitySettings(LmixLevels)
  end if
  iFPS = 30
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  append(the actorList, me)
  return me
end

on mdispose me
  idx = getPos(the actorList, me)
  if idx then
    deleteAt(the actorList, idx)
  end if
  goSongMgr.mKillSong(#sndscape1)
  goSongMgr.mKillSong(#sndscape2)
  repeat with tag in iLactiveRMFs
    goSongMgr.mKillSong(tag)
  end repeat
  repeat with n = 1 to iLoBarrels.count
    iLoBarrels[n].mdispose()
  end repeat
  iMode = VOID
  iRMFpath = VOID
  iLoSong = VOID
  iLoBarrels = VOID
  iLctrlVals = VOID
  ilchannels = VOID
  iLchnAlloc = VOID
  iFPS = VOID
  iTimer = VOID
  iDelay = VOID
  iCurVolume = VOID
  iBlnMute = VOID
  iLactiveRMFs = VOID
end

on stepFrame me
  msecs = the milliSeconds
  if msecs < (iTimer + iDelay) then
    exit
  else
    iTimer = msecs
  end if
  repeat with i = 1 to iLoBarrels.count
    Levents = iLoBarrels[i].mPoll(msecs)
    if ilk(Levents, #list) then
      repeat with n = 1 to Levents.count
        eventType = Levents.getPropAt(n)
        eventData = Levents[n]
        case eventType of
          #start:
            me.mStartNote(eventData)
          #stop:
            me.mStopNote(eventData)
          #play:
            me.mPlayNote(eventData)
          #vol:
            me.mSetVol(eventData)
          #playrmf:
            me.mPlayRMF(eventData)
          #stoprmf:
            me.mStopRMF(eventData)
          #volrmf:
            me.mSetVolRMF(eventData)
          #mutechn:
            me.mSetChnMute(eventData)
        end case
      end repeat
    end if
  end repeat
end

on mStartNote me, Levent
  Levent = duplicate(Levent)
  Lchn = me.mGetChn(Levent.chn)
  Levent.chn = Lchn[2]
  Levent.addProp(#bank, 2)
  err = iLoSong[Lchn[1]].mStartNote(Levent)
end

on mPlayNote me, Levent
  Levent = duplicate(Levent)
  Lchn = me.mGetChn(Levent.chn)
  Levent.chn = Lchn[2]
  Levent.addProp(#bank, 2)
  err = iLoSong[Lchn[1]].mPlayNote(Levent)
end

on mStopNote me, data
  case 1 of
    ilk(data, #symbol):
      LabsChannels = iLchnAlloc.getaProp(data)
    ilk(data, #integer):
      LabsChannels = [data]
    ilk(data, #list):
      LabsChannels = []
      repeat with chn in data
        LabsChannels.append(chn)
      end repeat
  end case
  repeat with absChn in LabsChannels
    Lchn = me.mGetChn(absChn)
    iLoSong[Lchn[1]].mStopChnNotes([Lchn[2]])
  end repeat
end

on mSetVol me, Levent
  chn = Levent[1]
  val = Levent[2]
  if iBlnMute then
    exit
  end if
  Lchn = me.mGetChn(chn)
  if iLblnChnMute[Lchn[1]][Lchn[2]] then
    exit
  end if
  val = integer(val * (iCurVolume / 100.0))
  val = min(127, max(0, val))
  if val <> iLctrlVals[Lchn[1]][Lchn[2]] then
    iLctrlVals[Lchn[1]][Lchn[2]] = val
    iLoSong[Lchn[1]].mSetController([#chn: Lchn[2], #ctrl: [#vol: val]])
  end if
end

on mPlayRMF me, Levent
  tag = Levent[1]
  rmfFileName = Levent[2]
  if iLactiveRMFs.getOne(tag) then
    exit
  end if
  iLactiveRMFs.append(tag)
  result = goSongMgr.mAddSong(tag)
  if result then
    AlertError(2)
  end if
  err = goSongMgr.ilsongs[tag].mConfigSong(iRMFpath & rmfFileName)
  if iBlnMute then
    goSongMgr.ilsongs[tag].mSetVolume(0)
  else
    goSongMgr.ilsongs[tag].mSetVolume(iCurVolume)
  end if
  err = goSongMgr.ilsongs[tag].mStartPlaying()
  return 0
end

on mStopRMF me, Levent
  tag = Levent[1]
  idx = iLactiveRMFs.getOne(tag)
  if idx then
    iLactiveRMFs.deleteAt(idx)
  end if
  err = goSongMgr.mKillSong(tag)
end

on mSetVolRMF me, Levent
  tag = Levent[1]
  val = Levent[2]
  if iBlnMute then
    exit
  end if
  val = integer(val * (iCurVolume / 100.0))
  goSongMgr.ilsongs[tag].mSetVolume(val)
end

on mSetChnMute me, Levent
  blnMute = Levent[1]
  Lchn = Levent[2]
  repeat with absChn in Lchn
    Lchn = me.mGetChn(absChn)
    iLblnChnMute[Lchn[1]][Lchn[2]] = blnMute
    if blnMute then
      val = 0
    else
      val = iLctrlVals[Lchn[1]][Lchn[2]]
    end if
    if not iBlnMute then
      iLoSong[Lchn[1]].mSetController([#chn: Lchn[2], #ctrl: [#vol: val]])
    end if
  end repeat
end

on mLoadIntensitySettings me, Lsettings
  repeat with n = 1 to iLoBarrels.count
    if ilk(Lsettings[n], #list) then
      mInitMixLevels(iLoBarrels[n], Lsettings[n])
    end if
  end repeat
end

on mLoadBlend me, Lblend
  err = me.mValidateBlendData(Lblend)
  if err then
    return err
  end if
  repeat with n = 1 to iLoBarrels.count
    Lflgs = Lblend.elementFlgs[n]
    if ilk(Lflgs, #propList) then
      repeat with i = 1 to Lflgs.count
        iLoBarrels[n].mSetElementEnabled(i, Lflgs[i])
      end repeat
    end if
  end repeat
  repeat with n = 1 to iLoBarrels.count
    iLoBarrels[n].mSetEnabled(Lblend.barrelFlgs[n])
  end repeat
  repeat with n = 1 to iLoBarrels.count
    if ilk(Lblend.mixvals[n], #list) then
      iLoBarrels[n].iLcurMixVals = Lblend.mixvals[n]
    end if
  end repeat
  repeat with n = 1 to iLoBarrels.count
    iLoBarrels[n].mSetValFromSlider(Lblend.intensity[n], #i)
  end repeat
  return 0
end

on mValidateBlendData me, Lblend
  if Lblend.count <> 4 then
    return -1
  end if
  if Lblend.barrelFlgs.count <> iLoBarrels.count then
    return -2
  end if
  if Lblend.elementFlgs.count <> iLoBarrels.count then
    return -3
  end if
  if Lblend.mixvals.count <> iLoBarrels.count then
    return -4
  end if
  if Lblend.intensity.count <> iLoBarrels.count then
    return -5
  end if
  repeat with n = 1 to iLoBarrels.count
    Lflgs = Lblend.elementFlgs[n]
    if ilk(Lflgs, #propList) then
      if not ilk(iLoBarrels[n].iLblnElementEnabled, #propList) then
        return -6
      end if
      if iLoBarrels[n].iLblnElementEnabled.count <> Lflgs.count then
        return -7
      end if
      repeat with i = 1 to Lflgs.count
        if iLoBarrels[n].iLblnElementEnabled.getPropAt(i) <> Lflgs.getPropAt(i) then
          return -8
        end if
      end repeat
      next repeat
    end if
    if iLoBarrels[n].iLblnElementEnabled <> 0 then
      return -9
    end if
  end repeat
  return 0
end

on mGetBlendData me
  Lblend = [:]
  Ltemp = []
  repeat with n = 1 to iLoBarrels.count
    Ltemp.append(iLoBarrels[n].iBlnEnabled)
  end repeat
  Lblend.setaProp(#barrelFlgs, Ltemp)
  Ltemp = []
  repeat with n = 1 to iLoBarrels.count
    Ltemp.append(iLoBarrels[n].iLblnElementEnabled)
  end repeat
  Lblend.setaProp(#elementFlgs, Ltemp)
  Ltemp = []
  repeat with n = 1 to iLoBarrels.count
    Ltemp.append(iLoBarrels[n].iLcurMixVals)
  end repeat
  Lblend.setaProp(#mixvals, Ltemp)
  Ltemp = []
  repeat with n = 1 to iLoBarrels.count
    Ltemp.append(iLoBarrels[n].iLsliderVals.i)
  end repeat
  Lblend.setaProp(#intensity, Ltemp)
  return Lblend
end

on mGetIntensitySettings me
  Lsettings = []
  repeat with n = 1 to iLoBarrels.count
    Lsettings.append(iLoBarrels[n].iLmixLevels)
  end repeat
  return Lsettings
end

on mSetSndScapeVolume me, newVol
  if newVol = iCurVolume then
    exit
  end if
  iCurVolume = newVol
  if iBlnMute then
    exit
  end if
  repeat with tag in iLactiveRMFs
    case tag of
      #music:
        val = integer(iLoBarrels.music.iCurVolume * (iCurVolume / 100.0))
        goSongMgr.ilsongs.music.mSetVolume(val)
      otherwise:
        goSongMgr.ilsongs[tag].mSetVolume(iCurVolume)
    end case
  end repeat
end

on mMuteAll me, blnMute
  if blnMute = iBlnMute then
    exit
  end if
  iBlnMute = blnMute
  repeat with bnk = 1 to iLoSong.count
    repeat with chn = 1 to 16
      if iBlnMute then
        vol = 0
      else
        vol = iLctrlVals[bnk][chn]
      end if
      if not iLblnChnMute[bnk][chn] then
        err = iLoSong[bnk].ixBeatnik.setController(chn, 7, vol)
      end if
    end repeat
    iLoSong[bnk].mKillNotesForMute()
    repeat with chn = 1 to 16
      if iLoSong[bnk].ixBeatnik.getController(chn, 7) <> 0 then
        if iBlnMute then
          vol = 0
        else
          vol = iLctrlVals[bnk][chn]
        end if
        if not iLblnChnMute[bnk][chn] then
          err = iLoSong[bnk].ixBeatnik.setController(chn, 7, vol)
        end if
      end if
    end repeat
  end repeat
  repeat with tag in iLactiveRMFs
    if iBlnMute then
      val = 0
    else
      case tag of
        #music:
          val = integer(iLoBarrels.music.iCurVolume * (iCurVolume / 100.0))
        otherwise:
          val = iCurVolume
      end case
    end if
    goSongMgr.ilsongs[tag].mSetVolume(val)
  end repeat
end

on mGetChn me, absChn
  if absChn <= 16 then
    return [1, ilchannels[1][absChn]]
  else
    return [2, ilchannels[2][absChn - 16]]
  end if
end

on mSetValFromSlider me, val, key
  case key of
    #v:
      me.mSetSndScapeVolume(val)
  end case
end

on mSetMixLevels me, barrelTag, intensitySetting, Lvals
  oBarrel = iLoBarrels.getaProp(barrelTag)
  LmixLevels = oBarrel.iLmixLevels
  case intensitySetting of
    #Low:
      LmixLevels[1] = Lvals
    #High:
      LmixLevels[2] = Lvals
  end case
  mInitMixLevels(iLoBarrels.getaProp(barrelTag), LmixLevels)
end

on mSetDioramaRef me, oDiorama
  repeat with oBarrel in iLoBarrels
    oBarrel.ioDiorama = oDiorama
  end repeat
end

on mReportVolCtrl me
  repeat with bnk = 1 to iLoSong.count
    repeat with chn = 1 to 16
      put bnk, chn, iLoSong[bnk].ixBeatnik.getController(chn, 7)
    end repeat
  end repeat
end
