on civilianToMilitary civilian
  the itemDelimiter = ":"
  hours = value(civilian.item[1])
  if civilian.item[3] = "PM" then
    if hours < 12 then
      hours = hours + 12
    end if
  end if
  minutes = civilian.item[2]
  seconds = "00"
  military = hours & ":" & minutes & ":" & seconds
  return military
end

on militaryToCivilian military
  the itemDelimiter = ":"
  hours = value(military.item[1])
  if hours > 12 then
    hours = hours - 12
  end if
  minutes = military.item[2]
  if military.item[1] < 12 then
    AMPM = "AM"
  else
    AMPM = "PM"
  end if
  civilian = hours & ":" & minutes & ":" & AMPM
  return civilian
end

on minsToTime mins
  if mins = 0 then
    return "12:00 AM"
  end if
  hours = integer(mins / 60)
  if hours >= 12 then
    AMPM = "PM"
  else
    AMPM = "AM"
  end if
  if hours > 12 then
    hours = hours - 12
  end if
  minutes = mins mod 60
  hoursStr = string(hours)
  if minutes > 9 then
    minutesStr = string(minutes)
  else
    minutesStr = "0" & string(minutes)
  end if
  ampmStr = AMPM
  if mins < 60 then
    hoursStr = "12"
  end if
  time = hoursStr & ":" & minutesStr & " " & ampmStr
  return time
end

on timeToMins longTime
  oldDelimiter = the itemDelimiter
  timeString = longTime
  repeat with X = 1 to length(timeString)
    thisChar = charToNum(char X of timeString)
    if (thisChar < 48) or (thisChar > 57) then
      the itemDelimiter = char X of timeString
      exit repeat
    end if
  end repeat
  hours = value(item 1 of timeString)
  minutes = value(item 2 of timeString)
  AMPM = word 2 of item 3 of timeString
  if AMPM = EMPTY then
    if hours >= 12 then
      AMPM = "PM"
    else
      AMPM = "AM"
    end if
  end if
  if (AMPM = "PM") and (hours = 0) then
    hours = 12
  end if
  if hours > 12 then
    hours = hours mod 12
  end if
  if (AMPM = "PM") and (hours < 12) then
    hours24 = hours + 12
  else
    if (hours = 12) and (AMPM = "AM") then
      hours24 = 0
    else
      hours24 = hours
    end if
  end if
  the itemDelimiter = oldDelimiter
  time = [#hours: hours, #minutes: minutes, #AMPM: AMPM, #hours24: hours24]
  mins = 0
  mins = mins + (60 * time.hours24)
  mins = mins + time.minutes
  return mins
end

on beGetDate
  shortDateList = parseDate(the short date) mod 100
  longDateList = parseDate(the long date)
  if count(shortDateList) <> 3 then
    alert("Short date separator is not valid")
    return [#day: 0, #month: 0, #year: 0, #centuryYear: 0]
    exit
  else
    if count(longDateList) <> 2 then
      alert("Cannot parse long date format")
      return [#day: 0, #month: 0, #year: 0, #centuryYear: 0]
      exit
    end if
  end if
  centuryYear = max(longDateList)
  year = centuryYear mod 100
  deleteAt(shortDateList, getOne(shortDateList, year))
  deleteAt(longDateList, getOne(longDateList, centuryYear))
  day = getAt(longDateList, 1)
  deleteAt(shortDateList, getOne(shortDateList, day))
  month = getAt(shortDateList, 1)
  return [#day: day, #month: month, #year: year, #centuryYear: centuryYear]
end

on beGetTime
  oldDelimiter = the itemDelimiter
  timeString = the long time
  repeat with X = 1 to length(timeString)
    thisChar = charToNum(char X of timeString)
    if (thisChar < 48) or (thisChar > 57) then
      the itemDelimiter = char X of timeString
      exit repeat
    end if
  end repeat
  hours = value(item 1 of timeString)
  minutes = value(item 2 of timeString)
  seconds = value(item 3 of timeString)
  AMPM = word 2 of item 3 of timeString
  if AMPM = EMPTY then
    if hours >= 12 then
      AMPM = "PM"
    else
      AMPM = "AM"
    end if
  end if
  if (AMPM = "PM") and (hours = 0) then
    hours = 12
  end if
  if hours > 12 then
    hours = hours mod 12
  end if
  if (AMPM = "PM") and (hours < 12) then
    hours24 = hours + 12
  else
    if (AMPM = "AM") and (hours = 12) then
      hours24 = 0
    else
      hours24 = hours
    end if
  end if
  the itemDelimiter = oldDelimiter
  return [#hours: hours, #minutes: minutes, #seconds: seconds, #AMPM: AMPM, #hours24: hours24]
end

on parseDate dateString
  repeat with X = 1 to length(dateString)
    thisChar = charToNum(char X of dateString)
    if (thisChar < 48) or (thisChar > 57) then
      put SPACE into char X of dateString
    end if
  end repeat
  dateList = []
  repeat with n = 1 to the number of words in dateString
    add(dateList, value(word n of dateString))
  end repeat
  return dateList
end
