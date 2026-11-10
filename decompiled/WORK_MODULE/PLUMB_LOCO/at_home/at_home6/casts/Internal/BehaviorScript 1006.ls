global gFlag

on exitFrame
  checkRollover()
  go("A")
  set gFlag to 0
end
