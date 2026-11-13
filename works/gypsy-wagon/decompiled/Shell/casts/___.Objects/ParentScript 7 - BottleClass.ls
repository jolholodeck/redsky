property delayBtwnFrames, nextFrameTime, cycleIn, cycleLoop, cycleOut, smokeCycle, smokeEvents, smokeEvtIdx, smokeNxtEvt, smokeNxtEvtMbr, crntAnimState, crntAnimIndex, animSprite, mainSndChan, eventSndChan, sndInRampVal, sndOutRampVal, mainSndVol, soundFadeState, objPaused, objectVisible, objAnimMode
global gdmoSmokeIsPlaying, gdmoFiniteBottle, gdmoInfiniteBottle, gdmoMadBottle

on new this, sptChan, mainSndChn, evntSndChn, cyIn, cyLoop, cyOut, smkCycle, smkEvents
  set the delayBtwnFrames of this to 2
  set the nextFrameTime of this to the timer
  set the cycleIn of this to cyIn
  set the cycleLoop of this to cyLoop
  set the cycleOut of this to cyOut
  set the smokeCycle of this to smkCycle
  set the smokeEvents of this to smkEvents
  set the smokeEvtIdx of this to 1
  set the smokeNxtEvt of this to 0
  set the smokeNxtEvtMbr of this to 0
  set the crntAnimState of this to #cycleIn
  set the crntAnimIndex of this to 1
  set the animSprite of this to sptChan
  set the mainSndChan of this to mainSndChn
  set the eventSndChan of this to evntSndChn
  set the objPaused of this to 0
  set the objAnimMode of this to #resting
  set the objectVisible of this to 1
  set the sndInRampVal of this to 0
  set the sndOutRampVal of this to 0
  set the mainSndVol of this to 0
  set the soundFadeState of this to #steady
  puppetSprite(sptChan, 1)
  set the loc of sprite sptChan to point(-1000, 300)
  return this
end

on objUpdate this
  global gdmoTheQuill, gdmoCrntMenu
  if the objPaused of this then
    exit
  end if
  case the objAnimMode of this of
    #resting:
    #animating:
      set nextTime to the nextFrameTime of this
      set now to the timer
      if now > nextTime then
        set nextTime to nextTime + the delayBtwnFrames of this
        if now > nextTime then
          set nextTime to now + the delayBtwnFrames of this
        end if
        set the nextFrameTime of this to nextTime
        case the soundFadeState of this of
          #rising:
            set vol to the mainSndVol of this
            set vol to vol + the sndInRampVal of this
            if vol > 255 then
              set vol to 255
              set the soundFadeState of this to #steady
            end if
            set the volume of sound the mainSndChan of this to vol
            set the mainSndVol of this to vol
          #steady:
          #fading:
            set vol to the mainSndVol of this
            set vol to vol - the sndOutRampVal of this
            if vol < 0 then
              set vol to 0
              set the soundFadeState of this to #steady
            end if
            set the volume of sound the mainSndChan of this to vol
            set the mainSndVol of this to vol
        end case
        set animIdx to the crntAnimIndex of this
        set animState to the crntAnimState of this
        set spt to the animSprite of this
        if animState <> #smoking then
          case animState of
            #cycleIn:
              set crntAnim to getAt(the cycleIn of this, animIdx)
            #cycleLoop:
              set crntAnim to getAt(the cycleLoop of this, animIdx)
            #cycleOut:
              set crntAnim to getAt(the cycleOut of this, animIdx)
          end case
          set mbr to getAt(crntAnim, 1)
          if mbr = -99 then
            set animIdx to 1
            case animState of
              #cycleIn:
                set the crntAnimState of this to #cycleLoop
                set the soundFadeState of this to #steady
              #cycleLoop:
                if rollOver(spt) then
                  set the crntAnimState of this to #cycleLoop
                else
                  set the crntAnimState of this to #cycleOut
                  set the soundFadeState of this to #fading
                end if
              #cycleOut:
                set the crntAnimState of this to #cycleIn
                set the objAnimMode of this to #resting
                set the loc of sprite spt to point(-1000, 300)
                sound stop the mainSndChan of this
            end case
          else
            if the objectVisible of this then
              set the member of sprite spt to mbr
              set the loc of sprite spt to getAt(crntAnim, 2)
              set animIdx to animIdx + 1
            end if
          end if
        end if
        set the crntAnimIndex of this to animIdx
      end if
  end case
end

on objrollover this
  if the objAnimMode of this = #resting then
    set the objAnimMode of this to #animating
    set the crntAnimState of this to #cycleIn
    set the crntAnimIndex of this to 1
    if soundBusy(the mainSndChan of this) = 0 then
      case this of
        gdmoInfiniteBottle:
          puppetSound(the mainSndChan of this, "infinite.roll.loop")
        gdmoFiniteBottle:
          puppetSound(the mainSndChan of this, "finite.roll.loop")
        gdmoMadBottle:
          puppetSound(the mainSndChan of this, "madness.roll.loop")
      end case
    end if
    set the sndInRampVal of this to 255.0 / count(the cycleIn of this)
    set the sndOutRampVal of this to 255.0 / count(the cycleOut of this)
    set the soundFadeState of this to #rising
  end if
end

on objClicked this
  global gdmoCricket, gdmoCricketSndChan
  if (gdmoSmokeIsPlaying = 0) and (the objAnimMode of this <> #smoking) then
    if the crntMode of gdmoCricket = #playingMusic then
      sound stop gdmoCricketSndChan
    end if
    set the objAnimMode of this to #animating
    set the crntAnimState of this to #smoking
    set the crntAnimIndex of this to 1
    set gdmoSmokeIsPlaying to 1
    if count(the smokeEvents of this) > 0 then
      set the smokeEvtIdx of this to 1
      set thisEvent to getAt(the smokeEvents of this, 1)
      set the smokeNxtEvtMbr of this to getAt(thisEvent, 1)
      set the smokeNxtEvt of this to getAt(thisEvent, 2)
    else
      set the smokeEvtIdx of this to 1
      set the smokeNxtEvt of this to 0
      set the smokeNxtEvtMbr of this to 0
    end if
    sound stop the mainSndChan of this
    set the loc of sprite the animSprite of this to point(-1000, 300)
    set the volume of sound the mainSndChan of this to 0
    case this of
      gdmoInfiniteBottle:
        puppetSound(the mainSndChan of this, "infLoop")
        go("InfiniteSmokeCycle")
      gdmoFiniteBottle:
        puppetSound(the mainSndChan of this, "finLoop")
        go("FiniteSmokeCycle")
      gdmoMadBottle:
        puppetSound(the mainSndChan of this, "madLoop")
        go("MadnessSmokeCycle")
    end case
    set the sndInRampVal of this to 255.0 / 60
    set the sndOutRampVal of this to 255.0 / 60
    set the mainSndVol of this to 0
    set the soundFadeState of this to #rising
  end if
end

on bottleCleanupSmoke this
  set the objAnimMode of this to #resting
  set the crntAnimState of this to #cycleIn
  set gdmoSmokeIsPlaying to 0
  sound stop the mainSndChan of this
end

on objPlay this
  set the objPaused of this to 0
end

on objPause this
  set the objPaused of this to 1
  sound stop the mainSndChan of this
  sound stop the eventSndChan of this
end

on objReset this
  set the crntAnimState of this to #cycleIn
  set the crntAnimIndex of this to 1
end

on objHide this
  set the loc of sprite the animSprite of this to point(-1000, 300)
  set the objectVisible of this to 0
  puppetSprite(the animSprite of this, 0)
end

on objShow this
  set the objectVisible of this to 1
  puppetSprite(the animSprite of this, 1)
end

on objDelete this
  set the loc of sprite the animSprite of this to point(-1000, 300)
  set the objectVisible of this to 0
  puppetSprite(the animSprite of this, 0)
  sound stop the mainSndChan of this
  sound stop the eventSndChan of this
end

on dump this
  put " Bottle: ", this
end
