on exitFrame
  if rollOver(10) or rollOver(13) then
    setCursor()
    go("easy1b1")
  else
    if rollOver(11) or rollOver(14) then
      setCursor()
      go("easy1b2")
    else
      if rollOver(23) then
        setCursor()
        go("easy1b7")
      else
        if rollOver(24) then
          setCursor()
          go("easy1b6")
        else
          if rollOver(25) then
            setCursor()
            go("easy1b5")
          else
            if rollOver(26) then
              setCursor()
              go("easy1b4")
            else
              if rollOver(28) then
                setCursor()
                go("easy1b3")
              else
                if rollOver(20) then
                  setCursor()
                  set the visible of sprite 48 to 1
                  go(#loop)
                else
                  if rollOver(34) or rollOver(37) then
                    setCursor()
                    go("easy1b")
                  else
                    cursor(-1)
                    set the visible of sprite 48 to 0
                    go("easy1b")
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
