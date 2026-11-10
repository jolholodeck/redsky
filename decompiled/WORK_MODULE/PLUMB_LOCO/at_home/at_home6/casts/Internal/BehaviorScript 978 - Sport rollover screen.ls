on exitFrame
  if rollOver(5) then
    setCursor()
    go(label("sport") + 2)
  else
    if rollOver(6) then
      setCursor()
      go(label("sport") + 3)
    else
      if rollOver(7) then
        setCursor()
        go(label("sport") + 4)
      else
        if rollOver(8) then
          setCursor()
          go(label("sport") + 5)
        else
          if rollOver(9) then
            setCursor()
            go(label("sport") + 6)
          else
            go(label("sport") + 1)
            checkRolloverScreen()
          end if
        end if
      end if
    end if
  end if
end
