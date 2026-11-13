global gDebug

on alertHook me, err, Msg
  if gDebug then
    str = "Err: " & err & RETURN & "Msg: " & Msg & RETURN & "RAM: " & the freeBytes / 1024 & "K"
    alert(str)
  else
    alert("Sorry, an unexpected error occurred. This program will now quit.")
  end if
  quit()
end
