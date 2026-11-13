on exitFrame
  global gdmoTheLantern
  objHide(gdmoTheLantern)
  if the machineType = 256 then
    go("pcFlare")
  else
    go("macFlare")
  end if
end
