on exitFrame
  global oldDepth
  set oldDepth to the colorDepth
  set the colorDepth to 8
  if the colorDepth <> 8 then
    alert("Please set your monitor to 256 colors and restart.")
    quit()
  end if
  if the controlDown then
    initglobals()
    go("screen1 start")
  end if
  if the optionDown then
    initglobals()
    go("screen2 start")
  end if
end
