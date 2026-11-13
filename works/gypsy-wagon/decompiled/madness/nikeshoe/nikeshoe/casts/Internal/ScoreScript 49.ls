on exitFrame
  global gCDHchoadDX, gCDHchoadDY, gCDHchoadCount
  set fx to getAt(g.current.Pos, 1)
  set fy to getAt(g.current.Pos, 2)
  set gCDHchoadDX to 9.0 - fx
  set gCDHchoadDY to 9.0 - fy
  if abs(gCDHchoadDX) > abs(gCDHchoadDY) then
    if gCDHchoadDY > 1.0 then
      set gCDHchoadCount to integer(abs(gCDHchoadDY))
    else
      set gCDHchoadCount to integer(abs(gCDHchoadDX))
    end if
  else
    if gCDHchoadDX > 1.0 then
      set gCDHchoadCount to integer(abs(gCDHchoadDX))
    else
      set gCDHchoadCount to integer(abs(gCDHchoadDY))
    end if
  end if
  if gCDHchoadCount < 1 then
    set gCDHchoadCount to 1
  end if
  set gCDHchoadDX to gCDHchoadDX / gCDHchoadCount
  set gCDHchoadDY to gCDHchoadDY / gCDHchoadCount
end
