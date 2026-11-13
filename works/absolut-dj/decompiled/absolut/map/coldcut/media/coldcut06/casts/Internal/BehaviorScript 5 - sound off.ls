global gSoundOn

on mouseUp
  if gSoundOn then
    set myVolume to 0
    set the castNum of sprite 93 to 101
    set gSoundOn to 0
  else
    set the castNum of sprite 93 to 99
    set myVolume to 255
    set gSoundOn to 1
  end if
  repeat with x = 1 to 4
    set the volume of sound x to myVolume
  end repeat
end

on mouseEnter
  if gSoundOn then
    set the castNum of sprite 93 to 99
  else
    set the castNum of sprite 93 to 101
  end if
end

on mouseLeave
  if gSoundOn then
    set the castNum of sprite 93 to 98
  else
    set the castNum of sprite 93 to 100
  end if
end
