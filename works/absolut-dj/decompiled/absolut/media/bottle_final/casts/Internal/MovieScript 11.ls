global gMyVol, gBaseURL

on startMovie
  set gMyVol to the volume of sound 1
  set the cursor of sprite 1 to [20, 21]
  getBaseURL()
end

on prepareMovie
  preloadMember(member 14, 14)
end

on stopMovie
  set the volume of sound 1 to gMyVol
end

on getBaseURL
  set gBaseURL to the moviePath
  set myLength to length(gBaseURL) - 6
  set gBaseURL to char 1 to myLength of gBaseURL
end
