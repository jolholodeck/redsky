global gWhereNext

on mouseUp
  clearGuide()
  set gWhereNext to "main"
  go("e to mtrans")
  cursor(-1)
end
