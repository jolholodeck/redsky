property pMySpr, pMyMem, myUpMember, myDownMember, myScrollDir, myScrollJump, myTextToScrollMem

on beginSprite me
  pMySpr = me.spriteNum
  pMyMem = sprite(pMySpr).member
  pMyMemNum = pMyMem.number
  myUpMember = pMyMemNum
  myDownMember = pMyMemNum - 1
  if myScrollDir = #up then
    myScrollJump = -1
  else
    myScrollJump = 1
  end if
end

on mouseDown me
  sprite(pMySpr).member = myDownMember
  repeat while the stillDown
    case myScrollDir of
      #down:
        playSound(#scrollDown)
      #up:
        playSound(#scrollUp)
    end case
    scrollByLine(member(myTextToScrollMem), myScrollJump)
    updateStage()
    waitForTimer(me, 5, #mouseUp)
  end repeat
end

on mouseUp me
  sprite(pMySpr).member = myUpMember
end

on mouseUpOutSide me
  sprite(pMySpr).member = myUpMember
end

on waitForTimer me, myTicks, condition
  waitTime = the timer + myTicks
  repeat while the timer < waitTime
    case condition of
      #mouseUp:
        if the mouseUp then
          exit repeat
        end if
      otherwise:
    end case
  end repeat
end

on getPropertyDescriptionList me
  if not (the currentSpriteNum) then
    exit
  end if
  theMember = sprite(the currentSpriteNum).member
  theMemberNum = theMember.number
  descriptionList = [#myTextToScrollMem: [#comment: "Text field to scroll:", #format: #field, #default: member(theMemberNum)], #myScrollDir: [#comment: "Text field to scroll:", #format: #symbol, #range: [#up, #down], #default: #up]]
  return descriptionList
end
