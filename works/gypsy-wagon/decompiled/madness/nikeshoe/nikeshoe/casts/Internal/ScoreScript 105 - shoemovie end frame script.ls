on exitFrame
  go(the frame)
  if the movieRate of sprite 48 = 0 then
    exitShoeMovie()
  end if
end

on mouseDown
  set spr to the clickOn
  if spr = 48 then
    set the movieRate of sprite 48 to 0
    exitShoeMovie()
  end if
end

on exitShoeMovie
  global g.current.Pos
  puppetSprite(48, 0)
  set g.current.Pos to [9, 8]
  Display.Image()
  case the frameLabel of
    "shoemovie1a":
      go("choad1")
    "shoemovie2a":
      go("choad2")
    "shoemovie3a":
      go("choad3")
  end case
end
