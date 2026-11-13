on exitFrame
  global gCDHchoadDX, gCDHchoadDY, gCDHchoadCount, g.current.Pos
  set fx to getAt(g.current.Pos, 1)
  set fy to getAt(g.current.Pos, 2)
  set x to integer(fx)
  set y to integer(fy)
  if gCDHchoadCount > 0 then
    set gCDHchoadCount to gCDHchoadCount - 1
    Display.Image()
    set fx to fx + gCDHchoadDX
    set fy to fy + gCDHchoadDY
    set g.current.Pos to 0
    set g.current.Pos to [fx, fy]
    go(the frame)
  end if
end
