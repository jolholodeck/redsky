property pMySpr, pMyMem, pMySelType, pOnColor, pOffColor, pFontStyle, pHiLine, pLHiLines, pFirstLine
global gCurScreen, oCurMeeting, oPrefsClass, oCalendar2Class, oCalendarClass, oTuner2Class, oFriendsClass, oPlacesClass, oInviteClass, oTunerClass

on beginSprite me
  pMySpr = the currentSpriteNum
  pMyMem = sprite(pMySpr).memberNum
  pFontStyle = "bold"
  pHiLine = 0
  pLHiLines = []
end

on mouseUp me
  if the mouseLine < 0 then
    exit
  end if
  if the doubleClick then
    if the mouseLine = pFirstLine then
      if gCurScreen = "calendar" then
        go("calendar2")
        exit
      else
        if gCurScreen = "tuner" then
          go("tuner2")
          exit
        end if
      end if
    end if
  end if
  pFirstLine = the mouseLine
  doSelect(me, the mouseLine, symbol(gCurScreen), 1)
end

on selectAll me, totalNum
  repeat with whatNum = 1 to totalNum
    if getPos(pLHiLines, whatNum) then
      next repeat
      next repeat
    end if
    doSelect(me, whatNum, symbol(gCurScreen))
  end repeat
end

on mHiLine me
  return pHiLine
end

on mHiLines me
  return pLHiLines
end

on selectNone me, totalNum
  if pLHiLines = [] then
    exit
  end if
  tempList = duplicate(pLHiLines)
  repeat with curLine in tempList
    doSelect(me, curLine, symbol(gCurScreen))
  end repeat
end

on resetField me
  pHiLine = 0
end

on selectSome me, lWhichOnes
  repeat with num in lWhichOnes
    doSelect(me, num, symbol(gCurScreen))
  end repeat
end

on doSelect me, num, doWhat, soundOn
  selState = hiliteSel(me, num, 0, soundOn)
  case doWhat of
    #places:
      oPlacesClass.mDoMyListSelectCallBack(num)
    #friends:
      oFriendsClass.mDoMyListSelectCallBack(num)
    #invite:
      if pMySelType = #multi then
        buddyData = getAt(oPrefsClass.pBuddyData, num)
        if selState = #off then
          oCurMeeting.mKillFromWhoList(buddyData.id)
        else
          oCurMeeting.mAddToWhoList(buddyData.id)
        end if
      else
        oCurMeeting.mUpdateMeetingData(#iWhere, num)
      end if
      oInviteClass.mDoMyListSelectCallBack(num)
    #calendar:
      oCalendarClass.mDoMyListSelectCallBack(num)
    #calendar_DC:
      go("calendar2")
    #calendar2:
      oCalendar2Class.mSelectAtendee(num)
    #tuner:
      oTunerClass.mDoMyListSelectCallBack(num)
    #tuner_DC:
      go("tuner2")
  end case
end

on hiliteSel me, lineNum, callback, soundOn
  oldLine = pHiLine
  case pMySelType of
    #single:
      if lineNum = oldLine then
        abort()
      else
        if not voidp(soundOn) then
          playSound(#selection)
        end if
        pHiLine = lineNum
        mTurnOn(me, pHiLine)
      end if
      if oldLine <> 0 then
        mTurnOff(me, oldLine)
      end if
    #multi:
      if not voidp(soundOn) then
        playSound(#selection)
      end if
      if getOne(pLHiLines, lineNum) then
        mTurnOff(me, lineNum)
        deleteOne(pLHiLines, lineNum)
        selState = #off
      else
        mTurnOn(me, lineNum)
        append(pLHiLines, lineNum)
        selState = #on
      end if
      return selState
  end case
end

on mTurnOn me, lineNum
  set the foreColor of line lineNum of (member pMyMem) to pOnColor
  set the textStyle of line lineNum of (member pMyMem) to pFontStyle
end

on mTurnOff me, lineNum
  set the foreColor of line lineNum of (member pMyMem) to pOffColor
  set the textStyle of line lineNum of (member pMyMem) to "plain"
end

on getBehaviorDescription me
  return "Text field selection"
end

on getPropertyDescriptionList
  propList = [#pMySelType: [#comment: "Single or Multi Select?:", #format: #symbol, #range: [#single, #multi], #default: #single], #pOnColor: [#comment: "Select On Color:", #format: #integer, #range: [#min: 0, #max: 255], #default: 255], #pOffColor: [#comment: "Select Off Color:", #format: #integer, #range: [#min: 0, #max: 255], #default: 255]]
  return propList
end
