on checkForProps lPropList, lProps
  repeat with thisProp in lProps
    thisPos = findPos(lPropList, thisProp)
    if thisPos = 0 then
      return thisProp
    end if
  end repeat
  return 0
end

on zeroRegPoints startMbr, endMbr, libNum
  repeat with X = startMbr to endMbr
    if member(X, libNum).type <> #bitmap then
      next repeat
    end if
    member(X, libNum).regPoint = point(0, 0)
  end repeat
end

on parseListData mbr
  if (mbr.type <> #text) and (mbr.type <> #field) then
    return -1
  end if
  dataStr = mbr.text
  if dataStr = EMPTY then
    return -2
  end if
  nbLines = the number of lines in dataStr
  out = EMPTY
  repeat with X = 1 to nbLines
    if line X of dataStr starts "--" then
      next repeat
    end if
    put line X of dataStr after dataStr
  end repeat
  lOut = value(out)
  if not listp(lOut) then
    return -3
  end if
  return lOut
end

on buildList a, b
  myList = []
  if a < b then
    repeat with i = a to b
      add(myList, i)
    end repeat
    return myList
  end if
  if a > b then
    repeat with i = a down to b
      add(myList, i)
    end repeat
    return myList
  end if
  if a = b then
    myList = [a]
    return myList
  end if
end

on replaceString fullText, sourceStr, targetStr
  output = EMPTY
  sourceLength = length(sourceStr)
  repeat while 1
    sourceOffset = offset(sourceStr, fullText)
    if sourceOffset = 0 then
      put fullText after output
      exit repeat
    end if
    if sourceOffset > 1 then
      put char 1 to (sourceOffset - 1) of fullText after output
    end if
    put targetStr after output
    delete char 1 to (sourceOffset + sourceLength - 1) of fullText
  end repeat
  return output
end

on getErrorText err
  case err of
    0:
      Msg = "OK"
    4:
      Msg = "Bad MOA class. The required network or nonnetwork Xtras are improperly installed or not installed at all."
    5:
      Msg = "Bad MOA Interface. See 4."
    6:
      Msg = "Bad URL or Bad MOA class. The required network or nonnetwork Xtras are improperly installed or not installed at all."
    20:
      Msg = "Internal error. Returned by netError() in the Netscape browser if the browser detected a network or internal error."
    4146:
      Msg = "Connection could not be established with the remote host."
    4149:
      Msg = "Data supplied by the server was in an unexpected format."
    4150:
      Msg = "Unexpected early closing of connection."
    4154:
      Msg = "Operation could not be completed due to timeout."
    4155:
      Msg = "Not enough memory available to complete the transaction."
    4156:
      Msg = "Protocol reply to request indicates an error in the reply."
    4157:
      Msg = "Transaction failed to be authenticated."
    4159:
      Msg = "Invalid URL."
    4164:
      Msg = "Could not create a socket."
    4165:
      Msg = "Requested object could not be found (URL may be incorrect)."
    4166:
      Msg = "Generic proxy failure."
    4167:
      Msg = "Transfer was intentionally interrupted by client."
    4242:
      Msg = "Download stopped by netAbort(url)."
    4836:
      Msg = "Download stopped for an unknown reason, possibly a network error, or the download was abandoned."
    otherwise:
      Msg = "Unknown net lingo error code."
  end case
  return Msg
end
