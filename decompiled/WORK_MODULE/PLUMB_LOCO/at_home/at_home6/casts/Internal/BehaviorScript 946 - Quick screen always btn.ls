global gWhereNext

on mouseUp
  clearQuick()
  set gWhereNext to "always"
  go("e to mtrans")
  cursor(-1)
end
