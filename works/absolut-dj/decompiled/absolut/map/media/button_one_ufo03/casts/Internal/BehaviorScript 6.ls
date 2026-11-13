global gBaseURL

on mouseUp
  if the platform contains "Windows" then
    gotoNetPage("ufo/uf_index.htm")
  else
    gotoNetPage(gBaseURL & "ufo:uf_index.htm")
  end if
end
