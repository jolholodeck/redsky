property iBank, iPgm, iNote, iVel, iDur, iPgmR, iNoteR, iVelR, iCtrl, iBgnFrm, iEndFrm, iBgnVal, iEndVal, iValR
global goSndFX

on enterFrame
  dur = integer(1000 / float(the frameTempo) * iDur)
  Levent = [#action: #play, #bank: iBank, #pgm: iPgm, #note: iNote, #vel: iVel, #dur: dur]
  Lrnd = [:]
  if iNoteR <> "0" then
    addProp(Lrnd, #note, iNoteR)
  end if
  if iPgmR <> "0" then
    addProp(Lrnd, #pgm, iPgmR)
  end if
  if iVelR <> "0" then
    addProp(Lrnd, #vel, iVelR)
  end if
  if Lrnd.count() then
    addProp(Levent, #rnd, Lrnd)
  end if
  Lctrl = [:]
  if iCtrl <> "none" then
    addProp(Lctrl, #ctrl, integer(iCtrl))
    addProp(Lctrl, #bgnFrm, iBgnFrm)
    addProp(Lctrl, #endFrm, iEndFrm)
    addProp(Lctrl, #bgnVal, iBgnVal)
    addProp(Lctrl, #endVal, iEndVal)
    if iValR <> "0" then
      addProp(Lctrl, #rnd, iValR)
    end if
  end if
  if Lctrl.count() then
    addProp(Levent, #ctrl, Lctrl)
  end if
  goSndFX.mPostEvent(Levent)
end

on getPropertyDescriptionList me
  vPDList = [:]
  Ltemp = [#comment: "Bank:", #format: #integer, #default: 2, #range: [0, 1, 2]]
  addProp(vPDList, #iBank, Ltemp)
  Ltemp = [#comment: "Program:", #format: #integer, #default: 0, #range: [#min: 0, #max: 127]]
  addProp(vPDList, #iPgm, Ltemp)
  Ltemp = [#comment: "Note:", #format: #integer, #default: 0, #range: [#min: 0, #max: 127]]
  addProp(vPDList, #iNote, Ltemp)
  Ltemp = [#comment: "Velocity:", #format: #integer, #default: 100, #range: [#min: 0, #max: 127]]
  addProp(vPDList, #iVel, Ltemp)
  Ltemp = [#comment: "Duration:", #format: #integer, #default: 10]
  addProp(vPDList, #iDur, Ltemp)
  Ltemp = [#comment: "Pgm Rnd:", #format: #string, #default: "0"]
  addProp(vPDList, #iPgmR, Ltemp)
  Ltemp = [#comment: "Note Rnd:", #format: #string, #default: "0"]
  addProp(vPDList, #iNoteR, Ltemp)
  Ltemp = [#comment: "Vel Rnd:", #format: #string, #default: "0"]
  addProp(vPDList, #iVelR, Ltemp)
  Ltemp = [#comment: "Controller:", #format: #string, #default: "none", #range: ["none", "1", "7", "10"]]
  addProp(vPDList, #iCtrl, Ltemp)
  Ltemp = [#comment: "Bgn Frm:", #format: #integer, #default: 0]
  addProp(vPDList, #iBgnFrm, Ltemp)
  Ltemp = [#comment: "End Frm:", #format: #integer, #default: 0]
  addProp(vPDList, #iEndFrm, Ltemp)
  Ltemp = [#comment: "Bgn Val:", #format: #integer, #default: 0, #range: [#min: 0, #max: 127]]
  addProp(vPDList, #iBgnVal, Ltemp)
  Ltemp = [#comment: "End Val:", #format: #integer, #default: 0, #range: [#min: 0, #max: 127]]
  addProp(vPDList, #iEndVal, Ltemp)
  Ltemp = [#comment: "Val Rnd:", #format: #string, #default: "0"]
  addProp(vPDList, #iValR, Ltemp)
  return vPDList
end
