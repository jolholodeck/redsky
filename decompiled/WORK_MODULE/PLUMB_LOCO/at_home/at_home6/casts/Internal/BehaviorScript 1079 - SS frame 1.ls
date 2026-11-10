global gMousePos

on exitFrame
  set gMousePos to "OFF"
  if the mouseDown then
    leaveSSaver()
  end if
end
