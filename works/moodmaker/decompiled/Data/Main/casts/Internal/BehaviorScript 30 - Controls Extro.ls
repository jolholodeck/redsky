on exitFrame me
  global goCurs, goK, goPanel, gxBeatnik, goDiorama
  goCurs.mLock(#watch)
  sendSprite(goK.iLsprNum.logobtn, #PushButton_ToggleActive, 0)
  sendSprite(goK.iLsprNum.main.PANEL.tooltip, #mRestore)
  goPanel.mExit()
  Ltemp = duplicate(goK.iLsprNum.diorama)
  repeat with sprNum in goK.iLsprNum.main.PANEL
    Ltemp.append(sprNum)
  end repeat
  gxBeatnik.noteOn(2, 2, 0, 8, 127)
  SlideSprite(Ltemp, 350, 10, 400)
  goDiorama.Resume()
  repeat with data in goK.iLsprNum.ctrl.left.PANEL
    if ilk(data, #integer) then
      sendSprite(data, #PushButton_ToggleActive, 0)
      next repeat
    end if
    repeat with sprNum in data
      sendSprite(sprNum, #PushButton_ToggleActive, 0)
    end repeat
  end repeat
  LmemNums = ReverseList(goK.iLmemNumKnob)
  gxBeatnik.noteOn(2, 2, 0, 5, 100)
  FlipBook([sprite(goK.iLsprNum.main.PANEL.knob)], [LmemNums], [goK.iLibNumAssets], 400)
  sprite(goK.iLsprNum.main.PANEL.voltmp).member = goK.iMbrDot
  sprite(goK.iLsprNum.main.PANEL.vol).member = member(goK.iLmemNumVol[goK.iLmemNumVol.count], goK.iLibNumAssets)
  sprite(goK.iLsprNum.main.PANEL.vol).locH = sprite(goK.iLsprNum.main.PANEL.voltmp).locH
  sprite(goK.iLsprNum.main.PANEL.voltmp).locH = 0
  sprite(goK.iLsprNum.main.PANEL.volshdwtmp).member = goK.iMbrDot
  sprite(goK.iLsprNum.main.PANEL.volshdw).member = member(goK.iLmemNumVolShdw[goK.iLmemNumVolShdw.count], goK.iLibNumAssets)
  sprite(goK.iLsprNum.main.PANEL.volshdw).locH = sprite(goK.iLsprNum.main.PANEL.volshdwtmp).locH
  sprite(goK.iLsprNum.main.PANEL.volshdwtmp).locH = 0
  Lsprs = [sprite(goK.iLsprNum.main.PANEL.vol), sprite(goK.iLsprNum.main.PANEL.volshdw)]
  LmemNums = [ReverseList(goK.iLmemNumVol), ReverseList(goK.iLmemNumVolShdw)]
  LcstNums = [goK.iLibNumAssets, goK.iLibNumAssets]
  gxBeatnik.noteOn(2, 2, 0, 15, 100)
  FlipBook(Lsprs, LmemNums, LcstNums, 400)
  go("Main")
end
