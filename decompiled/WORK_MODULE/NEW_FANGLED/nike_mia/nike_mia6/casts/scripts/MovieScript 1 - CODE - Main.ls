global gCrntMode, gNumChansInScore, gNumChansPerSeq, gsptBeautiful, gsptStrong, gsptPrecious, gsptTough, gsptDoll, gsptBall, gsptAnimation, gsptOverlay, gBeautifulState, gStrongState, gPreciousState, gToughState, gDollState, gBallState, gCursorNum, gCursorMaskNum

on startMovie
  set gCrntMode to #Intro
  set gNumChansInScore to 48
  set gNumChansPerSeq to 5
  initStateVars()
  set gsptBeautiful to 3
  set gsptStrong to 8
  set gsptPrecious to 13
  set gsptTough to 18
  set gsptDoll to 3
  set gsptBall to 8
  set gsptAnimation to 24
  set gsptOverlay to 30
  set gCursorNum to the number of member "Nike cursor"
  set gCursorMaskNum to the number of member "Nike cursor mask"
  set the keyDownScript to "CheckForExitKey()"
end

on initStateVars
  set gBeautifulState to 0
  set gStrongState to 0
  set gPreciousState to 0
  set gToughState to 0
  set gDollState to 0
  set gBallState to 0
end

on clearAllPuppetSprites
  repeat with i = 1 to gNumChansInScore
    set the loc of sprite i to point(1000, 300)
    puppetSprite(i, 0)
  end repeat
end

on copyTextToOverlay sptPtr
  set lastSpt to sptPtr + gNumChansPerSeq - 1
  repeat with i = sptPtr to lastSpt
    if the type of sprite i > 0 then
      set targSpt to gsptOverlay + i - sptPtr
      puppetSprite(targSpt, 1)
      set the member of sprite targSpt to the member of sprite i
      set the loc of sprite targSpt to the loc of sprite i
      set the blend of sprite targSpt to the blend of sprite i
      set the visible of sprite targSpt to the visible of sprite i
      set the ink of sprite targSpt to 39
    end if
  end repeat
end

on clearOverlayChans
  set lastSpt to gsptOverlay + gNumChansPerSeq - 1
  repeat with i = gsptOverlay to lastSpt
    set the loc of sprite i to point(1000, 300)
    puppetSprite(i, 0)
  end repeat
end
