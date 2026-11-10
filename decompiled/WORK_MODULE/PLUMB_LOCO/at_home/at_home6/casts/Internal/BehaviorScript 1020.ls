on exitFrame
  if rollOver(9) or rollOver(12) then
    setCursor()
    go("Aroll1")
  else
    if rollOver(10) or rollOver(13) then
      setCursor()
      go("Aroll2")
    else
      if rollOver(23) then
        setCursor()
        go("ARoll7")
      else
        if rollOver(24) then
          setCursor()
          go("ARoll6")
        else
          if rollOver(25) then
            setCursor()
            go("ARoll5")
          else
            if rollOver(27) then
              setCursor()
              go("ARoll4")
            else
              if rollOver(28) then
                setCursor()
                go("ARoll3")
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
end
