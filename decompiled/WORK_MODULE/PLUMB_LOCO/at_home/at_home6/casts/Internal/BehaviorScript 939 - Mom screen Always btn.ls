global gWhereNext

on mouseUp
  clearMom()
  set gWhereNext to "always"
  go("e to mtrans")
  cursor(-1)
end
