global g.obj.SystemManager, gameSpace, Ball, gun, Andre, Scanner, PowerBar, score, Face, static, extro, gGamePhase, gWinner, gBoundsRect, gWidth, gHeight, gDepth, gLeft, gTop, gRight, gBot, gFarRect, gShadowDivY, gStageOffH, gStageOffV, gPerspective, gDepthIncX, gDepthIncY, gGravity, gGravFreq, kCueTime, gBgdOffH, gBgdOffV, gBgdOffPt, grInnerTarget, grMidTarget, gOuterLeft, gOuterRight, gTGTinnerCast, gTGTmidCast, gTGTouterCast, gTGTleftCast, gTGTrightCast, gBallSpr, gShadowSpr, gGunSpr, gFarSpr, gTGTspr, gSmokeSpr, gAndreSpr, gPlotSpr, gForceSpr, gBackWallFXspr, gFgdFXspr, gStaticSpr, gScoreSpr, gFaceSpr, gDotCast, gSwooshSpr1, gSwooshSpr2, gWinLoseSpr, gPlayBtnSpr, gThoughtsBtnSpr, gForfeitBtnSpr, gFireSnd, gBounceSnd, gHitSnd, gMissSnd, glShockSnds, gStaticSnd, gSuckSnd, gLastKey, gLeftKey, gRightKey, gMousePrimed, gForfeitCast, gForfeitCastHilite, gFarCastNum, gStatusField

on startMovie
  if objectp(g.obj.SystemManager) then
    sysEnterStartMovie(g.obj.SystemManager)
  end if
  set gStatusField to 51
  set gForfeitCast to 67
  set gForfeitCastHilite to 68
  set the text of field gStatusField to " "
  set the foreColor of member gStatusField to 86
  initSystem()
  initMetrics()
  initSpriteMap()
  INITSOUNDS()
  set the idleHandlerPeriod to 0
  set the cpuHogTicks to 1000
  set gLastKey to EMPTY
  set gLeftKey to ","
  set gRightKey to "."
  set gMousePrimed to 0
  set gDotCast to 20
  set kCueTime to 2
  set gameSpace to new(script "GameSpace Parent")
  set Ball to new(script "Ball Parent")
  set gun to new(script "Gun Parent")
  set Andre to new(script "Andre Parent")
  set Scanner to new(script "Scanner Parent")
  set PowerBar to new(script "PowerBar Parent")
  set Face to new(script "Face Parent")
  set score to new(script "Score Parent")
  set static to new(script "Static Parent")
  set extro to new(script "Extro Parent")
  set nonsense to ["System", "Metrics", "SpriteMap", "Sounds"]
  repeat with w in nonsense
    set the text of field gStatusField to "Init  " & w
    doPause(20)
  end repeat
  set nonsense to ["GameSpace", "Ball", "Gun", "Scanner", "PowerBar", "Score", "Agassi"]
  repeat with w in nonsense
    set the text of field gStatusField to "Instantiate " & w
    doPause(20)
  end repeat
  set the text of field gStatusField to " "
  set the foreColor of member gStatusField to 35
  repeat with x = 1 to 3
    set the text of field gStatusField to "ready"
    doPause(15)
    set the text of field gStatusField to " "
    doPause(4)
  end repeat
  set the foreColor of member gStatusField to 86
  mDisplay(Ball)
  mDisplay(gun)
  mDisplay(Andre)
  updateStage()
  set gGamePhase to #inProgress
  if objectp(g.obj.SystemManager) then
    sysExitStartMovie(g.obj.SystemManager)
  end if
end

on stopMovie
  if objectp(g.obj.SystemManager) then
    sysExitStopMovie(g.obj.SystemManager)
  end if
end

on resetGame
  puppetSound(1, 0)
  puppetSound(2, 0)
  set the soundLevel to 4
  set the volume of sound 1 to 255
  set the volume of sound 2 to 80
  set the text of field gStatusField to " "
  set gLastKey to EMPTY
  set gLeftKey to ","
  set gRightKey to "."
  set gMousePrimed to 0
  set gameSpace to 0
  set Ball to 0
  set gun to 0
  set Andre to 0
  set Scanner to 0
  set PowerBar to 0
  set Face to 0
  set score to 0
  set static to 0
  set extro to 0
  set gameSpace to new(script "GameSpace Parent")
  set Ball to new(script "Ball Parent")
  set gun to new(script "Gun Parent")
  set Andre to new(script "Andre Parent")
  set Scanner to new(script "Scanner Parent")
  set PowerBar to new(script "PowerBar Parent")
  set Face to new(script "Face Parent")
  set score to new(script "Score Parent")
  set static to new(script "Static Parent")
  set extro to new(script "Extro Parent")
  set the text of field gStatusField to " "
  set the foreColor of member gStatusField to 35
  repeat with x = 1 to 3
    set the text of field gStatusField to "ready"
    doPause(15)
    set the text of field gStatusField to " "
    doPause(4)
  end repeat
  set the foreColor of member gStatusField to 86
  mDisplay(Ball)
  mDisplay(gun)
  mDisplay(Andre)
  updateStage()
end

on idle
  set freeze to the timer
  case gGamePhase of
    #inProgress:
      mMove(gun)
      mMove(Andre)
      mMove(Ball)
      mMove(Scanner)
      mMove(PowerBar)
      mMove(Face)
      mMove(gameSpace)
      mMove(static)
      if rollOver(gForfeitBtnSpr) then
        set the castNum of sprite gForfeitBtnSpr to gForfeitCastHilite
      else
        set the castNum of sprite gForfeitBtnSpr to gForfeitCast
      end if
      if gMousePrimed then
        if the mouseUp then
          mFire(gun)
          set gMousePrimed to 0
        end if
      else
        if the mouseDown then
          if the mouseCast = gForfeitCastHilite then
            set the iState of Ball to #idle
            mHide(Ball)
            mHide(Scanner)
            set gGamePhase to #startExtro
            mTrigger(Face, #laugh)
            set gWinner to #Andre
            set the castNum of sprite gForfeitBtnSpr to gForfeitCast
            updateStage()
            exit
          end if
          if mCanPower(PowerBar) then
            set gMousePrimed to 1
            mStartPower(PowerBar)
          end if
        end if
      end if
    #startExtro:
      mMove(gun)
      mMove(Andre)
      mMove(Ball)
      mMove(Scanner)
      mMove(PowerBar)
      mMove(Face)
      mMove(gameSpace)
      mMove(static)
      if the iState of Face = #idle then
        if the iState of PowerBar = #idle then
          mLockStatic(static)
          mHide(Ball)
          mHide(Andre)
          mHide(gun)
          mHilite(score, 0, 1)
          set gGamePhase to #extro
          exit
        end if
      end if
    #extro:
      mMove(static)
      mMove(extro)
    #reset:
      mHide(extro)
      mUnlockStatic(static)
      mMove(static)
      updateStage()
      resetGame()
      set gGamePhase to #inProgress
    #quit:
      mHide(extro)
      mUnlockStatic(static)
      mMove(static)
      updateStage()
      exitToShell()
    #exit:
      exit
  end case
  updateStage()
  waitForTimer(freeze + kCueTime)
end

on exitToShell
  set gGamePhase to #exit
  if objectp(g.obj.SystemManager) then
    puppetAllSprites(g.obj.SystemManager)
    updateStage()
    go("gdmoFadeToBlack")
  else
    play done
  end if
end

on keyDown
  if objectp(g.obj.SystemManager) then
    systemKeyHandler(g.obj.SystemManager, the key)
  end if
  set gLastKey to the key
  dontPassEvent()
end

on keyUp
  set gLastKey to EMPTY
  dontPassEvent()
end

on initSystem
end

on initMetrics
  set gBoundsRect to rect(0, 0, 450, 270)
  set gBgdOffH to 160
  set gBgdOffV to 124
  set gBgdOffPt to point(gBgdOffH, gBgdOffV)
  set gStageOffH to -65 + gBgdOffH
  set gStageOffV to -62 + gBgdOffV
  set L to getAt(gBoundsRect, 1)
  set t to getAt(gBoundsRect, 2)
  set r to getAt(gBoundsRect, 3)
  set b to getAt(gBoundsRect, 4)
  set gLeft to L
  set gTop to t
  set gRight to r
  set gBot to b
  set gWidth to r - L
  set gHeight to b - t
  set gDepth to gWidth
  set gPerspective to 0.33000000000000002
  set gGravity to 1
  set gGravFreq to 5
  set farWidth to integer(gWidth * gPerspective)
  set farHeight to integer(gHeight * gPerspective)
  set gFarRect to inflate(gBoundsRect, -(gWidth - farWidth) / 2, -(gHeight - farHeight) / 2)
  set gDepthIncX to gDepth / ((gWidth - farWidth) / 2)
  set gDepthIncY to gDepth / ((gHeight - farHeight) / 2)
  set gShadowDivY to gDepth / ((gHeight - (gHeight * gPerspective)) / 2)
  set grInnerTarget to rect(200, 106, 254, 160)
  set grMidTarget to rect(148, 50, 308, 215)
  set gOuterLeft to 90
  set gOuterRight to 364
  set gTGTinnerCast to 41
  set gTGTmidCast to 42
  set gTGTouterCast to 43
  set gTGTleftCast to 44
  set gTGTrightCast to 45
end

on initSpriteMap
  set gTGTspr to 4
  puppetSprite(gTGTspr, 1)
  set gBackWallFXspr to 5
  puppetSprite(gBackWallFXspr, 1)
  set gShadowSpr to 6
  puppetSprite(gShadowSpr, 1)
  set gAndreSpr to 9
  puppetSprite(gAndreSpr, 1)
  set gBallSpr to 10
  puppetSprite(gBallSpr, 1)
  set gSmokeSpr to 11
  puppetSprite(gSmokeSpr, 1)
  set gGunSpr to 12
  puppetSprite(gGunSpr, 1)
  set gForfeitBtnSpr to 21
  puppetSprite(gForfeitBtnSpr, 1)
  set gPlotSpr to 22
  puppetSprite(gPlotSpr, 1)
  set gForceSpr to 23
  puppetSprite(gForceSpr, 1)
  set gScoreSpr to 26
  puppetSprite(gScoreSpr, 1)
  set gFaceSpr to 28
  puppetSprite(gFaceSpr, 1)
  set gFgdFXspr to 29
  puppetSprite(gFgdFXspr, 1)
  set gStaticSpr to 30
  puppetSprite(gStaticSpr, 1)
  set gWinLoseSpr to 44
  puppetSprite(gWinLoseSpr, 1)
  set gPlayBtnSpr to 45
  puppetSprite(gPlayBtnSpr, 1)
  set gThoughtsBtnSpr to 46
  puppetSprite(gThoughtsBtnSpr, 1)
  set gSwooshSpr1 to 47
  puppetSprite(gSwooshSpr1, 1)
  set gSwooshSpr2 to 48
  puppetSprite(gSwooshSpr2, 1)
end

on INITSOUNDS
  puppetSound(1, 0)
  puppetSound(2, 0)
  set the soundLevel to 4
  set the volume of sound 1 to 255
  set the volume of sound 2 to 80
  set gFireSnd to 52
  set gBounceSnd to 53
  set gHitSnd to 54
  set gMissSnd to 55
  set glShockSnds to [56, 57, 58]
  set gStaticSnd to 59
  set gSuckSnd to 60
end

on handleBtn ID
  set spr to the clickOn
  set col to the foreColor of sprite spr
  repeat while the mouseDown
    set freeze to the timer
    mMove(static)
    mMove(extro)
    waitForTimer(freeze + kCueTime)
    if rollOver(spr) then
      set the foreColor of sprite spr to 29
    else
      set the foreColor of sprite spr to 36
    end if
    waitForTimer(freeze + kCueTime)
    updateStage()
  end repeat
  set the foreColor of sprite spr to 36
  if rollOver(spr) then
    if ID = #play then
      set gGamePhase to #reset
    else
      set gGamePhase to #quit
    end if
  end if
end

on systemExitCleanupHandler
  put "CHILD: in systemExitCleanupHandler"
  mHide(extro)
  mUnlockStatic(static)
  mMove(static)
  updateStage()
  exitToShell()
end
