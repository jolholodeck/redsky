global gMousePos

on startMovie
  set the visible of sprite 48 to 0
  set the keyDownScript to "checkKey"
  set the timeoutLength to 30 * 60
  set gMousePos to "OFF"
  if the machineType <> 256 then
    set the exitLock to 1
  end if
end

on checkKey theKey
  CheckForExitKey()
  if theKey = 0 then
    set theKey to the key
  end if
  if the commandDown then
    if theKey = "I" then
      set the keyDownScript to "checkKey"
      go(label("IntroA") - 1)
      exit
    else
      if theKey = "S" then
        set the keyDownScript to "leaveSSaver"
        go("SS")
        exit
      else
        if theKey = "L" then
          set gMousePos to "OFF"
          set the keyDownScript to "checkKey"
          go("Loop")
          exit
        else
          if theKey = "M" then
            set gMousePos to 0
            set the keyDownScript to "checkKey"
            go("mainBlur")
            exit
          end if
        end if
      end if
    end if
  end if
end

on leaveSSaver
  CheckForExitKey()
  set theKey to the key
  checkKey(theKey)
  set the keyDownScript to "checkKey"
  go("introA")
end
