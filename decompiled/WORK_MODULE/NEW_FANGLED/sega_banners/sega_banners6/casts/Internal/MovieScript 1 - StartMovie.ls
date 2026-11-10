global gMyDestination, gBannerSlow, gQuitTime

on startMovie
  set gBannerSlow to 0
  if stringp(externalParamValue("sw1")) then
    set gMyDestination to externalParamValue("sw1")
  else
    set gMyDestination to "http://www.sega.com"
  end if
  set the volume of sound 1 to 10
  set gQuitTime to 0
  set the keyDownScript to "CheckForExitKey"
end

on stopMovie
  sound stop 1
end
