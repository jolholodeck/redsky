property pMode, plSptBank, pbFinish, pPlayLst, pPlayIdx, pLastStt, pLoc, plLoadAnim, pLastTm, pCycTm, pFadeVal, pFadeTmr, pFadeDur, pStatVct, pTargVct, pRndVct, pFavStates, pBoxStat, pSpdrStat, pSwasStat
global glGlob, gSptMgr, gFrmTm

on new this, loc, useSmall
  this.mInitMode(#init)
  pLoc = loc
  if useSmall then
    n1 = glGlob.glySm1.number
    n2 = glGlob.glySmN.number
  else
    n1 = glGlob.gly1.number
    n2 = glGlob.glyN.number
  end if
  plLoadAnim = []
  repeat with i = n1 to n2
    plLoadAnim.append(member(i))
  end repeat
  numSpts = plLoadAnim.count
  plSptBank = gSptMgr.mGetSptBank(#load, numSpts)
  pStatVct = []
  pTargVct = []
  pRndVct = []
  idx = 1
  repeat with i = 1 to numSpts
    spt = sprite(plSptBank[i])
    spt.member = plLoadAnim[i]
    spt.loc = pLoc
    spt.ink = 8
    spt.blend = 0
    idx = idx + 1
    pStatVct.append(0)
    pTargVct.append(0)
    pRndVct.append(0)
  end repeat
  pFavStates = [[5, 14, 16], [1, 2, 3, 8, 14, 15, 16], [1, 2, 7, 9], [5, 6, 13], [2, 5, 6, 7, 9, 13], [5, 6, 12, 13, 14], [5, 6, 10, 11, 12, 15], [4, 5, 6, 12], [1, 2, 4, 5, 6], [1, 11, 12, 13, 16], [3, 4, 8, 11, 12, 15]]
  pBoxStat = [1, 2, 3, 7, 10, 14, 15, 16]
  pSpdrStat = [4, 5, 6, 8, 9, 11, 12, 13]
  pSwasStat = [0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0]
  pPlayIdx = 0
  pLastStt = 0
  pPlayLst = []
  cnt = integer(pFavStates.count * 1.5)
  repeat with i = 1 to cnt
    if i > pFavStates.count then
      pPlayLst.append(0)
      next repeat
    end if
    pPlayLst.append(i)
  end repeat
  shuffleLst(pPlayLst)
  pLastTm = gFrmTm
  pbFinish = 0
  pCycTm = 120
  this.mInitMode(#fade)
  return this
end

on mDestroy this
  gSptMgr.mRlsBank(plSptBank)
  voidList(plSptBank)
  plSptBank = VOID
  voidList(plLoadAnim)
  voidList(pFavStates)
  voidList(pSpdrStat)
  voidList(pStatVct)
  voidList(pTargVct)
  voidList(pRndVct)
  plLoadAnim = VOID
  pFavStates = VOID
  pSpdrStat = VOID
  pStatVct = VOID
  pTargVct = VOID
  pRndVct = VOID
end

on mMediaReady this
  repeat with mbr in plLoadAnim
    if not mbr.mediaReady then
      return 0
    end if
  end repeat
  return 1
end

on mFinish this
  pbFinish = 1
end

on mSetDelay this, dly
  if dly <> pCycTm then
    pCycTm = dly
    pcntLeft = float(gFrmTm - pFadeTmr) / float(pFadeDur)
    pFadeTmr = gFrmTm - integer(pcntLeft * pCycTm)
    pFadeDur = pCycTm
  end if
end

on mGetNxtState this
  pPlayIdx = pPlayIdx + 1
  if pPlayIdx > pPlayLst.count then
    shuffleLst(pPlayLst)
    pPlayIdx = 1 + (pPlayLst[1] = pLastStt)
  end if
  pLastStt = pPlayLst[pPlayIdx]
  return pLastStt
end

on mUpdate this
  dTm = gFrmTm - pLastTm
  if dTm > 4 then
    pFadeTmr = pFadeTmr + (dTm - 4)
  end if
  pLastTm = gFrmTm
  case pMode of
    #fade, #boxStat, #fullStat, #spdrStat, #fadeOut:
      done = 0
      fadeVal = 100 * (gFrmTm - pFadeTmr) / pFadeDur
      if fadeVal > 100 then
        fadeVal = 100
        done = 1
      end if
      cnt = pStatVct.count
      repeat with i = 1 to cnt
        if pStatVct[i] <> pTargVct[i] then
          sprite(plSptBank[i]).blend = (pTargVct[i] * fadeVal) + (pStatVct[i] * (100 - fadeVal))
        end if
      end repeat
      if done then
        case pMode of
          #fade:
            if pbFinish then
              this.mInitMode(#spdrStat)
            else
              this.mInitMode(#fade)
            end if
          #boxStat:
            this.mInitMode(#fullStat)
          #fullStat:
            this.mInitMode(#spdrStat)
          #spdrStat:
            this.mInitMode(#fadeOut)
          #fadeOut:
            this.mInitMode(#done)
        end case
      end if
  end case
end

on mInitMode this, m
  pMode = m
  case pMode of
    #fade:
      pFadeVal = 0
      pFadeTmr = gFrmTm
      pFadeDur = pCycTm
      stt = this.mGetNxtState()
      if stt > 0 then
        this.mSetTarg(pFavStates[stt])
      else
        this.mCalcRndTarg()
        cnt = 0
        repeat with i = 1 to 16
          cnt = cnt + (pRndVct[i] = pSwasStat[i])
        end repeat
        if cnt < 13 then
          this.mSetBitTarg(pRndVct)
        else
          this.mSetTarg(pFavStates[random(pFavStates.count)])
        end if
      end if
    #boxStat:
      pFadeVal = 0
      pFadeTmr = gFrmTm
      pFadeDur = pCycTm
      this.mSetTarg(pBoxStat)
    #fullStat:
      pFadeVal = 0
      pFadeTmr = gFrmTm
      pFadeDur = pCycTm
      this.mSetTarg([])
      cnt = pTargVct.count
      repeat with i = 1 to cnt
        pTargVct[i] = 1
      end repeat
    #spdrStat:
      pFadeVal = 0
      pFadeTmr = gFrmTm
      pFadeDur = pCycTm
      this.mSetTarg(pSpdrStat)
    #fadeOut:
      pFadeVal = 0
      pFadeTmr = gFrmTm
      pFadeDur = pCycTm / 2
      this.mSetTarg([])
  end case
end

on mSetTarg this, targ
  cnt = pStatVct.count
  repeat with i = 1 to cnt
    pStatVct[i] = pTargVct[i]
    pTargVct[i] = 0
  end repeat
  repeat with idx in targ
    pTargVct[idx] = 1
  end repeat
end

on mSetBitTarg this, targ
  cnt = pStatVct.count
  repeat with i = 1 to cnt
    pStatVct[i] = pTargVct[i]
    pTargVct[i] = targ[i]
  end repeat
end

on mCalcRndTarg this
  cnt = pRndVct.count
  repeat with i = 1 to cnt
    pRndVct[i] = random(3) = 1
  end repeat
end
