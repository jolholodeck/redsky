global glGlob, gSptMgr, gSndMgr, gLoadMgr, gOutroMgr, gPI, g2PI, gLoadRMF, gMainRMF, gPlatform, gRunMode, gUrlCGI, gUrlPriv, gUrlTerm, gFrmTm, gLstFrmMs, gFrmDurMs, gCrntMode, gMousePt, gLstMsPt, gFadeSpt, gSpdrLoc, gRegMgr, gLiveConn, glQuads, gWebSpts, gSpdrSpt, gCursSpt, gOutroSpts, gDnaSpts, mlYacSpts, mlBandSpts, mlCmidSpts, mlCtigSpts, mLineSpt

on startMovie
  clearGlobals()
  initGlob()
  gCrntMode = #init
  gSndMgr = new(glGlob.cSndMgr)
  gLoadRMF = gSndMgr.mNewRMFobj(#load, the moviePath & "loading6.rmf")
  gSptMgr = new(glGlob.cSptMgr)
  initStatics()
  cnt = glQuads.count
  gWebSpts = gSptMgr.mGetSptBank(#web, cnt + 2)
  gSpdrSpt = sprite(gSptMgr.mGetSpt(#spdr))
  gCursSpt = sprite(gSptMgr.mGetSpt(#curs))
  gOutroSpts = gSptMgr.mGetSptBank(#outro, 3)
  gDnaSpts = gSptMgr.mGetSptBank(#dna, 20)
  yacs = 5
  mlYacSpts = gSptMgr.mGetSptBank(#dna, yacs)
  mlBandSpts = gSptMgr.mGetSptBank(#dna, yacs)
  mlCmidSpts = gSptMgr.mGetSptBank(#dna, yacs)
  mlCtigSpts = gSptMgr.mGetSptBank(#dna, yacs)
  mLineSpt = sprite(gSptMgr.mGetSpt(#dna))
  gLiveConn = 0
  if the runMode contains "Plugin" then
    gRunMode = #plugin
    cnt = externalParamCount()
    repeat with i = 1 to cnt
      case externalParamName(i) of
        "sw1":
          gUrlCGI = externalParamValue(i)
        "sw2":
          gUrlPriv = externalParamValue(i)
        "sw3":
          gUrlTerm = externalParamValue(i)
        "sw9":
          if externalParamValue(i) contains "Netscape" then
            gLiveConn = 1
          end if
      end case
    end repeat
  else
    gRunMode = #local
    gUrlCGI = "http://172.16.15.141/cgi-bin/spiderman_register.pl"
    gUrlPriv = "http://www.spe.sony.com/spe/privacy_index.html"
    gUrlTerm = "http://www.spe.sony.com/spe/terms_index.html"
    gLiveConn = 1
  end if
  if the platform contains "Mac" then
    gPlatform = #mac
  else
    gPlatform = #pc
  end if
  go("idle")
  puppetTempo(45)
  gPI = PI
  g2PI = 2 * gPI
  gFadeSpt = sprite(gSptMgr.mGetSpt(#fade))
  gLstFrmMs = the milliSeconds
  glGlob.msgTxt.text = EMPTY
  glGlob.inputTxt.text = EMPTY
  initMode(#preLoad)
end

on stopMovie
  if ilk(gLoadRMF, #instance) then
    if ilk(gLoadRMF.pxBeatnik, #instance) then
      gLoadRMF.pxBeatnik.stop()
      gLoadRMF.pxBeatnik.closeBeatnik()
    end if
    gLoadRMF.pxBeatnik = VOID
  end if
  updateStage()
  if ilk(gMainRMF, #instance) then
    if ilk(gMainRMF.pxBeatnik, #instance) then
      gMainRMF.mFlushNotes()
      gMainRMF.pxBeatnik.stop()
      gMainRMF.pxBeatnik.closeBeatnik()
    end if
    gMainRMF.pxBeatnik = VOID
  end if
  updateStage()
  if objectp(gSndMgr) then
    gSndMgr.mDestroy()
    gSndMgr = 0
  end if
  updateStage()
  if objectp(gSptMgr) then
    gSptMgr.mDestroy()
  end if
  updateStage()
end

on enterFrame
  gFrmTm = the ticks
  gLstMsPt = gMousePt
  gMousePt = the mouseLoc
  now = the milliSeconds
  gFrmDurMs = now - gLstFrmMs
  gLstFrmMs = now
  case gCrntMode of
    #preLoad:
      gLoadMgr.mUpdate()
      if gLoadMgr.pMode = #fade then
        initMode(#load)
      end if
    #load:
      gLoadMgr.mUpdate()
      if gLoadMgr.pMode = #done then
        initMode(#harp)
      end if
    #harp, #enter, #attack:
      updWeb()
      updCurs()
      updSpdr()
    #settle:
      updWeb()
      updSpdr()
    #dna, #signoff:
      gOutroMgr.mUpdate()
      if gOutroMgr.pMode = #done then
        initMode(#reg)
      end if
    #reg:
      gRegMgr.mUpdate()
  end case
  if objectp(gSndMgr) then
    gSndMgr.mUpdate()
  end if
end

on initMode m
  case gCrntMode of
    #load:
      if objectp(gLoadMgr) then
        gLoadMgr.mDestroy()
        gLoadMgr = VOID
      end if
    #signoff:
      if objectp(gOutroMgr) then
        gOutroMgr.mDestroy()
        gOutroMgr = VOID
      end if
    #reg:
      if objectp(gRegMgr) then
        gRegMgr.mDestroy()
        gRegMgr = VOID
      end if
  end case
  gCrntMode = m
  case gCrntMode of
    #preLoad:
      gLoadMgr = new(glGlob.cLoadMgr)
    #load:
      gMainRMF = gSndMgr.mNewRMFobj(#main, the moviePath & "main18.rmf")
    #harp:
      spdrLoc = point(80, 70)
      swtSpot = spdrLoc + point(150, 150)
      initWeb(swtSpot)
      initSpdr(spdrLoc)
      initCurs()
      webInitMode(#enter)
    #enter:
      spdrInitMode(#lEnter)
    #attack:
      spdrInitMode(#lEmerge)
    #settle:
      webInitMode(#settle)
    #dna:
      webInitMode(#idle)
      gOutroMgr = new(glGlob.cOutroMgr, gSpdrLoc)
    #signoff:
      destroyWeb()
      destroySpdr()
      destroyCurs()
    #reg:
      gRegMgr = new(glGlob.cReg)
  end case
end

on mouseUp
  case gCrntMode of
    #load:
      gLoadMgr.mCancelTmr()
    #harp, #enter, #attack:
      webMUp()
    #reg:
      gRegMgr.mMouseUp()
  end case
end
