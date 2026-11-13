property pxBeatnik, pXtraReady, pRMFurl, pRMFnetID, pRMFready, pBytesSoFar, pBytesTotal, plChanVols, pFading, pFadeTmr, pFadeDur
global gPlatform

on new this
  pXtraReady = 0
  this.mInit()
  plChanVols = []
  repeat with i = 1 to 16
    plChanVols.append(0)
  end repeat
  pFading = 0
  pFadeTmr = 0
  pFadeDur = 0
  return this
end

on mInit this
  this.mDestroy()
  pRMFnetID = 0
  pRMFready = 0
  pXtraReady = 0
  pBytesSoFar = 0
  pBytesTotal = 0
  pxBeatnik = xtra("beatnik").new()
  if voidp(pxBeatnik) then
  else
    pxBeatnik.register("BXP-ALL-1-510219-17092267-01167")
    if pxBeatnik.getVersion() contains "Unregistered" then
    else
      if the runMode contains "plugin" then
        hsbPath = pxBeatnik.getSampleLibrary("0.0.1", "stub.hsb")
      else
        hsbPath = the moviePath & "stub.hsb"
      end if
      pxBeatnik.setSampleLibrary(hsbPath)
      pxBeatnik.setSliceSize(1)
      pxBeatnik.setReady()
      pxBeatnik.setAutoStart(0)
      pxBeatnik.setReverbType(0)
      pXtraReady = pxBeatnik.isReady()
      if not pXtraReady then
      end if
    end if
  end if
  return pXtraReady
end

on mDestroy this
  if ilk(pxBeatnik, #instance) then
    pxBeatnik.stop()
    pxBeatnik.closeBeatnik()
  end if
  pxBeatnik = VOID
  if pRMFnetID > 0 then
    netAbort(pRMFnetID)
  end if
end

on mSndEvent this, evt, dat
  retVal = VOID
  if pRMFready then
    case evt of
      #loadStart:
        pxBeatnik.play()
      #loadStop:
        this.mFadeToStop(5000)
      #loadBlowOut:
        pxBeatnik.noteOn(12, 2, 5, 65, 60)
        pxBeatnik.noteOn(13, 2, 6, 74, 85)
        pxBeatnik.setController(12, 10, 0)
        pxBeatnik.setController(13, 10, 127)
      #windStart:
        pxBeatnik.noteOn(15, 2, 44, 64, 120)
      #windVol:
      #windStop:
        pxBeatnik.noteOff(15, 64, 120)
      #startWebBg:
        pxBeatnik.noteOn(2, 2, 12, 48, 80)
        pxBeatnik.noteOn(3, 2, 12, 51, 80)
        pxBeatnik.setController(2, 10, 0)
        pxBeatnik.setController(3, 10, 127)
        pxBeatnik.noteOn(4, 2, 27, 64, 127)
        pxBeatnik.setController(4, 7, 1)
        pxBeatnik.fadeFromTo(0, 100, 2000)
      #webBgAnchor:
        pxBeatnik.noteOn(9, 2, 21, 50, 40)
      #webBgVol:
        if dat < 1 then
          dat = 1
        end if
        pxBeatnik.setController(9, 7, dat)
        pxBeatnik.setController(2, 7, dat)
        pxBeatnik.setController(3, 7, dat)
      #webProxVol:
        if dat < 1 then
          dat = 1
        end if
        pxBeatnik.setController(4, 7, dat)
      #webKillProx:
        pxBeatnik.noteOff(4, 64, 127)
      #closeWebBg:
        pxBeatnik.noteOff(9, 50, 40)
        pxBeatnik.noteOff(2, 48, 80)
        pxBeatnik.noteOff(3, 51, 80)
        pxBeatnik.noteOff(4, 76, 127)
        pxBeatnik.noteOff(15, 64, 120)
      #webStick:
        if dat < 40 then
          dat = 40
        end if
        if dat > 100 then
          dat = 100
        end if
        pxBeatnik.noteOn(6, 2, 28, 88 + random(10), dat - 20 + random(25))
        pxBeatnik.noteOn(5, 2, 30, 70 + random(10), dat + random(25))
      #webStruggle:
        vol = 30 + dat
        if vol > 127 then
          vol = 127
        end if
        numNotes = 1 + (2 * (dat > 15))
        repeat with i = 1 to numNotes
          pxBeatnik.noteOn(7, 2, 29, 65 + (2 * random(dat)), vol)
        end repeat
      #spdrAppear:
        pxBeatnik.noteOn(5, 2, 13, 60, 80)
        pxBeatnik.noteOn(5, 2, 13, 48, 80)
      #spdrEnter:
        pxBeatnik.noteOff(12, 65, 60)
        pxBeatnik.noteOff(13, 74, 85)
        pxBeatnik.noteOn(14, 2, 27, 68, 120)
        pxBeatnik.noteOn(12, 2, 20, 53, 65)
        pxBeatnik.noteOn(13, 2, 16, 72, 127)
        pxBeatnik.setController(13, 7, 1)
        pxBeatnik.setController(13, 10, 40)
      #spdrProx:
        if dat < 1 then
          dat = 1
        end if
        pxBeatnik.setController(13, 7, dat)
      #spdrLeap:
        pxBeatnik.noteOn(16, 2, 37, 84, 50)
        pxBeatnik.noteOff(13, 72, 127)
      #spdrStrike:
        pxBeatnik.noteOff(14, 68, 120)
      #spdrBite:
        pxBeatnik.noteOff(16, 84, 50)
        pxBeatnik.setController(13, 10, 40)
        pxBeatnik.noteOff(5, 48, 50)
        pxBeatnik.noteOff(5, 54, 50)
        pxBeatnik.noteOff(12, 53, 65)
        pxBeatnik.noteOn(12, 2, 43, 69, 80)
        pxBeatnik.noteOn(16, 2, 45, 72, 40)
        pxBeatnik.noteOn(16, 2, 45, 80, 40)
        pxBeatnik.noteOff(14, 68, 120)
      #startClose:
        pxBeatnik.noteOff(5, 48, 80)
        pxBeatnik.noteOff(5, 60, 80)
        pxBeatnik.noteOff(14, 68, 120)
        pxBeatnik.noteOff(12, 69, 80)
        pxBeatnik.noteOff(13, 72, 127)
        pxBeatnik.noteOff(4, 60, 50)
        pxBeatnik.noteOff(16, 72, 40)
        pxBeatnik.noteOff(16, 80, 40)
        repeat with n = 54 to 127
          repeat with v = 0 to 127
            pxBeatnik.noteOff(6, n, v)
            pxBeatnik.noteOff(5, n, v)
            pxBeatnik.noteOff(7, n, v)
            pxBeatnik.noteOff(1, n, v)
            pxBeatnik.noteOff(12, n, v)
            pxBeatnik.noteOff(13, n, v)
            pxBeatnik.noteOff(14, n, v)
            pxBeatnik.noteOff(15, n, v)
            pxBeatnik.noteOff(16, n, v)
          end repeat
        end repeat
        pxBeatnik.setController(0, 7, 120)
        pxBeatnik.play()
      #getPos:
        retVal = pxBeatnik.getPosition()
      #setPos:
        pxBeatnik.setPosition(dat)
      #fall2001:
        pxBeatnik.noteOn(15, 2, 44, 64, 120)
      #mainStop:
        this.mFlushNotes()
        this.mFadeToStop(3000)
        pxBeatnik.noteOff(15, 64, 120)
    end case
  end if
  return retVal
end

on mUpdate this
  if pFading then
    fadePcnt = 1.0 - (float(the milliSeconds - pFadeTmr) / float(pFadeDur))
    if fadePcnt < 0.0 then
      pxBeatnik.stop()
      this.mResetVols()
      pFading = 0
    else
      repeat with i = 1 to 16
        vol = integer(fadePcnt * plChanVols[i])
        if vol < 1 then
          vol = 1
        end if
        pxBeatnik.setController(i, 7, vol)
      end repeat
    end if
  end if
  if pRMFnetID > 0 then
    if netDone(pRMFnetID) then
      pBytesSoFar = pBytesTotal
      pRMFnetID = 0
      pxBeatnik.setAutoStart(0)
      pxBeatnik.play(0, pRMFurl)
      pRMFready = 1
    else
      stat = getStreamStatus(pRMFnetID)
      pBytesSoFar = stat.bytesSoFar
      pBytesTotal = stat.bytesTotal
    end if
  end if
end

on mFlushNotes this
  a = the milliSeconds
  repeat with c = 1 to 16
    repeat with n = 0 to 127
      repeat with v = 0 to 127
        pxBeatnik.noteOff(c, n, v)
      end repeat
    end repeat
  end repeat
  a = the milliSeconds - a
end

on mLoadRMF this, RMFurl
  if pXtraReady then
    pRMFready = 0
    pRMFurl = RMFurl
    pRMFnetID = preloadNetThing(RMFurl)
  end if
end

on mRMFready this
  return pRMFready
end

on mLoadPcnt this
  return 0
end

on mFadeToStop this, ms
  repeat with i = 1 to 16
    plChanVols[i] = pxBeatnik.getController(i, 7)
  end repeat
  pFading = 1
  pFadeTmr = the milliSeconds
  pFadeDur = ms
end

on mResetVols this
  repeat with i = 1 to 16
    pxBeatnik.setController(i, 7, 127)
  end repeat
end
