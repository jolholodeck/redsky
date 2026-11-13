property pDisplayTextMem, pCopyTextMemMin, pMenuSprMin, pMenuIdx, pScrollData1, pHelpButtonSpr
global gHelpMenuHiSpr

on new me
  pDisplayTextMem = "prs_H_helptext"
  pCopyTextMemMin = 412
  pMenuSprMin = 10
  pScrollData1 = [7, 8, 9]
  pHelpButtonSpr = 53
  pMenuIdx = 0
  return me
end

on mInitMyScreen me
  gHelpMenuHiSpr = 0
  constructScroll(pScrollData1)
  X = mSelectMenu(me, sprite(pHelpButtonSpr).pOldScreen)
  sprite(X).mSelect()
end

on mSelectMenu me, whatSubject
  case whatSubject of
    "tuner", "tuner2":
      spr = 10
      textMem = 412
    "friends":
      spr = 12
      textMem = 414
    "places":
      spr = 13
      textMem = 415
    "calendar", "calendar2":
      spr = 14
      textMem = 416
    "prefs":
      spr = 15
      textMem = 417
    "invite", "invite2":
      spr = 11
      textMem = 413
    otherwise:
      spr = 10
      textMem = 412
  end case
  member(pDisplayTextMem).text = member(textMem).text
  member(pDisplayTextMem).scrollTop = 0
  return spr
end

on mDoMyMouseDown me, myFunc
end

on mLeaveMyScreen me
end

on mErrorAlert me, errorType
  case errorType of
    #errorType:
      alert("ERROR MESSAGE")
  end case
end
