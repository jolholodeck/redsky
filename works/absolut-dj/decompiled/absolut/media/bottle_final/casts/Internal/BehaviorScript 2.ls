global gBaseURL

on mouseUp
  if the platform contains "Windows" then
    gotoNetPage("map/index.htm")
    go(69)
  else
    gotoNetPage(gBaseURL & "map:index.htm")
    go(69)
  end if
end
