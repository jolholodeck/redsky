global gWhereNext

on mouseUp
  clearGuide()
  set gWhereNext to "always"
  go("e to mtrans")
  cursor(-1)
end
