global g.current.Pos, g.direction, g.hor.limit, g.ver.limit, g.QT, g.Color.Offset

on Init.ShoeVR
  puppetSprite(40, 1)
  set g.current.Pos to [1.0, 1.0]
  set g.direction to #null
  set g.QT to #off
  set g.Color.Offset to 1000
  set g.hor.limit to 18
  set g.ver.limit to 18
end

on Do.ShoeVR
  set cellsize to float(152.0 / 18.0)
  set new.x to 18.0 - (float(the mouseH - 52) / cellsize)
  set new.y to 18.0 - (float(the mouseV - 111) / cellsize)
  set g.current.Pos to 0
  set g.current.Pos to [new.x, new.y]
  Display.Image()
end

on Display.Image
  set x to integer(getAt(g.current.Pos, 1))
  set y to integer(getAt(g.current.Pos, 2))
  if y > g.ver.limit then
    set y to g.ver.limit
  end if
  if y < 1 then
    set y to 1
  end if
  if x > g.hor.limit then
    set x to g.hor.limit
  end if
  if x < 1 then
    set x to 1
  end if
  set new.cast to (y * g.ver.limit) + x + g.Color.Offset
  set the member of sprite 40 to member new.cast
  updateStage()
end

on Do.Tween.Animation
  set current.x to getAt(g.current.Pos, 1)
  set current.y to getAt(g.current.Pos, 2)
  set x.direction to 19 - current.x
  if x.direction < 6 then
    set x.offset to -1
    exit
  else
    if x.direction < 14 then
      set x.offset to 0
      exit
    else
      set x.offset to 1
    end if
  end if
  set y.direction to 20 - current.y
  if y.direction < 4 then
    set y.offset to -1
    exit
  else
    if y.direction < 14 then
      set y.offset to 0
      exit
    else
      set y.offset to 1
    end if
  end if
  set current.x to current.x + x.offset
  set current.y to current.y + y.offset
  update.matrix(current.x, current.y)
  Display.Image()
  wait.sec(0.5)
end

on wait.sec length
  startTimer()
  repeat with index = 1 to 60 * length
    nothing()
  end repeat
end

on update.matrix x, y
  deleteAt(g.current.Pos, 1)
  addAt(g.current.Pos, 1, x)
  deleteAt(g.current.Pos, 2)
  addAt(g.current.Pos, 2, y)
end

on ToggleShoeColor
  global g.Color.Offset
  if g.Color.Offset = 1000 then
    set the member of sprite 27 to 52
    set the member of sprite 28 to 53
  else
    set the member of sprite 27 to 51
    set the member of sprite 28 to 54
  end if
end
