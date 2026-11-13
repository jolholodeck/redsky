property iName, iCallBack, iSpr, iWidget

on beginSprite me
  module = "1.1.1"
  widget = 1
  iSpr = sprite(me.spriteNum)
  iSprNum = me.spriteNum
  iCastLib = iSpr.castLibNum
  iSpr.loc = point(0, 0)
  matteInk = 8
  CopyInk = 0
  transInk = 36
  if (iName contains "game") or (iName contains "bar") or (iName contains "whistle") or (iName contains "whynot") then
    iSpr.ink = transInk
  else
    iSpr.ink = matteInk
  end if
  iWidget = script("Generic Widget Class").new(module, widget, iSprNum, 1, iName, iCastLib, iCallBack)
  iWidget.mStartup()
  iWidget.mTrigger()
end

on endSprite me
  iWidget.mShutdown()
end

on getPropertyDescriptionList
  propList = [:]
  setaProp(propList, #iName, [#comment: "Name", #format: #string, #default: EMPTY])
  setaProp(propList, #iCallBack, [#comment: "Callback goes to which frame label?", #format: #string, #default: EMPTY])
  return propList
end
