on mouseUp
  global gToughState
  if gToughState > 0 then
    copyTextToOverlay(gsptTough)
    go("toughAnim")
  end if
end
