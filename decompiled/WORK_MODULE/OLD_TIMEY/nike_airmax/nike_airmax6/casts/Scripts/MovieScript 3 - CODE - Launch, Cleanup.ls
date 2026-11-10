global gLastH, gLastV, gLastR, gMaxPeeking, gExitCurling, gLogoBreathing, gGoOutAndPlay, gCrntMode, gMarketingOn, gLogoBreathList, gMetronome, gRoleCallCount, gRoleCallDelay, gFlashingIS, gFlashingDOES, gFlashingFasterBadder, gMaxSoleStomping, gIsPCversion, gNumAnimationsRunning

on launchFlashingIS
  if gFlashingIS = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  puppetSprite(35, 1)
  set the locH of sprite 35 to 267
  set the locV of sprite 35 to 26
  set gFlashingIS to 1
end

on cleanupFlashingIS
  set gFlashingIS to 0
  set the locH of sprite 35 to 730
  puppetSprite(35, 0)
  set gNumAnimationsRunning to gNumAnimationsRunning - 1
end

on launchFlashingDOES
  if gFlashingDOES = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  puppetSprite(36, 1)
  set the locH of sprite 36 to 570
  set the locV of sprite 36 to 143
  set gFlashingDOES to 1
end

on cleanupFlashingDOES
  set gFlashingDOES to 0
  set the locH of sprite 36 to 730
  puppetSprite(36, 0)
  set gNumAnimationsRunning to gNumAnimationsRunning - 1
end

on launchFlashingFasterBadder
  if gFlashingFasterBadder = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  puppetSprite(41, 1)
  set gFlashingFasterBadder to 1
end

on cleanupFlashingFasterBadder
  set the castNum of sprite 41 to cast "Faster/Badder"
  set gFlashingFasterBadder to 0
  puppetSprite(41, 0)
  set gNumAnimationsRunning to gNumAnimationsRunning - 1
end

on launchExitCurling
  if gExitCurling = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  puppetSprite(45, 1)
  set gExitCurling to 1
end

on cleanupExitCurling
  set gExitCurling to 0
  set the locH of sprite 45 to 900
  puppetSprite(45, 0)
  set gNumAnimationsRunning to gNumAnimationsRunning - 1
end

on launchMaxPeeking
  if gMaxPeeking = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  puppetSprite(38, 1)
  set gMaxPeeking to 1
end

on cleanupMaxPeeking
  set gMaxPeeking to 0
  set the locH of sprite 38 to 730
  puppetSprite(38, 0)
  set gNumAnimationsRunning to gNumAnimationsRunning - 1
end

on launchLogoBreathing
  if gLogoBreathing = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  puppetSprite(40, 1)
  set gLogoBreathing to 1
end

on cleanupLogoBreathing
  set gLogoBreathing to 0
  puppetSprite(40, 0)
  set gNumAnimationsRunning to gNumAnimationsRunning - 1
end

on launchGoOutAndPlay
  if gGoOutAndPlay = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  puppetSprite(44, 1)
  set the locH of sprite 44 to 100 + random(440)
  set the locV of sprite 44 to 50 + random(390)
  set gGoOutAndPlay to 1
  puppetSound("stamp.aiff")
  updateStage()
end

on cleanupGoOutAndPlay
  set gGoOutAndPlay to 0
  set the locH of sprite 44 to 730
  puppetSprite(44, 0)
  set gNumAnimationsRunning to gNumAnimationsRunning - 1
end

on launchMaxSoleStomping
  if gMaxSoleStomping = 0 then
    set gNumAnimationsRunning to gNumAnimationsRunning + 1
  end if
  puppetSprite(42, 1)
  set the locH of sprite 42 to 72
  set the locV of sprite 42 to 411
  set gMaxSoleStomping to 1
  cleanupMaxPeeking()
  puppetSprite(38, 1)
  set the castNum of sprite 38 to cast "Max squished"
  set the locH of sprite 38 to 90
  set the locV of sprite 38 to 385
  puppetSound("squish.max.aiff")
  updateStage()
end

on cleanupMaxSoleStomping
  set gMaxSoleStomping to 0
  set the locH of sprite 38 to 730
  puppetSprite(38, 0)
  set the locH of sprite 42 to 730
  puppetSprite(42, 0)
  set gNumAnimationsRunning to gNumAnimationsRunning - 1
end

on launchMaxShoeSquish
  global maxLocX, maxLocY, maxCycle, maxDirectionX, maxDirectionY, maxSpeedX, maxSpeedY, maxWalkingTimer, maxWalkingTimerDelay, targetLocX, targetLocY
  set r to random(3)
  if r = 1 then
    set targetLocX to 50 + random(30)
    set targetLocY to 50 + random(30)
  end if
  if r = 2 then
    set targetLocX to 520 + random(70)
    set targetLocY to 50 + random(200)
  end if
  if r = 3 then
    set targetLocX to 50 + random(540)
    set targetLocY to 310 + random(110)
  end if
  put r, targetLocX, targetLocY
  puppetSprite(30, 1)
  set the castNum of sprite 30 to cast "Bulls Eye"
  set the locH of sprite 30 to targetLocX
  set the locV of sprite 30 to targetLocY
  set maxLocX to the locH of sprite 15
  set maxLocY to the locV of sprite 15
  set maxCycle to 0
  if maxLocX > targetLocX then
    set maxDirectionX to 2
  else
    set maxDirectionX to 0
  end if
  set maxDirectionY to 2
  set maxSpeedX to 15
  set maxSpeedY to 5
  puppetSprite(9, 1)
  set the castNum of sprite 9 to the castNum of sprite 15
  set the locH of sprite 9 to maxLocX
  set the locV of sprite 9 to maxLocY
  set maxWalkingTimer to 0
  set maxWalkingTimerDelay to 20
end

on cleanupMaxShoeSquish
  set the locH of sprite 9 to 730
  set the locH of sprite 10 to 730
  set the locH of sprite 30 to 730
  puppetSprite(9, 0)
  puppetSprite(10, 0)
  puppetSprite(30, 0)
end

on cleanupAthleteScreens
  puppetSprite(30, 0)
  puppetSprite(31, 0)
  puppetSprite(32, 0)
  puppetSprite(33, 0)
  puppetSprite(34, 0)
end

on stopAllAnimations
  cleanupAthleteScreens()
  cleanupFlashingIS()
  cleanupFlashingDOES()
  cleanupFlashingFasterBadder()
  cleanupExitCurling()
  cleanupMaxPeeking()
  cleanupLogoBreathing()
  cleanupGoOutAndPlay()
  cleanupMaxShoeSquish()
  cleanupMaxSoleStomping()
  set gRoleCallCount to 20
  updateStage()
end
