global glGlob, gSptMgr, gSndMgr, gLoadRMF, gMainRMF, gFrmTm, gCrntMode, gMousePt, gLstMsPt, gFadeSpt, glNodes, gbStk, gNdStk, gNdVct, gCursMode, gCursSpt, gCursForc, gCursPt, gCursCatchPcnt, gCursCatchVel, gCursForcScl, gCursForcScl0, gCursTmr, gCursDur

on initCurs
  gCursSpt.member = glGlob.iCurs
  gCursSpt.ink = 8
  cursor(200)
  gbStk = 0
  gNdStk = 0
  gNdVct = 0
  gCursPt = the mouseLoc
  gCursLastPt = gCursPt
  gCursForc = 0.0
  gCursCatchPcnt = 0.0
  gCursCatchVel = 0.0
  gCursForcScl0 = 0.10000000000000001
  gCursForcScl = gCursForcScl0
  gCursTmr = 0
  gCursMode = #mouse
end

on destroyCurs
  gCursMode = #hide
  if objectp(gCursSpt) then
    CDH_hideSpt(gCursSpt.spriteNum)
  end if
end

on updCurs
  cursor(200)
  case gCursMode of
    #mouse:
      gCursPt = gMousePt
      gCursSpt.loc = gCursPt
    #stuck:
      gCursPt = glNodes[gNdStk].pt + gNdVct
      gCursSpt.loc = gCursPt
    #catchUp:
      gCursCatchVel = gCursCatchVel + 0.10000000000000001
      gCursCatchPcnt = gCursCatchPcnt + gCursCatchVel
      if gCursCatchPcnt > 0.94999999999999996 then
        gCursCatchPcnt = 1.0
        gCursMode = #mouse
      end if
      gCursPt = gCursPt + (gCursCatchPcnt * (gMousePt - gCursPt))
      gCursSpt.loc = gCursPt
  end case
  if gCursTmr > 0 then
    fac = float(gFrmTm - gCursTmr) / float(gCursDur)
    if fac > 1.0 then
      fac = 1.0
      gCursTmr = 0
    end if
    gCursForcScl = gCursForcScl0 - (gCursForcScl0 * fac)
    if gCursForcScl < 0.01 then
      gCursForcScl = 0.01
    end if
  end if
end

on stickCurs nd, pt
  gCursMode = #stuck
  gbStk = 1
  gNdStk = nd
  gNdVct = pt - glNodes[gNdStk].pt
end

on unStkCurs
  gCursMode = #catchUp
  gCursCatchPcnt = 0.0
  gCursCatchVel = 0.0
  gbStk = 0
  gNdStk = 0
end

on getCursVect nd
  if gCursMode = #hide then
    return point(0.0, 0.0)
  else
    vct = gMousePt - gLstMsPt
    gCursForc = vLen(vct)
    if gCursForc > 150.0 then
      vct = vct * (150.0 / gCursForc)
    end if
    return gCursForcScl * vct
  end if
end

on getCursWebXY
  if gNdStk < 1 then
    return gCursPt
  else
    return glNodes[gNdStk].o + gNdVct
  end if
end

on cursHide
  gCursMode = #hide
  gCursSpt.loc = glGlob.hideLoc
end

on cursFadeForc
  gCursTmr = gFrmTm
  gCursDur = 400
end
