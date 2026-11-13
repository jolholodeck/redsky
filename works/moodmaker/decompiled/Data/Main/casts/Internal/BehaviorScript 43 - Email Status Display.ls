property spriteNum, mySprite, myDefaultMember, iBlnWaitForUserEvent, mySendingMember, mySuccessMember, myError1Member, myError2Member, myError3Member

on beginSprite me
  mySprite = sprite(me.spriteNum)
  myDefaultMember = mySprite.member
  iBlnWaitForUserEvent = 0
end

on exitFrame me
  if not iBlnWaitForUserEvent then
    exit
  end if
  if the mouseDown or (the keyPressed <> EMPTY) then
    iBlnWaitForUserEvent = 0
    mySprite.member = myDefaultMember
    stopEvent()
  end if
end

on mDisplay me, Msg, blnWaitForUserEvent
  case Msg of
    #default:
      mySprite.member = myDefaultMember
    #sending:
      mySprite.member = mySendingMember
    #success:
      mySprite.member = mySuccessMember
    #error1:
      mySprite.member = myError1Member
    #error2:
      mySprite.member = myError2Member
    #error3:
      mySprite.member = myError3Member
  end case
  if blnWaitForUserEvent then
    iBlnWaitForUserEvent = 1
  end if
  stopEvent()
end

on getPropertyDescriptionList me
  if not (the currentSpriteNum) then
    exit
  end if
  theMember = sprite(the currentSpriteNum).member
  theMemberNum = theMember.number
  descriptionList = [#mySendingMember: [#comment: "'Sending' message member:", #format: #member, #default: member(theMemberNum + 1)], #mySuccessMember: [#comment: "'Thank-you' message member:", #format: #member, #default: member(theMemberNum + 2)], #myError1Member: [#comment: "'Error 1' message member:", #format: #member, #default: member(theMemberNum + 3)], #myError2Member: [#comment: "'Error 2' message member:", #format: #member, #default: member(theMemberNum + 4)], #myError3Member: [#comment: "'Error 3' message member:", #format: #member, #default: member(theMemberNum + 5)]]
  return descriptionList
end
