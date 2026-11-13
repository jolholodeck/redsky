property iState, iStrength, iSeconds, iCallBack, iStartTime, iEndTime, iSpr, X, Y, iOrigin
global oGyro, kPlatform

on beginSprite me
  if kPlatform <> #win then
    exit
  end if
  iSpr = sprite(me.spriteNum)
  X = value(baWindowInfo(baWinHandle(), "left"))
  Y = value(baWindowInfo(baWinHandle(), "top"))
  iOrigin = [X, Y]
  oGyro = me
  iState = #off
  me.mStartShake()
  (the actorList).add(me)
end

on stepFrame me
  if kPlatform <> #win then
    exit
  end if
  case iState of
    #on:
      me.mShake()
    #off:
      nothing()
  end case
  curX = value(baWindowInfo(baWinHandle(), "left"))
  curY = value(baWindowInfo(baWinHandle(), "top"))
end

on mResetOrigin me
  X = value(baWindowInfo(baWinHandle(), "left"))
  Y = value(baWindowInfo(baWinHandle(), "top"))
  iOrigin = [X, Y]
end

on mGoToOrigin me
  origin_x = iOrigin[1]
  origin_y = iOrigin[2]
  baMoveWindow(baWinHandle(), origin_x, origin_y, -1, -1, 1)
end

on mShake me
  X = value(baWindowInfo(baWinHandle(), "left"))
  Y = value(baWindowInfo(baWinHandle(), "top"))
  if the milliSeconds < iEndTime then
    dx = iStrength - (random(iStrength) * 2)
    dy = iStrength - (random(iStrength) * 2)
    me.moveWindow(dx, dy)
  else
    (the actorList).deleteOne(me)
    if iCallBack <> 0 then
      do(iCallBack)
    end if
  end if
end

on mStartShake me
  iState = #on
  iStartTime = the milliSeconds
  iEndTime = iStartTime + (iSeconds * 1000)
end

on mStopShake me
  iState = #off
end

on moveWindow me, dx, dy
  newX = iOrigin[1] + dx
  newY = iOrigin[2] + dy
  baMoveWindow(baWinHandle(), newX, newY, -1, -1, 1)
end

on endSprite me
  (the actorList).deleteOne(me)
end

on getPropertyDescriptionList
  propList = [:]
  setaProp(propList, #iStrength, [#comment: "Strength", #format: #integer, #default: 25, #range: [#min: 1, #max: 100]])
  setaProp(propList, #iSeconds, [#comment: "Seconds", #format: #integer, #default: 1, #range: [#min: 1, #max: 100]])
  setaProp(propList, #iCallBack, [#comment: "Callback handler", #format: #string, #default: EMPTY])
  return propList
end
