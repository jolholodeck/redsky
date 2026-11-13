property pFirstNameTextMem, pLastNameTextMem, pBirthdayTextMem1, pBirthdayTextMem2, pBirthdayTextMem3, pZipTextMem, pEmailTextMem, pUsernameTextMem, pPasswordTextMem, pMoreInfoCheck, pPword1Spr, pPword2Spr, plFields, pConnectCheck1, pConnectCheck2, pConnectCheck3, pConnectCheck4, pGenderCheck1, pGenderCheck2, plRegData, pCurRegReq
global gNavMenu, oPrefsClass, oRequestMgr, kMyId

on new me
  pFirstNameTextMem = "in_R_firstname"
  pLastNameTextMem = "in_R_lastname"
  pBirthdayTextMem1 = "in_R_birthday1"
  pBirthdayTextMem2 = "in_R_birthday2"
  pBirthdayTextMem3 = "in_R_birthday3"
  pZipTextMem = "in_R_zip"
  pEmailTextMem = "in_R_email"
  pUsernameTextMem = "in_R_username"
  pPasswordTextMem = "in_R_password1"
  pPword1Spr = 10
  plFields = [pFirstNameTextMem, pLastNameTextMem, pBirthdayTextMem1, pBirthdayTextMem2, pBirthdayTextMem3, pZipTextMem, pEmailTextMem, pUsernameTextMem, pPasswordTextMem]
  return me
end

on mInitMyScreen me
  if plRegData = VOID then
    plRegData = [#sound: 1, #autocheck: 1, #showLogin: 0, #id: 0, #sFirstName: EMPTY, #sLastName: EMPTY, #sDOB: EMPTY, #sZipCode: EMPTY, #sEmail: EMPTY, #sScreenName: EMPTY, #sPassword: EMPTY, #sOptIn: "y", #sConnectSpeed: "56k", #sGender: "none"]
  else
    member(pFirstNameTextMem).text = plRegData.sFirstName
    member(pLastNameTextMem).text = plRegData.sLastName
    the itemDelimiter = "/"
    member(pBirthdayTextMem1).text = plRegData.sDOB.item[1]
    member(pBirthdayTextMem2).text = plRegData.sDOB.item[2]
    member(pBirthdayTextMem3).text = plRegData.sDOB.item[3]
    member(pZipTextMem).text = plRegData.sZipCode
    member(pEmailTextMem).text = plRegData.sEmail
    member(pUsernameTextMem).text = plRegData.sScreenName
    sprite(pPword1Spr).mFillInPassword(plRegData.sPassword)
  end if
  member("reg error").text = EMPTY
end

on mLeaveReg me
  userID = pCurRegReq
  pCurRegReq = VOID
  startMovie()
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #R_next:
      if mCheckFieldInput(me) then
        mUpdateRegData(me)
        member("reg error").text = EMPTY
        go("register2")
      end if
    #R_cancel:
      member("reg error").text = EMPTY
      plRegData = VOID
      go("login")
  end case
end

on mFieldCleaned me
end

on mFieldDirtied me
end

on mLeaveMyScreen me
end

on regError me, errorText
  member("reg error").text = errorText
end

on mErrorAlert me, errorType, special
  case errorType of
  end case
end

on mUpdateRegData me
  plRegData.id = 0
  plRegData.sFirstName = member(pFirstNameTextMem).text
  plRegData.sLastName = member(pLastNameTextMem).text
  plRegData.sDOB = member(pBirthdayTextMem1).text & "/" & member(pBirthdayTextMem2).text & "/" & member(pBirthdayTextMem3).text
  plRegData.sZipCode = member(pZipTextMem).text
  plRegData.sEmail = member(pEmailTextMem).text
  plRegData.sScreenName = member(pUsernameTextMem).text
  plRegData.sPassword = sendSprite(pPword1Spr, #mReturnPassword)
end

on mCheckFieldInput me
  repeat with curField in plFields
    curText = member(curField).text
    trimmedText = trimSpaces(curText)
    if trimmedText = EMPTY then
      regError(me, "Please fill out each field.")
      return 0
    end if
  end repeat
  monthNum = value(member(pBirthdayTextMem1).text)
  dayNum = value(member(pBirthdayTextMem2).text)
  yearNum = value(member(pBirthdayTextMem3).text)
  if (monthNum > 12) or (monthNum < 1) then
    regError(me, "The birthdate you've entered is invalid.")
    return 0
  end if
  if (dayNum > 31) or (dayNum < 1) then
    regError(me, "The birthdate you've entered is invalid.")
    return 0
  end if
  if dayNum > mGetMaxDayNum(monthNum, yearNum) then
    regError(me, "The birthdate you've entered is invalid.")
    return 0
  end if
  if not (member(pEmailTextMem).text contains "@") or not (member(pEmailTextMem).text contains ".") then
    regError(me, "You've entered an invalid email address.")
    return 0
  end if
  if the number of chars in the text of member pPasswordTextMem < 4 then
    regError(me, "Password must be at least 4 characters.")
    return 0
  end if
  ziptext = member(pZipTextMem).text
  if ziptext.chars.count < 5 then
    regError(me, "The zip code you've entered is invalid.")
    return 0
  end if
  regError(me, EMPTY)
  return 1
end
