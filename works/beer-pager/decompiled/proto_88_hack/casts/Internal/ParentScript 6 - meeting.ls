property iID, iWhen, iWhenDate, iWhereName, iWhereAddress, iWhy, iMessage, iLWho, iDateObj

on new me, myData
  seperateMeetingData(me, myData)
  return me
end

on seperateMeetingData me, myData
  iID = getProp(myData, #idMeeting)
  iWhen = getProp(myData, #dWhenTime)
  iWhenDate = getProp(myData, #dWhenDate)
  iWhereName = getProp(myData, #sWhereName)
  iWhereAddress = getProp(myData, #sWhereAddress)
  iWhy = getProp(myData, #yWhy)
  iMessage = getProp(myData, #sMessage)
  iLWho = getProp(myData, #lWho)
  oldDelim = the itemDelimiter
  the itemDelimiter = "/"
  iDateObj = date(value(iWhenDate.item[3]), value(iWhenDate.item[1]), value(iWhenDate.item[2]))
  the itemDelimiter = oldDelim
end

on mGetPropList me
  tempList = [#idMeeting: iID, #dWhen: iWhen, #dWhenDate: iWhenDate, #sWhereName: iWhereName, #sWhereAddress: iWhereAddress, #yWhy: iWhy, #sMessage: iMessage, #lWho: iLWho]
  return tempList
end
