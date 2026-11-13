on exitFrame
  global goSongMgr, goSndFX, gSndFXid, goSong, gSongID
  goSongMgr.mKillSong(gSndFXid)
  goSndFX = VOID
  gSndFXid = VOID
  FPS = 15
  gSongID = #zordSong
  result = goSongMgr.mAddSong(gSongID, FPS)
  if stringp(result) then
    alert("An error occurred while attempting to create a song object." && "(" & string(result) & ")")
    quit()
  else
    goSong = goSongMgr.ilsongs.getaProp(gSongID)
  end if
  goSong.iVelocityOffset = 27
end
