global gMousePos, gWhereNext

on timeout
  if gMousePos <> "OFF" then
    if gMousePos = 0 then
      put the mouseH into item 1 of gMousePos
      put the mouseV into item 2 of gMousePos
      set the timeoutLength to 10 * 60
    else
      if (the mouseH = value(item 1 of gMousePos)) and (the mouseV = value(item 2 of gMousePos)) then
        set gMousePos to "OFF"
        puppetSprite(21, 0)
        puppetSprite(22, 0)
        puppetSprite(24, 0)
        puppetSprite(25, 0)
        cursor(-1)
        set gWhereNext to EMPTY
        go("SS")
        set the keyDownScript to "leaveSSaver"
        set the visible of sprite 48 to 0
        set the timeoutLength to 30 * 60
      else
        set gMousePos to 0
        set the timeoutLength to 30 * 60
      end if
    end if
  end if
end
