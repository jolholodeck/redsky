on exitFrame
  set mc to the mouseCast
  case mc of
    1:
      go("sportmenu1a")
    3, 5, 7, 9, 11, 13, 15, 17:
      hiliteButton(mc)
  end case
  go(the frame)
end
