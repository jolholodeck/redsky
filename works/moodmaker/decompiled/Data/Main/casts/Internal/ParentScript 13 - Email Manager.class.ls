property iStrFriendsAddr, iStrFriendsName, iStrYourName, iMbrFriendsAddr, iMbrFriendsName, iMbrYourName, iNetID, iLsprFlds, iCurFld, iLcharFilters, iBlnEmailActive
global goK, goSysEnvirons, goDataStore

on new me
  iMbrFriendsAddr = member("friend's email", goK.iLibNumAssets)
  iMbrFriendsName = member("friend's name", goK.iLibNumAssets)
  iMbrYourName = member("your name", goK.iLibNumAssets)
  if goSysEnvirons.iPlatform = #mac then
    theFontSize = 10
    theFont = "Courier"
  else
    theFontSize = 10
    theFont = "Arial"
  end if
  iMbrFriendsAddr.text = " "
  iMbrFriendsName.text = " "
  iMbrYourName.text = " "
  iMbrFriendsAddr.fontSize = theFontSize
  iMbrFriendsName.fontSize = theFontSize
  iMbrYourName.fontSize = theFontSize
  iMbrFriendsAddr.font = theFont
  iMbrFriendsName.font = theFont
  iMbrYourName.font = theFont
  iStrYourName = goDataStore.mGetData(#yourname)
  if voidp(iStrYourName) then
    iStrYourName = EMPTY
  end if
  iStrFriendsName = EMPTY
  iStrFriendsAddr = EMPTY
  iLsprFlds = [sprite(goK.iLsprNum.email.addr), sprite(goK.iLsprNum.email.friendsname), sprite(goK.iLsprNum.email.yourname)]
  iNetID = 0
  iLcharFilters = []
  iLcharFilters.append(FlattenList([[28, 29], [48, 57], [65, 90], [97, 122], 8, 9, 95, 45, 64, 46]))
  iLcharFilters.append(FlattenList([8, 9, [28, 29], [32, 33], [35, 39], [42, 59], 61, [63, 126]]))
  iLcharFilters.append(FlattenList([8, 9, [28, 29], [32, 33], [35, 39], [42, 59], 61, [63, 126]]))
  iBlnEmailActive = 0
  set the keyDownScript to "KeyFilter"
  append(the actorList, me)
  return me
end

on stepFrame me
  if iNetID then
    if netDone(iNetID) then
      if netError(iNetID) = "OK" then
        sendSprite(goK.iLsprNum.email.status, #mDisplay, #success, 1)
      else
        sendSprite(goK.iLsprNum.email.status, #mDisplay, #error3, 1)
      end if
      iNetID = 0
    end if
  end if
end

on mInit me
  iMbrYourName.text = iStrYourName
  iMbrFriendsName.text = iStrFriendsName
  iMbrFriendsAddr.text = iStrFriendsAddr
  iCurFld = 0
  me.mActivateField(1)
  iBlnEmailActive = 1
end

on mExit me
  if iNetID then
    netAbort(iNetID)
    iNetID = 0
  end if
  me.mDisactivateCurField()
  iBlnEmailActive = 0
end

on mEmail_clickSend me, Ref, sprNum
  if iNetID then
    beep()
    exit
  end if
  strFriendsAddr = iMbrFriendsAddr.text
  strFriendsName = iMbrFriendsName.text
  strYourName = iMbrYourName.text
  strFriendsAddr = me.mStripSpaces(strFriendsAddr)
  strFriendsName = me.mStripSpaces(strFriendsName)
  strYourName = me.mStripSpaces(strYourName)
  if strFriendsAddr = EMPTY then
    errorFlg = 1
  end if
  if strFriendsName = EMPTY then
    errorFlg = 1
  end if
  if strYourName = EMPTY then
    errorFlg = 1
  end if
  if errorFlg then
    sendSprite(goK.iLsprNum.email.status, #mDisplay, #error1, 1)
    exit
  end if
  err = me.mValidateEmailAddr(strFriendsAddr)
  if err then
    sendSprite(goK.iLsprNum.email.status, #mDisplay, #error2, 1)
    exit
  end if
  strFriendsAddr = strFriendsAddr.char[1..min(128, strFriendsAddr.length)]
  strFriendsName = strFriendsName.char[1..min(128, strFriendsName.length)]
  strYourName = strYourName.char[1..min(128, strYourName.length)]
  sendSprite(goK.iLsprNum.email.status, #mDisplay, #sending)
  iStrFriendsAddr = strFriendsAddr
  iStrFriendsName = strFriendsName
  iStrYourName = strYourName
  Lquery = [:]
  Lquery.setaProp(#you, strYourName)
  Lquery.setaProp(#her, strFriendsName)
  Lquery.setaProp(#addr, strFriendsAddr)
  iNetID = postNetText(goK.iEmailCGIurl, Lquery)
end

on mStripSpaces me, str
  repeat while str.char[1] = " "
    delete me.char[1]
  end repeat
  repeat while str.char[str.length] = " "
    delete me.char[str.length]
  end repeat
  return str
end

on mValidateEmailAddr me, str
  Lpos = []
  repeat with n = 1 to str.length
    if str.char[n] = "." then
      Lpos.append(n)
    end if
  end repeat
  if Lpos.count >= 2 then
    repeat with n = 2 to Lpos.count
      if (Lpos[n] - Lpos[n - 1]) = 1 then
        return 1
      end if
    end repeat
  end if
  if not (str contains "@") then
    return 1
  end if
  cnt = 0
  repeat with n = 1 to str.length
    if str.char[n] = "@" then
      cnt = cnt + 1
    end if
  end repeat
  if cnt > 1 then
    return 1
  end if
  if (str.char[1] = "@") or (str.char[str.length] = "@") then
    return 1
  end if
  str1 = str.char[1..offset("@", str) - 1]
  str2 = str.char[offset("@", str) + 1..str.length]
  if not (str2 contains ".") then
    return 1
  end if
  if (str1.char[1] = ".") or (str1.char[str1.length] = ".") then
    return 1
  end if
  if (str2.char[1] = ".") or (str2.char[str2.length] = ".") then
    return 1
  end if
  return 0
end

on mActivateField me, whichFld
  if whichFld = iCurFld then
    exit
  end if
  me.mDisactivateCurField()
  iCurFld = whichFld
  iLsprFlds[iCurFld].editable = 1
  updateStage()
end

on mDisactivateCurField me
  if iCurFld < 1 then
    exit
  end if
  iLsprFlds[iCurFld].editable = 0
  updateStage()
end

on mTabField me
  newFld = iCurFld + 1
  if newFld > iLsprFlds.count then
    newFld = 1
  end if
  me.mActivateField(newFld)
end

on mMoveCursor me, Dir
  if Dir < 0 then
    set the selStart to max(0, the selStart - 1)
    set the selEnd to the selStart
  else
    case iCurFld of
      1:
        str = iMbrFriendsAddr.text
      2:
        str = iMbrFriendsName.text
      3:
        str = iMbrYourName.text
    end case
    set the selStart to min(str.length, the selEnd + 1)
    set the selEnd to the selStart
  end if
end
