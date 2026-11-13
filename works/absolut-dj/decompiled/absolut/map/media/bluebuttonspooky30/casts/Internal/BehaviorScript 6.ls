global gBaseURL

on mouseUp
  if the platform contains "Windows" then
    gotoNetPage("spooky/sp_index.htm")
  else
    gotoNetPage(gBaseURL & "spooky:sp_index.htm")
  end if
end
