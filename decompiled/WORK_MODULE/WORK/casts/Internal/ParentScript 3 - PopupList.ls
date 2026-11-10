property pnSlots, pnRealSlots, pnPixelsPerSlot, pnMovies, pchFirstSlotOffset, plMovies, plnmBitmaps, pchFrameTop, pchFrameBottom, plCursorUp, plCursorDown, pchScrollArea, plBaseV, pCurrentPixelOffset, pCurrentItemInSlot1, psymScrollDirection, pfScrollUpAvailable, pfScrollDownAvailable, pEndTicks, pnWaitTicks, pnWaitTicksMax, pnWaitTicksStandard, plDefaultCursor, pnPixelsPerScroll, pState, pHeightOfName, pThresholdSlowingUp, pThresholdSlowingDown

on new me, chFirstSlot, nSlots, chFrameTop, chFrameBottom, nPixelsPerSlot, lCursor
  set pnWaitTicksStandard to 1
  set pnWaitTicksMax to pnWaitTicksStandard + 7
  set pnPixelsPerScroll to 2
  set pchFirstSlotOffset to chFirstSlot - 1
  set pnSlots to nSlots
  set pnRealSlots to pnSlots + 1
  set pnPixelsPerSlot to nPixelsPerSlot
  set plDefaultCursor to lCursor
  set pchFrameTop to chFrameTop
  set pchFrameBottom to chFrameBottom
  set plCursorUp to [the number of member "ArrowUp", the number of member "ArrowUpMask"]
  set plCursorDown to [the number of member "ArrowDown", the number of member "ArrowDownMask"]
  set plBaseV to []
  repeat with i = 1 to pnRealSlots
    set ch to pchFirstSlotOffset + i
    set thisBaseV to the locV of sprite ch
    add(plBaseV, thisBaseV)
  end repeat
  set pState to #none
  set pHeightOfName to pnPixelsPerSlot - pnPixelsPerScroll
  set pThresholdSlowingUp to pHeightOfName / 3
  set pThresholdSlowingDown to pHeightOfName * 2 / 3
  return me
end

on mCleanUp me
  nothing()
end

on mShow me, lnmBitmaps, lMovies
  set pnWaitTicks to pnWaitTicksStandard
  mClearScrollCursor(me)
  set plnmBitmaps to lnmBitmaps
  set plMovies to lMovies
  set pnMovies to count(plMovies)
  mSetPuppets(me, 1)
  if pnMovies <= pnSlots then
    set pState to #noScroll
    set pfScrollUpAvailable to 0
    set pfScrollDownAvailable to 0
    set pCurrentPixelOffset to 0
    set pCurrentItemInSlot1 to 1
    repeat with i = 1 to pnRealSlots
      set ch to pchFirstSlotOffset + i
      set the locV of sprite ch to getAt(plBaseV, i)
      if i <= pnMovies then
        set the member of sprite ch to getAt(plnmBitmaps, i)
        next repeat
      end if
      set the member of sprite ch to the number of member "Hide"
    end repeat
  else
    set pState to #autoScrolling
    set pfScrollUpAvailable to 1
    set pfScrollDownAvailable to 0
    RegisterForIdleEvents(me)
    set psymScrollDirection to #Up
    set pEndTicks to the ticks + pnWaitTicks
    set pfScrollDownAvailable to 0
    set pCurrentPixelOffset to pnPixelsPerSlot
    set pCurrentItemInSlot1 to pnMovies - pnRealSlots + 1
    repeat with i = 1 to pnRealSlots
      set ch to pchFirstSlotOffset + i
      set the locV of sprite ch to getAt(plBaseV, i) - pCurrentPixelOffset
      set theIndex to pCurrentItemInSlot1 + i - 1
      set the member of sprite ch to getAt(plnmBitmaps, theIndex)
    end repeat
  end if
end

on mShowStartAtTop me, lnmBitmaps, lMovies
  mClearScrollCursor(me)
  set plnmBitmaps to lnmBitmaps
  set plMovies to lMovies
  set pnMovies to count(plMovies)
  mSetPuppets(me, 1)
  if pnMovies <= pnSlots then
    set pState to #noScroll
    set pfScrollUpAvailable to 0
    set pfScrollDownAvailable to 0
  else
    set pState to #autoScrolling
    set pfScrollUpAvailable to 0
    set pfScrollDownAvailable to 1
    RegisterForIdleEvents(me)
    set psymScrollDirection to #down
    set pEndTicks to the ticks + pnWaitTicks
  end if
  repeat with i = 1 to pnRealSlots
    set ch to pchFirstSlotOffset + i
    set the locV of sprite ch to getAt(plBaseV, i)
    if i <= pnMovies then
      set the member of sprite ch to getAt(plnmBitmaps, i)
      next repeat
    end if
    set the member of sprite ch to the number of member "Hide"
  end repeat
  set pCurrentPixelOffset to 0
  set pCurrentItemInSlot1 to 1
end

on mSetPuppets me, trueORfalse
  repeat with i = 1 to pnRealSlots
    set ch to pchFirstSlotOffset + i
    puppetSprite(ch, trueORfalse)
  end repeat
  puppetSprite(pchFrameTop, trueORfalse)
  puppetSprite(pchFrameBottom, trueORfalse)
end

on mHide me
  mSetPuppets(me, 0)
  mClearScrollCursor(me)
  if pState = #autoScrolling then
    DeRegisterForIdleEvents(me)
    set pState to #none
  end if
end

on mHit me
  PlayRicochet()
  set itemNum to the clickOn - pchFirstSlotOffset + pCurrentItemInSlot1 - 1
  set theMovie to getAt(plMovies, itemNum)
  return theMovie
end

on mMouseEnteredScrollArea me, symUpOrDown, spriteNum
  set pchScrollArea to spriteNum
  if pnMovies <= pnSlots then
    return 
  end if
  if symUpOrDown = #Up then
    if not pfScrollUpAvailable then
      return 
    end if
    puppetSprite(pchScrollArea, 1)
    set the cursor of sprite pchScrollArea to plCursorUp
  else
    if not pfScrollDownAvailable then
      return 
    end if
    puppetSprite(pchScrollArea, 1)
    set the cursor of sprite pchScrollArea to plCursorDown
  end if
  RegisterForIdleEvents(me)
  set psymScrollDirection to symUpOrDown
  set pEndTicks to the ticks + pnWaitTicks
  set pState to #scrollAvailable
  set pnWaitTicks to pnWaitTicksStandard
end

on mIdleEvent me
  if the ticks < pEndTicks then
    return 
  end if
  if pState = #slowing then
    set pnWaitTicks to pnWaitTicks + 1
    if pnWaitTicks = pnWaitTicksMax then
      DeRegisterForIdleEvents(me)
      return 
    end if
  end if
  set pEndTicks to the ticks + pnWaitTicks
  if psymScrollDirection = #down then
    if not pfScrollDownAvailable then
      return 
    end if
    if (pState <> #slowing) and (pnMovies = (pCurrentItemInSlot1 + pnSlots)) and (pCurrentPixelOffset >= pThresholdSlowingDown) then
      set pState to #slowing
    end if
    if (pnMovies = (pCurrentItemInSlot1 + pnSlots)) and (pCurrentPixelOffset >= pHeightOfName) then
      set pfScrollDownAvailable to 0
      set pCurrentPixelOffset to pnPixelsPerSlot
      mClearScrollCursor(me)
      if pState = #autoScrolling then
        DeRegisterForIdleEvents(me)
        set pState to #scrollAvailable
      end if
    else
      set pfScrollDownAvailable to 1
      if (pCurrentPixelOffset + pnPixelsPerScroll) >= pnPixelsPerSlot then
        set pCurrentItemInSlot1 to pCurrentItemInSlot1 + 1
        repeat with i = 1 to pnRealSlots
          set ch to pchFirstSlotOffset + i
          set indexOfBitmap to pCurrentItemInSlot1 + i - 1
          set the member of sprite ch to getAt(plnmBitmaps, indexOfBitmap)
        end repeat
        set pCurrentPixelOffset to 0
      else
        set pCurrentPixelOffset to pCurrentPixelOffset + pnPixelsPerScroll
      end if
    end if
    set pfScrollUpAvailable to 1
  else
    if not pfScrollUpAvailable then
      return 
    end if
    if (pState <> #slowing) and (pCurrentItemInSlot1 = 1) and (pCurrentPixelOffset <= pThresholdSlowingUp) then
      set pState to #slowing
    end if
    if (pCurrentItemInSlot1 = 1) and (pCurrentPixelOffset <= pnPixelsPerScroll) then
      set pfScrollUpAvailable to 0
      set pCurrentPixelOffset to 0
      mClearScrollCursor(me)
      if pState = #autoScrolling then
        DeRegisterForIdleEvents(me)
        set pState to #scrollAvailable
      end if
    else
      set pfScrollUpAvailable to 1
      if pCurrentPixelOffset <= 1 then
        set pCurrentItemInSlot1 to pCurrentItemInSlot1 - 1
        repeat with i = 1 to pnRealSlots
          set ch to pchFirstSlotOffset + i
          set indexOfBitmap to pCurrentItemInSlot1 + i - 1
          set the member of sprite ch to getAt(plnmBitmaps, indexOfBitmap)
        end repeat
        set pCurrentPixelOffset to pnPixelsPerSlot
      else
        set pCurrentPixelOffset to pCurrentPixelOffset - pnPixelsPerScroll
      end if
    end if
    set pfScrollDownAvailable to 1
  end if
  repeat with i = 1 to pnRealSlots
    set ch to pchFirstSlotOffset + i
    set the locV of sprite ch to getAt(plBaseV, i) - pCurrentPixelOffset
  end repeat
end

on mMouseLeftScrollArea me, symUpOrDown
  if pnMovies <= pnSlots then
    return 
  end if
  if pState <> #autoScrolling then
    set pState to #slowing
  end if
  mClearScrollCursor(me)
end

on mClearScrollCursor me
  set the cursor of sprite pchScrollArea to plDefaultCursor
  puppetSprite(pchScrollArea, 0)
end
