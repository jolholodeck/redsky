property iState, iSwooshBgdCast, iSwooshAnim1, iSwooshAnim2, iSwooshLoc, iWaitCycles, iCurCycle, iWinLosePicts, iWinLoseLoc, iPlayBtnLoc, iThoughtsBtnLoc, iCycleCount, iColRange, iColToggle, iRolloverToggle
global gSwooshSpr1, gSwooshSpr2, gWinLoseSpr, gPlayBtnSpr, gThoughtsBtnSpr, gGamePhase, gBgdOffH, gBgdOffV, gBgdOffPt, gFireSnd, gBounceSnd, gHitSnd, gMissSnd, glShockSnds, gStaticSnd, gSuckSnd, gWinner

on new me
  set iState to #ready
  set iWaitCycles to 20
  set iCurCycle to 0
  set iColRange to [0, 23, 29, 35, 71, 107, 143, 107, 71, 35, 29, 23]
  set iColToggle to 0
  set iRolloverToggle to 0
  set iCycleCount to 0
  set iWinLosePicts to [#user: 261, #Andre: 262]
  set iSwooshBgdCast to 312
  set iSwooshAnim1 to [1, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312]
  set iSwooshAnim2 to [0, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 326, 325, 324, 323, 322, 321, 320, 319, 318, 317, 316, 315, 314]
  set the locH of sprite gSwooshSpr1 to -1000
  set the locH of sprite gSwooshSpr2 to -1000
  set iSwooshLoc to point(166, 109) + gBgdOffPt
  set iWinLoseLoc to point(166, 55) + gBgdOffPt
  set iPlayBtnLoc to point(60, 170) + gBgdOffPt
  set iThoughtsBtnLoc to point(260, 170) + gBgdOffPt
  return me
end

on mMove me
  case iState of
    #ready:
      set iCurCycle to iCurCycle + 1
      if iCurCycle >= iWaitCycles then
        set iState to #prep
      end if
    #prep:
      set the castNum of sprite gSwooshSpr1 to iSwooshBgdCast
      set the loc of sprite gSwooshSpr2 to iSwooshLoc
      set iState to #part1
    #part1:
      set idx to getAt(iSwooshAnim1, 1) + 1
      if idx > (count(iSwooshAnim1) - 1) then
        set the loc of sprite gSwooshSpr1 to iSwooshLoc
        set iState to #part2
        exit
      end if
      set the castNum of sprite gSwooshSpr2 to getAt(iSwooshAnim1, idx + 1)
      setAt(iSwooshAnim1, 1, idx)
      if idx = 9 then
        set the volume of sound 2 to 20
        puppetSound(1, gSuckSnd)
      end if
    #part2:
      set iCycleCount to min(iCycleCount + 1, the maxinteger)
      set idx to getAt(iSwooshAnim2, 1) + 1
      if idx > (count(iSwooshAnim2) - 1) then
        set idx to 1
      end if
      set the castNum of sprite gSwooshSpr2 to getAt(iSwooshAnim2, idx + 1)
      setAt(iSwooshAnim2, 1, idx)
      if iColToggle then
        set idx to getAt(iColRange, 1) + 1
        if idx > (count(iColRange) - 1) then
          set idx to 1
        end if
        set the foreColor of sprite gWinLoseSpr to getAt(iColRange, idx + 1)
        setAt(iColRange, 1, idx)
      end if
      if iRolloverToggle then
        set col to 23
        if rollOver(gThoughtsBtnSpr) then
          set the foreColor of sprite gThoughtsBtnSpr to col
        else
          set the foreColor of sprite gThoughtsBtnSpr to 36
        end if
        if rollOver(gPlayBtnSpr) then
          set the foreColor of sprite gPlayBtnSpr to col
        else
          set the foreColor of sprite gPlayBtnSpr to 36
        end if
      end if
      case iCycleCount of
        40:
          set the castNum of sprite gWinLoseSpr to getaProp(iWinLosePicts, gWinner)
          set the loc of sprite gWinLoseSpr to iWinLoseLoc
          set the foreColor of sprite gWinLoseSpr to getAt(iColRange, 2)
          set iColToggle to 1
        70:
          set the loc of sprite gPlayBtnSpr to iPlayBtnLoc
          set the loc of sprite gThoughtsBtnSpr to iThoughtsBtnLoc
          set the foreColor of sprite gPlayBtnSpr to 0
          set the foreColor of sprite gThoughtsBtnSpr to 0
          set iRolloverToggle to 1
      end case
  end case
end

on mHide me
  set the locH of sprite gSwooshSpr1 to -1000
  set the locH of sprite gSwooshSpr2 to -1000
  set the locH of sprite gWinLoseSpr to -1000
  set the locH of sprite gPlayBtnSpr to -1000
  set the locH of sprite gThoughtsBtnSpr to -1000
end
