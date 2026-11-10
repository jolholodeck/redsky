on enterFrame
  global _gWhichSection
  if rollOver(2) then
    set _gWhichSection to 1
  else
    if rollOver(3) then
      set _gWhichSection to 2
    else
      if rollOver(4) then
        set _gWhichSection to 3
      else
        set _gWhichSection to 0
      end if
    end if
  end if
end
