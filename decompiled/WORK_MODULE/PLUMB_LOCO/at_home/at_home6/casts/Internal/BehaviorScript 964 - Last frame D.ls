global gFlag

on exitFrame
  checkRollover()
  go("aftD")
  set gFlag to 0
end
