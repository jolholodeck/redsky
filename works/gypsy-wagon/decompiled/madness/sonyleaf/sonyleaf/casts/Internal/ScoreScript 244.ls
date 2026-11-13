on exitFrame
  global gWhatActive
  if gWhatActive <> 0 then
    doCleanUp(gWhatActive)
  end if
end
