property pnPopupButtons, poPopup, poBuffalo, pchPresentationButton, pWhichPopupIsUp, pllMovies, pllnmBitmaps, pchBuffalo, pWorkMovie, plBullet, ploAnimatedTitles, poExitButton, pfPC, pWhichModule
global goStateMgr, goNavMgr

on new me, lButtons, lchButtons
  set pnPopupButtons to count(lButtons)
  set pchPresentationButton to 23
  set pchBuffalo to 97
  set ploAnimatedTitles to []
  set pllMovies to []
  set pllnmBitmaps to []
  set plBullet to [the number of member "Bullet", the number of member "BulletMask"]
  cursor(plBullet)
  repeat with thisButtonNum = 1 to pnPopupButtons
    set lMovieNames to mGetListMovies(script ("Popup" & string(thisButtonNum)))
    add(pllMovies, lMovieNames)
    set lBitMapNames to mGetListBitmaps(script ("Popup" & string(thisButtonNum)))
    set nBitmaps to count(lBitMapNames)
    set lnmBitmaps to []
    repeat with thisBitmapNum = 1 to nBitmaps
      set thisBitMapName to getAt(lBitMapNames, thisBitmapNum)
      set nmBitmap to the number of member thisBitMapName
      add(lnmBitmaps, nmBitmap)
    end repeat
    add(pllnmBitmaps, lnmBitmaps)
    set buttonName to getAt(lButtons, thisButtonNum)
    set chButton to getAt(lchButtons, thisButtonNum)
    set oAnimatedTitles to new(script "AnimatedTitle", buttonName, chButton, 5)
    append(ploAnimatedTitles, oAnimatedTitles)
  end repeat
  set chExitButton to 91
  set poExitButton to new(script "AnimatedButton", "g_exit_", chExitButton, 3, 3)
  set chFirstSlot to 80
  set nSlots to 6
  set chFrameTop to 95
  set chFrameBottom to 96
  set nPixelsPerSlot to 40
  set poPopup to new(script "PopupList", chFirstSlot, nSlots, chFrameTop, chFrameBottom, nPixelsPerSlot, plBullet)
  set poBuffalo to new(script "SimpleAnimation", "buff00000", "buff00118", pchBuffalo)
  set lSavedData to mGetData(goStateMgr, #work)
  if voidp(lSavedData) then
    set pWhichPopupIsUp to 0
  else
    set pWhichPopupIsUp to getaProp(lSavedData, #pWhichPopupIsUp)
  end if
  if pWhichPopupIsUp > 0 then
    put "pWhichPopupIsUp: " & pWhichPopupIsUp
    mShowPopup(me, pWhichPopupIsUp, 1)
  end if
  if the platform contains "Mac" then
    set pfPC to 0
  else
    set pfPC to 1
  end if
  return me
end

on mCleanUp me
  mCleanUp(poPopup)
  set nItems to count(ploAnimatedTitles)
  repeat with i = 1 to nItems
    set oAnimatedTitle to getAt(ploAnimatedTitles, i)
    mCleanUp(oAnimatedTitle)
    setAt(ploAnimatedTitles, i, VOID)
  end repeat
  set ploAnimatedTitles to []
  mCleanUp(poExitButton)
  set poExitButton to VOID
end

on mShowPopup me, which, fromStartMovie
  if voidp(fromStartMovie) then
    if pWhichPopupIsUp = which then
      exit
    end if
    PlayRicochet()
  end if
  if pWhichPopupIsUp > 0 then
    if which <> pWhichPopupIsUp then
      set oAnimatedTitle to getAt(ploAnimatedTitles, pWhichPopupIsUp)
      mRun(oAnimatedTitle)
    end if
  end if
  set pWhichPopupIsUp to which
  set lnmBitmaps to getAt(pllnmBitmaps, pWhichPopupIsUp)
  set lnmMovies to getAt(pllMovies, pWhichPopupIsUp)
  flicker_jumpcut(1, random(5) - 3, random(5) - 3)
  flicker_splicecut(2, the frame)
  mShow(poPopup, lnmBitmaps, lnmMovies)
  set oAnimatedTitle to getAt(ploAnimatedTitles, pWhichPopupIsUp)
  mShow(oAnimatedTitle)
end

on mSelectItemFromPopup me
  set pWorkMovie to mHit(poPopup)
  set lDataToSave to [#pWhichPopupIsUp: pWhichPopupIsUp]
  mSetData(goStateMgr, #work, lDataToSave)
  mHide(poPopup)
  flicker_setstate(#off)
  updateStage()
  flicker_splicecut(2, "Demo")
end

on mGetMovieName me
  if pfPC then
    set where to offset(":", pWorkMovie)
    repeat while where > 0
      put "\" into char where of pWorkMovie
      set where to offset(":", pWorkMovie)
    end repeat
  end if
  return the pathName & pWorkMovie
end

on mDismissPopup me
  if pWhichPopupIsUp = 0 then
    return 
  end if
  flicker_jumpcut(1, random(5) - 3, random(5) - 3)
  mHide(poPopup)
  set oAnimatedTitle to getAt(ploAnimatedTitles, pWhichPopupIsUp)
  mRun(oAnimatedTitle)
  set pWhichPopupIsUp to 0
end

on mExit me
  set pWhichModule to #exit
  flicker_setstate(#off)
  updateStage()
  flicker_splicecut(2, "Module")
end

on mEntertainment me
  puppetSound(3, "w_shoot_bottle")
  if the machineType = 256 then
    doPause(20)
  end if
  set pWhichModule to #entertainment
  flicker_setstate(#off)
  updateStage()
  flicker_splicecut(2, "Module")
end

on mPresentation me
  set pWhichModule to #Presentation
  flicker_setstate(#off)
  updateStage()
  flicker_splicecut(2, "Module")
end

on mGetModuleName me
  return pWhichModule
end

on mSetModuleName me, theModule
  set pWhichModule to theModule
end

on mMouseEnteredScrollArea me, symUpOrDown
  if pWhichPopupIsUp = 0 then
    return 
  end if
  mMouseEnteredScrollArea(poPopup, symUpOrDown)
end

on mMouseLeftScrollArea me, symUpOrDown
  if pWhichPopupIsUp = 0 then
    return 
  end if
  mMouseLeftScrollArea(poPopup, symUpOrDown)
end

on mExitButtonStartRoll me
  mRoll(poExitButton)
end

on mExitButtonStopRoll
  mRun(poExitButton)
end
