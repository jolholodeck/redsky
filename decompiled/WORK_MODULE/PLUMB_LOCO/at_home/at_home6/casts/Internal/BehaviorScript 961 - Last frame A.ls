global gFlag

on exitFrame
  checkRollover()
  go("sport")
  set gFlag to 0
end
