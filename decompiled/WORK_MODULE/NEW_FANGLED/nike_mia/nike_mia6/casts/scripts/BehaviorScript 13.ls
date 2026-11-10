on mouseUp
  global gPreciousState
  if gPreciousState > 0 then
    copyTextToOverlay(gsptPrecious)
    go("preciousAnim")
  end if
end
