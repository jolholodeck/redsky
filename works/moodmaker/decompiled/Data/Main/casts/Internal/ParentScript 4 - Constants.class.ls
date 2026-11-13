property iPathDelim, iPrefsFileName, iLibNumAssets, iLibNumCollUI, iLibNumCollDio, iLibNumSndScape, iEmptyCstPath, iSndPath, iPatchesPath, iUIrmfPath, iCollPath, iLsprNum, iMbrPvwBuff, iMbrDot, iLmemNumKnob, iLmemNumVol, iLmemNumVolShdw, iDefaultCollOrder, iEmailCGIurl, iRndPlayDur
global gDebug

on new me, platform
  if platform = #win then
    iPrefsFileName = "MoodMaker.ini"
    iPathDelim = "\"
  else
    iPrefsFileName = "MoodMaker Prefs"
    iPathDelim = ":"
  end if
  iLibNumAssets = castLib("Assets").number
  iLibNumCollUI = castLib("Collection UI").number
  iLibNumCollDio = castLib("Collection Diorama").number
  iLibNumSndScape = castLib("SoundScape").number
  iEmptyCstPath = the moviePath & "Empty"
  iSndPath = the moviePath & "Snd" & iPathDelim
  iPatchesPath = iSndPath & "Stub.hsb"
  iUIrmfPath = iSndPath & "UI.rmf"
  iCollPath = the moviePath & "Collections" & iPathDelim
  iLsprNum = [:]
  iLsprNum.addProp(#diorama, makeList(43, 25))
  iLsprNum.addProp(#logobtn, 84)
  iLsprNum.addProp(#main, [:])
  iLsprNum.main.addProp(#PANEL, [#beauty: 68, #preview: 69, #a: 70, #dioframe: 71, #tooltip: 72, #email: 73, #mute: 74, #leftarrow: 75, #rightarrow: 76, #d: 77, #knob: 78, #volshdwtmp: 79, #voltmp: 80, #volshdw: 85, #vol: 86])
  iLsprNum.addProp(#email, [#addr: 2, #friendsname: 3, #yourname: 4, #status: 8, #send: 12, #Cancel: 13])
  iLsprNum.addProp(#ctrl, [:])
  iLsprNum.ctrl.addProp(#left, [:])
  iLsprNum.ctrl.left.addProp(#PANEL, [#PANEL: 20, #elementlabel: 33, #knob: 36, #blendlabel: 42, #resetbtn: 34, #rndbtn: 35])
  iLsprNum.ctrl.left.PANEL.addProp(#blendbtnlist, makeList(37, 5))
  iLsprNum.ctrl.left.PANEL.addProp(#elementbtnlist, makeList(21, 12))
  iLsprNum.ctrl.addProp(#right, [#PANEL: 7, #toggle1: 8, #toggle2: 9, #toggle3: 10, #toggle4: 11, #label: 12, #dialshdw: 13, #dial: 14, #dialball: 15, #btnleft: 16, #btnright: 17, #panellogo: 18])
  iMbrPvwBuff = member("Preview Buffer", iLibNumAssets)
  iMbrDot = member("1-bit dot", iLibNumAssets)
  iLmemNumKnob = makeList(member("main_control panel knob 1", iLibNumAssets).memberNum, 5)
  iLmemNumVol = makeList(member("volume_slider_1", iLibNumAssets).memberNum, 4)
  iLmemNumVolShdw = makeList(member("VOLUME_1 shadow", iLibNumAssets).memberNum, 4)
  iDefaultCollOrder = ["Napa", "Shenval", "Helena"]
  iEmailCGIurl = "http://www.sutterhome.com/cgi-bin/mood_maker.cgi"
  if gDebug then
    iRndPlayDur = 1000 * 60 * 5
  else
    iRndPlayDur = 1000 * 60 * 60
  end if
  return me
end
