property delayBtwnFrames, nextFrameTime, crntFlameMode, crntFlameCycle, crntFlameIndex, flameSprite, crntWaxMode, crntWaxCycle, crntWaxIndex, waxSprite, waxRestDelay, objPaused
global gdmoCandleIgniteCycle, gdmoCandleIdleCycle, gdmoCandleBlowLeftCycle, gdmoCandleBlowRghtCycle, gdmoCandleBlowOutCycle, gdmoCandleWaxLeftCycle, gdmoCandleWaxRightCycle, gdmoCandleWaxCenterCycle

on new this, flameChan, waxChan
  set the delayBtwnFrames of this to 2
  set the nextFrameTime of this to the timer
  set the crntFlameMode of this to #idle
  set the crntFlameCycle of this to gdmoCandleIdleCycle
  set the crntFlameIndex of this to 1
  set the flameSprite of this to flameChan
  set the crntWaxMode of this to #resting
  set the crntWaxCycle of this to gdmoCandleIdleCycle
  set the crntWaxIndex of this to 1
  set the waxSprite of this to waxChan
  set the waxRestDelay of this to the timer + 120 + random(240)
  set the objPaused of this to 0
  puppetSprite(waxChan, 0)
  puppetSprite(flameChan, 1)
  set the member of sprite flameChan to getAt(getAt(gdmoCandleIdleCycle, 1), 1)
  set the loc of sprite flameChan to getAt(getAt(gdmoCandleIdleCycle, 1), 2)
  return this
end

on objUpdate this
  if the objPaused of this then
    exit
  end if
  set nextTime to the nextFrameTime of this
  set now to the timer
  if now > nextTime then
    set nextTime to nextTime + the delayBtwnFrames of this
    if now > nextTime then
      set nextTime to now + the delayBtwnFrames of this
    end if
    set the nextFrameTime of this to nextTime
    set animIdx to the crntFlameIndex of this
    set crntAnim to getAt(the crntFlameCycle of this, animIdx)
    set spt to the flameSprite of this
    set mbr to getAt(crntAnim, 1)
    if mbr = -99 then
      set animIdx to 1
      set the crntFlameMode of this to #idle
      set the crntFlameCycle of this to gdmoCandleIdleCycle
      set the nextFrameTime of this to the timer
    else
      set the member of sprite spt to getAt(crntAnim, 1)
      set the loc of sprite spt to getAt(crntAnim, 2)
      set animIdx to animIdx + 1
    end if
    set the crntFlameIndex of this to animIdx
    case the crntWaxMode of this of
      #resting:
        if the timer > waxRestDelay then
          launchWaxAnimation(this)
        end if
      #animating:
        set animIdx to the crntWaxIndex of this
        set crntAnim to getAt(the crntWaxCycle of this, animIdx)
        set spt to the waxSprite of this
        set mbr to getAt(crntAnim, 1)
        if mbr = -99 then
          set animIdx to 1
          set the crntWaxMode of this to #resting
          set the crntWaxCycle of this to 0
          set the waxRestDelay of this to the timer + 120 + random(240)
          set the loc of sprite spt to point(-1000, 300)
          puppetSprite(the waxSprite of this, 0)
          if the crntFlameMode of this = #blowing then
            launchWaxAnimation(this)
          end if
        else
          set the member of sprite spt to mbr
          set the loc of sprite spt to getAt(crntAnim, 2)
          set animIdx to animIdx + 1
        end if
        set the crntWaxIndex of this to animIdx
    end case
  end if
end

on launchWaxAnimation this
  case random(3) of
    1:
      set the crntWaxCycle of this to gdmoCandleWaxLeftCycle
    2:
      set the crntWaxCycle of this to gdmoCandleWaxRightCycle
    3:
      set the crntWaxCycle of this to gdmoCandleWaxCenterCycle
  end case
  set the crntWaxMode of this to #animating
  set the crntWaxIndex of this to 1
  puppetSprite(the waxSprite of this, 1)
end

on objrollover this
  global gdmoLastMouseH, gdmoLastMouseV, gdmoCandleSndChan
  if gdmoLastMouseH <> the mouseH then
    if gdmoLastMouseH < the mouseH then
      if the crntFlameCycle of this <> gdmoCandleBlowRghtCycle then
        set the crntFlameCycle of this to gdmoCandleBlowRghtCycle
        set the crntFlameIndex of this to 1
        set the nextFrameTime of this to the timer
      end if
    else
      if the crntFlameCycle of this <> gdmoCandleBlowLeftCycle then
        set the crntFlameCycle of this to gdmoCandleBlowLeftCycle
        set the crntFlameIndex of this to 1
        set the nextFrameTime of this to the timer
      end if
    end if
    set the crntFlameMode of this to #blowing
    case random(2) of
      1:
        puppetSound(gdmoCandleSndChan, "candle.blow.1")
      2:
        puppetSound(gdmoCandleSndChan, "candle.blow.2")
    end case
    if the crntWaxMode of this <> #animating then
      launchWaxAnimation(this)
    end if
  end if
end

on objPlay this
  set the objPaused of this to 0
end

on objPause this
  set the objPaused of this to 1
end

on objReset this
end

on objHide this
  set the loc of sprite the flameSprite of this to point(-1000, 300)
  set the loc of sprite the waxSprite of this to point(-1000, 300)
  puppetSprite(the flameSprite of this, 0)
  puppetSprite(the waxSprite of this, 0)
end

on objShow this
  puppetSprite(the flameSprite of this, 1)
  puppetSprite(the waxSprite of this, 1)
end

on objDelete this
  set the loc of sprite the flameSprite of this to point(-1000, 300)
  set the loc of sprite the waxSprite of this to point(-1000, 300)
  puppetSprite(the flameSprite of this, 0)
  puppetSprite(the waxSprite of this, 0)
end

on dump this
  put " Candle: ", this
end

on checkState this
  put "crntFlameMode  " & crntFlameMode
  put "crntFlameCycle " & crntFlameCycle
  put "crntFlameIndex " & crntFlameIndex
  put "flameSprite    " & flameSprite
  put "crntWaxMode    " & crntWaxMode
  put "crntWaxCycle   " & crntWaxCycle
  put "crntWaxIndex   " & crntWaxIndex
  put "waxSprite      " & waxSprite
  put "waxRestDelay   " & waxRestDelay
end
