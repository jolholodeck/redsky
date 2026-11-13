on exitFrame
  global gCurRot, gMinRot, gMaxRot, gIncr
  gCurRot = gCurRot + gIncr
  if gIncr > 0 then
    if gCurRot >= gMaxRot then
      gIncr = -1
    end if
  else
    if gCurRot <= gMinRot then
      gIncr = 1
    end if
  end if
  sprite(7).rotation = gCurRot
  sprite(8).rotation = gCurRot
  go(the frame)
end
