on exitFrame
  set mc to the mouseCast
  case mc of
    (-1):
      hideSportsMenu()
    1:
      go("skatemenu1a")
    21:
      showSportsMenu()
    3, 5, 7, 9, 11, 13, 15, 17:
      hiliteButton(mc)
    22, 24, 26, 28, 30, 32:
      randomShoe()
      hiliteButton(mc)
  end case
  go(the frame)
end
