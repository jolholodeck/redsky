on exitFrame
  global gdmoMadBottle
  bottleCleanupSmoke(gdmoMadBottle)
  unLoad("MadnessSmokeCycle", "EndMadSmoke")
  go("Idle")
end
