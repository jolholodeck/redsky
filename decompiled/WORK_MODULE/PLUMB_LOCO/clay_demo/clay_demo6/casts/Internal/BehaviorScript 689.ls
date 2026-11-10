on mouseUp
  global toPlay
  set toPlay to the name of cast the castNum of sprite the clickOn
  if not (toPlay contains "blacktile") then
    go("segway")
  end if
end
