global gWhereNext

on mouseUp
  clearMom()
  set gWhereNext to "main"
  go("e to mtrans")
  cursor(-1)
end
