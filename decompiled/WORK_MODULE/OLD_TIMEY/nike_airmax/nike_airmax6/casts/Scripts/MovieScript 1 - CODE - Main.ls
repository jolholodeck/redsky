global gLastH, gLastV, gLastR, gMaxPeeking, gExitCurling, gLogoBreathing, gGoOutAndPlay, gCrntMode, gMarketingOn, gLogoBreathList, gMetronome, gRoleCallCount, gRoleCallDelay, gFlashingIS, gFlashingDOES, gFlashingFasterBadder, gMaxSoleStomping, gIsPCversion, gNumAnimationsRunning, gMaxStompCount, gDemoSuspended

on startMovie
  set gIsPCversion to 0
  set gLastH to the mouseH
  set gLastV to the mouseV
  set gNumAnimationsRunning to 0
  set gMaxStompCount to 0
  set gMaxPeeking to 0
  set gExitCurling to 0
  set gLogoBreathing to 0
  set gGoOutAndPlay to 0
  set gMaxSoleStomping to 0
  set gFlashingIS to 0
  set gFlashingDOES to 0
  set gFlashingFasterBadder to 0
  set gRoleCallDelay to 100
  set gRoleCallCount to 0
  set gMetronome to 0
  set gCrntMode to 0
  set gMarketingOn to 0
  set gLogoBreathList to list(the number of member "Breathe.+1", the number of member "Breathe.+2", the number of member "Breathe.+3", the number of member "Breathe.+2", the number of member "Breathe.+1", the number of member "Breathe.0", the number of member "Breathe.-1", the number of member "Breathe.-2", the number of member "Breathe.-3", the number of member "Breathe.-2", the number of member "Breathe.-1", the number of member "Breathe.0", -99)
  set cnum to the number of member "Nike cursor"
  set mnum to the number of member "Nike cursor mask"
  set the cursor of sprite 2 to [cnum, mnum]
  set the cursor of sprite 4 to [cnum, mnum]
  set the cursor of sprite 9 to [cnum, mnum]
  set the cursor of sprite 40 to [cnum, mnum]
  set the cursor of sprite 41 to [cnum, mnum]
  set the cursor of sprite 45 to [cnum, mnum]
  set gDemoSuspended to 0
  set the keyDownScript to "demoExitKey()"
end

on demoExitKey
  if (the key = RETURN) or (the key = ENTER) then
    set gDemoSuspended to 1
    ReturnToWork()
    abort()
  end if
end

on enterFrame
  if gDemoSuspended then
    exit
  end if
  if (gCrntMode > 19) and (gCrntMode < 50) then
    set nowH to the mouseH
    set nowV to the mouseV
    if (abs(nowH - gLastH) + abs(nowV - gLastV)) > 300 then
      puppetSound("bike.pump.aiff")
    end if
    set gLastH to nowH
    set gLastV to nowV
  end if
end

on exitFrame
  if gDemoSuspended then
    exit
  end if
  set gMetronome to 1 - gMetronome
  set myrand to random(1000)
  if (gCrntMode > 19) and (gCrntMode < 50) then
    if rollOver(2) and (gFlashingIS = 0) then
      launchFlashingIS()
    end if
    if rollOver(4) and (gFlashingDOES = 0) then
      launchFlashingDOES()
    end if
    if rollOver(41) and (gFlashingFasterBadder = 0) then
      launchFlashingFasterBadder()
    end if
    if (gRoleCallCount < 2) and (gNumAnimationsRunning > 1) then
      set gRoleCallCount to 0
    end if
    if gRoleCallCount = 1 then
      launchFlashingIS()
    end if
    if gRoleCallCount = 3 then
      launchFlashingDOES()
    end if
    if gRoleCallCount = 5 then
      launchFlashingFasterBadder()
    end if
    if gRoleCallCount = 7 then
      launchExitCurling()
    end if
    set gRoleCallCount to gRoleCallCount + 1
    if gRoleCallCount > gRoleCallDelay then
      set gRoleCallCount to 0
    end if
    if gFlashingIS > 0 then
      if (gMetronome = 0) and (gMarketingOn = 0) then
        set the locH of sprite 35 to 267
      else
        set the locH of sprite 35 to 730
      end if
      set gFlashingIS to gFlashingIS + 1
      if gFlashingIS > 12 then
        cleanupFlashingIS()
      end if
    end if
    if gFlashingDOES > 0 then
      if (gMetronome = 0) and (gMarketingOn = 0) then
        set the locH of sprite 36 to 570
      else
        set the locH of sprite 36 to 730
      end if
      set gFlashingDOES to gFlashingDOES + 1
      if gFlashingDOES > 12 then
        cleanupFlashingDOES()
      end if
    end if
    if gFlashingFasterBadder > 0 then
      if gMetronome = 0 then
        set the castNum of sprite 41 to cast "Faster/Badder.jittered"
      else
        set the castNum of sprite 41 to cast "Faster/Badder"
      end if
      if gCrntMode = 40 then
        set the castNum of sprite 41 to cast "Faster/Badder"
      end if
      set gFlashingFasterBadder to gFlashingFasterBadder + 1
      if gFlashingFasterBadder > 12 then
        cleanupFlashingFasterBadder()
      end if
    end if
    if gMaxPeeking > 0 then
      if (gMaxPeeking = 1) or (gMaxPeeking = 7) then
        set the castNum of sprite 38 to cast "Max.R.talk"
        set the locH of sprite 38 to 50
        set the locV of sprite 38 to 408
      end if
      if (gMaxPeeking = 2) or (gMaxPeeking = 6) then
        set the locH of sprite 38 to 62
        set the locV of sprite 38 to 384
      end if
      if (gMaxPeeking = 3) or (gMaxPeeking = 5) then
        set the castNum of sprite 38 to cast "Max.R.talk"
        set the locH of sprite 38 to 75
        set the locV of sprite 38 to 391
      end if
      if gMaxPeeking = 4 then
        set the castNum of sprite 38 to cast "Max.R.wink"
        puppetSound("hey!")
      end if
      set gMaxPeeking to gMaxPeeking + 1
      if gMaxPeeking > 8 then
        cleanupMaxPeeking()
      end if
    else
      if (gMaxStompCount < 3) and (gMaxSoleStomping = 0) and ((myrand < 4) or (rollOver(41) and (myrand < 100))) then
        launchMaxPeeking()
      end if
    end if
    if gMaxSoleStomping > 0 then
      set gMaxSoleStomping to gMaxSoleStomping + 1
      if gMaxSoleStomping > 10 then
        cleanupMaxSoleStomping()
      end if
    end if
    if gExitCurling > 0 then
      if (gExitCurling = 1) or (gExitCurling = 7) then
        set the castNum of sprite 45 to cast "exit curl 1"
        set the locH of sprite 45 to 623
        set the locV of sprite 45 to 465
      end if
      if (gExitCurling = 2) or (gExitCurling = 6) then
        set the castNum of sprite 45 to cast "exit curl 2"
        set the locH of sprite 45 to 679
        set the locV of sprite 45 to 655
      end if
      if (gExitCurling = 3) or (gExitCurling = 5) then
        set the castNum of sprite 45 to cast "exit curl 3"
        set the locH of sprite 45 to 591
        set the locV of sprite 45 to 542
      end if
      if gExitCurling = 4 then
        set the castNum of sprite 45 to cast "exit curl 4"
        set the locH of sprite 45 to 761
        set the locV of sprite 45 to 986
      end if
      set gExitCurling to gExitCurling + 1
      if gExitCurling > 8 then
        cleanupExitCurling()
      end if
    else
      if ((the mouseH > 600) and (the mouseV > 440)) or (myrand > 995) then
        launchExitCurling()
      end if
    end if
    if gLogoBreathing > 0 then
      set the castNum of sprite 40 to getAt(gLogoBreathList, gLogoBreathing)
      if gLogoBreathing = 1 then
        puppetSound("breath.in.aiff")
      end if
      if gLogoBreathing = 4 then
        puppetSound("breath.out.aiff")
      end if
      set gLogoBreathing to gLogoBreathing + 1
      if getAt(gLogoBreathList, gLogoBreathing) = -99 then
        cleanupLogoBreathing()
      end if
    else
      if rollOver(40) or ((myrand > 200) and (myrand < 206)) then
        launchLogoBreathing()
      end if
    end if
    if gGoOutAndPlay > 0 then
      set gGoOutAndPlay to gGoOutAndPlay + 1
      if gGoOutAndPlay > 10 then
        cleanupGoOutAndPlay()
      end if
    else
      if myrand = 333 then
        launchGoOutAndPlay()
      end if
    end if
  end if
  if gNumAnimationsRunning < 0 then
    set gNumAnimationsRunning to 0
  end if
end

on mouseUp
  if gDemoSuspended then
    exit
  end if
  if (gCrntMode = 10) and rollOver(9) then
    go("Max Gets Squished")
  end if
  if gCrntMode = 15 then
    cleanupMaxShoeSquish()
    go("Main Title")
  end if
  if (gCrntMode > 19) and (gCrntMode < 50) then
    if rollOver(40) then
      launchLogoBreathing()
    end if
    if rollOver(44) and (gGoOutAndPlay > 0) then
      puppetSound("slow.hiss.aiff")
      cleanupGoOutAndPlay()
    end if
    if rollOver(45) and (gExitCurling > 0) then
      puppetSound("bike.pump.aiff")
      stopAllAnimations()
      set gMarketingOn to 0
      set gCrntMode to 50
      go("Close")
    end if
    if rollOver(2) then
      puppetSound("stamp.aiff")
      cleanupAthleteScreens()
      if gCrntMode = 20 then
        go("AirMax Shoe")
      else
        if gCrntMode = 30 then
          go("AirRupt Shoe")
        else
          if gCrntMode = 40 then
            go("Uptempo Shoe")
          end if
        end if
      end if
      if gRoleCallCount > 10 then
        set gRoleCallCount to gRoleCallDelay - 20
      end if
    end if
    if rollOver(4) then
      puppetSound("stamp.aiff")
      if gCrntMode = 20 then
        go("Uptempo.Does")
      else
        if gCrntMode = 30 then
          go("AirMax.Does")
        else
          if gCrntMode = 40 then
            go("AirRupt.Does")
          end if
        end if
      end if
    end if
    if rollOver(38) and (gMaxPeeking > 0) and (rollOver(41) = 0) then
      set gMaxStompCount to gMaxStompCount + 1
      launchMaxSoleStomping()
    end if
    if rollOver(41) then
      incrementMarketingSequence()
    end if
  end if
end
