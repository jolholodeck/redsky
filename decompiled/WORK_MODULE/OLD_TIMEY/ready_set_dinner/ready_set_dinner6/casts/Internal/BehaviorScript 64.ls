on mouseUp
  set whatToPrint to the text of cast "Print Dump"
  printReport(whatToPrint)
  if _lastScreen = 2 then
    go("card1")
  else
    if _lastScreen = 3 then
      go("weekly1a")
    end if
  end if
end
