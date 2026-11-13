global oXmlParser, xml, gTimeOffset, gDateOffset

on xmlToLingo type, rawXml
  case type of
    "RegisterUser":
      temp = oXmlParser.parseString(rawXml)
      xml = oXmlParser.makeList()
      id = value(xml[1]["response"]["!CHARDATA"])
      return [#id: id]
    "Connect":
      temp = oXmlParser.parseString(rawXml)
      xml = oXmlParser.makeList()
      id = value(xml[1]["response"]["!CHARDATA"])
      return [#id: id]
    "PostMeeting":
      temp = oXmlParser.parseString(rawXml)
      xml = oXmlParser.makeList()
      id = value(xml[1]["response"]["!CHARDATA"])
      return [#id: id]
    "FindUser":
      temp = oXmlParser.parseString(rawXml)
      xml = oXmlParser.makeList()
      sScreenName = xml[1]["response"]["sScreenName"]["!CHARDATA"]
      idUser = value(xml[1]["response"]["idUser"]["!CHARDATA"])
      sEmail = xml[1]["response"]["sEmail"]["!CHARDATA"]
      user = [#name: sScreenName, #id: idUser, #email: sEmail]
      return user
    "ListMeeting":
      bigBlob = [:]
      temp = oXmlParser.parseString(rawXml)
      xml = oXmlParser.makeList()
      lMtgsXml = xml[1]["response"]["meetingList"]
      lMtgs = []
      repeat with i = 2 to lMtgsXml.count
        idMeeting = lMtgsXml[i]["!ATTRIBUTES"]["idMeeting"]
        dWhenDate = lMtgsXml[i]["dWhenDate"]["!CHARDATA"]
        dWhenTime = militaryToCivilian(lMtgsXml[i]["dWhenTime"]["!CHARDATA"])
        sWhereName = lMtgsXml[i]["sWhereName"]["!CHARDATA"]
        sWhereAddress = lMtgsXml[i]["sWhereAddress"]["!CHARDATA"]
        yWhy = symbol(lMtgsXml[i]["yWhy"]["!CHARDATA"])
        sMessage = lMtgsXml[i]["sMessage"]["!CHARDATA"]
        if sMessage = VOID then
          sMessage = EMPTY
        end if
        lWhoTotal = lMtgsXml[i]["lwho"].count
        lWho = []
        repeat with invitee = 2 to lWhoTotal
          thisWho = [:]
          attendStatusXml = lMtgsXml[i]["lwho"][invitee]["yAttendStatus"]["!CHARDATA"]
          attendStatus = symbol(attendStatusXml)
          if ilk(attendStatus) <> #symbol then
            alert("Uh, oh.  Attend status is not a symbol.")
            nothing()
            nothing()
          end if
          iidUser = value(lMtgsXml[i]["lwho"][invitee]["!ATTRIBUTES"]["idUser"])
          isUserName = lMtgsXml[i]["lwho"][invitee]["sUserName"]["!CHARDATA"]
          iyAttendStatus = attendStatus
          isMessage = lMtgsXml[i]["lwho"][invitee]["sMessage"]["!CHARDATA"]
          iyCreator = lMtgsXml[i]["lwho"][invitee]["yCreator"]["!CHARDATA"]
          iTimeStamp = value(lMtgsXml[i]["lwho"][invitee]["timestamp"]["!CHARDATA"])
          if isMessage = VOID then
            isMessage = EMPTY
          end if
          thisWho = [#idUser: iidUser, #sUserName: isUserName, #yAttendStatus: iyAttendStatus, #sMessage: isMessage, #yCreator: iyCreator, #timeStamp: iTimeStamp]
          lWho.add(thisWho)
        end repeat
        timeStamp = value(lMtgsXml[i]["timestamp"]["!CHARDATA"])
        myMeeting = [#idMeeting: idMeeting, #dWhenDate: dWhenDate, #dWhenTime: dWhenTime, #sWhereName: sWhereName, #sWhereAddress: sWhereAddress, #yWhy: yWhy, #sMessage: sMessage, #lWho: lWho, #timeStamp: timeStamp]
        add(lMtgs, myMeeting)
      end repeat
      addProp(bigBlob, #meetingData, lMtgs)
      timeStamp = value(xml[1]["response"]["timestamp"]["!CHARDATA"])
      addProp(bigBlob, #timeStamp, timeStamp)
      pingfrequency = value(xml[1]["response"]["pingfrequency"]["!CHARDATA"])
      addProp(bigBlob, #pingfrequency, pingfrequency)
      messagefrommiller = xml[1]["response"]["messageFromMiller"]["!CHARDATA"]
      messageFromMillerTimeStamp = value(xml[1]["response"]["messageFromMiller"]["timestamp"]["!CHARDATA"])
      addProp(bigBlob, #messagefrommiller, messagefrommiller)
      addProp(bigBlob, #messageFromMillerTimeStamp, messageFromMillerTimeStamp)
      return bigBlob
    "TimeSync":
      temp = oXmlParser.parseString(rawXml)
      if not (rawXml contains "error") then
        lingo = oXmlParser.makeList()
        timeOffset = value(lingo[1]["response"]["TimeOffset"]["MinuteOffset"]["!CHARDATA"])
        dateOffset = value(lingo[1]["response"]["TimeOffset"]["DayOffset"]["!CHARDATA"])
        offset = [:]
        offset.addProp(#time, timeOffset)
        offset.addProp(#date, dateOffset)
        return offset
      end if
    "GetPrefs":
      temp = oXmlParser.parseString(rawXml)
      xml = oXmlParser.makeList()
      xmlRoot = xml[1]
      listData = xml[1]["response"]["user"]
      idUser = listData["idUser"]["!CHARDATA"]
      sPrefs = value(listData["sPrefs"]["!CHARDATA"])
      sZipCode = value(listData["sZipCode"]["!CHARDATA"])
      timeStamp = listData["timestamp"]["!CHARDATA"]
      return [#idUser: idUser, #sPrefs: sPrefs, #sZipCode: sZipCode, #timeStamp: timeStamp]
  end case
end
