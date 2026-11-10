global gWhereNext

on mouseUp
  clearQuick()
  set gWhereNext to "main"
  go("e to mtrans")
  cursor(-1)
end
