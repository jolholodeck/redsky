property pMode, plSptBank, pLowSpt, pMedSpt, pTopSpt, plIconAnim, pAnimIdx, plDNAactv, plDNAfree, plDNAdone, pDNAscl, pStLoc, mGene, pX1, pX2, pY1, pY2, pTmr, pDur, pBlnd, pStTmr, pMinFrmTm, pLstFrmTm
global glGlob, gSptMgr, gSndMgr, gMainRMF, gFrmTm, gFadeSpt, gOutroSpts, gDnaSpts, gDNAgfx, gDNAgrid

on new this, stLoc
  pStLoc = stLoc
  this.mInitMode(#init)
  gDNAgfx = [glGlob.dnaCore, glGlob.dnaHex, glGlob.dnaPent, glGlob.dnaWheels]
  gDNAgrid = [[[#flp: 0, #mbr: 4, #pth: [[1, 0, point(36, -6)], [0, -1, point(0, -44)], [0, 1, point(0, 44)]]], [#flp: 0, #mbr: 2, #pth: [[-1, 0, point(-36, 6)], [1, 0, point(34, -4)]]], [#flp: 0, #mbr: 1, #pth: [[-1, 0, point(-34, 4)], [1, 0, point(54, 4)]]], [#flp: 1, #mbr: 3, #pth: [[-1, 0, point(-54, -4)], [1, 0, point(35, 17)]]], [#flp: 1, #mbr: 4, #pth: [[-1, 0, point(-35, -17)], [0, -1, point(0, -44)], [0, 1, point(0, 44)]]]], [[#flp: 0, #mbr: 4, #pth: [[1, 0, point(35, -5)], [0, -1, point(0, -44)], [0, 1, point(0, 44)]]], [#flp: 0, #mbr: 3, #pth: [[-1, 0, point(-35, 5)], [1, 0, point(54, -4)]]], [#flp: 1, #mbr: 1, #pth: [[-1, 0, point(-54, 4)], [1, 0, point(35, 4)]]], [#flp: 1, #mbr: 2, #pth: [[-1, 0, point(-35, -4)], [1, 0, point(35, 16)]]], [#flp: 1, #mbr: 4, #pth: [[-1, 0, point(-35, -16)], [0, -1, point(0, -44)], [0, 1, point(0, 44)]]]]]
  plDNAactv = []
  plDNAfree = []
  plDNAdone = []
  cnt = gDnaSpts.count
  idx = 1
  repeat while idx < cnt
    plDNAfree.append(new(glGlob.cDNA, this, glGlob.hideLoc, 1.0, gDnaSpts[idx], gDnaSpts[idx + 1]))
    idx = idx + 2
  end repeat
  mGene = VOID
  pDNAscl = 0.0
  pMinFrmTm = 10
  pLstFrmTm = the ticks
  plSptBank = gOutroSpts
  pLowSpt = sprite(plSptBank[1])
  pMedSpt = sprite(plSptBank[2])
  pTopSpt = sprite(plSptBank[3])
  plIconAnim = []
  n1 = glGlob.logoShmr0.number
  n2 = glGlob.logoShmrN.number
  repeat with i = n1 to n2
    plIconAnim.append(member(i))
  end repeat
  this.mInitMode(#dna)
  return this
end

on mDestroy this
  repeat with spt in plSptBank
    CDH_hideSpt(spt)
  end repeat
  plSptBank = VOID
  voidList(plIconAnim)
  plIconAnim = VOID
  pLowSpt = VOID
  pMedSpt = VOID
  pTopSpt = VOID
  voidList(gDNAgfx)
  voidList(gDNAgrid)
  gDNAgfx = VOID
  gDNAgrid = VOID
  voidObjList(plDNAactv)
  voidObjList(plDNAfree)
  voidObjList(plDNAdone)
  plDNAactv = VOID
  plDNAfree = VOID
  plDNAdone = VOID
end

on mUpdateDNA this
  repeat with dna in plDNAactv
    dna.mUpdate()
  end repeat
  repeat with dna in plDNAdone
    idx = plDNAactv.getPos(dna)
    if idx > 0 then
      plDNAfree.append(plDNAactv[idx])
      plDNAactv.deleteAt(idx)
    end if
  end repeat
  plDNAdone = []
end

on mStopDNA this, dna
  dna.mSpawn()
  plDNAdone.append(dna)
end

on mCreateDNA this, loc, bDisplace
  tmLft = 6.90000000000000036 - (float(gFrmTm - pStTmr) * 0.0115)
  if tmLft < 0.0 then
    tmLft = 0.0
  end if
  scl = 10.0 / exp(tmLft)
  if scl > 7.0 then
    scl = 7.0
  end if
  pDNAscl = scl
  if bDisplace then
    dx = 300 * scl
    if dx > 1.0 then
      dx2 = dx / 2.0
      loc = loc + point(random(dx) - dx2, random(dx) - dx2)
    end if
  end if
  if plDNAfree.count > 0 then
    dna = plDNAfree[1]
    plDNAfree.deleteAt(1)
    dna.mInit(loc, scl)
    plDNAactv.append(dna)
  end if
end

on mClearAllDNA this
  repeat with dna in plDNAactv
    dna.mDestroy()
  end repeat
  plDNAactv = []
  repeat with dna in plDNAfree
    dna.mDestroy()
  end repeat
  plDNAfree = []
end

on mUpdate this
  dTm = gFrmTm - pLstFrmTm
  if dTm > pMinFrmTm then
    pDur = pDur + (dTm - pMinFrmTm)
  end if
  pLstFrmTm = gFrmTm
  case pMode of
    #dna:
      this.mUpdateDNA()
      if pDNAscl > 0.14999999999999999 then
        this.mInitMode(#dnaGene)
      end if
    #dnaGene:
      this.mUpdateDNA()
      mGene.mUpdate()
      if (gMainRMF.mSndEvent(#getPos, VOID) >= 10000) or ((gFrmTm - pStTmr) > 720) then
        this.mInitMode(#whiteOut)
      end if
    #whiteOut:
      pBlnd = 100
      gFadeSpt.blend = pBlnd
      if gFrmTm > pTmr then
        this.mInitMode(#fadeDown)
      end if
    #fadeDown:
      dt = gFrmTm - pTmr
      pBlnd = 100 - (100 * dt / pDur)
      if pBlnd < 0 then
        pBlnd = 0
      end if
      gFadeSpt.blend = pBlnd
      if dt > pDur then
        this.mInitMode(#crtVert)
      end if
    #crtVert:
      dt = gFrmTm - pTmr
      h = pX2 + integer((1.0 - (float(dt) / float(pDur))) * pX1)
      if h < 0 then
        h = 0
      end if
      pLowSpt.height = h
      pMedSpt.height = h
      if dt > pDur then
        this.mInitMode(#crtHoriz)
      end if
    #crtHoriz:
      dt = gFrmTm - pTmr
      val = float(dt) / float(pDur)
      if val > 1.0 then
        val = 1.0
      end if
      pTopSpt.width = integer((1.0 - sqrt(sqrt(sqrt(val)))) * pX1)
      pTopSpt.height = (1.0 - (val * val * val)) * glGlob.horizGlow.height
      w2 = 5 + integer(val * 8)
      pLowSpt.width = w2
      pLowSpt.height = w2
      if dt > pDur then
        this.mInitMode(#dotToOval)
      end if
    #dotPause:
      if gFrmTm > pTmr then
        this.mInitMode(#dotToOval)
      end if
    #dotToOval:
      dt = gFrmTm - pTmr
      val = float(dt) / float(pDur)
      if val > 1.0 then
        val = 1.0
      end if
      val = val * val
      pLowSpt.width = pX1 + integer(val * pX2)
      pLowSpt.height = pY1 + integer(val * pY2)
      if dt > pDur then
        this.mInitMode(#fadeInLegs)
      end if
    #fadeInLegs:
      dt = gFrmTm - pTmr
      val = float(dt) / float(pDur)
      if val > 1.0 then
        val = 1.0
      end if
      pMedSpt.blend = integer(val * 100.0)
      pLowSpt.blend = 100 - integer(val * 100.0)
      if dt > pDur then
        this.mInitMode(#blueShmr)
      end if
    #blueShmr:
      if gFrmTm > pTmr then
        pTmr = gFrmTm + 4
        pMedSpt.member = plIconAnim[pAnimIdx]
        pAnimIdx = pAnimIdx + 1
        if pAnimIdx > plIconAnim.count then
          this.mInitMode(#fadeOutSpdr)
        end if
      end if
    #fadeOutSpdr:
      dt = gFrmTm - pTmr
      val = float(dt) / float(pDur)
      if val > 1.0 then
        val = 1.0
      end if
      pMedSpt.blend = 100 - integer(val * 100.0)
      if dt > pDur then
        this.mInitMode(#fadeOutDot)
      end if
    #fadeOutDot:
      dt = gFrmTm - pTmr
      val = float(dt) / float(pDur)
      if val > 1.0 then
        val = 1.0
      end if
      pLowSpt.blend = pBlnd - integer(val * pBlnd)
      if dt > pDur then
        this.mInitMode(#endPause)
      end if
    #endPause:
      if gFrmTm > pTmr then
        this.mInitMode(#fadeInCmg)
      end if
    #fadeInCmg:
      dt = gFrmTm - pTmr
      val = float(dt) / float(pDur)
      if val > 1.0 then
        val = 1.0
      end if
      pMedSpt.blend = integer(val * 100.0)
      if dt > pDur then
        this.mInitMode(#holdCmg)
      end if
    #holdCmg:
      if gFrmTm > pTmr then
        this.mInitMode(#fadeOutCmg)
      end if
    #fadeOutCmg:
      dt = gFrmTm - pTmr
      val = float(dt) / float(pDur)
      if val > 1.0 then
        val = 1.0
      end if
      pMedSpt.blend = 100 - integer(val * 100.0)
      if dt > pDur then
        this.mInitMode(#done)
      end if
  end case
end

on mInitMode this, m
  pMode = m
  case pMode of
    #dna:
      pStTmr = gFrmTm
      this.mCreateDNA(pStLoc, 0)
      gMainRMF.mSndEvent(#closeWebBg, VOID)
      gMainRMF.mSndEvent(#startClose, VOID)
      mGene = new(glGlob.cGenePlot, this, glGlob.stgRect)
    #dnaGene:
      mGene.mInitMode(#Run)
      x = glGlob.stgCntr[1]
      y = glGlob.stgCntr[2]
      stLoc = point(100 + x + random(x - 120), 20 + random((2 * y) - 40))
      this.mCreateDNA(stLoc, 0)
    #whiteOut:
      mClearAllDNA()
      if objectp(mGene) then
        mGene.mDestroy()
      end if
      initMode(#signoff)
      pBlnd = 50
      gFadeSpt.member = glGlob.rct
      gFadeSpt.rect = glGlob.stgRect
      gFadeSpt.forecolor = 0
      gFadeSpt.blend = pBlnd
      pTmr = gFrmTm + 6
    #fadeDown:
      pBlnd = 100
      pTmr = gFrmTm
      pDur = 8
      pLowSpt.member = glGlob.vertGlow
      pLowSpt.loc = glGlob.stgCntr + point(glGlob.stgCntr[1], 0)
      pLowSpt.width = glGlob.vertGlow.width
      pLowSpt.height = glGlob.vertGlow.height
      pLowSpt.ink = 0
      pMedSpt.member = glGlob.vertGlow
      pMedSpt.loc = glGlob.stgCntr
      pMedSpt.width = glGlob.vertGlow.width
      pMedSpt.height = glGlob.vertGlow.height
      pMedSpt.ink = 0
      pTopSpt.member = glGlob.horizGlow
      pTopSpt.loc = glGlob.stgCntr
      pTopSpt.width = 10000
      pTopSpt.height = glGlob.horizGlow.height
      pTopSpt.ink = 0
    #crtVert:
      gFadeSpt.blend = 100
      gFadeSpt.rect = rect(-1000, -999, -1000, -999)
      pX2 = glGlob.horizGlow.height
      pX1 = glGlob.vertGlow.height - pX2
      pTmr = gFrmTm
      pDur = 20
    #crtHoriz:
      pLowSpt.member = glGlob.signBody
      pLowSpt.loc = glGlob.stgCntr
      pLowSpt.width = 1
      pLowSpt.height = 1
      pLowSpt.ink = 8
      pMedSpt.member = glGlob.dotC
      pMedSpt.loc = glGlob.hideLoc
      pTopSpt.width = 3000
      pX1 = pTopSpt.width
      pTmr = gFrmTm
      pDur = 7
    #dotPause:
      pTmr = gFrmTm + 40
    #dotToOval:
      pX1 = pLowSpt.width
      pY1 = pLowSpt.height
      pX2 = glGlob.signBody.width - pX1
      pY2 = glGlob.signBody.height - pY1
      pTmr = gFrmTm
      pDur = 60
    #fadeInLegs:
      pMedSpt.member = glGlob.signLogo
      pMedSpt.loc = glGlob.stgCntr
      pMedSpt.width = glGlob.signLogo.width
      pMedSpt.height = glGlob.signLogo.height
      pMedSpt.ink = 36
      pMedSpt.blend = 0
      pTmr = gFrmTm
      pDur = 60
    #blueShmr:
      pMedSpt.blend = 100
      pMedSpt.stretch = 0
      pAnimIdx = 1
      pTmr = 0
    #fadeOutSpdr:
      pLowSpt.member = glGlob.signBody
      pLowSpt.loc = glGlob.stgCntr
      pLowSpt.width = 16
      pLowSpt.height = 20
      pLowSpt.ink = 8
      pLowSpt.blend = 60
      pTmr = gFrmTm
      pDur = 90
    #fadeOutDot:
      pBlnd = pLowSpt.blend
      pTmr = gFrmTm
      pDur = 60
    #endPause:
      pTmr = gFrmTm + 90
    #fadeInCmg:
      pMedSpt.member = glGlob.comingSoon
      pMedSpt.loc = glGlob.stgCntr
      pMedSpt.width = glGlob.comingSoon.width
      pMedSpt.height = glGlob.comingSoon.height
      pMedSpt.ink = 0
      pMedSpt.blend = 0
      pTmr = gFrmTm
      pDur = 120
      gMainRMF.mSndEvent(#fall2001, VOID)
    #holdCmg:
      pTmr = gFrmTm + 90
    #fadeOutCmg:
      pTmr = gFrmTm
      pDur = 120
  end case
end
