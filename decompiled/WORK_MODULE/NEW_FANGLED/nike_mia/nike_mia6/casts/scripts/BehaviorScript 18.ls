on exitFrame
  global gBeautifulState, gStrongState, gPreciousState, gToughState
  if (gBeautifulState = 2) and (gStrongState = 2) and (gPreciousState = 2) and (gToughState = 2) then
    go("Scene1Fade")
  else
    go(the frame - 1)
  end if
end
