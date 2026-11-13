on enterFrame me
  global goCurs, goK, goPanel, goColl, gxBeatnik, goDiorama
  goCurs.mChange(#watch, me)
  sendAllSprites(#PushButton_ToggleActive, 0)
  gxBeatnik.noteOn(2, 2, 0, 5, 100)
  FlipBook([sprite(goK.iLsprNum.main.PANEL.knob)], [goK.iLmemNumKnob], [goK.iLibNumAssets], 400)
  Lsprs = [sprite(goK.iLsprNum.main.PANEL.vol), sprite(goK.iLsprNum.main.PANEL.volshdw)]
  LmemNums = [goK.iLmemNumVol, goK.iLmemNumVolShdw]
  LcstNums = [goK.iLibNumAssets, goK.iLibNumAssets]
  gxBeatnik.noteOn(2, 2, 0, 15, 100)
  FlipBook(Lsprs, LmemNums, LcstNums, 400)
  sprite(goK.iLsprNum.main.PANEL.vol).member = goK.iMbrDot
  sprite(goK.iLsprNum.main.PANEL.voltmp).member = member(goK.iLmemNumVol[goK.iLmemNumVol.count], goK.iLibNumAssets)
  sprite(goK.iLsprNum.main.PANEL.voltmp).locH = sprite(goK.iLsprNum.main.PANEL.vol).locH
  sprite(goK.iLsprNum.main.PANEL.volshdw).member = goK.iMbrDot
  sprite(goK.iLsprNum.main.PANEL.volshdwtmp).member = member(goK.iLmemNumVolShdw[goK.iLmemNumVolShdw.count], goK.iLibNumAssets)
  sprite(goK.iLsprNum.main.PANEL.volshdwtmp).locH = sprite(goK.iLsprNum.main.PANEL.volshdw).locH
  goPanel.mInit()
  sendSprite(goK.iLsprNum.ctrl.left.PANEL.blendbtnlist[goColl.iLcurSndScapeData.curBlend], #Toggle, 1)
  sendSprite(goK.iLsprNum.ctrl.left.PANEL.rndbtn, #Toggle, goPanel.iBlnRndPlay)
  LsprNums = duplicate(goK.iLsprNum.ctrl.left.PANEL)
  LsprNums.deleteProp(#elementbtnlist)
  repeat with data in LsprNums
    if ilk(data, #integer) then
      sendSprite(data, #PushButton_ToggleActive, 1)
      next repeat
    end if
    repeat with sprNum in data
      sendSprite(sprNum, #PushButton_ToggleActive, 1)
    end repeat
  end repeat
  goPanel.mSetupElementBtns()
  sendSprite(goK.iLsprNum.logobtn, #PushButton_ToggleActive, 1)
  goDiorama.pause()
  Ltemp = duplicate(goK.iLsprNum.diorama)
  repeat with sprNum in goK.iLsprNum.main.PANEL
    Ltemp.append(sprNum)
  end repeat
  gxBeatnik.noteOn(2, 2, 0, 8, 127)
  SlideSprite(Ltemp, -350, 10, 400)
  goCurs.mChange(#arrow, me)
end
