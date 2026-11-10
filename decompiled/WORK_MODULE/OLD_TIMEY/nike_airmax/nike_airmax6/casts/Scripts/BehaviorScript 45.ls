on enterFrame
  global gIsPCversion
  if gIsPCversion = 1 then
    go("Uptempo.Morph.PC")
  else
    go("Uptempo.Morph.Mac")
  end if
end
