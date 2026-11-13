on exitFrame
  global currentPosition
  checkRollover()
  if calcDestination() <> currentPosition then
    go(label("outof" & currentPosition) + 4)
  end if
end
