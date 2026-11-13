property iDZID, iDelay, iSprEnabled, iSprDisabled
global goSndFX, goShellConstants, gMegaCnt

on exitFrame
  blnEnabled = goShellConstants.ikLEnabledFrameSets.getaProp(value("#dz" & string(6)))
  if blnEnabled then
    sprite(iSprEnabled).member = member("enabled.on")
    Levent = [#action: #play, #bank: 2, #pgm: 0, #note: 10, #vel: 127, #dur: mFrmsToTime(45)]
    goSndFX.mPostEvent(Levent)
    sprBtn = 108
    sprite(sprBtn).member = member("megamaster")
    sprite(sprBtn).loc = point(221, 347)
    Levent = [#action: #play, #bank: 2, #pgm: 6, #note: 60, #vel: 100, #dur: mFrmsToTime(10)]
    goSndFX.mPostEvent(Levent)
  else
    sprite(iSprDisabled).member = member("disabled.on")
    Levent = [#action: #play, #bank: 2, #pgm: 0, #note: 11, #vel: 127, #dur: mFrmsToTime(45)]
    goSndFX.mPostEvent(Levent)
    dur = mFrmsToTime(35)
    t = the milliSeconds
    repeat while the milliSeconds < (t + dur)
      updateStage()
      mWait(1)
    end repeat
    cnt = 3 - gMegaCnt
    case cnt of
      1:
        note = 13
      2:
        note = 12
    end case
    Levent = [#action: #play, #bank: 2, #pgm: 0, #note: note, #vel: 127, #dur: mFrmsToTime(45)]
    goSndFX.mPostEvent(Levent)
  end if
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
  Ltemp = [#comment: "Enabled Sprite:", #format: #integer, #default: 0]
  addProp(vPDList, #iSprEnabled, Ltemp)
  Ltemp = [#comment: "Disabled Sprite:", #format: #integer, #default: 0]
  addProp(vPDList, #iSprDisabled, Ltemp)
  return vPDList
end
