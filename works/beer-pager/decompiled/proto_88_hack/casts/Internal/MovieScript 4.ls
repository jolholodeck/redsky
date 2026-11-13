global oPrefsClass

on parseNotesField textToParse
  repeat with lineNum = 1 to the number of lines in textToParse
  end repeat
end

on resetScrollWindow dataType, whatMem, whatProp
  member(whatMem).fontStyle = "plain"
  member(whatMem).text = EMPTY
  if not whatProp then
    whatProp = #name
  end if
  if dataType = #friends then
    oPrefsClass.pBuddyData = sortPList(oPrefsClass.pBuddyData, #name)
    whatData = oPrefsClass.pBuddyData
  else
    if dataType = #places then
      oPrefsClass.pPlacesData = sortPList(oPrefsClass.pPlacesData, #name)
      whatData = oPrefsClass.pPlacesData
    end if
  end if
  tempList = []
  repeat with curItem in whatData
    append(tempList, getProp(curItem, whatProp))
  end repeat
  repeat with curLine = 1 to count(tempList)
    member(whatMem).line[curLine] = getAt(tempList, curLine)
  end repeat
  member(whatMem).forecolor = 225
  member(whatMem).scrollTop = 0
end

on clearScrollWindow whatMem
  member(whatMem).fontStyle = "plain"
  member(whatMem).text = EMPTY
  member(whatMem).forecolor = 225
  member(whatMem).scrollTop = 0
end

on trimSpaces curText
  newText = removeLeadSpaces(curText)
  newText = removeTrailSpaces(newText)
  return newText
end

on removeLeadSpaces curText
  if curText.char[1] = " " then
    repeat while curText.char[1] = " "
      delete char 1 of curText
    end repeat
  end if
  return curText
end

on removeTrailSpaces curText
  lastChar = curText.chars.count
  if curText.char[lastChar] = " " then
    repeat while curText.char[lastChar] = " "
      delete char lastChar of curText
      lastChar = lastChar - 1
    end repeat
  end if
  return curText
end

on forceFieldFocus spr
  sprite(spr).editable = 1
end

on batchFieldParam
  tempList = []
  tempList2 = []
end

on clearFields fieldNameList
  repeat with curField in fieldNameList
    member(curField).text = EMPTY
  end repeat
end

on resetFields fieldList
  repeat with idx = 1 to count(fieldList)
    myName = string(getPropAt(fieldList, idx))
    lMyParams = getAt(fieldList, idx)
    repeat with cntIdx = 1 to count(lMyParams)
      curParam = getPropAt(lMyParams, cntIdx)
      curValue = getProp(lMyParams, curParam)
      case curParam of
        #edit:
          member(myName).editable = curValue
        #border:
          member(myName).border = curValue
        #bgColor:
          member(myName).backcolor = curValue
        #fgColor:
          member(myName).forecolor = curValue
        #scrollTop:
          member(myName).scrollTop = curValue
        #text:
          member(myName).text = curValue
      end case
    end repeat
  end repeat
end

on dataToField dataType, entryNum
  case dataType of
    #buddy:
      if count(oPrefsClass.pBuddyData) = 0 then
        exit
      end if
      tempData = getAt(oPrefsClass.pBuddyData, entryNum)
      curName = tempData.name
      curEmail = tempData.email
      curNotes = tempData.notes
      dataList = [[curName, "pr_F_name"], [curEmail, "pr_F_email"], [curNotes, "in_F_notes"]]
      sendSprite(33, #mCleanField)
    #places:
      if count(oPrefsClass.pPlacesData) = 0 then
        exit
      end if
      tempData = getAt(oPrefsClass.pPlacesData, entryNum)
      curName = getAt(tempData, 1)
      curWhere = getAt(tempData, 2)
      curNotes = getAt(tempData, 3)
      dataList = [[curName, "pr_P_name"], [curWhere, "pr_P_where"], [curNotes, "in_P_notes"]]
      sendSprite(34, #mCleanField)
  end case
  repeat with curPair in dataList
    curData = getAt(curPair, 1)
    curField = getAt(curPair, 2)
    member(curField).text = string(curData)
  end repeat
end
