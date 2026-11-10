on exitFrame
  if rollOver(8) then
    setCursor()
    go("exroll")
  else
    if rollOver(9) then
      setCursor()
      go("lroll")
    else
      if rollOver(10) then
        setCursor()
        go("fstroll")
      else
        if rollOver(11) then
          setCursor()
          go("onroll")
        else
          if rollOver(12) then
            setCursor()
            go("esyroll")
          else
            if rollOver(13) then
              setCursor()
              go("iroll")
            else
              cursor(-1)
              go("mainA")
            end if
          end if
        end if
      end if
    end if
  end if
end
