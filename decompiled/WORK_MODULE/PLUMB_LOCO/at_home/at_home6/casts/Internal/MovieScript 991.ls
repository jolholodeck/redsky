global gFlag

on checkRolloverScreen
  if rollOver(21) then
    if gFlag = 21 then
      exit
    end if
    if gFlag > 0 then
      set the memberNum of sprite gFlag to the memberNum of sprite gFlag - 1
    end if
    setCursor()
    set the memberNum of sprite 21 to the memberNum of sprite 21 + 1
    set gFlag to 21
  else
    if rollOver(22) then
      if gFlag = 22 then
        exit
      end if
      if gFlag > 0 then
        set the memberNum of sprite gFlag to the memberNum of sprite gFlag - 1
      end if
      setCursor()
      set the memberNum of sprite 22 to the memberNum of sprite 22 + 1
      set gFlag to 22
    else
      if rollOver(24) then
        if gFlag = 24 then
          exit
        end if
        if gFlag > 0 then
          set the memberNum of sprite gFlag to the memberNum of sprite gFlag - 1
        end if
        setCursor()
        set the memberNum of sprite 24 to the memberNum of sprite 24 + 1
        set gFlag to 24
      else
        if rollOver(25) then
          if gFlag = 25 then
            exit
          end if
          if gFlag > 0 then
            set the memberNum of sprite gFlag to the memberNum of sprite gFlag - 1
          end if
          setCursor()
          set the memberNum of sprite 25 to the memberNum of sprite 25 + 1
          set gFlag to 25
        else
          if gFlag > 0 then
            cursor(-1)
            set the memberNum of sprite gFlag to the memberNum of sprite gFlag - 1
            set gFlag to 0
          else
            cursor(-1)
          end if
        end if
      end if
    end if
  end if
  updateStage()
end

on checkRollover
  if rollOver(21) then
    if gFlag = 21 then
      exit
    end if
    if gFlag > 0 then
      set the memberNum of sprite gFlag to the memberNum of sprite gFlag - 1
    end if
    setCursor()
    set the memberNum of sprite 21 to the memberNum of sprite 21 + 1
    set gFlag to 21
  else
    if rollOver(22) then
      if gFlag = 22 then
        exit
      end if
      if gFlag > 0 then
        set the memberNum of sprite gFlag to the memberNum of sprite gFlag - 1
      end if
      setCursor()
      set the memberNum of sprite 22 to the memberNum of sprite 22 + 1
      set gFlag to 22
    else
      if gFlag > 0 then
        cursor(-1)
        set the memberNum of sprite gFlag to the memberNum of sprite gFlag - 1
        set gFlag to 0
      end if
    end if
  end if
  updateStage()
end
