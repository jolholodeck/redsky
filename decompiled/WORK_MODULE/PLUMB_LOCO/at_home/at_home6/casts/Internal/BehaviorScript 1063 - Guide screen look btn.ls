global gWhereNext

on mouseUp
  clearGuide()
  set gWhereNext to "Look"
  go("e to Otrans")
  cursor(-1)
end
