on mouseUp
  global gStartVol
  if the castNum of sprite the clickOn = 131 then
    set the castNum of sprite the clickOn to the castNum of sprite the clickOn + 1
    set myVol to 0
  else
    set the castNum of sprite the clickOn to the castNum of sprite the clickOn - 1
    set myVol to gStartVol
  end if
  repeat with x = 1 to 6
    set the volume of sound x to myVol
  end repeat
end

on mouseEnter
  set the foreColor of sprite 118 to 0
end

on mouseLeave
  set the foreColor of sprite 118 to 95
end
