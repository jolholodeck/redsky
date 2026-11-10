global gWhereNext

on mouseUp
  clearGuide()
  set gWhereNext to "faster"
  go("e to mtrans")
  cursor(-1)
end
