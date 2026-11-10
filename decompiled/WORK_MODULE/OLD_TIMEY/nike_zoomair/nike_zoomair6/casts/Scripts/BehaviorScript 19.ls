global gHypnoRunning

on exitFrame
  cleanupJohnsonRollOver()
  unLoad()
  if gHypnoRunning = 0 then
    launchHypno()
  end if
end
