property iDZID, iDelay, iSprEnabled, iSprDisabled
global goSndFX, goShellConstants, gMegaCnt

on exitFrame
  dur = mFrmsToTime(iDelay)
  t = the milliSeconds
  repeat while the milliSeconds < (t + dur)
    updateStage()
    mWait(1)
  end repeat
  blnEnabled = goShellConstants.ikLEnabledFrameSets.getaProp(value("#dz" & string(iDZID)))
  if blnEnabled then
    gMegaCnt = gMegaCnt + 1
    sprite(iSprEnabled).member = member("enabled.on")
    Levent = [#action: #play, #bank: 2, #pgm: 0, #note: 26, #vel: 127, #dur: mFrmsToTime(10)]
    goSndFX.mPostEvent(Levent)
    locVbtn = 127 + ((iDZID - 1) * 40)
    sprBtn = 18 + ((iDZID - 1) * 4)
    sprite(sprBtn).member = member("btn_" & string(iDZID) & "_enabled")
    sprite(sprBtn).loc = point(281, locVbtn)
    Levent = [#action: #play, #bank: 2, #pgm: 6, #note: 60, #vel: 100, #dur: mFrmsToTime(10)]
    goSndFX.mPostEvent(Levent)
    if (gMegaCnt >= 1) and (gMegaCnt <= 3) then
      spr = 105 + (gMegaCnt - 1)
      sprite(spr).member = member("mega" & string(gMegaCnt))
      sprite(spr).loc = point(203 + ((gMegaCnt - 1) * 18), 287)
    end if
  else
    sprite(iSprDisabled).member = member("disabled.on")
    Levent = [#action: #play, #bank: 2, #pgm: 0, #note: 25, #vel: 127, #dur: mFrmsToTime(10)]
    goSndFX.mPostEvent(Levent)
  end if
  dur = mFrmsToTime(15)
  t = the milliSeconds
  repeat while the milliSeconds < (t + dur)
    updateStage()
    mWait(1)
  end repeat
end

on mWait nbFrames
  dur = integer(1000 / float(the frameTempo) * nbFrames)
  t = the milliSeconds
  repeat while the milliSeconds < (t + dur)
  end repeat
end

on mFrmsToTime frms
  return integer(1000 / float(the frameTempo) * frms)
end

on getPropertyDescriptionList me
  vPDList = [:]
  Ltemp = [#comment: "DZ ID:", #format: #integer, #default: 1, #range: [1, 2, 3, 4, 5]]
  addProp(vPDList, #iDZID, Ltemp)
  Ltemp = [#comment: "Delay (in frames):", #format: #integer, #default: 10]
  addProp(vPDList, #iDelay, Ltemp)
  Ltemp = [#comment: "Enabled Sprite:", #format: #integer, #default: 0]
  addProp(vPDList, #iSprEnabled, Ltemp)
  Ltemp = [#comment: "Disabled Sprite:", #format: #integer, #default: 0]
  addProp(vPDList, #iSprDisabled, Ltemp)
  return vPDList
end
