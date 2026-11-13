property pTunerMenuSpr
global oDialogueClass, gNavMenuHiSpr, oMeetings, gStartOver

on new me
  pTunerMenuSpr = 54
  return me
end

on mInitMyScreen me
  setClock()
  sprite(61).checkMessageLite()
  if oMeetings.pNewMessages then
    sprite(61).mStartBlinking()
  end if
end

on mDoMyMouseDown me, myFunc
  case myFunc of
    #M_open:
      go(the frame - 1)
    #M_invite:
      go("invite")
    #M_power:
      gStartOver = 1
      go("animPowerDown")
  end case
end

on mLeaveMyScreen me
end

on mCheckButtons me
end

on mErrorAlert me, errorType
  oDialogueClass.mDoDialogue(errorType)
end
