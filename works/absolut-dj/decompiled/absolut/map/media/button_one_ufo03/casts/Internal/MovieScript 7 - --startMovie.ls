global gStartVol, gBaseURL

on startMovie
  set gStartVol to the volume of sound 1
  set the cursor of sprite 10 to [52, 53]
  getBaseURL()
end

on stopMovie
  set the volume of sound 1 to gStartVol
  updateStage()
end

on getBaseURL
  set gBaseURL to the moviePath
  set myLength to length(gBaseURL) - 6
  set gBaseURL to char 1 to myLength of gBaseURL
end

on exitFrame
  set the castNum of sprite 15 to the castNum of sprite 15 + 1
  if the castNum of sprite 15 > 37 then
    set the castNum of sprite 15 to 11
  end if
  set myLocH to abs(the mouseH - 64)
  set myLocV to abs(the mouseV - 64)
  set mytrans to abs(((myLocH + myLocV) / 2) - 15)
  if mytrans < 0 then
    set mytrans to 0
  end if
  if mytrans > 100 then
    set mytrans to 100
  end if
  set the blend of sprite 15 to 100 - mytrans
  set the blend of sprite 12 to 100 - mytrans
  set myVol to integer((101 - mytrans) * 2.56000000000000005)
  if myVol < 20 then
    set myVol to 20
  end if
  if myVol > 255 then
    set myVol to 255
  end if
  set the volume of sound 1 to myVol
end
