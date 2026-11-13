on exitFrame
  set mc to the mouseCast
  case mc of
    (-1):
      go(the frame + 1)
      go("skatemenu")
  end case
  go(the frame)
end
