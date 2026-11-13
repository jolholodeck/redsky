on exitFrame
  if netDone() = 1 then
    nothing()
  else
    go(the frame - 5)
  end if
end
