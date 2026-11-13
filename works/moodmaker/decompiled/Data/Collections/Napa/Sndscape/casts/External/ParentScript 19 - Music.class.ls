property ioSndScape, iMode, iLsliderVals, iTag, iBlnEnabled, ixBeatnik, iBlnThemeSwitch, ilActiveTrks, iThemeHasRepeatedFlg, iCurTheme, iCurVar, ilAutoFlgs, ilLayerFlgs, iPlayState, iPlayTimer, ilDelayRange, iMaxVolume, iMinVolume, iCurVolume, ioFade, iBlnFade, iFadeSecs, iLcurMixVals, iLblnElementEnabled, iLmixLevels, ioDiorama, iFPS, iTimer, iDelay, iBirthTime, iBlnBlockStart
global goSongMgr

on new me, oSndScape
  ioSndScape = oSndScape
  iMode = ioSndScape.iMode
  iLsliderVals = [#i: 0]
  iTag = #music
  iBlnEnabled = 0
  iPlayState = #stop
  iLcurMixVals = 0
  iLblnElementEnabled = 0
  iLmixLevels = 0
  iFPS = 15
  iTimer = the milliSeconds
  iDelay = 1000 / iFPS
  iPlayTimer = the milliSeconds
  longTime = 1000 * 60 * 60 * 48
  ilDelayRange = [#play: [0: 60, 50: 60, 99: 480, 100: longTime], #stop: [0: 480, 50: 120, 99: 60, 100: 0]]
  iBlnThemeSwitch = 0
  ilActiveTrks = []
  iThemeHasRepeatedFlg = 0
  iCurTheme = 1
  iCurVar = 1
  ilAutoFlgs = [#theme: 1, #var: 1, #layer: 1]
  ilLayerFlgs = [1, 1, 1, 1, 1]
  iMaxVolume = 80
  iMinVolume = 30
  ioFade = new(script("Fade.class"))
  iBlnFade = 0
  iFadeSecs = 10
  result = goSongMgr.mAddSong(#music)
  if result then
    AlertError(2)
  end if
  ixBeatnik = goSongMgr.ilsongs.music.ixBeatnik
  err = goSongMgr.ilsongs.music.mConfigSong(ioSndScape.iRMFpath & "Music.rmf", 1)
  ioSndScape.iLactiveRMFs.append(#music)
  iBirthTime = the milliSeconds
  iBlnBlockStart = 1
  return me
end

on mPoll me, msecs
  Levents = [:]
  if msecs < (iTimer + iDelay) then
    return 0
  else
    iTimer = msecs
  end if
  if iBlnBlockStart then
    if msecs >= (iBirthTime + 3000) then
      iBlnBlockStart = 0
      me.mSetEnabled(iBlnEnabled)
    end if
    return 0
  end if
  if me.iBlnEnabled then
    if not ilAutoFlgs.theme then
      exit
    end if
    ctrlVal = ixBeatnik.getController(16, 1)
    if iBlnThemeSwitch then
      if not ctrlVal then
        iBlnThemeSwitch = 0
        if iThemeHasRepeatedFlg then
          iThemeHasRepeatedFlg = 0
          lThemes = [1, 2, 3]
          lThemes.deleteAt(iCurTheme)
          newTheme = lThemes[random(2)]
        else
          newTheme = random(3)
          if newTheme = iCurTheme then
            iThemeHasRepeatedFlg = 1
          end if
        end if
        me.mSwitchTheme(newTheme)
      end if
    else
      if ctrlVal then
        iBlnThemeSwitch = 1
      end if
    end if
    Levents.addProp(#volrmf, [iTag, iCurVolume])
    if (msecs >= iPlayTimer) and not iBlnFade then
      if iPlayState = #play then
        ioFade.mInit(15, iFadeSecs, iCurVolume, 0)
        iBlnFade = 1
        ioFade.mStart()
      else
        me.mSetPlay(1)
      end if
    end if
  end if
  if iBlnFade then
    val = ioFade.mStep(msecs)
    if symbolp(val) then
      iBlnFade = 0
      me.mSetPlay(0)
    else
      Levents.setaProp(#volrmf, [iTag, val])
    end if
  end if
  return Levents
end

on mSetValFromSlider me, val, key
  case key of
    #i:
      iLsliderVals.i = val
  end case
  me.mSetVolume(val)
  delaySecs = integer(me.mGetValFromRange(iLsliderVals.i, ilDelayRange[iPlayState]))
  delaySecs = delaySecs + ([1, -1][random(2)] * random(20))
  iPlayTimer = the milliSeconds + (delaySecs * 1000)
end

on mSetEnabled me, blnEnabled
  iBlnEnabled = blnEnabled
  if iBlnBlockStart then
    exit
  end if
  if iBlnEnabled then
    iBlnFade = 0
    me.mSetPlay(1)
  else
    ioFade.mInit(15, iFadeSecs, iCurVolume, 0)
    if not iBlnFade then
      iBlnFade = 1
      ioFade.mStart()
    end if
  end if
  if iMode = #musicpreview then
    member("cb enabled", 1).hilite = blnEnabled
  end if
end

on mSetPlay me, bln
  if bln then
    ioSndScape.mSetVolRMF([#music, 0])
    err = goSongMgr.ilsongs.music.mStartPlaying()
    me.mMuteAll()
    me.mSwitchTheme(iCurTheme)
    iPlayState = #play
  else
    err = goSongMgr.ilsongs.music.mStopPlaying()
    iPlayState = #stop
  end if
  delaySecs = integer(me.mGetValFromRange(iLsliderVals.i, ilDelayRange[iPlayState]))
  delaySecs = delaySecs + ([1, -1][random(2)] * random(20))
  iPlayTimer = the milliSeconds + (delaySecs * 1000)
end

on mToggleEnabled me
  me.mSetEnabled(not iBlnEnabled)
end

on mdispose me
  ioSndScape = VOID
  ixBeatnik = VOID
end

on mSetVolume me, val
  iCurVolume = iMinVolume + integer((iMaxVolume - iMinVolume) / 100.0 * val)
end

on mMuteAll me
  repeat with trk = 2 to 64
    if not ixBeatnik.getTrackMute(trk) then
      ixBeatnik.setTrackMute(trk, 1)
    end if
  end repeat
end

on mMute me, Ltrks
  repeat with trk in Ltrks
    ixBeatnik.setTrackMute(trk, 1)
    ilActiveTrks.deleteAt(ilActiveTrks.getPos(trk))
  end repeat
end

on mdemute me, Ltrks
  repeat with trk in Ltrks
    ixBeatnik.setTrackMute(trk, 0)
    ilActiveTrks.append(trk)
  end repeat
end

on mSwitchTheme me, newTheme
  iCurTheme = newTheme
  if iMode = #musicpreview then
    me.mUpdateThemeButtons(newTheme)
  end if
  if ilAutoFlgs.var then
    iCurVar = random(4)
  end if
  me.mSwitchVar(iCurVar)
end

on mSwitchVar me, newVar
  iCurVar = newVar
  me.mMute(duplicate(ilActiveTrks))
  if iMode = #musicpreview then
    me.mUpdateVarButtons(newVar)
  end if
  if ilAutoFlgs.layer then
    lLayerFlgs = me.mGetNewLayerFlgs()
    repeat with n = 1 to 5
      ilLayerFlgs[n] = lLayerFlgs[n]
      if iMode = #musicpreview then
        me.mUpdateLayerCheckBox(n)
      end if
    end repeat
  end if
  bgnTrk = ((iCurTheme - 1) * 20) + 2 + ((newVar - 1) * 5)
  Ltrks = []
  repeat with n = 1 to 5
    if ilLayerFlgs[n] then
      Ltrks.append(bgnTrk + n - 1)
    end if
  end repeat
  me.mdemute(Ltrks)
end

on mToggleLayer me, idx
  bln = not ilLayerFlgs[idx]
  trk = ((iCurTheme - 1) * 20) + 2 + ((iCurVar - 1) * 5) + idx - 1
  ixBeatnik.setTrackMute(trk, not bln)
  ilLayerFlgs[idx] = bln
  if iMode = #musicpreview then
    me.mUpdateLayerCheckBox(idx)
  end if
  if bln then
    ilActiveTrks.append(trk)
  else
    ilActiveTrks.deleteAt(ilActiveTrks.getPos(trk))
  end if
end

on mGetNewLayerFlgs me
  p1 = 10
  p2 = 30
  p3 = 35
  p4 = 25
  a = p1
  b = p1 + p2
  c = p1 + p2 + p3
  d = p1 + p2 + p3 + p4
  rnd = random(d)
  case 1 of
    (rnd <= a):
      trkCnt = 2
    ((rnd > a) and (rnd <= b)):
      trkCnt = 3
    ((rnd > b) and (rnd <= c)):
      trkCnt = 4
    ((rnd > c) and (rnd <= d)):
      trkCnt = 5
  end case
  lLayers = [1, 2, 3, 4, 5]
  lLayerFlgs = [0, 0, 0, 0, 0]
  repeat with n = 1 to trkCnt
    idx = random(lLayers.count)
    trk = lLayers[idx]
    lLayerFlgs[trk] = 1
    lLayers.deleteAt(idx)
  end repeat
  return lLayerFlgs
end

on mGetValFromRange me, theSetting, Lrange
  case theSetting of
    0:
      return Lrange.getaProp(0)
    100:
      return Lrange.getaProp(100)
    otherwise:
      repeat with n = 1 to Lrange.count
        thisSetting = Lrange.getPropAt(n)
        nextSetting = Lrange.getPropAt(n + 1)
        if (theSetting >= thisSetting) and (theSetting < nextSetting) then
          loVal = Lrange.getaProp(thisSetting)
          hiVal = Lrange.getaProp(nextSetting)
          exit repeat
        end if
      end repeat
  end case
  return loVal + ((theSetting - thisSetting) * ((hiVal - loVal) / float(nextSetting - thisSetting)))
end

on mUpdateThemeButtons me, newTheme
  Lbtns = [1, 2, 3]
  Lbtns.deleteAt(newTheme)
  repeat with btnNum in Lbtns
    member("theme btn" && string(btnNum), 1).hilite = 0
  end repeat
  member("theme btn" && string(newTheme), 1).hilite = 1
end

on mUpdateVarButtons me, newVar
  Lbtns = [1, 2, 3, 4]
  Lbtns.deleteAt(newVar)
  repeat with btnNum in Lbtns
    member("var btn" && string(btnNum), 1).hilite = 0
  end repeat
  member("var btn" && string(newVar), 1).hilite = 1
end

on mUpdateLayerCheckBox me, idx
  member("layer cb" && string(idx), 1).hilite = ilLayerFlgs[idx]
end

on mUpdateAutoCheckBox me, theProp, bln
  ilAutoFlgs[theProp] = bln
  member("auto" && string(theProp) && "cb", 1).hilite = bln
end
