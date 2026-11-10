on exitFrame
  global gBottleDive, gActionState, gTotalMoths
  if gBottleDive then
    bottleEntry()
  end if
  checkSound()
  if gActionState < 3 then
    checkFire()
  end if
  if (gActionState = 3) and (gBottleDive < 1) then
    lotsOfBugs()
  end if
  if gActionState = 4 then
    shakeBottle()
  end if
  if gActionState < 5 then
    moveFire()
  end if
  if gActionState > 3 then
    repeat with x = 1 to gTotalMoths
      moveMoth(x)
    end repeat
  end if
  if gActionState = 5 then
    glowBottle()
  end if
  if the blend of sprite 26 < 50 then
    set the blend of sprite 26 to the blend of sprite 26 + 5
  end if
  if (the blend of sprite 26 > 50) and (the blend of sprite 26 < 80) then
    set the blend of sprite 26 to 30
  end if
  updateStage()
  go(the frame - 1)
end
