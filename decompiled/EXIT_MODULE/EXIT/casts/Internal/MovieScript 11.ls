global goNavMgr, gCRDspeed, gCRDtextField, gCRDscrollOrgH, gCRDscrollLocV, gCRDscrollFldHeight, gCRDscrollMinLocV, gCRDscrollSpr, gCRDloopSpr, gCRDloopLoc, glCRDloopArt, glCRDloopIdx, gCRDnbLoopMbrs, gCRDcreditsRate, gCRDcreditsNextCue, gCRDsound, gCRDchan, gCRDdoQuit, gCRDrollCredits, gCRDcreditsPhase, gFlicker_dustMember, gFlicker_dustAmount, gWaitExitCue, gLastkey

on credits_idle
  if not gCRDrollCredits then
    exit
  end if
  case gCRDcreditsPhase of
    #prep:
      set gCRDcreditsNextCue to 0
      sound playFile gCRDchan, gCRDsound
      updateStage()
      set gCRDscrollOrgH to 220
      set gCRDscrollLocV to the stageBottom - the stageTop + 10
      set gCRDloopLoc to point(110, 150)
      set gCRDscrollFldHeight to the height of member gCRDtextField of castLib "RTFcredits"
      set gCRDcreditsRate to 2
      set gCRDcreditsNextCue to 0
      set gCRDscrollMinLocV to -gCRDscrollFldHeight - 10
      set gCRDloopSpr to 2
      set gCRDscrollSpr to 3
      puppetSprite(gCRDloopSpr, 1)
      puppetSprite(gCRDscrollSpr, 1)
      set glCRDloopArt to [19, 20, 21, 22, 23, 24, 25, 26]
      set glCRDloopIdx to 1
      set gCRDnbLoopMbrs to count(glCRDloopArt)
      set curLoopCast to getCreditsLoopArt()
      set the memberNum of sprite gCRDloopSpr to curLoopCast
      set the loc of sprite gCRDloopSpr to gCRDloopLoc
      set the memberNum of sprite gCRDscrollSpr to gCRDtextField
      set the locH of sprite gCRDscrollSpr to gCRDscrollOrgH
      set the locV of sprite gCRDscrollSpr to gCRDscrollLocV
      set gCRDcreditsPhase to #roll
      exit
    #roll:
      set skip to 0
      if the mouseDown then
        set skip to 1
      else
        if gCRDscrollLocV < gCRDscrollMinLocV then
          set skip to 1
        else
          if (the lastKey < 10) and (gLastkey = " ") then
            set skip to 1
          end if
        end if
      end if
      if skip then
        set the locH of sprite gCRDscrollSpr to -1000
        set gCRDcreditsPhase to #exitIdle
        set gWaitExitCue to the timer
        exit
      end if
      if the timer < gCRDcreditsNextCue then
        exit
      end if
      set gCRDcreditsNextCue to the timer + gCRDcreditsRate
      set curLoopCast to getCreditsLoopArt()
      set the memberNum of sprite gCRDloopSpr to curLoopCast
      set gCRDscrollLocV to gCRDscrollLocV - gCRDspeed
      set the locV of sprite gCRDscrollSpr to gCRDscrollLocV
      updateStage()
    #exitIdle:
      if the timer < gCRDcreditsNextCue then
        exit
      end if
      set gCRDcreditsNextCue to the timer + gCRDcreditsRate
      set curLoopCast to getCreditsLoopArt()
      set the memberNum of sprite gCRDloopSpr to curLoopCast
      updateStage()
      if the timer < (gWaitExitCue + 60) then
        exit
      end if
      if the mouseDown then
        set gCRDcreditsPhase to #cleanup
        exit
      else
        if (the lastKey < 10) and (gLastkey = " ") then
          set gCRDcreditsPhase to #cleanup
          exit
        end if
      end if
      if not soundBusy(gCRDchan) then
        sound playFile gCRDchan, gCRDsound
      end if
    #cleanup:
      set gCRDcreditsPhase to #noop
      timer_kill(#newFlicker)
      timer_kill(#gFlicker_dust)
      set the locH of sprite gCRDscrollSpr to -1000
      set the locH of sprite gCRDloopSpr to -1000
      updateStage()
      repeat with i = gFlicker_dustMember to gFlicker_dustMember + gFlicker_dustAmount - 1
        set the loc of sprite i to point(-320, -240)
      end repeat
      puppetPalette(0)
      if soundBusy(gCRDchan) then
        set cue to 1
        repeat with x = 255 down to 0
          set t to the timer + cue
          set the volume of sound gCRDchan to x
          repeat while the timer < t
          end repeat
        end repeat
        sound stop gCRDchan
        updateStage()
      end if
      mRestoreSystem(goNavMgr)
      quit()
  end case
end

on getCreditsLoopArt
  set idx to glCRDloopIdx
  repeat while idx = glCRDloopIdx
    set glCRDloopIdx to random(gCRDnbLoopMbrs)
  end repeat
  return getAt(glCRDloopArt, glCRDloopIdx)
end
