on exitFrame
  case the mouseCast of
    (-1):
      go(the frame + 1)
      go("start")
    2:
      go(the frame + 1)
      go("sportmenu")
  end case
  go(the frame)
end
