property mySprite, mySpriteNum, myMember, myMemberNum, myStandardMember, myRolloverMember, myMouseDownMember, pMyCallBack, pOldScreen
global gNavMenuHiSpr, gCurScreen

on beginSprite me
  Initialize(me)
end

on Initialize me
  mySpriteNum = me.spriteNum
  mySprite = sprite(mySpriteNum)
  myMember = mySprite.member
  myMemberNum = mySprite.member
  myStandardMember = value(myStandardMember)
  myRolloverMember = value(myRolloverMember)
  myMouseDownMember = value(myMouseDownMember)
  myMember = myStandardMember
end

on mouseDown me
  if mySpriteNum <> gNavMenuHiSpr then
    mDoTopNav(me)
    doMyCallBack(me)
  end if
end

on mDoTopNav me
  playSound(#topNav)
  pOldScreen = gCurScreen
  leaveScoreSection()
  mSelect(me)
  gNavMenuHiSpr = mySpriteNum
end

on mSelect me
  if gNavMenuHiSpr then
    sendSprite(gNavMenuHiSpr, #mDeSelect)
  end if
  sprite(mySpriteNum).memberNum = sprite(mySpriteNum).memberNum + 1
end

on mDeSelect me
  sprite(mySpriteNum).memberNum = sprite(mySpriteNum).memberNum - 1
end

on doMyCallBack me
  case pMyCallBack of
    #X_invite:
      go("invite")
    #X_friends:
      go("friends")
    #X_places:
      go("places")
    #X_prefs:
      go("prefs")
    #X_help:
      go("help")
    #X_tuner:
      sprite(61).mHideLite()
      go("tuner")
    #X_calendar:
      go("calendar")
    #X_main:
      gNavMenuHiSpr = 0
      go("main")
  end case
end

on getPropertyDescriptionList me
  if not (the currentSpriteNum) then
    exit
  end if
  theMember = sprite(the currentSpriteNum).member
  theMemberNum = theMember.number
  descriptionList = [#myStandardMember: [#comment: "Standard member:", #format: #member, #default: member(theMemberNum)], #myMouseDownMember: [#comment: "MouseDown member:", #format: #member, #default: member(theMemberNum + 1)], #pMyCallBack: [#comment: "What callback?:", #format: #symbol, #default: #none, #range: [#X_invite, #X_friends, #X_places, #X_prefs, #X_help, #X_tuner, #X_calendar, #X_main]]]
  return descriptionList
end
