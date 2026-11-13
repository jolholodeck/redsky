property mySpr
global ohelpClass, gHelpMenuHiSpr

on beginSprite me
  mySpr = me.spriteNum
end

on mouseUp me
  playSound(#help)
  if mySpr <> gHelpMenuHiSpr then
    mSelect(me)
    case mySpr of
      10:
        whatSubject = "tuner"
      11:
        whatSubject = "invite"
      12:
        whatSubject = "friends"
      13:
        whatSubject = "places"
      14:
        whatSubject = "calendar"
      15:
        whatSubject = "prefs"
    end case
    ohelpClass.mSelectMenu(whatSubject)
  end if
end

on mSelect me
  if gHelpMenuHiSpr then
    sendSprite(gHelpMenuHiSpr, #mDeSelect)
  end if
  sprite(mySpr).memberNum = sprite(mySpr).memberNum + 1
  gHelpMenuHiSpr = mySpr
end

on mDeSelect me
  sprite(mySpr).memberNum = sprite(mySpr).memberNum - 1
end
