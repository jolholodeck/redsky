global gFlag

on exitFrame
  checkRollover()
  go("D")
  set gFlag to 0
end
