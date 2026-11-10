on exitFrame
  if rollOver(9) or rollOver(12) then
    setCursor()
    go("Alway2b1")
  else
    if rollOver(23) then
      setCursor()
      go("Alway2b6")
    else
      if rollOver(24) then
        setCursor()
        go("Alway2b5")
      else
        if rollOver(25) then
          setCursor()
          go("Alway2b4")
        else
          if rollOver(27) then
            setCursor()
            go("Alway2b3")
          else
            if rollOver(28) then
              setCursor()
              go("Alway2b2")
            else
              if rollOver(20) then
                setCursor()
                set the visible of sprite 48 to 1
                go(#loop)
              else
                cursor(-1)
                set the visible of sprite 48 to 0
                go("Alway2b")
              end if
            end if
          end if
        end if
      end if
    end if
  end if
end
