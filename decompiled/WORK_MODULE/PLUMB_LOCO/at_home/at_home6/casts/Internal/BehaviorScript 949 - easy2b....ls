on exitFrame
  if rollOver(9) or rollOver(12) then
    setCursor()
    go("easy2b1")
  else
    if rollOver(11) or rollOver(14) then
      setCursor()
      go("easy2b2")
    else
      if rollOver(23) then
        setCursor()
        go("easy2b7")
      else
        if rollOver(24) then
          setCursor()
          go("easy2b6")
        else
          if rollOver(25) then
            setCursor()
            go("easy2b5")
          else
            if rollOver(26) then
              setCursor()
              go("easy2b4")
            else
              if rollOver(28) then
                setCursor()
                go("easy2b3")
              else
                if rollOver(20) then
                  setCursor()
                  set the visible of sprite 48 to 1
                  go(#loop)
                else
                  cursor(-1)
                  set the visible of sprite 48 to 0
                  go("easy2b")
                end if
              end if
            end if
          end if
        end if
      end if
    end if
  end if
end
