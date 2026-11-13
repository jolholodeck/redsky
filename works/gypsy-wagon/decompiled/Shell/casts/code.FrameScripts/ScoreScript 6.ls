on exitFrame
  global g.demoLaunched
  if g.demoLaunched = 1 then
    go("CandleIgnite")
  end if
  go(the frame)
end

on mouseUp
  go("CandleIgnite")
end
