on mouseUp
  global gCurrentYear, gMyYear
  set gMyYear to 0
  set myArea to integer(the mouseH / 58) + 1
  set gCurrentYear to 0
  if myArea = 2 then
    go("1")
  else
    go("0")
  end if
end
