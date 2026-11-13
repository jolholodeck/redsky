property ancestor, ioConsole, iStepFrameEnabled, iState, iDestZordID, iPhase, iCurFrame, ikNbFadeoutFrames, ikNbBurst1Frames, ikNbBurst2Frames, ikNbClearFrames, iklStaticMbrs, iklStatic2Mbrs, ikNbStaticMbrs, iCurStaticMbr, ikBlendMbr, ikBaseSwitchMbr, iklPalettes, ikRndBlendProb, ikPinkZordMbr, ikLoadScreenMbr, iklStaticLoops, iklModemLoop, iklStaticSnd, ikStaticNoteNumber, iklConnectSnd, ikStaticGroupID, ikStaticNoteID, ikModemGroupID, ikModemNoteID, ikBlackMaskMbr, ikMZCPLastSpr, iklMZCPframes, iMZCPcurFrame, iMZCPcurSeq, iklMZCPsndData, ikStaticSpr, ikBlendSpr
global koConstants, goMemoryMgr, gIsPinkZord

on new me, oConsole
  ioConsole = oConsole
  iStepFrameEnabled = 0
  iState = #ready
  iPhase = #ready
  iCurFrame = 0
  ikNbFadeoutFrames = 8
  ikNbBurst1Frames = 5
  ikNbClearFrames = 1
  ikNbBurst2Frames = 8
  ikStaticGroupID = #staticGroup
  ikStaticNoteID = #staticNote
  iklStaticLoops = [[#bank: 2, #pgm: 12, #vel: 100, #action: #loop, #note: 35, #dur: 500], [#bank: 2, #pgm: 11, #vel: 100, #action: #loop, #note: 22, #dur: 500], [#bank: 2, #pgm: 125, #vel: 100, #action: #loop, #note: 2, #dur: 500]]
  repeat with curLoop in iklStaticLoops
    curLoop.addProp(#srcID, ikStaticGroupID)
    curLoop.addProp(#tag, ikStaticNoteID)
  end repeat
  ikModemGroupID = #modemGroup
  ikModemNoteID = #modemNote
  iklModemLoop = [#bank: 2, #pgm: 45, #vel: 100, #action: #loop, #note: 48, #dur: 500]
  iklModemLoop.addProp(#srcID, ikModemGroupID)
  iklModemLoop.addProp(#tag, ikModemNoteID)
  iklConnectSnd = [#bank: 2, #pgm: 36, #vel: 100, #action: #play, #note: 50, #dur: 600]
  iklStaticSnd = [#bank: 2, #pgm: 126, #vel: 100, #action: #play, #note: 93, #dur: 300]
  ikStaticNoteNumber = iklStaticSnd.note
  iklMZCPsndData = me.mGetMZCPsoundData()
  ikRndBlendProb = 3
  iklStaticMbrs = [101, 102, 103, 104, 105, 106, 107, 108]
  iklStatic2Mbrs = [111, 112, 113, 114, 115, 116, 117, 118]
  ikNbStaticMbrs = iklStaticMbrs.count
  iCurStaticMbr = iklStaticMbrs[random(ikNbStaticMbrs)]
  ikBlendMbr = 120
  ikBaseSwitchMbr = 91
  ikPinkZordMbr = 97
  ikBlackMaskMbr = 102
  iklPalettes = [121, 122, 123, 124, 125, 126]
  ikBlendSpr = koConstants.ikMaxSpriteNum
  ikStaticSpr = ikBlendSpr - 1
  sprite(ikStaticSpr).ink = 0
  sprite(ikBlendSpr).ink = 32
  iklMZCPframes = [[301, 302, 303, 304, 305, 306, 307, 308], [309, 310, 311, 312, 313, 314, 315, 316], [317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341], [342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355], [356, 357, 358, 359, 360], [361, 362, 363, 364, 365], [366, 367, 368, 369, 370, 371], [372, 373, 374, 375], [376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390], [391, 392, 393, 394, 395, 396, 397], [398, 399, 400, 401, 402, 403], [404, 405, 406, 407, 408]]
  ikMZCPLastSpr = 132
  iMZCPcurFrame = 1
  iMZCPcurSeq = 1
  return me
end

on mAssertPalette me, zordID
  puppetPalette(iklPalettes[zordID], 60)
end

on mDoTransition me, srcZordID, dstZordID
  iDestZordID = dstZordID
  if iState = #running then
    exit
  end if
  if gIsPinkZord then
    ikLoadScreenMbr = ikPinkZordMbr
  else
    ikLoadScreenMbr = ikBaseSwitchMbr + iDestZordID - 1
  end if
  goMemoryMgr.mPreloadMembers(iklStaticMbrs, 2, 0)
  goMemoryMgr.mPreloadMembers(iklStatic2Mbrs, 2, 0)
  goMemoryMgr.mPreloadMembers([ikLoadScreenMbr], 2, 0)
  me.mSetStepFrameHook(1)
  iState = #running
  iPhase = #start
  iCurFrame = 0
  ioConsole.ioSong.mStopAllNotes()
  ioConsole.ioSong.mStopLoops()
  puppetTempo(30)
end

on stepFrame me
  case iPhase of
    #start:
      sprite(ikStaticSpr).ink = 0
      sprite(ikStaticSpr).forecolor = 255
      sprite(ikStaticSpr).backcolor = 0
      sprite(ikStaticSpr).loc = point(0, 0)
      sprite(ikStaticSpr).member = member(iCurStaticMbr, 2)
      ioConsole.ioCurFrameset.mShutdown()
      ioConsole.ioCursorControl.mClearCursor()
      ioConsole.ioSong.mPostEvent(iklStaticLoops[random(iklStaticLoops.count)])
      iCurFrame = 0
      iPhase = #fadeOut
    #fadeOut:
      iCurFrame = iCurFrame + 1
      if iCurFrame > ikNbFadeoutFrames then
        sprite(ikBlendSpr).locH = -1000
        sprite(ikStaticSpr).loc = point(0, 0)
        sprite(ikStaticSpr).member = member(ikBlackMaskMbr, 1)
        ioConsole.ioSong.mStopLoops(ikStaticGroupID, ikStaticNoteID)
        ioConsole.ioSong.mPostEvent(iklModemLoop)
        ioConsole.ioSong.mPostEvent(iklConnectSnd)
        iCurFrame = 0
        iPhase = #switch
        exit
      end if
      me.mSetNextStaticMbr()
      sprite(ikStaticSpr).member = member(iCurStaticMbr, 2)
      me.mDoStaticBlend()
    #switch:
      puppetPalette(iklPalettes[iDestZordID], 60)
      go(the frame)
      sprite(ikStaticSpr).member = member(ikLoadScreenMbr, 2)
      updateStage()
      unLoad()
      ioConsole.iCurFrameSetID = iDestZordID
      ioConsole.mBuildCurFrameset()
      ioConsole.ioCurFrameset.mStartup()
      ioConsole.mDisableEvents()
      goMemoryMgr.mPreloadMembers(iklStaticMbrs, 2, 0)
      goMemoryMgr.mPreloadMembers(iklStatic2Mbrs, 2, 0)
      iCurFrame = 0
      iPhase = #burst1
      me.mSetNextStaticMbr()
      ioConsole.ioSong.mPostEvent(iklStaticLoops[random(iklStaticLoops.count)])
      ioConsole.ioSong.mStopLoops(ikModemGroupID, ikModemNoteID)
    #burst1:
      iCurFrame = iCurFrame + 1
      if iCurFrame > ikNbBurst1Frames then
        sprite(ikStaticSpr).locH = -1000
        sprite(ikBlendSpr).locH = -1000
        ioConsole.ioSong.mStopLoops(ikStaticGroupID, ikStaticNoteID)
        iCurFrame = 0
        if iDestZordID = 6 then
          me.mPrepMZCP()
          iPhase = #MZCP
        else
          iPhase = #clear
        end if
        exit
      end if
      me.mSetNextStaticMbr()
      sprite(ikStaticSpr).member = member(iCurStaticMbr, 2)
      me.mDoStaticBlend()
    #clear:
      iCurFrame = iCurFrame + 1
      if iCurFrame <= ikNbClearFrames then
        exit
      end if
      sprite(ikStaticSpr).ink = 36
      sprite(ikStaticSpr).forecolor = 0
      me.mSetNextStaticMbr()
      sprite(ikStaticSpr).loc = point(0, 0)
      sprite(ikStaticSpr).member = member(iCurStaticMbr + 10, 2)
      ioConsole.ioSong.mPostEvent(iklStaticLoops[random(iklStaticLoops.count)])
      iCurFrame = 0
      iPhase = #burst2
    #burst2:
      iCurFrame = iCurFrame + 1
      if iCurFrame > ikNbBurst2Frames then
        sprite(ikStaticSpr).locH = -1000
        sprite(ikBlendSpr).locH = -1000
        ioConsole.ioSong.mStopLoops(ikStaticGroupID, ikStaticNoteID)
        me.mSetStepFrameHook(0)
        iState = #ready
        iPhase = #ready
        puppetTempo(15)
        ioConsole.mEnableEvents()
        exit
      end if
      if random(ikRndBlendProb) = 1 then
        sprite(ikStaticSpr).locH = -1000
      else
        me.mSetNextStaticMbr()
        sprite(ikStaticSpr).loc = point(0, 0)
        sprite(ikStaticSpr).member = member(iCurStaticMbr + 10, 2)
        me.mDoStaticBlend()
      end if
    #MZCP:
      iMZCPcurFrame = iMZCPcurFrame + 1
      if iMZCPcurFrame > iklMZCPframes[iMZCPcurSeq].count then
        sprite(ikMZCPLastSpr - iMZCPcurSeq + 1).locH = -1000
        if iMZCPcurSeq >= iklMZCPframes.count then
          me.mSetStepFrameHook(0)
          iState = #ready
          iPhase = #ready
          puppetTempo(15)
          ioConsole.mEnableEvents()
          exit
        end if
        iMZCPcurSeq = iMZCPcurSeq + 1
        iMZCPcurFrame = 0
        updateStage()
        goMemoryMgr.mPreloadMembers(iklMZCPframes[iMZCPcurSeq], 2, 0)
        exit
      end if
      sprite(ikMZCPLastSpr - iMZCPcurSeq + 1).member = member(iklMZCPframes[iMZCPcurSeq][iMZCPcurFrame], 2)
      Levent = iklMZCPsndData[iMZCPcurSeq][iMZCPcurFrame]
      if listp(Levent) then
        deleteProp(getaProp(Levent, #ctrl), #rnd)
        ioConsole.ioSong.mPostEvent(Levent)
      end if
  end case
end

on mDoStaticBlend me
  if random(ikRndBlendProb) = 1 then
    rTop = random(450)
    rHeight = 30 + random(200)
    rBlend = 10 * (3 + random(5))
    sprite(ikBlendSpr).member = member(ikBlendMbr, 2)
    sprite(ikBlendSpr).rect = rect(0, rTop, 640, rTop + rHeight)
    sprite(ikBlendSpr).blend = rBlend
    iklStaticSnd.note = ikStaticNoteNumber + 10 - random(20)
    iklStaticSnd.vel = 90 + random(20)
    ioConsole.ioSong.mPostEvent(iklStaticSnd)
  else
    sprite(ikBlendSpr).locH = -1000
  end if
end

on mSetStepFrameHook me, State
  if State = iStepFrameEnabled then
    exit
  end if
  iStepFrameEnabled = State
  if iStepFrameEnabled then
    add(the actorList, me)
  else
    deleteOne(the actorList, me)
  end if
end

on mSetNextStaticMbr
  mbr = iCurStaticMbr
  repeat while mbr = iCurStaticMbr
    iCurStaticMbr = iklStaticMbrs[random(ikNbStaticMbrs)]
  end repeat
end

on mPrepMZCP me
  iMZCPcurSeq = 1
  iMZCPcurFrame = 0
  spr = ikMZCPLastSpr
  repeat with frameData in iklMZCPframes
    mbr = frameData[1]
    sprite(spr).member = member(frameData[1], 2)
    sprite(spr).loc = point(0, 0)
    spr = spr - 1
  end repeat
end

on mGetMZCPsoundData
  return [[[#bank: 2, #pgm: 81, #vel: 100, #action: #play, #note: 59, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 0, #endVal: 0, #rnd: 0]], [#bank: 2, #pgm: 112, #vel: 100, #action: #play, #note: 38, #dur: 4000, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 0, #endVal: 0, #rnd: 0]], 3, 4, 5, 6, 7, 8], [[#bank: 2, #pgm: 81, #vel: 90, #action: #play, #note: 59, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 127, #endVal: 127, #rnd: 0]], 2, 3, 4, 5, 6, 7, [#bank: 2, #pgm: 109, #vel: 100, #action: #play, #note: 43, #dur: 4000, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 0, #endVal: 0, #rnd: 0]]], [[#bank: 2, #pgm: 66, #vel: 90, #action: #play, #note: 48, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 64, #endVal: 64, #rnd: 0]], 2, 3, [#bank: 2, #pgm: 66, #vel: 90, #action: #play, #note: 48, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 64, #endVal: 64, #rnd: 0]], 5, 6, [#bank: 2, #pgm: 66, #vel: 90, #action: #play, #note: 48, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 64, #endVal: 64, #rnd: 0]], 8, 9, [#bank: 2, #pgm: 66, #vel: 90, #action: #play, #note: 48, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 64, #endVal: 64, #rnd: 0]], 11, 12, 13, 14, 15, [#bank: 2, #pgm: 69, #vel: 90, #action: #play, #note: 48, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 64, #endVal: 64, #rnd: 0]], 17, [#bank: 2, #pgm: 120, #vel: 90, #action: #play, #note: 55, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 64, #endVal: 64, #rnd: 0]], 19, 20, 21, 22, 23, 24, 25], [[#bank: 2, #pgm: 121, #vel: 100, #action: #play, #note: 52, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 50, #endVal: 50, #rnd: 0]], 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], [[#bank: 2, #pgm: 119, #vel: 100, #action: #play, #note: 55, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 0, #endVal: 0, #rnd: 0]], 2, 3, 4, 5], [[#bank: 2, #pgm: 119, #vel: 100, #action: #play, #note: 55, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 127, #endVal: 127, #rnd: 0]], 2, 3, 4, 5], [[#bank: 2, #pgm: 85, #vel: 100, #action: #play, #note: 45, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 50, #endVal: 50, #rnd: 0]], 2, 3, 4, 5, 6], [[#bank: 2, #pgm: 85, #vel: 100, #action: #play, #note: 52, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 50, #endVal: 50, #rnd: 0]], 2, 3, 4], [[#bank: 2, #pgm: 82, #vel: 100, #action: #play, #note: 52, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 80, #endVal: 80, #rnd: 0]], 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], [[#bank: 2, #pgm: 118, #vel: 100, #action: #play, #note: 50, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 120, #endVal: 120, #rnd: 0]], 2, 3, 4, 5, 6, 7], [[#bank: 2, #pgm: 81, #vel: 100, #action: #play, #note: 69, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 64, #endVal: 64, #rnd: 0]], 2, 3, 4, 5, 6], [[#bank: 2, #pgm: 88, #vel: 100, #action: #play, #note: 48, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 20, #endVal: 20, #rnd: 0]], 2, 3, 4, [#bank: 2, #pgm: 32, #vel: 100, #action: #play, #note: 47, #dur: 500, #ctrl: [#ctrl: 10, #bgnFrm: 0, #endFrm: 0, #bgnVal: 64, #endVal: 64, #rnd: 0]]]]
end
