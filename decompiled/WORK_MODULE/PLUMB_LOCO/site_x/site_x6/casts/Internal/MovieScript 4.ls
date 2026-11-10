on gotoStampPage stampCnum
  global klNetPages, kPalThumbBaseCast, kNbSwatches, gBaseUrl, gFrameName
  set idx to stampCnum - kPalThumbBaseCast + 1
  if idx < 1 then
    exit
  end if
  if idx > kNbSwatches then
    exit
  end if
  set url to gBaseUrl & getAt(klNetPages, idx)
  if not stringp(url) then
    exit
  end if
  if url = EMPTY then
    exit
  end if
  put "stamp" & string(idx) && url
end

on encodeURL url
  set badList to [" ", "<", ">", QUOTE, "{", "}", "|", "\", "^", "[", "]", "'"]
  set newURL to EMPTY
  repeat with i = 1 to the number of chars in url
    set tChar to char i of url
    set tNum to charToNum(tChar)
    if getOne(badList, tChar) or (tNum < 32) or (tNum = 127) then
      set tChar to "%" & numToHex(tNum)
    end if
    set newURL to newURL & tChar
  end repeat
  return newURL
end

on numToHex num
  set num1 to num / 16
  set num2 to num - (num1 * 16)
  case num1 of
    10:
      set num1 to "A"
    11:
      set num1 to "B"
    12:
      set num1 to "C"
    13:
      set num1 to "D"
    14:
      set num1 to "E"
    15:
      set num1 to "F"
    otherwise:
      set num1 to string(num1)
  end case
  case num2 of
    10:
      set num2 to "A"
    11:
      set num2 to "B"
    12:
      set num2 to "C"
    13:
      set num2 to "D"
    14:
      set num2 to "E"
    15:
      set num2 to "F"
    otherwise:
      set num2 to string(num2)
  end case
  return num1 & num2
end
