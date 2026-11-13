property mySpr, myMem, pBoxSpr, pBoxHiMem, pBoxLoMem, pMyCheckButtonRole, pBoxHiState, pDirtyBit
global gCurScreen, oLoginClass, oregisterClass

on beginSprite me
  mySpr = me.spriteNum
  myMem = sprite(mySpr).member
  case pMyCheckButtonRole of
    #box:
      pBoxSpr = mySpr
      pBoxHiState = 0
      pBoxHiMem = myMem.number - 1
      pBoxLoMem = myMem.number
    #hotText:
      pBoxSpr = mySpr - 1
  end case
  pDirtyBit = 0
end

on mCleanField me
  pDirtyBit = 0
  fieldCleanedScript = "o" & gCurScreen & "Class.mFieldCleaned()"
  do(fieldCleanedScript)
end

on mDirtyField me
  pDirtyBit = 1
  fieldDirtiedScript = "o" & gCurScreen & "Class.mFieldDirtied()"
  do(fieldDirtiedScript)
end

on mouseUp me
  mDoSelect(me)
  doScript = "o" & gCurScreen & "class.mCheckEvent(" & pBoxSpr & ")"
  do(doScript)
end

on mReturnDirtyBit me
  return pDirtyBit
end

on mDoSelect me
  playSound(#checkBox)
  if sendSprite(pBoxSpr, #getBoxHiState) then
    sendSprite(pBoxSpr, #setBoxHiState, 0)
  else
    sendSprite(pBoxSpr, #setBoxHiState, 1)
  end if
end

on setBoxHiState me, State
  if pMyCheckButtonRole = #box then
    if State = 1 then
      sprite(pBoxSpr).member = pBoxHiMem
    else
      sprite(pBoxSpr).member = pBoxLoMem
    end if
    pBoxHiState = State
  end if
end

on getBoxHiState me
  if pMyCheckButtonRole = #box then
    return pBoxHiState
  end if
end

on getPropertyDescriptionList
  propList = [#pMyCheckButtonRole: [#comment: "What am I?:", #format: #symbol, #range: [#box, #hotText], #default: #box]]
  return propList
end
