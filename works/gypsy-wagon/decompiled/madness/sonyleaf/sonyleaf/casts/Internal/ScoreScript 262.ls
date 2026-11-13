on exitFrame
  global gWhatActive
  if gWhatActive <> 0 then
    set the visible of sprite gWhatActive to 1
  end if
end
