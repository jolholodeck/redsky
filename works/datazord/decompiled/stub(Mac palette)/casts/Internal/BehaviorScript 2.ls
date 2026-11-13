on exitFrame
  global gTargetMovie
  if not voidp(gTargetMovie) then
    cursor(4)
    go(1, gTargetMovie)
  else
    alert("A target movie was not specified in the Lingo.ini file or the Lingo.ini file is not present.")
    quit()
  end if
end
