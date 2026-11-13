property iPatchesPath, iRegNum, ilsongs, iMaxSongs, iCurReverb

on new me, patchesPath, regNum
  iPatchesPath = patchesPath
  iRegNum = regNum
  ilsongs = [:]
  iMaxSongs = 8
  append(the actorList, me)
  return me
end

on stepFrame me
  msecs = the milliSeconds
  repeat with oSong in ilsongs
    oSong.mProcessEventQueue(msecs)
  end repeat
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

on mAddSong me, songID
  if not voidp(getaProp(ilsongs, songID)) then
    return -1
  end if
  if ilsongs.count >= iMaxSongs then
    return -2
  end if
  xBeatnik = new(xtra("beatnik"))
  if not objectp(xBeatnik) then
    return -3
  else
    register(xBeatnik, iRegNum)
    strVersion = getVersion(xBeatnik)
    if strVersion contains "Unregistered" then
      return -4
    end if
  end if
  setSliceSize(xBeatnik, 1)
  setSampleLibrary(xBeatnik, iPatchesPath)
  setReady(xBeatnik)
  setAutoStart(xBeatnik, 0)
  err = isReady(xBeatnik)
  if not err then
    return -5
  end if
  oSong = new(script("Song.class"), xBeatnik)
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
  ilsongs.setaProp(songID, 0)
  ilsongs.deleteProp(songID)
  return 0
end

on mGetErrorString me, errorCode
  case errorCode of
    (-1):
      strError = "A song with that ID already exists!"
    (-2):
      strError = "The maximum number of songs has been reached.  Kill one first."
    (-3):
      strError = "Beatnik musicObject instance creation failed."
    (-4):
      strError = "Beatnik registration failed!"
    (-5):
      strError = "The Beatnik instance failed to initialize."
    otherwise:
      strError = "Unknown Beatnik initialization error."
  end case
  return strError
end

on mdispose me
  repeat with n = 1 to ilsongs.count
    songID = ilsongs.getPropAt(n)
    me.mKillSong(songID)
  end repeat
  iPatchesPath = VOID
  iRegNum = VOID
  ilsongs = VOID
  iMaxSongs = VOID
  iCurReverb = VOID
end
