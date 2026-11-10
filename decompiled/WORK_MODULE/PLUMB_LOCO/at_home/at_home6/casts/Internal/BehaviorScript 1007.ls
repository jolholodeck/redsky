global gFlag

on exitFrame
  checkRollover()
  go("B")
  set gFlag to 0
end
