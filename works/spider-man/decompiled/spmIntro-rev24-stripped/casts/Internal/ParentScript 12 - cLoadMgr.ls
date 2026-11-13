property pMode, plSptBank, pGlyph, pTtlSpt, pPcntSpt, pGlyphOn, pFadeVal, pFadeTmr, pFadeDur, pLastTm, pbLoadDone, pLoadTmr
global glGlob, gSptMgr, gSndMgr, gFrmTm, gFadeSpt, gLoadRMF, gMainRMF, gPlatform

on new this
  this.mInitMode(#init)
  pGlyph = new(glGlob.cGlyph, glGlob.stgCntr, 0)
  pGlyphOn = 0
  plSptBank = gSptMgr.mGetSptBank(#load, 2)
  pTtlSpt = sprite(plSptBank[1])
  pTtlSpt.member = glGlob.loadTtl
  pTtlSpt.loc = glGlob.stgCntr
  pPcntSpt = sprite(plSptBank[2])
  pPcntSpt.member = glGlob.msgTxt
  pPcntSpt.loc = point(645, 256)
  glGlob.msgTxt.text = EMPTY
  glGlob.msgTxt.forecolor = 105
  glGlob.msgTxt.backcolor = 255
  gFadeSpt.member = glGlob.rct
  gFadeSpt.rect = glGlob.stgRect
  gFadeSpt.forecolor = 255
  gFadeSpt.blend = 100
  pbLoadDone = 0
  this.mInitMode(#preLoad)
  return this
end

on mDestroy this
  gSptMgr.mRlsBank(plSptBank)
  voidList(plSptBank)
  plSptBank = VOID
  pGlyph.mDestroy()
  pGlyph = VOID
  pMode = VOID
  pTtlSpt = VOID
  pPcntSpt = VOID
  pFadeVal = VOID
  pFadeTmr = VOID
  pFadeDur = VOID
  pLastTm = VOID
  pbLoadDone = VOID
  pLoadTmr = VOID
end

on mLoadDone this
  return pMode = #done
end

on mCancelTmr this
  pLoadTmr = gFrmTm - 1
end

on mCalcPcnt this
  itmCnt = 0
  nDone = 0
  nLibs = the number of castLibs
  sofar = 0
  totSz = 0
  repeat with clib = 1 to nLibs
    nMbrs = the number of castMembers of castLib clib
    repeat with num = 1 to nMbrs
      mbr = member(num, clib)
      if mbr.type <> #empty then
        itmCnt = itmCnt + 1
        totSz = totSz + mbr.size
        if mbr.mediaReady then
          nDone = nDone + 1
          sofar = sofar + mbr.size
        end if
      end if
    end repeat
  end repeat
  sndDone = gSndMgr.mLoadDone()
  sndState = gSndMgr.mLoadPcnt()
  sofar = sofar + sndState[1]
  totSz = totSz + sndState[2]
  pbLoadDone = (itmCnt = nDone) and sndDone
  pcnt = float(sofar) / float(totSz)
  glGlob.msgTxt.text = string(integer(100.0 * pcnt)) & "%"
  return pcnt
end

on mUpdate this
  dTm = gFrmTm - pLastTm
  if dTm > 4 then
    pFadeTmr = pFadeTmr + (dTm - 4)
  end if
  pLastTm = gFrmTm
  if pGlyphOn then
    pGlyph.mUpdate()
  else
    if pGlyph.mMediaReady() and gLoadRMF.mRMFready() then
      pGlyphOn = 1
      gLoadRMF.mSndEvent(#loadStart, VOID)
      pLoadTmr = gFrmTm + (10 * 60)
    end if
  end if
  case pMode of
    #preLoad:
      if glGlob.msgTxt.mediaReady and glGlob.loadTtl.mediaReady then
        this.mInitMode(#fade)
      end if
    #fade:
      this.mCalcPcnt()
      fadeVal = 100 * (gFrmTm - pFadeTmr) / pFadeDur
      if fadeVal < 100 then
        gFadeSpt.blend = 100 - fadeVal
      else
        fadeVal = 100
        gFadeSpt.rect = rect(-1000, -999, -1000, -999)
        this.mInitMode(#idle)
      end if
    #idle:
      this.mCalcPcnt()
      if pbLoadDone and (gFrmTm > pLoadTmr) then
        this.mInitMode(#spdr)
      end if
    #spdr:
      if pGlyph.pMode = #fadeOut then
        this.mInitMode(#blowOut)
      end if
    #blowOut:
      if pGlyph.pMode = #done then
        this.mInitMode(#done)
      end if
  end case
end

on mInitMode this, m
  pMode = m
  case pMode of
    #fade:
      pFadeVal = 0
      pFadeTmr = gFrmTm
      pFadeDur = 90
    #spdr:
      pGlyph.mFinish()
    #blowOut:
      gLoadRMF.mSndEvent(#loadStop, VOID)
      gMainRMF.mSndEvent(#loadBlowOut, VOID)
  end case
end
