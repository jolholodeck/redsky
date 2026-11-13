property pMode, plSptBank, pInpSpt, pFrmSpt, pMsgSpt, pSubSpt, pAgnSpt, pClsSpt, pGlyph, pTxtClr, pTxtErrClr, pbErrOn, pBadTxt, pDefMsg, pDone, pFadeVal, pFadeTmr, pFadeDur, pSubRct, pLgoSpt, pLglSpt, pPrvSpt, pTrmSpt, pBluSpt, pLocZ, pPostID, pEmailSent
global glGlob, gSptMgr, gSndMgr, gFrmTm, gFadeSpt, gMousePt, gLoadRMF, gMainRMF, gPlatform, gLiveConn, gUrlCGI, gUrlPriv, gUrlTerm

on new this
  this.mInitMode(#init)
  pTxtClr = 24
  pTxtErrClr = 0
  pDone = 0
  pPostID = 0
  pEmailSent = EMPTY
  plSptBank = gSptMgr.mGetSptBank(#load, 11)
  pInpSpt = sprite(plSptBank[1])
  pFrmSpt = sprite(plSptBank[2])
  pMsgSpt = sprite(plSptBank[3])
  pSubSpt = sprite(plSptBank[4])
  pAgnSpt = sprite(plSptBank[5])
  pClsSpt = sprite(plSptBank[6])
  pLgoSpt = sprite(plSptBank[7])
  pLglSpt = sprite(plSptBank[8])
  pPrvSpt = sprite(plSptBank[9])
  pTrmSpt = sprite(plSptBank[10])
  pBluSpt = sprite(plSptBank[11])
  pInpSpt.member = glGlob.inputTxt
  pInpSpt.loc = glGlob.hideLoc
  glGlob.inputTxt.text = EMPTY
  glGlob.inputTxt.wordWrap = 0
  glGlob.inputTxt.forecolor = pTxtClr
  pFrmSpt.member = glGlob.inputFrm
  pFrmSpt.loc = glGlob.stgCntr
  pFrmSpt.ink = 36
  pDefMsg = "You've taken the first step." & RETURN & "Enter your e-mail address to take the next."
  pMsgSpt.member = glGlob.msgTxt
  pMsgSpt.loc = point(214, 189)
  glGlob.msgTxt.forecolor = pTxtClr
  glGlob.msgTxt.text = pDefMsg
  pbErrOn = 0
  pBadTxt = EMPTY
  pSubSpt.member = glGlob.submit
  pAgnSpt.member = glGlob.again
  pSubSpt.loc = glGlob.stgCntr
  pAgnSpt.loc = glGlob.stgCntr
  if (gPlatform = #pc) or gLiveConn then
    pClsSpt.member = glGlob.close
    pClsSpt.loc = glGlob.stgCntr
  else
    pClsSpt.member = glGlob.dotC
    pClsSpt.loc = glGlob.hideLoc
  end if
  pLgoSpt.member = glGlob.regColumbiaLogo
  pLglSpt.member = glGlob.regLegalBase
  pPrvSpt.member = glGlob.regPrivRO
  pTrmSpt.member = glGlob.regTermRO
  pBluSpt.member = glGlob.regBlueSqr
  pLgoSpt.loc = glGlob.stgCntr
  pLglSpt.loc = glGlob.stgCntr
  pPrvSpt.loc = glGlob.stgCntr
  pTrmSpt.loc = glGlob.stgCntr
  pBluSpt.loc = glGlob.stgCntr
  pLocZ = pLgoSpt.locZ
  pPrvSpt.locZ = pLocZ - 100
  pTrmSpt.locZ = pLocZ - 100
  pBluSpt.locZ = pLocZ - 100
  pSubRct = rect(364, 245, 439, 259)
  pGlyph = new(glGlob.cGlyph, point(166, 169), 1)
  gFadeSpt.member = glGlob.rct
  gFadeSpt.rect = glGlob.stgRect
  gFadeSpt.forecolor = 255
  gFadeSpt.blend = 100
  this.mInitMode(#fade)
  return this
end

on mDestroy this
  gSptMgr.mRlsBank(plSptBank)
  pInpSpt = VOID
  pFrmSpt = VOID
  pMsgSpt = VOID
  pSubSpt = VOID
  pAgnSpt = VOID
  pClsSpt = VOID
  gFadeSpt.rect = rect(-1000, -999, -1000, -999)
  if objectp(pGlyph) then
    pGlyph.mDestroy()
  end if
  pGlyph = VOID
end

on mUpdate this
  if gLoadRMF.mSndEvent(#getPos, VOID) >= 230000 then
    gLoadRMF.mSndEvent(#setPos, 0)
  end if
  case pMode of
    #fade:
      pFadeVal = 100 * (gFrmTm - pFadeTmr) / pFadeDur
      if pFadeVal < 100 then
        gFadeSpt.blend = 100 - pFadeVal
      else
        gFadeSpt.blend = 100
        gFadeSpt.rect = rect(-1000, -999, -1000, -999)
        this.mInitMode(#reg)
      end if
      this.mUpdateReg()
    #reg:
      this.mUpdateReg()
    #submit:
      if netDone(pPostID) then
        retVal = netTextResult(pPostID)
        if netError(pPostID) = "OK" then
          glGlob.msgTxt.forecolor = pTxtClr
          glGlob.msgTxt.text = "Thank you." & RETURN & "Expect more to come."
          pSubSpt.loc = glGlob.hideLoc
          pInpSpt.loc = glGlob.hideLoc
          pFrmSpt.loc = glGlob.hideLoc
          pBluSpt.loc = glGlob.hideLoc
          pInpSpt.member = VOID
          pDone = 1
          this.mInitMode(#reg)
        else
          pFadeTmr = gFrmTm - 1
        end if
      end if
      if (gFrmTm > pFadeTmr) or (pPostID < 1) then
        glGlob.msgTxt.forecolor = pTxtErrClr
        glGlob.msgTxt.text = "ALERT: The server is not responding." & RETURN & "Please try again later."
        this.mInitMode(#reg)
      end if
    #replay:
      pFadeVal = 100 * (gFrmTm - pFadeTmr) / pFadeDur
      if pFadeVal < 100 then
        gFadeSpt.blend = pFadeVal
      else
        gFadeSpt.blend = 100
        this.mInitMode(#done)
      end if
    #done:
      initMode(#harp)
  end case
  if objectp(pGlyph) then
    pGlyph.mUpdate()
  end if
  if (pMode = #reg) or (pMode = #submit) then
    roll = inside(gMousePt, pSubRct)
    pBluSpt.locZ = pLocZ + (200 * roll) - 100
    if roll then
      mbr = glGlob.subRO
    else
      mbr = glGlob.submit
    end if
    if pSubSpt.member <> mbr then
      pSubSpt.member = mbr
    end if
    if rollOver(pAgnSpt) then
      mbr = glGlob.agnRO
    else
      mbr = glGlob.again
    end if
    if pAgnSpt.member <> mbr then
      pAgnSpt.member = mbr
    end if
    if rollOver(pClsSpt) then
      mbr = glGlob.clsRO
    else
      mbr = glGlob.close
    end if
    if pClsSpt.member <> mbr then
      pClsSpt.member = mbr
    end if
    pPrvSpt.locZ = pLocZ + (200 * inside(gMousePt, pPrvSpt.rect)) - 100
    pTrmSpt.locZ = pLocZ + (200 * inside(gMousePt, pTrmSpt.rect)) - 100
  end if
end

on mUpdateReg this
  crntTxt = glGlob.inputTxt.text
  noRet = 1
  len = crntTxt.length
  repeat with i = 1 to len
    c = crntTxt.char[i]
    if (c = RETURN) or (c = ENTER) then
      noRet = 0
      if len < 2 then
        newTxt = EMPTY
      else
        newTxt = crntTxt.char[1..i - 1] & crntTxt.char[i + 1..len]
      end if
      glGlob.inputTxt.text = newTxt
      if not pDone then
        this.mInitMode(#submit)
      end if
    end if
  end repeat
  if pbErrOn and noRet then
    if crntTxt <> pBadTxt then
      glGlob.msgTxt.forecolor = pTxtClr
      glGlob.msgTxt.text = pDefMsg
      pbErrOn = 0
      pBadTxt = EMPTY
    end if
  end if
end

on mMouseUp this
  if pMode = #reg then
    if inside(gMousePt, pSubRct) then
      this.mInitMode(#submit)
    end if
    if rollOver(pAgnSpt) then
      this.mInitMode(#replay)
    end if
    if rollOver(pClsSpt) then
      externalEvent("closeWindow('secretMsg')")
    end if
    if inside(gMousePt, pPrvSpt.rect) then
      gotoNetPage(gUrlPriv, "SPMintroLink")
    end if
    if inside(gMousePt, pTrmSpt.rect) then
      gotoNetPage(gUrlTerm, "SPMintroLink")
    end if
  end if
end

on mVerifyEmail this, str
  pos = offset("@", str)
  if pos < 2 then
    return 0
  end if
  if this.mBadChars(str.char[1..pos - 1], 1) then
    return 0
  end if
  dotCnt = 0
  len = str.length
  repeat while pos > 0
    idx = pos + 1
    pos = offset(".", str.char[idx..len])
    if pos = 0 then
      exit repeat
      next repeat
    end if
    pos = idx + pos - 1
    dotCnt = dotCnt + 1
    if this.mBadChars(str.char[idx..pos - 1], 0) then
      return 0
    end if
  end repeat
  if dotCnt = 0 then
    return 0
  end if
  if idx > len then
    return 0
  end if
  if this.mBadChars(str.char[idx..len], 0) then
    return 0
  end if
  return 1
end

on mBadChars this, str, beforeAtSign
  len = str.length
  if len < 1 then
    return 1
  end if
  cnt = 0
  repeat with i = 1 to len
    chr = charToNum(str.char[i])
    if not (((chr > 47) and (chr < 58)) or ((chr > 64) and (chr < 91)) or ((chr > 96) and (chr < 123))) then
      if beforeAtSign then
        cnt = cnt + (offset(str.char[i], "%^-_.") = 0)
        next repeat
      end if
      cnt = cnt + (offset(str.char[i], "-_") = 0)
    end if
  end repeat
  return cnt > 0
end

on mInitMode this, m
  pMode = m
  case pMode of
    #fade:
      cursor(-1)
      gMainRMF.mSndEvent(#mainStop, VOID)
      gLoadRMF.mResetVols()
      gLoadRMF.mSndEvent(#loadStart, VOID)
      pFadeVal = 0
      pFadeTmr = the ticks
      pFadeDur = 90
    #reg:
      pInpSpt.loc = point(218, 222)
      pGlyph.mSetDelay(120)
    #submit:
      if this.mVerifyEmail(glGlob.inputTxt.text) then
        pEmailSent = glGlob.inputTxt.text
        pkg = ["test": pEmailSent]
        pPostID = postNetText(gUrlCGI, pkg)
        pGlyph.mSetDelay(4)
        pFadeTmr = gFrmTm + (60 * 30)
      else
        glGlob.msgTxt.forecolor = pTxtErrClr
        glGlob.msgTxt.text = "ALERT: You have entered an invalid e-mail address." & RETURN & "Please re-enter."
        pbErrOn = 1
        pBadTxt = glGlob.inputTxt.text
        this.mInitMode(#reg)
      end if
    #replay:
      gLoadRMF.mSndEvent(#loadStop, VOID)
      gMainRMF.mResetVols()
      gMainRMF.mSndEvent(#loadBlowOut, VOID)
      gMainRMF.mResetVols()
      pFadeVal = 0
      pFadeTmr = gFrmTm
      pFadeDur = 45
      gFadeSpt.rect = glGlob.stgRect
      gFadeSpt.blend = 0
    #done:
      cursor(200)
      repeat with spt in plSptBank
        CDH_hideSpt(spt)
      end repeat
      if objectp(pGlyph) then
        pGlyph.mDestroy()
      end if
      pGlyph = VOID
      pInpSpt.member = VOID
  end case
end
