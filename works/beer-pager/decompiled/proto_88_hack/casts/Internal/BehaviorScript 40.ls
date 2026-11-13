property pCurWord, pValidChars, pValidCharSet, pAdditionalChars, pNotTheseChars, pCharMax, pSprite, pMember, pDirtyBit
global gCurScreen

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pMember = pSprite.member
  pCurWord = EMPTY
  if member(myCurMem(me)).type = #field then
    member(myCurMem(me)).text = EMPTY
  end if
  pDirtyBit = 0
  mGetMyValidChars(me)
end

on myCurMem me
  return sprite(pSprite).member
end

on mGetMyValidChars me
  case pValidCharSet of
    #all:
      pValidChars = "abcdefghijklmnopqrstuvwxyz1234567890 _!@#$%^*()+=[]{}|\':;,.?/~`-" & QUOTE
    #alphanumeric:
      pValidChars = "abcdefghijklmnopqrstuvwxyz1234567890_"
    #Alpha:
      pValidChars = "abcdefghijklmnopqrstuvwxyz"
    #numbers:
      pValidChars = "1234567890"
  end case
  pValidChars = pValidChars & pAdditionalChars
  if pNotTheseChars <> EMPTY then
    repeat with curLetterNum = 1 to the number of chars in pNotTheseChars
      curLetter = pNotTheseChars.char[curLetterNum]
      charPos = offset(curLetter, pValidChars)
      if charPos then
        delete char charPos of pValidChars
      end if
    end repeat
  end if
  if not pCharMax then
    pCharMax = 500
  end if
end

on mCleanField me
  pDirtyBit = 0
  fieldCleanedScript = "o" & gCurScreen & "Class.mFieldCleaned(1)"
  do(fieldCleanedScript)
end

on mDirtyField me
  pDirtyBit = 1
  fieldDirtiedScript = "o" & gCurScreen & "Class.mFieldDirtied(1)"
  do(fieldDirtiedScript)
end

on keyDown me
  nothing()
  pCurWord = member(myCurMem(me)).text
  if isEditingKey() then
    pass()
  else
    if pValidChars contains the key then
      if the number of chars in pCurWord = pCharMax then
        if the selStart = the selEnd then
          exit
        end if
      end if
      if not pDirtyBit then
        mDirtyField(me)
      end if
      pass()
    end if
  end if
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
      alert("Maximum number of characters for this field is " & string(pCharMax))
  end case
end

on getPropertyDescriptionList
  propList = [#pValidCharSet: [#comment: "Allowed Chars:", #format: #symbol, #range: [#all, #alphanumeric, #Alpha, #numbers], #default: #all], #pAdditionalChars: [#comment: "Additional Chars:", #format: #string, #default: EMPTY], #pNotTheseChars: [#comment: "Not these:", #format: #string, #default: EMPTY], #pCharMax: [#comment: "Char Limit:", #format: #integer, #range: [#min: 0, #max: 60], #default: 30]]
  return propList
end
