on exitFrame
  global gdmoFiniteBottle
  bottleCleanupSmoke(gdmoFiniteBottle)
  unLoad("FiniteSmokeCycle", "EndFinSmoke")
  go("Idle")
end
