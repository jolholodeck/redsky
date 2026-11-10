global gCrntMode, gRoleCallCount, gHypnoRunning, gPlayMouseSounds

on exitFrame
  set gCrntMode to 100
  set gRoleCallCount to 20
  set gPlayMouseSounds to 0
  if gHypnoRunning = 0 then
    launchHypno()
  end if
end
