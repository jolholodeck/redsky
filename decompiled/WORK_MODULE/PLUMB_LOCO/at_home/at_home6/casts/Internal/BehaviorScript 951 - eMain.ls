on exitFrame
  if rollOver(9) or rollOver(12) then
    setCursor()
    go("Eroll1")
  else
    if rollOver(10) or rollOver(13) then
      setCursor()
      go("Eroll2")
    else
      if rollOver(11) or rollOver(14) then
        setCursor()
        go("Eroll3")
      else
        if rollOver(23) then
          setCursor()
          go("ERoll8")
        else
          if rollOver(24) then
            setCursor()
            go("ERoll7")
          else
            if rollOver(25) then
              setCursor()
              go("ERoll6")
            else
              if rollOver(26) then
                setCursor()
                go("ERoll5")
              else
                if rollOver(28) then
                  setCursor()
                  go("ERoll4")
                else
                  if rollOver(20) then
                    setCursor()
                    set the visible of sprite 48 to 1
                  else
                    cursor(-1)
                    set the visible of sprite 48 to 0
                  end if
                end if
              end if
            end if
          end if
        end if
      end if
    end if
  end if
end
