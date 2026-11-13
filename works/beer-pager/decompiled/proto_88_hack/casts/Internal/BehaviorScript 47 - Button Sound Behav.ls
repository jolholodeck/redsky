property iRolloverSound, iDownSound, iUpSound, iBeginSprite, iEndSprite, iMeaningOfLife

on beginSprite me
  iRolloverSound = me.convertToList(iRolloverSound)
  iDownSound = me.convertToList(iDownSound)
  iUpSound = me.convertToList(iUpSound)
  iBeginSprite = me.convertToList(iBeginSprite)
  iEndSprite = me.convertToList(iEndSprite)
  if iBeginSprite = 0 then
    exit
  end if
  bank = iBeginSprite[1]
  program = iBeginSprite[2]
  note = iBeginSprite[3]
  vel = iBeginSprite[4]
  dur = iBeginSprite[5]
  playSound(bank, program, note, vel, dur)
end

on convertToList me, txt
  if txt = "0" then
    return 0
  else
    listText = "[" & txt & "]"
    listVal = value(listText)
    return listVal
  end if
end

on mouseEnter me
  if iRolloverSound = 0 then
    exit
  end if
  bank = iRolloverSound[1]
  program = iRolloverSound[2]
  note = iRolloverSound[3]
  vel = iRolloverSound[4]
  dur = iRolloverSound[5]
  playSound(bank, program, note, vel, dur)
end

on mouseDown me
  if iDownSound = 0 then
    exit
  end if
  bank = iDownSound[1]
  program = iDownSound[2]
  note = iDownSound[3]
  vel = iDownSound[4]
  dur = iDownSound[5]
  playSound(bank, program, note, vel)
end

on mouseUp me
  if iUpSound = 0 then
    exit
  end if
  bank = iUpSound[1]
  program = iUpSound[2]
  note = iUpSound[3]
  vel = iUpSound[4]
  dur = iUpSound[5]
  playSound(bank, program, note, vel, dur)
end

on endSprite me
  if iEndSprite = 0 then
    exit
  end if
  bank = iEndSprite[1]
  program = iEndSprite[2]
  note = iEndSprite[3]
  vel = iEndSprite[4]
  dur = iEndSprite[5]
  playSound(bank, program, note, vel)
end

on getPropertyDescriptionList me
  propList = [:]
  setaProp(propList, #iRolloverSound, [#comment: "Rollover sound", #format: #string, #default: "0"])
  setaProp(propList, #iDownSound, [#comment: "Mousedown sound", #format: #string, #default: "0"])
  setaProp(propList, #iUpSound, [#comment: "Mouseup sound", #format: #string, #default: "0"])
  setaProp(propList, #iBeginSprite, [#comment: "Begin sprite sound", #format: #string, #default: "0"])
  setaProp(propList, #iEndSprite, [#comment: "End sprite sound", #format: #string, #default: "0"])
  setaProp(propList, #iMeaningOfLife, [#comment: "Meaninsg of life", #format: #symbol, #default: #Yeah_right_whatever, #range: [#Yeah_right_whatever]])
  return propList
end
