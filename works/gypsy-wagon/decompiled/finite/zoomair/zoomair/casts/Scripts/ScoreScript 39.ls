global gAirSwooshRevolving

on exitFrame
  updatePennyHologram()
  if gAirSwooshRevolving > 0 then
    updateAirSwooshRevolve()
  end if
end
