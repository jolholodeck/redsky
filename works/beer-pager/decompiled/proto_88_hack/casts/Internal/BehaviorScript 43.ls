property mySprite, mySpriteNum, myMember, myMemberNum, myStandardMember, myHiliteMember, myBlinkStyle, pTimerIncrement, pCurTimer, pBlinking, pBlinkTimer, pMyLiteType
global oConnectoScope

on beginSprite me
  Initialize(me)
end

on Initialize me
  mySprite = me.spriteNum
  myMember = sprite(mySpriteNum).member
  myMemberNum = myMember.number
  case pMyLiteType of
    #main:
      myStandardMember = member(132)
      myHiliteMember = member(141)
      myBlinkStyle = #multi
    #invite:
      myStandardMember = member(93)
      myHiliteMember = member(94)
      myBlinkStyle = #single
    #other:
      myStandardMember = member(91)
      myHiliteMember = member(92)
      myBlinkStyle = #single
  end case
  pTimerIncrement = 60 * 10
  pCurTimer = 0
  pBlinking = 0
end

on exitFrame me
  if the timer > pCurTimer then
    pCurTimer = the timer + pTimerIncrement
    if oConnectoScope.mConnected() then
      if myMember <> myHiliteMember then
        sprite(mySprite).member = myHiliteMember
      end if
    else
      if myMember <> myStandardMember then
        sprite(mySprite).member = myStandardMember
      end if
    end if
  end if
  if pBlinking then
    if the timer > pBlinkTimer then
      pBlinkTimer = the timer + random(8)
      mDoMyBlink(me)
    end if
  end if
end

on mDoMyBlink me
  case myBlinkStyle of
    #single:
      if sprite(mySprite).member = myStandardMember then
        sprite(mySprite).member = myHiliteMember
      else
        sprite(mySprite).member = myStandardMember
      end if
    #multi:
      sprite(mySprite).member = member(member(myHiliteMember).number + (random(4) - 1))
  end case
  snd = random(4)
  case snd of
    1:
      playSound(#net1)
    2:
      playSound(#net2)
    3:
      playSound(#net3)
    4:
      playSound(#net4)
  end case
end

on mStartBlinking me
  pBlinking = 1
  pBlinkTimer = the timer + random(30)
end

on mStopBlinking me
  pBlinking = 0
  pBlinkTimer = 0
  sprite(mySprite).member = myHiliteMember
end

on getPropertyDescriptionList
  propList = [#pMyLiteType: [#comment: "Which screen?:", #format: #symbol, #range: [#main, #invite, #other], #default: #main]]
  return propList
end
