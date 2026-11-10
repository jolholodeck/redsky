on exitFrame
  if _autoHelp then
    if the timer > (5 * 60) then
      ding()
      go("mainTO")
    else
      go(marker(0) + 3)
    end if
  else
    go(marker(0) + 3)
  end if
end
