global oRequestMgr, oXmlParser

on readMeetingXML xmlString
  node = parseString(oXmlParser, xmlString)
  listData = buildList(oXmlParser)
  return listData
end

on parseQuotes rawText
  parsedText = replaceString(rawText, "'", QUOTE)
  return parsedText
end

on doPut type, Args, misc
  if not oRequestMgr.iDebugMode then
    exit
  end if
  case type of
    #starting:
      put "Starting request manager..."
      put "Response=Started successfully."
      put EMPTY
    #creating:
      put "Creating " & misc & " request..."
      put "Parameters=" & Args & RETURN
    #sending:
      put "Sending request..."
      put "Request=" & string(Args) & RETURN
    #latency:
      put "Calculating latency..."
      put "Response time= " & Args & " milliseconds."
      put EMPTY
    #xml:
      put "Receiving response..."
      put "Raw xml=" & Args
      put EMPTY
    #messagefrommiller:
      data = Args
      messagefrommiller = data.messagefrommiller
      put "Receiving message from miller response..."
      put "Response=" & messagefrommiller
      put EMPTY
    #parsing:
      put "Parsing response..."
      put "Response.iResult=" & Args.result
      if Args.result <> 1 then
        put "Response.iErrorType=" & Args.error
      end if
      put "Response.iData=" & Args.data
      put EMPTY
    #ping:
      put "Pinging server..."
      put "Meetings list refreshed."
      put EMPTY
    #error:
      put "Recieving getNetText result..."
      put "Net text error= " & Args
      put "NetTextResult=<VOID>." & RETURN
  end case
end

on goNext
  go(#next)
end
