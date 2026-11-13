property delayBtwnFrames, nextFrameTime, crntMode, crntCycle, crntAnimIndex, CycleSprite, animRestDelay, soundChan, crntMusicIndex, objPaused
global gdmoCricketLegsCycle, gdmoCricketHeadCycle, gdmoCricketAntennaeCycle

on new this, sptChan, sndChan
  set the delayBtwnFrames of this to 2
  set the nextFrameTime of this to the timer
  set the crntMode of this to #resting
  set the crntCycle of this to 0
  set the crntAnimIndex of this to 1
  set the CycleSprite of this to sptChan
  set the animRestDelay of this to the timer + 60 + random(180)
  set the soundChan of this to sndChan
  set the crntMusicIndex of this to 0
  set the objPaused of this to 0
  puppetSprite(sptChan, 1)
  set the member of sprite sptChan to getAt(getAt(gdmoCricketLegsCycle, 1), 1)
  set the loc of sprite sptChan to getAt(getAt(gdmoCricketLegsCycle, 1), 2)
  return this
end

on objUpdate this
  if the objPaused of this then
    exit
  end if
  case the crntMode of this of
    #resting:
      if the timer > the animRestDelay of this then
        if random(2) = 1 then
          set the crntCycle of this to gdmoCricketLegsCycle
          puppetSound(the soundChan of this, "cricket.chirp.aiff")
        else
          set the crntCycle of this to gdmoCricketAntennaeCycle
        end if
        set the crntMode of this to #animating
        set the crntAnimIndex of this to 1
        set the nextFrameTime of this to the timer
      end if
    #playingMusic:
      set nextTime to the nextFrameTime of this
      set now to the timer
      if now > nextTime then
        set nextTime to nextTime + the delayBtwnFrames of this
        if now > nextTime then
          set nextTime to now + the delayBtwnFrames of this
        end if
        set the nextFrameTime of this to nextTime
        set animIdx to the crntAnimIndex of this
        set crntAnim to getAt(the crntCycle of this, animIdx)
        set spt to the CycleSprite of this
        set mbr to getAt(crntAnim, 1)
        if mbr = -99 then
          if soundBusy(gdmoCricketSndChan) then
            set animIdx to 1
          else
            set animIdx to 1
            set the crntMode of this to #resting
            set the crntCycle of this to 0
            set the animRestDelay of this to the timer + 60 + random(180)
            set the member of sprite spt to getAt(getAt(gdmoCricketLegsCycle, 1), 1)
          end if
        else
          set the member of sprite spt to getAt(crntAnim, 1)
          set the loc of sprite spt to getAt(crntAnim, 2)
          set animIdx to animIdx + 1
        end if
        set the crntAnimIndex of this to animIdx
      end if
    #animating:
      set nextTime to the nextFrameTime of this
      set now to the timer
      if now > nextTime then
        set nextTime to nextTime + the delayBtwnFrames of this
        if now > nextTime then
          set nextTime to now + the delayBtwnFrames of this
        end if
        set the nextFrameTime of this to nextTime
        set animIdx to the crntAnimIndex of this
        set crntAnim to getAt(the crntCycle of this, animIdx)
        set spt to the CycleSprite of this
        set mbr to getAt(crntAnim, 1)
        if mbr = -99 then
          set animIdx to 1
          set the crntMode of this to #resting
          set the crntCycle of this to 0
          set the animRestDelay of this to the timer + 60 + random(180)
          set the member of sprite spt to getAt(getAt(gdmoCricketLegsCycle, 1), 1)
        else
          set the member of sprite spt to mbr
          set the loc of sprite spt to getAt(crntAnim, 2)
          set animIdx to animIdx + 1
        end if
        set the crntAnimIndex of this to animIdx
      end if
  end case
end

on objrollover this
  if the crntMode of this = #resting then
    case random(2) of
      1:
        set the crntCycle of this to gdmoCricketHeadCycle
      otherwise:
        set the crntCycle of this to gdmoCricketAntennaeCycle
    end case
    set the crntMode of this to #animating
    set the crntAnimIndex of this to 1
    set the nextFrameTime of this to the timer
  end if
end

on objClicked this
  global gdmoExternalDataPath
  if the crntMode of this = #playingMusic then
    sound stop the soundChan of this
  else
    set the crntCycle of this to gdmoCricketLegsCycle
    set the crntMode of this to #playingMusic
    set the crntAnimIndex of this to 1
    set the nextFrameTime of this to the timer
    case the crntMusicIndex of this of
      0:
        sound playFile the soundChan of this, gdmoExternalDataPath & "cricket1.aif"
      1:
        sound playFile the soundChan of this, gdmoExternalDataPath & "cricket2.aif"
    end case
    set the crntMusicIndex of this to 1 - the crntMusicIndex of this
  end if
end

on objPlay this
  set the objPaused of this to 0
end

on objPause this
  set the objPaused of this to 1
  sound stop the soundChan of this
end

on objReset this
end

on objHide this
  set the loc of sprite the CycleSprite of this to point(-1000, 300)
  puppetSprite(the CycleSprite of this, 0)
end

on objShow this
  puppetSprite(the CycleSprite of this, 1)
end

on objDelete this
  set the loc of sprite the CycleSprite of this to point(-1000, 300)
  puppetSprite(the CycleSprite of this, 0)
  sound stop the soundChan of this
end

on dump this
  put " Cricket: ", this
  put "  crntMode:  " & the crntMode of this
end
