on exitFrame
  if rollOver(5) then
    setCursor()
    go(label("home") + 2)
  else
    if rollOver(6) then
      setCursor()
      go(label("home") + 3)
    else
      if rollOver(7) then
        setCursor()
        go(label("home") + 4)
      else
        if rollOver(8) then
          setCursor()
          go(label("home") + 5)
        else
          if rollOver(9) then
            setCursor()
            go(label("home") + 6)
          else
            if rollOver(10) then
              setCursor()
              go(label("home") + 7)
            else
              if rollOver(11) then
                setCursor()
                go(label("home") + 8)
              else
                if rollOver(12) then
                  setCursor()
                  go(label("home") + 9)
                else
                  if rollOver(13) then
                    setCursor()
                    go(label("home") + 10)
                  else
                    if rollOver(14) then
                      setCursor()
                      go(label("home") + 11)
                    else
                      if rollOver(15) then
                        setCursor()
                        go(label("home") + 12)
                      else
                        go(label("home") + 1)
                        checkRolloverScreen()
                      end if
                    end if
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
