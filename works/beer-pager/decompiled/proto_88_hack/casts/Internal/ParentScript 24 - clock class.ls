property pColonSpr, plMemberNumMins, plMainMemNumMins
global gMetronome, gCurScreen

on new me
  plMemberNumMins = [62: 1421, 63: 1431, 64: 1441, 65: 1451]
  plMainMemNumMins = [62: 1361, 63: 1371, 64: 1381, 65: 1391]
  pColonSpr = 66
  addToActorList(VOID, me)
  return me
end

on mSetTime me, theTime
  oldDelim = the itemDelimiter
  the itemDelimiter = ":"
  hourNum = value(item 1 of theTime)
  hourNumStr = item 1 of theTime
  if hourNum < 10 then
    h1 = 0
    h2 = char 1 of hourNumStr
  else
    h1 = char 1 of hourNumStr
    h2 = char 2 of hourNumStr
  end if
  minNum = value(item 2 of theTime)
  minNumStr = item 2 of theTime
  m1 = char 1 of minNumStr
  m2 = char 2 of minNumStr
  num = 1
  repeat with curNum in [h1, h2, m1, m2]
    mSetDigits(me, num, curNum)
    num = num + 1
  end repeat
  the itemDelimiter = oldDelim
end

on mSetDigits me, theDigit, theNum
  if gCurScreen = "main" then
    clockData = plMainMemNumMins
  else
    clockData = plMemberNumMins
  end if
  theMember = getAt(clockData, theDigit) + theNum
  theSprite = getPropAt(clockData, theDigit)
  sprite(theSprite).member = theMember
end

on stepFrame me
  if gMetronome <> sprite(pColonSpr).visible then
    sprite(pColonSpr).visible = gMetronome
  end if
end

on mErrorAlert me, errorType
  case errorType of
    #errorType:
      alert("ERROR MESSAGE")
  end case
end
