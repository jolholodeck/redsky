on exitFrame
  if soundBusy(1) then
    go(the frame)
  else
    set the volume of sound 2 to 255
    go(1)
  end if
  showSprites()
end
