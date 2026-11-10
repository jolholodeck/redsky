on exitFrame
  if rollOver(9) or rollOver(12) then
    setCursor()
    go("Fast3b1")
  else
    if rollOver(10) or rollOver(13) then
      setCursor()
      go("Fast3b2")
    else
      if rollOver(23) then
        setCursor()
        go("Fast3b7")
      else
        if rollOver(24) then
          setCursor()
          go("Fast3b6")
        else
          if rollOver(26) then
            setCursor()
            go("Fast3b5")
          else
            if rollOver(27) then
              setCursor()
              go("Fast3b4")
            else
              if rollOver(28) then
                setCursor()
                go("Fast3b3")
              else
                if rollOver(20) then
                  setCursor()
                  set the visible of sprite 48 to 1
                  go(#loop)
                else
                  cursor(-1)
                  set the visible of sprite 48 to 0
                  go("Fast3b")
                end if
              end if
            end if
          end if
        end if
      end if
    end if
  end if
end
