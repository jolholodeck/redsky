on exitFrame
  if rollOver(10) or rollOver(13) then
    setCursor()
    go("Fast1b1")
  else
    if rollOver(11) or rollOver(14) then
      setCursor()
      go("Fast1b2")
    else
      if rollOver(23) then
        setCursor()
        go("Fast1b7")
      else
        if rollOver(24) then
          setCursor()
          go("Fast1b6")
        else
          if rollOver(26) then
            setCursor()
            go("Fast1b5")
          else
            if rollOver(27) then
              setCursor()
              go("Fast1b4")
            else
              if rollOver(28) then
                setCursor()
                go("Fast1b3")
              else
                if rollOver(20) then
                  setCursor()
                  set the visible of sprite 48 to 1
                  go(#loop)
                else
                  cursor(-1)
                  set the visible of sprite 48 to 0
                  go("Fast1b")
                end if
              end if
            end if
          end if
        end if
      end if
    end if
  end if
end
