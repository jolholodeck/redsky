on enterFrame
  global gIsPCversion
  if gIsPCversion = 1 then
    go("AirRupt.Morph.PC")
  else
    go("AirRupt.Morph.Mac")
  end if
end
