on mouseUp
  global gDollState
  if gDollState > 0 then
    copyTextToOverlay(gsptDoll)
    go("dollAnim")
  end if
end
