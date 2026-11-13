property mySprite, mySpriteNum, myMember, myMemberNum, myStandardMember, myRolloverMember, myRollOverSound, myMouseDownMember, myMouseDownSound, pMyCallBack
global oCurMeeting, gCurScreen, oCalendarClass, oCalendar2Class, oPrefsClass, oLoginClass, oregisterClass, oTuner2Class, oFriendsClass, oPlacesClass, gNavMenuHiSpr, oDialogueClass, oConnectoScope, gState, oInvite3Class

on beginSprite me
  Initialize(me)
end

on Initialize me
  mySpriteNum = me.spriteNum
  mySprite = sprite(mySpriteNum)
  myMember = mySprite.member
  myMemberNum = mySprite.member
  myStandardMember = value(myStandardMember)
  myMouseDownMember = value(myMouseDownMember)
  myRolloverMember = value(myRolloverMember)
  myMember = myStandardMember
end

on mouseUp me
  mySprite.member = myRolloverMember
  doMyCallBack(me)
end

on mouseDown me
  mySprite.member = myMouseDownMember
  updateStage()
end

on mouseUpOutSide me
  mySprite.member = myStandardMember
end

on mouseEnter me
  if gState = #Active then
    mySprite.member = myRolloverMember
  end if
end

on mouseLeave me
  mySprite.member = myStandardMember
end

on doMyCallBack me
  if gCurScreen = "main" then
    mouseDownScriptToDo = "o" & gCurScreen & "Class.mDoMyMouseDown(pMyCallBack)"
    do(mouseDownScriptToDo)
  else
    if pMyCallBack = #X_invite then
      leaveScoreSection()
      go("animCloseAlt")
    else
      if pMyCallBack = #X_close then
        leaveScoreSection()
        go("animClose")
      else
        if pMyCallBack = #CI_send then
          leaveScoreSection()
          go("sendFlapClose")
        else
          if pMyCallBack = #M_powerup then
            go("animpowerup")
          end if
        end if
      end if
    end if
  end if
end

on getPropertyDescriptionList me
  if not (the currentSpriteNum) then
    exit
  end if
  theMember = sprite(the currentSpriteNum).member
  theMemberNum = theMember.number
  descriptionList = [#myStandardMember: [#comment: "Standard member:", #format: #member, #default: member(theMemberNum)], #myMouseDownMember: [#comment: "MouseDown member:", #format: #member, #default: member(theMemberNum + 1)], #myRolloverMember: [#comment: "Inactive:", #format: #member, #default: member(theMemberNum + 2)], #pMyCallBack: [#comment: "What callback?:", #format: #symbol, #default: #none, #range: [#X_invite, #X_close, #CI_send, #M_open, #M_invite, #M_powerup]]]
  return descriptionList
end
