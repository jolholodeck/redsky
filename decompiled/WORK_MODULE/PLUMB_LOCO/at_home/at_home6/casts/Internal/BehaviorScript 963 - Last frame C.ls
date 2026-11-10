global gFlag

on exitFrame
  checkRollover()
  go("aftC")
  set gFlag to 0
end
