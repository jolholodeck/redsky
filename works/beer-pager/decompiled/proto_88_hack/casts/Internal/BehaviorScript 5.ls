on mouseDown
  sprite(109).loc = point(150, 150)
  updateStage()
end

on mouseUpOutSide
  sprite(109).loc = point(-1000, -1000)
end
