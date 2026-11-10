on mouseUp
  global gBeautifulState
  if gBeautifulState > 0 then
    copyTextToOverlay(gsptBeautiful)
    go("beautifulAnim")
  end if
end
