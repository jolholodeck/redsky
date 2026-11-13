property mySpr, myMem, pLMyRadioButtonsGroup, pMyRadioRole, pLMyValues, pBoxHiMem, pBoxLoMem
global oCurMeeting, oregisterClass, oregister2Class

on beginSprite me
  mySpr = me.spriteNum
  myMem = sprite(mySpr).member
  pBoxHiMem = myMem.number + 1
  pBoxLoMem = myMem.number
  case pMyRadioRole of
    #inviteWhy:
      myGroup = [11, 12, 13, 14]
      valueList = [#millerTime, #afterWork, #theGame, #whyNot]
    #connect:
      myGroup = [oregister2Class.pConnectCheck1, oregister2Class.pConnectCheck2, oregister2Class.pConnectCheck3, oregister2Class.pConnectCheck4]
      valueList = ["28.8", "33.6", "56k", "T1"]
    #gender:
      myGroup = [oregister2Class.pGenderCheck1, oregister2Class.pGenderCheck2]
      valueList = [#M, #f]
  end case
  pLMyRadioButtonsGroup = myGroup
  pLMyValues = valueList
end

on mouseUp me
  mDoSelect(me, mySpr)
  playSound(#radio)
end

on mDoSelect me, curSpr
  repeat with curButt in pLMyRadioButtonsGroup
    sprite(curButt).member = sprite(curButt).pBoxLoMem
  end repeat
  sprite(curSpr).member = sprite(curSpr).pBoxHiMem
  myIdx = getPos(pLMyRadioButtonsGroup, curSpr)
  valToSet = getAt(pLMyValues, myIdx)
  case pMyRadioRole of
    #inviteWhy:
      oCurMeeting.mUpdateMeetingData(#iWhy, myIdx)
    #connect:
      oregisterClass.plRegData.sConnectSpeed = valToSet
    #gender:
      oregisterClass.plRegData.sGender = valToSet
  end case
end

on mSelectByIdx me, idx
  curSpr = getAt(pLMyRadioButtonsGroup, idx)
  mDoSelect(me, curSpr)
end

on getPropertyDescriptionList
  propList = [#pMyRadioRole: [#comment: "Which group?:", #format: #symbol, #range: [#inviteWhy, #connect, #gender], #default: #none]]
  return propList
end
