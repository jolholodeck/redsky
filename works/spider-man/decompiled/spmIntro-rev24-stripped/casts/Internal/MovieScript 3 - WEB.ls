global glGlob, gSptMgr, gSndMgr, gLoadRMF, gMainRMF, gFrmTm, gFrmDurMs, gCrntMode, gMousePt, gLstMsPt, gFadeSpt, gWebMode, glNodes, glQuads, glStNds, gSideMap, kSpr, gWebBlnd, gAncRspt, gAncBspt, gWebSpts, nCnt, qCnt, sCnt, gWebCntr, gSwtNode, gSwtVect, gWebTmr, gWebTmr2, gWebTmr3, gWebTmr4, gWebCnt, gWebPluckDist, gbStk, gNdStk, gNdVct, gStkVct, gBrkForc, gSpdrNode, gSpdrForc, gWebEnergy, gWindFrc, gStLoc, gEnVct, gNrVct, gWebBgVol, gWebBgVolTarg, gWebProxVol, gWebProxMode, gSndAncCnt, gSndAncTmr, gStruggleTmr, gCursPt, gbWebRO, gbBeenStk, pWindMode, pWindVol, pNxtSpdrTm, pNxtWindTm, gSpdrMode

on initWeb swtSpot
  webInitMode(#load)
  cnt = glNodes.count
  repeat with i = 1 to cnt
    nd = glNodes[i]
    nd.pt = point(float(nd.pt[1]), float(nd.pt[2]))
    nd.addProp(#o, nd.pt)
    nd.addProp(#v, point(0.0, 0.0))
    nd.addProp(#f, point(0.0, 0.0))
    sort(nd)
  end repeat
  gAncRspt = sprite(gWebSpts[1])
  gAncBspt = sprite(gWebSpts[2])
  gAncRspt.member = glGlob.rAnc
  gAncBspt.member = glGlob.bAnc
  gAncRspt.loc = glGlob.stgCntr
  gAncBspt.loc = glGlob.stgCntr
  cnt = glQuads.count
  repeat with i = 1 to cnt
    spt = gWebSpts[2 + i]
    qd = glQuads[i]
    nd = qd.node
    qd.spt = sprite(spt)
    qd.spt.member = qd.mbr
    qd.spt.quad = [glNodes[nd[1]].pt + point(-1.0, -1.0), glNodes[nd[2]].pt + point(1.0, -1.0), glNodes[nd[3]].pt + point(1.0, 1.0), glNodes[nd[4]].pt + point(-1.0, 1.0)]
  end repeat
  gFadeSpt.member = glGlob.rct
  gFadeSpt.rect = glGlob.stgRect
  gFadeSpt.blend = 100
  gSideMap = [[1, 2], [2, 3], [3, 4], [4, 1]]
  kSpr = 0.10000000000000001
  gWebBlnd = 0
  nCnt = glNodes.count
  qCnt = glQuads.count
  sCnt = glStNds.count
  gWebCntr = point(150, 149)
  gSwtNode = glStNds[glStNds.count]
  gSwtVect = swtSpot - glNodes[gSwtNode].pt
  gWebEnergy = 0.0
  gWindFrc = 15.0
  gWebBgVol = 0.0
  gWebBgVolTarg = 0.0
  gWebProxVol = 0.0
  gWebProxMode = #silent
  pWindMode = #silent
  pWindVol = 5
  gSndAncCnt = 0
  gSndAncTmr = 0
  gStruggleTmr = 0
  pNxtWindTm = 0
  pNxtSpdrTm = 0
  gbBeenStk = 0
  gbWebRO = 0
end

on destroyWeb
  webInitMode(#hide)
  cnt = gWebSpts.count
  repeat with i = 1 to cnt
    sptObj = sprite(gWebSpts[i])
    sptObj.ink = 0
    sptObj.loc = glGlob.hideLoc
    sptObj.member = glGlob.dotC
    if i > 2 then
      sptObj.quad = glGlob.hideQuad
    end if
  end repeat
end

on updWeb
  case gWebMode of
    #enter:
      gWebBlnd = 100 * (gFrmTm - gWebTmr) / gWebTmr2
      if gWebBlnd < 100 then
        gFadeSpt.blend = 100 - gWebBlnd
      else
        gFadeSpt.blend = 100
        gFadeSpt.rect = rect(-1000, -999, -1000, -999)
        webInitMode(#windWait)
      end if
    #windWait:
      zeroForce()
      updPhys()
      if webRollover() then
        webInitMode(#harp)
      else
        if gFrmTm > pNxtWindTm then
          webInitMode(#wind)
        end if
      end if
    #wind:
      if gFrmTm > gWebTmr2 then
        f = 1.0 - (float(gFrmTm - gWebTmr2) / float(gWebTmr3 - gWebTmr2))
        pWindMode = #fadeOut
      else
        f = float(gFrmTm - gWebTmr) / float(gWebTmr2 - gWebTmr)
        pWindVol = 1 + (4 * gWindFrc * (sin(f) + (f / 3.0 * sin(8.0 * f))))
      end if
      repeat with i = 1 to nCnt
        nd = glNodes[i]
        if nd.m then
          str = 0.5 + (float(random(50)) / 100.0)
          nd.f[1] = f * str * gNrVct[1]
          nd.f[2] = f * str * gNrVct[2]
        end if
      end repeat
      updPhys()
      if webRollover() then
        webInitMode(#harp)
      else
        if gFrmTm > gWebTmr3 then
          webInitMode(#windWait)
        end if
      end if
    #spdrWait:
      zeroForce()
      updPhys()
      if webRollover() then
        webInitMode(#harp)
      else
        if gSpdrMode = #strumDone then
          webInitMode(#windWait)
        end if
      end if
    #harp:
      zeroForce()
      if gbStk then
        vct = gMousePt - gStkVct
        dst = vLen(vct) * 2
        if dst > gWebPluckDist then
          vct = vct * (gWebPluckDist / dst)
        end if
        glNodes[gNdStk].f = vct
        if dst > gWebPluckDist then
          unStkCurs()
          gWebTmr2 = gFrmTm + 10 + random(10)
        end if
      else
        if gFrmTm > gWebTmr2 then
          if webRollover() and (vLen(gMousePt - gLstMsPt) > 1.0) then
            gWebCnt = gWebCnt + 1
            gWebPluckDist = 1.0 + gWebCnt
            if gWebPluckDist > 30.0 then
              gWebPluckDist = 30.0
            end if
            if gWebTmr < 0 then
              gWebTmr = gFrmTm + (60 * 15)
            end if
            stickToNode()
            gStkVct = gMousePt
          end if
        end if
      end if
      updPhys()
      if ((gWebTmr > 0) and (gFrmTm > gWebTmr)) or (gWebCnt > 40) then
        webInitMode(#stick)
      end if
    #stick:
      zeroForce()
      if gbStk then
        if vLen(glNodes[gNdStk].pt - glNodes[gNdStk].o) > gBrkForc then
          unStkCurs()
          gWebProxMode = #fadeUp
          gBrkForc = gBrkForc * 1.5
          gWebTmr2 = gFrmTm + 30 + random(60)
        else
          glNodes[gNdStk].f = getCursVect(gNdStk)
        end if
      else
        if gFrmTm > gWebTmr2 then
          if webRollover() and (vLen(gMousePt - gLstMsPt) > 1.0) then
            stickToNode()
            gWebProxMode = #fadeOut
          end if
        end if
      end if
      updPhys()
      if gbStk and webRollover() then
        if (gFrmTm > gWebTmr) or (gWebCnt > 2) then
          webInitMode(#stuck)
        end if
      end if
    #stuck:
      zeroForce()
      glNodes[gNdStk].f = getCursVect(gNdStk)
      cursPt = glNodes[gNdStk].pt + gNdVct
      dSwt = glNodes[gSwtNode].pt + gSwtVect - cursPt
      if (gFrmTm > gWebTmr) or (vLen(dSwt) < 7.0) then
        webInitMode(#lunch)
      else
        dMxy = gMousePt - gLstMsPt
        if ((dMxy[1] * dSwt[1]) > 0) and ((dMxy[2] * dSwt[2]) > 0) then
          dMxy = dMxy / 5.0
          if (abs(dMxy[1]) > abs(dSwt[1])) and (abs(dMxy[2]) > abs(dSwt[2])) then
            dMxy[1] = dSwt[1]
            dMxy[2] = dSwt[2]
          end if
          cursPt = cursPt + dMxy
          ndIdx = 1 + (cursPt[1] > gWebCntr[1]) + (2 * (cursPt[2] > gWebCntr[2]))
          stickCurs(glStNds[ndIdx], cursPt)
        end if
      end if
      updPhys()
    #lunch:
      zeroForce()
      if gbStk then
        glNodes[gNdStk].f = glNodes[gNdStk].f + getCursVect(gNdStk)
      end if
      updPhys()
    #settle:
      zeroForce()
      updPhys()
      if gFrmTm > gWebTmr then
        initMode(#dna)
      end if
      if (gWebEnergy < 0.001) and (gWebBgVol < 1) then
        initMode(#dna)
      end if
  end case
  if gbWebRO > 0 then
    if gWebBgVol <> gWebBgVolTarg then
      if gWebBgVol > gWebBgVolTarg then
        gWebBgVol = gWebBgVol - (gFrmDurMs / 10.0)
        if gWebBgVol < gWebBgVolTarg then
          gWebBgVol = gWebBgVolTarg
        end if
      else
        gWebBgVol = gWebBgVol + (gFrmDurMs / 10.0)
        if gWebBgVol > gWebBgVolTarg then
          gWebBgVol = gWebBgVolTarg
        end if
      end if
      gMainRMF.mSndEvent(#webBgVol, gWebBgVol)
    end if
    if gSndAncCnt < 3 then
      if gFrmTm > gSndAncTmr then
        gMainRMF.mSndEvent(#webBgAnchor, VOID)
        gSndAncCnt = gSndAncCnt + 1
        gSndAncTmr = gFrmTm + 60
      end if
    end if
    if gNdStk then
      if gFrmTm > gStruggleTmr then
        fpt = glNodes[gNdStk].f
        f = integer(2 * (abs(fpt[1]) + abs(fpt[2])))
        if vLen(gMousePt - gLstMsPt) > 0.5 then
          gMainRMF.mSndEvent(#webStruggle, f)
        end if
        gStruggleTmr = gStruggleTmr + 12
      end if
    end if
  end if
  vct = gCursPt - gWebCntr
  dst = abs(vct[1]) + abs(vct[2])
  vol = 100 - (100 * dst / 700)
  if vol < 20.0 then
    vol = 20.0
  end if
  case gWebProxMode of
    #fadeUp:
      gWebProxVol = gWebProxVol + (gFrmDurMs / 10.0)
      if gWebProxVol > vol then
        gWebProxVol = vol
        gWebProxMode = #follow
      end if
      gMainRMF.mSndEvent(#webProxVol, gWebProxVol)
    #fadeOut:
      gWebProxVol = gWebProxVol - (gFrmDurMs / 20.0)
      if gWebProxVol < 5.0 then
        gWebProxVol = 5.0
        gWebProxMode = #silent
      end if
      gMainRMF.mSndEvent(#webProxVol, gWebProxVol)
    #follow:
      gWebProxVol = vol
      gMainRMF.mSndEvent(#webProxVol, gWebProxVol)
  end case
  case pWindMode of
    #fadeOut:
      pWindVol = pWindVol - (gFrmDurMs / 30.0)
      if pWindVol < 5.0 then
        pWindVol = 5.0
        pWindMode = #silent
        gMainRMF.mSndEvent(#windStop, VOID)
      end if
      gMainRMF.mSndEvent(#windVol, pWindVol)
    #follow:
      gMainRMF.mSndEvent(#windVol, pWindVol)
  end case
end

on webRollover
  return vLen(gWebCntr - gMousePt) < 100.0
end

on stickToNode
  if not gbStk then
    gMainRMF.mSndEvent(#webStick, 30 * vLen(gMousePt - gLstMsPt) / gFrmDurMs)
  end if
  gbBeenStk = 1
  repeat with i = 1 to sCnt
    if vLen(glNodes[glStNds[i]].pt - gMousePt) < 45.0 then
      stickCurs(glStNds[i], gMousePt)
      gWebCnt = gWebCnt + 1
    end if
  end repeat
end

on zeroForce
  repeat with i = 1 to nCnt
    nd = glNodes[i]
    if nd.m then
      if gSpdrNode = i then
        nd.f[1] = gSpdrForc[1]
        nd.f[2] = gSpdrForc[2]
        gSpdrForc[1] = 0.0
        gSpdrForc[2] = 0.0
        next repeat
      end if
      nd.f[1] = 0.0
      nd.f[2] = 0.0
    end if
  end repeat
end

on updPhys
  global gPhysTm
  stTm = the milliSeconds
  repeat with i = 1 to qCnt
    qd = glQuads[i]
    nd = qd.node
    repeat with l = 1 to 4
      sm = gSideMap[l]
      n1 = glNodes[nd[sm[1]]]
      n2 = glNodes[nd[sm[2]]]
      rLn = qd.len[l]
      vct = n2.pt - n1.pt
      vLn = vLen(vct)
      dx = vLn - rLn
      f = kSpr * dx / vLn * vct
      n1.f = n1.f + f
      n2.f = n2.f - f
    end repeat
  end repeat
  gWebEnergy = 0.0
  repeat with i = 1 to nCnt
    nd = glNodes[i]
    if nd.m then
      gWebEnergy = gWebEnergy + abs(nd.f[1]) + abs(nd.f[2])
      vct = nd.o - nd.pt
      fo = vct * 1.5
      nd.v = nd.v * 0.84999999999999998
      nd.v = nd.v + nd.f + fo
      nd.pt = nd.pt + nd.v
    end if
  end repeat
  gPhysTm = gPhysTm + (the milliSeconds - stTm)
  repeat with i = 1 to qCnt
    qd = glQuads[i]
    nd = qd.node
    qd.spt.quad = [glNodes[nd[1]].pt + point(-1.0, -1.0), glNodes[nd[2]].pt + point(1.0, -1.0), glNodes[nd[3]].pt + point(1.0, 1.0), glNodes[nd[4]].pt + point(-1.0, 1.0)]
  end repeat
end

on webInitMode m
  case gWebMode of
    #harp:
      if gNdStk > 0 then
        glNodes[gNdStk].m = 1
      end if
  end case
  gWebMode = m
  case gWebMode of
    #enter:
      gMainRMF.mSndEvent(#startWebBg, VOID)
      gWebBgVol = 127
      gWebBgVolTarg = 127
      gWebProxMode = #fadeUp
      gWebTmr = gFrmTm
      gWebTmr2 = 120
      pNxtWindTm = gFrmTm + (8 * 60) + random(120)
      pNxtSpdrTm = gFrmTm + 3600
    #windWait:
      pWindMode = #fadeOut
    #wind:
      pNxtWindTm = gFrmTm + (15 * 60) + random(300)
      if gFrmTm > pNxtSpdrTm then
        webInitMode(#spdrWait)
      else
        pWindMode = #follow
        pWindVol = 5.0
        gMainRMF.mSndEvent(#windStart, VOID)
        gMainRMF.mSndEvent(#windVol, pWindVol)
        gWebTmr = gFrmTm
        gWebTmr2 = gFrmTm + 90
        gWebTmr3 = gFrmTm + 120
        gWebTmr4 = gFrmTm
        gWindFrc = 18.0 + (float(random(60)) / 10.0)
        gNrVct = gWindFrc * point(float(50 + random(50)) / 100.0, float(-random(50)) / 100.0)
      end if
    #spdrWait:
      spdrInitMode(#lEnter)
      pNxtSpdrTm = gFrmTm + (60 * (50 + random(20)))
    #harp:
      pWindMode = #fadeOut
      gWebTmr = -1
      gWebTmr2 = 0
      gWebCnt = 0
      gNdStk = 0
      gStkVct = gMousePt
      gbWebRO = 1
    #stick:
      gWebTmr = gFrmTm + (60 * 8)
      gWebTmr2 = 0
      gWebCnt = 0
      gBrkForc = 15.0
    #stuck:
      gWebProxMode = #fadeOut
      if gNdStk > 0 then
        gWebTmr = gFrmTm + (60 * 8)
        initMode(#enter)
      else
        webInitMode(#stick)
      end if
    #lunch:
      gMainRMF.mSndEvent(#webKillProx, VOID)
      initMode(#attack)
    #settle:
      gWebBgVolTarg = 0
      gWebTmr = gFrmTm + (60 * 4)
    #idle:
      repeat with i = 1 to qCnt
        qd = glQuads[i]
        nd = qd.node
        qd.spt.quad = [glNodes[nd[1]].o + point(-1.0, -1.0), glNodes[nd[2]].o + point(1.0, -1.0), glNodes[nd[3]].o + point(1.0, 1.0), glNodes[nd[4]].o + point(-1.0, 1.0)]
      end repeat
  end case
end

on webMUp
  case gWebMode of
    #enter:
    #harp, #stick:
      if webRollover() then
        stickToNode()
        webInitMode(#stuck)
      end if
    #stuck, #lunch:
  end case
end
