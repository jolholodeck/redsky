property pEndTime, pSoundNumber, pPath, pfRunning

on new me
  set the volume of sound 1 to 180
  set pEndTime to mGetRandom10To15(me) + the ticks
  RegisterForFrameEvents(me)
  set pSoundNumber to random(3)
  set pPath to the pathName
  set theDelim to the last char in pPath
  set pPath to pPath & "work_support" & theDelim
  set pfRunning to 1
  return me
end

on mCleanUp me
end

on mFrameEvent me
  if not pfRunning then
    return 
  end if
  if not soundBusy(1) then
    set pSoundNumber to pSoundNumber + 1
    if pSoundNumber > 3 then
      set pSoundNumber to 1
    end if
    set theFileName to pPath & "w_back" & string(pSoundNumber) & ".aif"
    sound playFile 1, theFileName
  end if
  if the ticks > pEndTime then
    set rand to random(7)
    set soundName to "w_randomSound" & string(rand)
    puppetSound(2, soundName)
    set pEndTime to mGetRandom10To15(me) + the ticks
  end if
end

on mGetRandom10To15 me
  set random0to5 to random(6) - 1
  set random10To15 to random0to5 + 10
  set randomTicks to 60 * random10To15
  return randomTicks
end

on mShuttingDown me
  set pfRunning to 0
end
