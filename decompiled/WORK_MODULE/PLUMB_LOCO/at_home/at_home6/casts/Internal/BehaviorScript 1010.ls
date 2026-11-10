on exitFrame
  if rollOver(9) or rollOver(12) then
    setCursor()
    go("Froll1")
  else
    if rollOver(10) or rollOver(13) then
      setCursor()
      go("Froll2")
    else
      if rollOver(11) or rollOver(14) then
        setCursor()
        go("Froll3")
      else
        if rollOver(23) then
          setCursor()
          go("FRoll8")
        else
          if rollOver(24) then
            setCursor()
            go("FRoll7")
          else
            if rollOver(26) then
              setCursor()
              go("FRoll6")
            else
              if rollOver(27) then
                setCursor()
                go("FRoll5")
              else
                if rollOver(28) then
                  setCursor()
                  go("FRoll4")
                else
                  if rollOver(20) then
                    setCursor()
                    set the visible of sprite 48 to 1
                    go(#loop)
                  else
                    cursor(-1)
                    set the visible of sprite 48 to 0
                    go("Fmain")
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
