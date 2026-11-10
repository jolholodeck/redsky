on exitFrame
  if rollOver(9) or rollOver(12) then
    setCursor()
    go("Fast2b1")
  else
    if rollOver(11) or rollOver(14) then
      setCursor()
      go("Fast2b2")
    else
      if rollOver(23) then
        setCursor()
        go("Fast2b7")
      else
        if rollOver(24) then
          setCursor()
          go("Fast2b6")
        else
          if rollOver(26) then
            setCursor()
            go("Fast2b5")
          else
            if rollOver(27) then
              setCursor()
              go("Fast2b4")
            else
              if rollOver(28) then
                setCursor()
                go("Fast2b3")
              else
                if rollOver(20) then
                  setCursor()
                  set the visible of sprite 48 to 1
                  go(#loop)
                else
                  cursor(-1)
                  set the visible of sprite 48 to 0
                  go("Fast2b")
                end if
              end if
            end if
          end if
        end if
      end if
    end if
  end if
end
