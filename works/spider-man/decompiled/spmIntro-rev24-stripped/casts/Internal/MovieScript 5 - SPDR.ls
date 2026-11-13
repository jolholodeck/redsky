global glGlob, gSptMgr, gSndMgr, gLoadRMF, gMainRMF, gPI, g2PI, gFrmTm, gFrmDurMs, gCrntMode, gMousePt, gLstMsPt, gFadeSpt, glNodes, glQuads, nCnt, gbStk, gNdStk, gNdVct, gCursPt, sCnt, glStNds, gbBeenStk, gbWebRO, gSpdrMode, glAnims, gSpdrVerts, gSpdrSpt, gSpdrLoc, gSpdrWebXY, gSpdrIdx, gSpdrTmr, gSpdrTmr2, gSpdrMd2, gSpdrAng, gSpdrNode, gSpdrVect, gSpdrForc, gWebEnergy, gSpdrLeapDst, gSpdrPnceRng, glSpdrLeapPcnt, gSpdrLeapPt, gSpdrDly, gSpdrStrumForc, gSpdrProxVol, gSpdrProxFade, gSpdrReachCnt

on initSpdr stLoc
  gSpdrSpt.member = glGlob.dotC
  gSpdrSpt.loc = glGlob.hideLoc
  gSpdrSpt.ink = 36
  gSpdrSpt.quad = glGlob.hideQuad
  gSpdrMode = #hide
  gSpdrLoc = glGlob.hideLoc
  gSpdrWebXY = stLoc
  gSpdrNode = 0
  gSpdrAng = 0.0
  gSpdrForc = point(0.0, 0.0)
  gSpdrReachCnt = 0
  gSpdrLeapDst = 0.0
  glSpdrLeapPcnt = []
  repeat with frm in glAnims.spdrLeap
    gSpdrLeapDst = gSpdrLeapDst + vLen(frm[2])
    glSpdrLeapPcnt.append(gSpdrLeapDst)
  end repeat
  gSpdrPnceRng = gSpdrLeapDst + 10.0
  updSpdrLoc()
  gSpdrDly = 3
  gSpdrStrumForc = 0.0
  gSpdrProxVol = 0
  gSpdrProxFade = 0
  spdrInitMode(#hide)
end

on destroySpdr
  gSpdrMode = #hide
  if objectp(gSpdrSpt) then
    gSpdrSpt.ink = 0
    gSpdrSpt.loc = glGlob.hideLoc
    gSpdrSpt.member = glGlob.dotC
    gSpdrSpt.quad = glGlob.hideQuad
  end if
end

on updSpdr
  case gSpdrMode of
    #lEnter:
      if animReady(glAnims.spdrEnter) then
        spdrInitMode(#enter)
      end if
    #enter:
      if gFrmTm >= gSpdrTmr then
        gSpdrTmr = gFrmTm + 5
        dPt = getCursWebXY() - gSpdrWebXY
        spdrPlayProx(dPt)
        gSpdrIdx = advSpdrAnim(glAnims.spdrEnter, gSpdrIdx)
        if gSpdrIdx = 1 then
          spdrInitMode(#wait)
        end if
      end if
    #wait:
      if gbWebRO then
        if not gbBeenStk then
          spdrInitMode(#retreat)
        end if
      else
        if gFrmTm >= gSpdrTmr then
          spdrInitMode(#strumOut)
        end if
      end if
    #strumOut:
      if gFrmTm >= gSpdrTmr then
        gSpdrTmr = gFrmTm + 8
        gSpdrIdx = advSpdrAnim(glAnims.spdrEmrg, gSpdrIdx)
        if gSpdrIdx > 5 then
          gSpdrIdx = 5
          gSpdrNode = glStNds[1]
          gSpdrForc = gSpdrStrumForc * point(-(4 + random(3)), -(4 + random(3)))
          spdrInitMode(#strumIn)
        end if
      end if
    #strumIn:
      gSpdrNode = 0
      if gFrmTm >= gSpdrTmr then
        gSpdrTmr = gFrmTm + 3
        advSpdrAnim(glAnims.spdrEmrg, gSpdrIdx)
        gSpdrIdx = gSpdrIdx - 1
        if gSpdrIdx < 1 then
          spdrInitMode(#waitPostStrum)
        end if
      end if
    #waitPostStrum:
      if gbWebRO then
        if not gbBeenStk then
          spdrInitMode(#retreat)
        end if
      else
        if gFrmTm >= gSpdrTmr then
          spdrInitMode(#retreat)
        end if
      end if
    #retreat:
      if gFrmTm >= gSpdrTmr then
        gSpdrTmr = gFrmTm + 5
        advSpdrAnim(glAnims.spdrEnter, gSpdrIdx)
        gSpdrIdx = gSpdrIdx - 1
        if gSpdrIdx < 1 then
          gSpdrSpt.member = glGlob.dotC
          gSpdrSpt.quad = glGlob.hideQuad
          spdrInitMode(#strumDone)
        end if
      end if
    #lEmerge:
      if animReady(glAnims.spdrEmrg) then
        spdrInitMode(#emerge)
      end if
    #emerge:
      if gFrmTm >= gSpdrTmr then
        gSpdrTmr = gFrmTm + 5
        dPt = getCursWebXY() - gSpdrWebXY
        spdrPlayProx(dPt)
        gSpdrIdx = advSpdrAnim(glAnims.spdrEmrg, gSpdrIdx)
        if gSpdrIdx = 1 then
          spdrInitMode(#Lwalk)
        end if
      end if
    #Lwalk:
      dPt = getCursWebXY() - gSpdrWebXY
      if vLen(dPt) < gSpdrPnceRng then
        spdrInitMode(#pounce)
      else
        spdrInitMode(#walk)
      end if
    #walk:
      if gFrmTm >= gSpdrTmr then
        gSpdrTmr = gFrmTm + gSpdrDly
        if gSpdrDly > 2 then
          if gWebEnergy < 5.0 then
            gSpdrDly = gSpdrDly - 1
          end if
        end if
        dPt = getCursWebXY() - gSpdrWebXY
        spdrPlayProx(dPt)
        case gSpdrMd2 of
          #up:
            anim = glAnims.spdrRmpU
            frm = anim[gSpdrIdx]
            mbr = frm[1]
            dxy = frm[2]
            gSpdrIdx = gSpdrIdx + 1
            if gSpdrIdx > anim.count then
              gSpdrIdx = 1
              gSpdrMd2 = #CycSt
            end if
          #CycSt:
            anim = glAnims.spdrCycSt
            frm = anim[gSpdrIdx]
            mbr = frm[1]
            dxy = frm[2]
            gSpdrIdx = gSpdrIdx + 1
            if gSpdrIdx > anim.count then
              gSpdrIdx = 1
              if (vLen(dPt) < gSpdrPnceRng) or (gWebEnergy > 8.0) then
                gSpdrMd2 = #dn
              else
                gSpdrMd2 = #cycEn
              end if
            end if
          #cycEn:
            anim = glAnims.spdrCycEn
            frm = anim[gSpdrIdx]
            mbr = frm[1]
            dxy = frm[2]
            gSpdrIdx = gSpdrIdx + 1
            if gSpdrIdx > anim.count then
              gSpdrIdx = 1
              gSpdrMd2 = #CycSt
            end if
          #dn:
            anim = glAnims.spdrRmpD
            frm = anim[gSpdrIdx]
            mbr = frm[1]
            dxy = frm[2]
            gSpdrIdx = gSpdrIdx + 1
            if gSpdrIdx > anim.count then
              gSpdrIdx = 1
              gSpdrMd2 = #wait
              gSpdrTmr2 = gFrmTm
            end if
          #wait:
            mbr = glAnims.spdrRmpD[glAnims.spdrRmpD.count][1]
            dxy = point(0, 0)
            if vLen(dPt) < gSpdrPnceRng then
              spdrInitMode(#pounce)
            else
              dt = (gFrmTm - gSpdrTmr2) / 40.0
              if gWebEnergy < dt then
                if gWebEnergy > 5.0 then
                  gSpdrDly = 6
                end if
                gSpdrMd2 = #up
              end if
            end if
        end case
        ang = getAng(dPt) - (g2PI * 0.125)
        if ang > gSpdrAng then
          lAng = gSpdrAng + (g2PI - ang)
          rAng = ang - gSpdrAng
        else
          lAng = gSpdrAng - ang
          rAng = ang + (g2PI - gSpdrAng)
        end if
        Turn = 0.03 * (dxy[1] + dxy[2])
        if rAng < lAng then
          if Turn > rAng then
            gSpdrAng = ang
          else
            gSpdrAng = gSpdrAng + Turn
          end if
        else
          if Turn > lAng then
            gSpdrAng = ang
          else
            gSpdrAng = gSpdrAng - Turn
          end if
        end if
        if gSpdrAng < 0.0 then
          gSpdrAng = g2PI + gSpdrAng
        end if
        if gSpdrAng > g2PI then
          gSpdrAng = gSpdrAng - g2PI
        end if
        c = cos(gSpdrAng)
        s = sin(gSpdrAng)
        walkStep = point((dxy[1] * c) - (dxy[2] * s), (dxy[1] * s) + (dxy[2] * c))
        gSpdrWebXY = gSpdrWebXY + walkStep
        updSpdrLoc()
        gSpdrSpt.member = mbr
        gMainRMF.mSndEvent(#spdrMotion, 10 * (abs(walkStep[1]) + abs(walkStep[2])))
        gSpdrForc = -1.0 * walkStep
      end if
    #pounce:
      if gFrmTm >= gSpdrTmr then
        gSpdrTmr = gFrmTm + gSpdrDly
        dPt = gCursPt - gSpdrLoc
        spdrPlayProx(dPt)
        case gSpdrMd2 of
          #lPounce:
            gSpdrDly = 4
            if animReady(glAnims.spdrRearUp) and animReady(glAnims.spdrReach) and animReady(glAnims.spdrWave) then
              if animReady(glAnims.spdrLeap) and animReady(glAnims.spdrClench) and animReady(glAnims.spdrSqueeze) then
                spdrInitMode2(#rearUp)
              end if
            end if
          #rearUp:
            gSpdrIdx = advSpdrAnim(glAnims.spdrRearUp, gSpdrIdx)
            if gSpdrIdx = 1 then
              if gWebEnergy > 5.0 then
                spdrInitMode2(#rearDn)
              else
                spdrInitMode2(#wave)
              end if
            end if
          #rearDn:
            advSpdrAnim(glAnims.spdrRearUp, gSpdrIdx)
            gSpdrIdx = gSpdrIdx - 1
            if gSpdrIdx = 0 then
              spdrInitMode2(#waitToPounce)
            end if
          #waitToPounce:
            gSpdrSpt.member = glAnims.spdrRmpD[glAnims.spdrRmpD.count][1]
            if (gWebEnergy < 3.0) and (gFrmTm > gSpdrTmr2) then
              if gSpdrReachCnt > 0 then
                spdrInitMode2(#rearUp)
              else
                spdrInitMode2(#reach)
              end if
            end if
          #reach:
            gSpdrIdx = advSpdrAnim(glAnims.spdrReach, gSpdrIdx)
            if gSpdrIdx = 1 then
              spdrInitMode2(#waitToPounce)
            end if
          #wave:
            gSpdrIdx = advSpdrAnim(glAnims.spdrWave, gSpdrIdx)
            if gSpdrIdx = 1 then
              if gWebEnergy > 5.0 then
                spdrInitMode2(#rearDn)
              else
                if random(2) = 1 then
                  spdrInitMode2(#leap)
                else
                  spdrInitMode2(#wave)
                end if
              end if
            end if
          #leap:
            pcnt = glSpdrLeapPcnt[gSpdrIdx] / gSpdrLeapDst
            gSpdrLoc = gSpdrLeapPt + (pcnt * (gCursPt - gSpdrLeapPt))
            gSpdrSpt.member = glAnims.spdrLeap[gSpdrIdx][1]
            gSpdrIdx = gSpdrIdx + 1
            if gSpdrIdx = 4 then
              cursHide()
            end if
            if gSpdrIdx > glAnims.spdrLeap.count then
              gSpdrWebXY = getCursWebXY()
              updSpdrLoc()
              gSpdrForc = (gSpdrLoc - gSpdrLeapPt) / 4.0
              spdrInitMode2(#clench)
            end if
          #clench:
            gSpdrIdx = advSpdrAnim(glAnims.spdrClench, gSpdrIdx)
            if gSpdrIdx = 1 then
              spdrInitMode2(#pauseAfterClench)
            end if
          #pauseAfterClench:
            gSpdrProxFade = 1
            if gFrmTm >= gSpdrTmr2 then
              spdrInitMode2(#squeeze)
            end if
          #squeeze:
            gSpdrIdx = advSpdrAnim(glAnims.spdrSqueeze, gSpdrIdx)
            if gSpdrIdx = 9 then
              gMainRMF.mSndEvent(#spdrBite, VOID)
            end if
            if gSpdrIdx = 1 then
              spdrInitMode2(#snackTime)
              initMode(#settle)
            end if
        end case
      end if
  end case
  if gSpdrSpt.member <> glGlob.dotC then
    updSpdrQuad(gSpdrSpt.member)
  end if
end

on spdrPlayProx dPt
  if gSpdrProxFade then
    gSpdrProxVol = gSpdrProxVol - (gFrmDurMs / 5.0)
    if gSpdrProxVol < 1 then
      gSpdrProxVol = 1
    end if
  else
    dst = abs(dPt[1]) + abs(dPt[2])
    gSpdrProxVol = 127 - integer(dst / 4)
    if gSpdrProxVol < 20 then
      gSpdrProxVol = 20
    end if
    if gSpdrProxVol > 127 then
      gSpdrProxVol = 0
    end if
  end if
  gMainRMF.mSndEvent(#spdrProx, gSpdrProxVol)
end

on updSpdrQuad mbr
  mbrNum = mbr.number
  mbrVrt = gSpdrVerts.getProp(mbrNum)
  mbrQ = mbrVrt[2].duplicate()
  c = cos(gSpdrAng)
  s = sin(gSpdrAng)
  repeat with cpt in mbrQ
    x = (cpt[1] * c) - (cpt[2] * s)
    y = (cpt[1] * s) + (cpt[2] * c)
    if mbrVrt[1] then
      x = gSpdrWebXY[1] + x
      y = gSpdrWebXY[2] + y
      nIdx = 0
      webQ = 0
      repeat with q in glQuads
        n1 = glNodes[q.node[1]]
        n3 = glNodes[q.node[3]]
        if (n1.o[1] <= x) and (n1.o[2] <= y) and (n3.o[1] >= x) and (n3.o[2] >= y) then
          webQ = q
          exit repeat
        end if
      end repeat
      if webQ > 0 then
        n2 = glNodes[q.node[2]]
        n4 = glNodes[q.node[4]]
        ax = (x - n1.o[1]) / float(webQ.len[1])
        ay = (y - n1.o[2]) / float(webQ.len[2])
        bx = 1.0 - ax
        by = 1.0 - ay
        x = (bx * ((n1.pt[1] * by) + (n4.pt[1] * ay))) + (ax * ((n2.pt[1] * by) + (n3.pt[1] * ay)))
        y = (bx * ((n1.pt[2] * by) + (n4.pt[2] * ay))) + (ax * ((n2.pt[2] * by) + (n3.pt[2] * ay)))
      end if
    else
      x = gSpdrLoc[1] + x
      y = gSpdrLoc[2] + y
    end if
    cpt[1] = x
    cpt[2] = y
  end repeat
  gSpdrSpt.quad = mbrQ
end

on updSpdrLoc
  nd = 1
  nVct = gSpdrVect
  dst = 100000.0
  repeat with i = 1 to sCnt
    thisNd = glStNds[i]
    vct = gSpdrWebXY - glNodes[thisNd].o
    nDst = abs(vct[1]) + abs(vct[2])
    if nDst < dst then
      dst = nDst
      nd = thisNd
      nVct = vct
    end if
  end repeat
  gSpdrNode = nd
  gSpdrVect = gSpdrWebXY - glNodes[gSpdrNode].o
  gSpdrLoc = glNodes[gSpdrNode].pt + gSpdrVect
end

on advSpdrAnim anim, idx
  frm = anim[idx]
  dxy = frm[2]
  c = cos(gSpdrAng)
  s = sin(gSpdrAng)
  walkStep = point((dxy[1] * c) - (dxy[2] * s), (dxy[1] * s) + (dxy[2] * c))
  gSpdrWebXY = gSpdrWebXY + walkStep
  updSpdrLoc()
  gSpdrSpt.member = frm[1]
  idx = idx + 1
  if idx > anim.count then
    idx = 1
  end if
  return idx
end

on spdrInitMode m
  gSpdrMode = m
  case gSpdrMode of
    #enter:
      gSpdrIdx = 1
      gSpdrTmr = gFrmTm
      gMainRMF.mSndEvent(#spdrAppear, VOID)
      gSpdrProxFade = 0
    #wait:
      gSpdrTmr = gFrmTm + 20 + random(40)
    #strumOut:
      gSpdrIdx = 1
      gSpdrTmr = gFrmTm
      gSpdrStrumForc = gSpdrStrumForc + 1.0
      if gSpdrStrumForc > 4.0 then
        gSpdrStrumForc = 4.0
      end if
    #waitPostStrum:
      gSpdrTmr = gFrmTm + 20 + random(40)
    #retreat:
      gSpdrIdx = glAnims.spdrEnter.count
      gSpdrTmr = gFrmTm
      gSpdrProxFade = 1
    #emerge:
      gSpdrIdx = 1
      gSpdrTmr = gFrmTm
      gSpdrSpt.rotation = 0
      gMainRMF.mSndEvent(#spdrEnter, VOID)
    #walk:
      cursFadeForc()
      updSpdrLoc()
      gSpdrMd2 = #up
      gSpdrIdx = 1
      gSpdrAng = 0.0
      gSpdrDly = 2
    #pounce:
      spdrInitMode2(#lPounce)
  end case
end

on spdrInitMode2 m
  gSpdrMd2 = m
  case m of
    #rearUp:
      gMainRMF.mSndEvent(#spdrRearUp, VOID)
      gSpdrIdx = 1
      gSpdrTmr = gFrmTm
      gSpdrDly = 5
    #rearDn:
      gSpdrIdx = glAnims.spdrRearUp.count
      gSpdrTmr = gFrmTm
      gSpdrDly = 4
    #waitToPounce:
      gSpdrTmr2 = gFrmTm + 60 + random(120)
    #reach:
      gSpdrIdx = 1
      gSpdrTmr = gFrmTm
      gSpdrDly = 6
      gSpdrReachCnt = gSpdrReachCnt + 1
    #wave:
      gSpdrIdx = 1
      gSpdrTmr = gFrmTm
      gSpdrDly = 6
    #leap:
      gMainRMF.mSndEvent(#spdrLeap, VOID)
      gSpdrIdx = 1
      gSpdrTmr = gFrmTm
      gSpdrLeapPt = gSpdrLoc
      gSpdrDly = 0
    #clench:
      gMainRMF.mSndEvent(#spdrStrike, VOID)
      gSpdrIdx = 1
      gSpdrTmr = gFrmTm
      gSpdrDly = 4
    #pauseAfterClench:
      gSpdrTmr2 = gFrmTm + random(30)
    #squeeze:
      gSpdrIdx = 1
      gSpdrTmr = gFrmTm
      gSpdrDly = 4
  end case
end
