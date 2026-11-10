global gWhereNext

on exitFrame
  cursor(-1)
  go(gWhereNext)
end
