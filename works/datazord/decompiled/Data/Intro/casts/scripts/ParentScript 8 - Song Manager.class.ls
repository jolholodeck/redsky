property iPatchesPath, iRegNum, ilsongs, iMaxSongs, iCurReverb

on new me, patchesPath, regNum
  iPatchesPath = patchesPath
  iRegNum = regNum
  ilsongs = [:]
  iMaxSongs = 8
  append(the actorList, me)
  return me
end

on mSetReverb me, newVal
  if newVal = iCurReverb then
    exit
  end if
  iCurReverb = newVal
  if ilsongs.count() > 0 then
    setReverbType(ilsongs[1].ixBeatnik, iCurReverb)
  end if
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
    strVersion = GetVersion(xBeatnik)
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
  oSong = new(script("Song.class"), xBeatnik, FPS)
  setaProp(ilsongs, songID, oSong)
  return 0
end

on mKillSong me, songID
  if voidp(ilsongs.getaProp(songID)) then
    return -2
  end if
  oSong = ilsongs.getaProp(songID)
  oSong.mStopAllNotes()
  oSong.mDisposeSong()
  oSong.ixBeatnik = 0
  ilsongs.setaProp(songID, 0)
  ilsongs.deleteProp(songID)
  return 0
end
