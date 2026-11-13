property mySprite, mySpriteNum, myMember, myMemberNum, myStandardMember, myHiliteMember, pTimerIncrement, pCurTimer, pBlinking, pBlinkTimer
global gCurScreen, oMeetings, oPrefsClass, oTunerClass

on beginSprite me
  Initialize(me)
end

on Initialize me
  mySprite = me.spriteNum
  myMember = sprite(mySpriteNum).member
  myMemberNum = myMember.number
  case the frame of
    18:
      myStandardMember = member(128)
      myHiliteMember = member(127)
    otherwise:
      myStandardMember = member(100)
      myHiliteMember = member(99)
  end case
  pTimerIncrement = 30
  pCurTimer = 0
  pBlinking = 0
  checkMessageLite(me)
end

on mHideLite me
  sprite(mySprite).loc = point(-100, -100)
end

on mShowLite me
  sprite(mySprite).loc = point(11, 48)
end

on checkMessageLite me
  if gCurScreen contains "tuner" then
    exit
  end if
  if gCurScreen contains "invite" then
    exit
  end if
  if gCurScreen = "login" then
    exit
  end if
  if (count(oPrefsClass.pInBoxData) + count(oMeetings.lNewMeetings)) < 1 then
    sprite(mySprite).member = myStandardMember
  else
    sprite(mySprite).member = myHiliteMember
  end if
end

on mcheckLiteAfterTuner me
  if (count(oPrefsClass.pInBoxData) + count(oMeetings.lNewMeetings)) < 1 then
    sprite(mySprite).member = myStandardMember
  else
    sprite(mySprite).member = myHiliteMember
  end if
end

on exitFrame me
  if pBlinking then
    if the timer > pBlinkTimer then
      pBlinkTimer = the timer + pTimerIncrement
      mDoMyBlink(me)
    end if
  end if
end

on mDoMyBlink me
  if sprite(mySprite).member = myStandardMember then
    sprite(mySprite).member = myHiliteMember
  else
    sprite(mySprite).member = myStandardMember
  end if
end

on mStartBlinking me
  pBlinking = 1
  pBlinkTimer = the timer + pTimerIncrement
end

on mStopBlinking me
  pBlinking = 0
  pBlinkTimer = 0
  sprite(mySprite).member = myHiliteMember
end
