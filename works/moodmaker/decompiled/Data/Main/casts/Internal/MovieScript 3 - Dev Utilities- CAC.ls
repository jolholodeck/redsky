global goK

on prepForBuild
  lColls = DirectoryToList(goK.iCollPath)
  str = member("VersionTrackingLog.fld").text & RETURN & RETURN & "Build" && convertToMMDD() & ":" & RETURN & "MoodMaker:" && member("version", "Internal").text
  repeat with coll in lColls
    curCollDirPath = goK.iCollPath & coll
    castLib(goK.iLibNumCollDio).fileName = curCollDirPath & "Diorama"
    dioStr = "Diorama:" && member("version", goK.iLibNumCollDio).text
    castLib(goK.iLibNumSndScape).fileName = curCollDirPath & "SndScape"
    sndStr = "SndScape:" && member("version", goK.iLibNumSndScape).text
    str = str & RETURN & dioStr & RETURN & sndStr
  end repeat
  member("VersionTrackingLog.fld").text = str
end

on convertToMMDD
  str = the date
  oldID = the itemDelimiter
  the itemDelimiter = "/"
  monthVal = value(str.item[1])
  dayVal = value(str.item[2])
  the itemDelimiter = oldID
  placeholderStr = EMPTY
  if monthVal < 10 then
    placeholderStr = "0"
  end if
  monthStr = placeholderStr & string(monthVal)
  placeholderStr = EMPTY
  if dayVal < 10 then
    placeholderStr = "0"
  end if
  dayStr = placeholderStr & string(dayVal)
  return monthStr & dayStr
end
