global gBaseURL

on mouseUp
  if the platform contains "Windows" then
    gotoNetPage("coldcut/cl_index.htm")
  else
    gotoNetPage(gBaseURL & "coldcut:cl_index.htm")
  end if
end
