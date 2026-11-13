on exitFrame
  Do.ShoeVR()
  set mc to the mouseCast
  case mc of
    (-1):
      hideSportsMenu()
      hideSkateMenu()
      showDescription()
    1:
      go(the frameLabel & "a")
    21:
      showSportsMenu()
    41:
      hideDescription()
      showSkateMenu()
    3, 5, 7, 9, 11, 13, 15, 17:
      hiliteButton(mc)
    22, 24, 26, 28, 30, 32:
      hiliteButton(mc)
  end case
  go(the frame)
end

on mouseDown
  global g.Color.Offset
  set spr to the clickOn
  case spr of
    23:
      go("choad1")
    24:
      go("choad2")
    25:
      go("choad3")
    27:
      if g.Color.Offset = 1500 then
        set g.Color.Offset to 1000
        ToggleShoeColor()
        Display.Image()
      end if
    28:
      if g.Color.Offset = 1000 then
        set g.Color.Offset to 1500
        ToggleShoeColor()
        Display.Image()
      end if
    40:
      set g.Color.Offset to 1000
      ToggleShoeColor()
      Display.Image()
      case the frameLabel of
        "choad1":
          go("shoemovie1")
        "choad2":
          go("shoemovie2")
        "choad3":
          go("shoemovie3")
      end case
  end case
end
