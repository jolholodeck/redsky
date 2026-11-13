on exitFrame
  global currentPosition
  checkRollover()
  if calcDestination() <> currentPosition then
    go(label("outof" & currentPosition) + 10)
  end if
end
