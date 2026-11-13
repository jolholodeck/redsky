property iPatchesPath, iRegNum, ilsongs, iMaxSongs

on new me, patchesPath, regNum
  iPatchesPath = patchesPath
  iRegNum = regNum
  ilsongs = [:]
  iMaxSongs = 8
  append(the actorList, me)
  return me
end

on stepFrame me
  repeat with oSong in ilsongs
    oSong.mProcessQueue()
  end repeat
end

on mAddSong me, songID, FPS
  if not voidp(getaProp(ilsongs, songID)) then
    strErr = "A song with that ID already exists!"
    return strErr
  end if
  if ilsongs.count >= iMaxSongs then
    strErr = "The maximum number of songs has been reached.  Kill one first."
    return strErr
  end if
  xBeatnik = new(xtra("beatnik"))
  if not objectp(xBeatnik) then
    strErr = "Beatnik musicObject instance creation failed."
    return strErr
  else
    register(xBeatnik, iRegNum)
    strVersion = getVersion(xBeatnik)
    if strVersion contains "Unregistered" then
      strErr = "Beatnik registration failed!"
      return strErr
    end if
  end if
  setSliceSize(xBeatnik, 2)
  setSampleLibrary(xBeatnik, iPatchesPath)
  setReady(xBeatnik)
  setAutoStart(xBeatnik, 0)
  err = isReady(xBeatnik)
  if not err then
    strErr = "The Beatnik instance failed to initialize."
    return strErr
  end if
  setReverbType(xBeatnik, 1)
  oSong = new(script("Song.class"), xBeatnik, FPS)
  setaProp(ilsongs, songID, oSong)
  return 0
end

on mKillSong me, songID
  if voidp(getaProp(ilsongs, songID)) then
    exit
  end if
  deleteProp(ilsongs, songID)
end

on mSuspend me
end

on mResume me
end
