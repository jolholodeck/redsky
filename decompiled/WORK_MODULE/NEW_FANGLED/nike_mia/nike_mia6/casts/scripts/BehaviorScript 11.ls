on mouseUp
  global gStrongState
  if gStrongState > 0 then
    copyTextToOverlay(gsptStrong)
    go("strongAnim")
  end if
end
