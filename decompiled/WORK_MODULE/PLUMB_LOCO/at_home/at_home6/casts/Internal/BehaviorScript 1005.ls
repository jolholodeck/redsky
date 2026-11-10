global gFlag

on exitFrame
  checkRollover()
  go("E")
  set gFlag to 0
end
