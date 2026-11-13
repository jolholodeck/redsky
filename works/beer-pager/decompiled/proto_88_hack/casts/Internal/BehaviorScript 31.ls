property pCurWord, pValidChars, pSprite, pMember, pBullet, pCharMax, pDirtyBit
global kPlatform, gCurScreen, oPrefsClass

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pValidChars = "abcdefghijklmnopqrstuvwxyz1234567890"
  pCurWord = EMPTY
  member(myCurMem(me)).text = EMPTY
  if the platform contains "win" then
    pBullet = numToChar(149)
  else
    pBullet = numToChar(165)
  end if
  if myCurMem(me).name = "APS Pword" then
    pCharMax = 50
  else
    pCharMax = 8
  end if
  pDirtyBit = 0
end

on myCurMem me
  return pSprite.member
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

on mReturnPassword me
  return pCurWord
end

on mSetPassword me, pWord
  pCurWord = pWord
end

on mFillInPassword me, Password
  mSetPassword(me, Password)
  member(myCurMem(me)).text = makeBullets()
end

on keyDown me
  if the optionDown then
    pass()
  end if
  curText = member(myCurMem(me)).text
  if pValidChars contains the key then
    oldSelStart = the selStart
    if the selStart <> the selEnd then
      delete char (the selStart + 1) to (the selEnd) of pCurWord
    end if
    if the selStart = 0 then
      part1 = EMPTY
    else
      part1 = char 1 to (the selStart) of pCurWord
    end if
    part2 = char (the selStart + 1) to (the number of chars in pCurWord) of pCurWord
    curWord = part1 & the key & part2
    if the number of chars in pCurWord = pCharMax then
      exit
    end if
    pCurWord = curWord
    member(myCurMem(me)).text = makeBullets(me)
    set the selStart to oldSelStart + 1
    set the selEnd to the selStart
    if not pDirtyBit then
      mDirtyField(me)
    end if
  else
    if (the key = BACKSPACE) or (the keyCode = 117) then
      if the selStart = the selEnd then
        if the selStart = 0 then
          exit
        else
          delete char (the selStart) of pCurWord
          checkIfEmpty(me)
        end if
      else
        delete char (the selStart + 1) to (the selEnd) of pCurWord
        checkIfEmpty(me)
      end if
      pass()
    else
      if isEditingKey(me) then
        pass()
      else
      end if
    end if
  end if
end

on checkIfEmpty me
  if gCurScreen = "prefs" then
    oPrefsClass.mCheckButtons(me)
  end if
end

on makeBullets me
  bullet = EMPTY
  repeat with X = 1 to the number of chars in pCurWord
    bullet = bullet & pBullet
  end repeat
  return bullet
end

on isEditingKey me
  case the key of
    TAB:
      return 1
  end case
  case the keyCode of
    51, 117, 123, 124, 125, 126:
      return 1
    otherwise:
      return 0
  end case
end

on mErrorAlert me, errorType
  case errorType of
    #maxChar:
      alert("Your password can be no longer than 8 characters")
  end case
end
