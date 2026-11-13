property iCtrlPanelDisplayState, iLsprNumToggles, iLsprNumSubPanel, iLelementCnt, iCurElementIDX, iLactiveToggles, iLogoPanelState, iSubPanelState, iBlnMute, iCurVolume, iBlnRndPlay, iRndPlaySwitchTime
global goK, goCurs, goSndScape, goColl, gxBeatnik, goDataStore

on new me
  iCtrlPanelDisplayState = 0
  iRndPlaySwitchTime = the maxinteger
  iLsprNumSubPanel = duplicate(goK.iLsprNum.ctrl.right)
  iLsprNumSubPanel.deleteProp(#panellogo)
  iLsprNumToggles = []
  append(iLsprNumToggles, iLsprNumSubPanel.toggle1)
  append(iLsprNumToggles, iLsprNumSubPanel.toggle2)
  append(iLsprNumToggles, iLsprNumSubPanel.toggle3)
  append(iLsprNumToggles, iLsprNumSubPanel.toggle4)
  iLactiveToggles = []
  iCurElementIDX = 0
  sendSprite(goK.iLsprNum.main.PANEL.vol, #PushButton_Subscribe, me)
  iBlnRndPlay = 0
  iBlnMute = goDataStore.mGetData(#mute)
  if voidp(iBlnMute) then
    iBlnMute = 0
  end if
  sendSprite(goK.iLsprNum.main.PANEL.mute, #Toggle, iBlnMute)
  iCurVolume = goDataStore.mGetData(#vol)
  if voidp(iCurVolume) then
    iCurVolume = 90
  end if
  sendSprite(goK.iLsprNum.main.PANEL.vol, #Slider_SetPosition, iCurVolume)
  append(the actorList, me)
  return me
end

on stepFrame me
  if iBlnRndPlay then
    if the milliSeconds > iRndPlaySwitchTime then
      newBlend = random(5)
      me.mSwitchBlend(newBlend)
      sendSprite(goK.iLsprNum.ctrl.left.PANEL.blendbtnlist[newBlend], #Toggle, 1)
    end if
  end if
end

on mInit me
  iCtrlPanelDisplayState = 1
  iLogoPanelState = 1
  iSubPanelState = 0
  iCurElementIDX = 0
  sendSprite(iLsprNumSubPanel.dial, #PushButton_Subscribe, me)
  sendSprite(iLsprNumSubPanel.btnleft, #PushButton_Subscribe, me)
  sendSprite(iLsprNumSubPanel.btnright, #PushButton_Subscribe, me)
end

on mExit me
  me.mDisplaySubPanel(0)
  iCtrlPanelDisplayState = 0
end

on mResetRndPlayTimer me
  iRndPlaySwitchTime = the milliSeconds + goK.iRndPlayDur
end

on mConfigSubPanel me, elementIDX
  if elementIDX > iLelementCnt.count then
    exit
  end if
  case iLelementCnt[elementIDX] of
    1:
      iLactiveToggles = [2]
    2:
      iLactiveToggles = [2, 3]
    3:
      iLactiveToggles = [1, 2, 3]
    4:
      iLactiveToggles = [1, 2, 3, 4]
  end case
  repeat with n = 1 to 4
    idx = iLactiveToggles.getPos(n)
    if idx then
      sendSprite(iLsprNumToggles[n], #ToggleButton_VisState, 1)
      next repeat
    end if
    sendSprite(iLsprNumToggles[n], #ToggleButton_VisState, 0)
  end repeat
  LtoggleStates = []
  LblendData = goColl.iLcurSndScapeData.blendsettings[goColl.iLcurSndScapeData.curBlend]
  if ilk(LblendData.elementFlgs[elementIDX], #propList) then
    repeat with State in LblendData.elementFlgs[elementIDX]
      LtoggleStates.append(State)
    end repeat
  else
    LtoggleStates.append(LblendData.barrelFlgs[elementIDX])
  end if
  repeat with n = 1 to LtoggleStates.count
    sendSprite(iLsprNumToggles[iLactiveToggles[n]], #ToggleButton_SetState, LtoggleStates[n])
  end repeat
  mbr = member(((elementIDX - 1) * 10) + 28, goK.iLibNumCollUI)
  sprite(iLsprNumSubPanel.label).member = mbr
  sprite(iLsprNumSubPanel.btnleft).myStandardMember = member(((elementIDX - 1) * 10) + 21, goK.iLibNumCollUI)
  sprite(iLsprNumSubPanel.btnleft).myRolloverMember = member(((elementIDX - 1) * 10) + 22, goK.iLibNumCollUI)
  sprite(iLsprNumSubPanel.btnleft).myMouseDownMember = member(((elementIDX - 1) * 10) + 23, goK.iLibNumCollUI)
  sprite(iLsprNumSubPanel.btnleft).myDisabledMember = member(((elementIDX - 1) * 10) + 21, goK.iLibNumCollUI)
  sendSprite(iLsprNumSubPanel.btnleft, #PushButton_ToggleActive, 0)
  sprite(iLsprNumSubPanel.btnright).myStandardMember = member(((elementIDX - 1) * 10) + 24, goK.iLibNumCollUI)
  sprite(iLsprNumSubPanel.btnright).myRolloverMember = member(((elementIDX - 1) * 10) + 25, goK.iLibNumCollUI)
  sprite(iLsprNumSubPanel.btnright).myMouseDownMember = member(((elementIDX - 1) * 10) + 26, goK.iLibNumCollUI)
  sprite(iLsprNumSubPanel.btnright).myDisabledMember = member(((elementIDX - 1) * 10) + 24, goK.iLibNumCollUI)
  sendSprite(iLsprNumSubPanel.btnright, #PushButton_ToggleActive, 0)
  val = goColl.iLcurSndScapeData.blendsettings[goColl.iLcurSndScapeData.curBlend].intensity[iCurElementIDX]
  sendSprite(iLsprNumSubPanel.dial, #Dial_SetPosition, val)
end

on mInitElements me
  iLelementCnt = []
  repeat with n = 1 to goSndScape.iLoBarrels.count
    Lelements = goSndScape.iLoBarrels[n].iLblnElementEnabled
    if ilk(Lelements, #list) then
      iLelementCnt.append(Lelements.count)
      next repeat
    end if
    iLelementCnt.append(1)
  end repeat
end

on mDisplaySubPanel me, elementIDX
  if elementIDX > iLelementCnt.count then
    exit
  end if
  goCurs.mChange(#watch, me)
  if elementIDX then
    if iLogoPanelState then
      me.mSlideLogoPanel(0)
    end if
    if iSubPanelState then
      me.mSlideSubPanel(0)
    end if
    me.mConfigSubPanel(elementIDX)
    me.mSlideSubPanel(1)
  else
    if iSubPanelState then
      me.mSlideSubPanel(0)
    end if
    if not iLogoPanelState then
      me.mSlideLogoPanel(1)
    end if
    sendSprite(goK.iLsprNum.ctrl.left.PANEL.elementlabel, #mSetDefault, goK.iMbrDot)
    iCurElementIDX = 0
  end if
  goCurs.mChange(#arrow, me)
end

on mSlideLogoPanel me, State
  gxBeatnik.noteOn(2, 2, 0, 9, 127)
  if State then
    SlideSprite([goK.iLsprNum.ctrl.right.panellogo], -182, 10, 500)
  else
    SlideSprite([goK.iLsprNum.ctrl.right.panellogo], 182, 10, 500)
  end if
  iLogoPanelState = State
end

on mSlideSubPanel me, State
  gxBeatnik.noteOn(2, 2, 0, 9, 127)
  if State then
    SlideSprite(iLsprNumSubPanel, -182, 10, 500)
    repeat with sprNum in iLsprNumSubPanel
      sendSprite(sprNum, #PushButton_ToggleActive, State)
    end repeat
  else
    repeat with sprNum in iLsprNumSubPanel
      sendSprite(sprNum, #PushButton_ToggleActive, State)
    end repeat
    SlideSprite(iLsprNumSubPanel, 182, 10, 500)
  end if
  iSubPanelState = State
end

on mSwitchBlend me, newBlend
  if newBlend = goColl.iLcurSndScapeData.curBlend then
    exit
  end if
  goColl.iLcurSndScapeData.curBlend = newBlend
  if iCtrlPanelDisplayState then
    gxBeatnik.noteOn(1, 2, 0, 0, 127)
  end if
  if iCtrlPanelDisplayState then
    me.mDisplaySubPanel(0)
  end if
  Lblend = goColl.iLcurSndScapeData.blendsettings[newBlend]
  err = goSndScape.mLoadBlend(Lblend)
  if err then
    AlertError(12, 1, err)
  end if
  if iCtrlPanelDisplayState then
    me.mSetupElementBtns()
  end if
  me.mResetRndPlayTimer()
end

on mResetBlend me
  me.mDisplaySubPanel(0)
  curBlend = goColl.iLcurSndScapeData.curBlend
  Lblend = value(member("blend" && string(curBlend), goK.iLibNumSndScape).text)
  goColl.iLcurSndScapeData.blendsettings[curBlend] = Lblend
  err = goSndScape.mLoadBlend(Lblend)
  if err then
    AlertError(12, 1, err)
  end if
  me.mSetupElementBtns()
end

on mGetElementBtnState me, btnIDX
  LblendDat = goColl.iLcurSndScapeData.blendsettings[goColl.iLcurSndScapeData.curBlend]
  if btnIDX > LblendDat.barrelFlgs.count then
    return #none
  end if
  barrelFlg = LblendDat.barrelFlgs[btnIDX]
  elementFlgs = LblendDat.elementFlgs[btnIDX]
  if ilk(elementFlgs, #propList) then
    repeat with n = 1 to elementFlgs.count
      if elementFlgs[n] then
        return 1
      end if
    end repeat
  else
    if barrelFlg then
      return 1
    end if
  end if
  return 0
end

on mSetupElementBtns me
  repeat with n = 1 to 12
    sprNum = goK.iLsprNum.ctrl.left.PANEL.elementbtnlist[n]
    activeBarrelFlg = me.mGetElementBtnState(n)
    if activeBarrelFlg = #none then
      sendSprite(sprNum, #PushButton_ToggleActive, 0)
      next repeat
    end if
    sendSprite(sprNum, #PushButton_ToggleActive, 1)
    sendSprite(sprNum, #PushButton_ToggleSelected, activeBarrelFlg)
    sendSprite(sprNum, #PushButton_Subscribe, me)
  end repeat
end

on PushButton_Activated me, Ref, sprNum, Msg
  case 1 of
    (goK.iLsprNum.ctrl.left.PANEL.elementbtnlist.getPos(sprNum) > 0):
      barrelIDX = goK.iLsprNum.ctrl.left.PANEL.elementbtnlist.getPos(sprNum)
      if iCurElementIDX then
        sendSprite(goK.iLsprNum.ctrl.left.PANEL.elementbtnlist[iCurElementIDX], #StickyClick, 0)
      end if
      iCurElementIDX = barrelIDX
      me.mDisplaySubPanel(iCurElementIDX)
    (sprNum = iLsprNumSubPanel.btnleft):
      curVal = goColl.iLcurSndScapeData.blendsettings[goColl.iLcurSndScapeData.curBlend].intensity[iCurElementIDX]
      newVal = min(100, max(0, curVal - 1))
      if newVal = curVal then
        exit
      end if
      sendSprite(iLsprNumSubPanel.dial, #Dial_SetPosition, newVal)
      me.mUpdateSoundScape(newVal)
    (sprNum = iLsprNumSubPanel.btnright):
      curVal = goColl.iLcurSndScapeData.blendsettings[goColl.iLcurSndScapeData.curBlend].intensity[iCurElementIDX]
      newVal = min(100, max(0, curVal + 1))
      if newVal = curVal then
        exit
      end if
      sendSprite(iLsprNumSubPanel.dial, #Dial_SetPosition, newVal)
      me.mUpdateSoundScape(newVal)
  end case
end

on mUpdateSoundScape me, newVal
  goColl.iLcurSndScapeData.blendsettings[goColl.iLcurSndScapeData.curBlend].intensity[iCurElementIDX] = newVal
  goSndScape.iLoBarrels[iCurElementIDX].mSetValFromSlider(newVal, #i)
end

on Dial_Adjusted me, Ref, sprNum, newVal
  if newVal = goColl.iLcurSndScapeData.blendsettings[goColl.iLcurSndScapeData.curBlend].intensity[iCurElementIDX] then
    exit
  end if
  me.mUpdateSoundScape(newVal)
end

on Slider_Adjusted me, Ref, sprNum, newVal
  if newVal = iCurVolume then
    exit
  end if
  iCurVolume = newVal
  if ilk(goSndScape, #instance) then
    goSndScape.mSetSndScapeVolume(iCurVolume)
  end if
end

on mToggleMute me, State
  iBlnMute = State
  if ilk(goSndScape, #instance) then
    goSndScape.mMuteAll(iBlnMute)
  end if
end

on mToggleRndPlay me, State
  iBlnRndPlay = State
  goColl.iLcurSndScapeData.rndplay = State
  if State then
    me.mResetRndPlayTimer()
  end if
end

on mToggleClick me, toggleNum, State
  dataIDX = iLactiveToggles.getPos(toggleNum)
  LblendData = goColl.iLcurSndScapeData.blendsettings[goColl.iLcurSndScapeData.curBlend]
  oBarrel = goSndScape.iLoBarrels[iCurElementIDX]
  curBarrelEnabledFlg = LblendData.barrelFlgs[iCurElementIDX]
  if ilk(LblendData.elementFlgs[iCurElementIDX], #propList) then
    LblendData.elementFlgs[iCurElementIDX][dataIDX] = State
    oBarrel.mSetElementEnabled(dataIDX, State)
    newBarrelEnabledFlg = 0
    repeat with n = 1 to LblendData.elementFlgs[iCurElementIDX].count
      if LblendData.elementFlgs[iCurElementIDX][n] then
        newBarrelEnabledFlg = 1
        exit repeat
      end if
    end repeat
  else
    newBarrelEnabledFlg = State
  end if
  if newBarrelEnabledFlg <> curBarrelEnabledFlg then
    LblendData.barrelFlgs[iCurElementIDX] = State
    oBarrel.mSetEnabled(newBarrelEnabledFlg)
  end if
  sprNum = goK.iLsprNum.ctrl.left.PANEL.elementbtnlist[iCurElementIDX]
  sprite(sprNum).myActiveBarrelFlag = me.mGetElementBtnState(iCurElementIDX)
end
