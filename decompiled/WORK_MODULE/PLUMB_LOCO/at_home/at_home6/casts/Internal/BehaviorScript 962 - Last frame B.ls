global gFlog

on exitFrame
  checkRollover()
  go("aftB")
  set gFlag to 0
end
