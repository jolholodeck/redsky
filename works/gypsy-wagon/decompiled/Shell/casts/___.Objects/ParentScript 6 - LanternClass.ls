property delayBtwnFrames, nextFrameTime, crntLanternCycle, crntLanternIndex, lanternSprite, objPaused, objectVisible
global gdmoLanternCycle

on new this, LanternChan
  set the delayBtwnFrames of this to 2
  set the nextFrameTime of this to the timer
  set the crntLanternCycle of this to gdmoLanternCycle
  set the crntLanternIndex of this to 1
  set the lanternSprite of this to LanternChan
  set the objectVisible of this to 1
  set the objPaused of this to 0
  puppetSprite(LanternChan, 1)
  set the member of sprite LanternChan to getAt(getAt(gdmoLanternCycle, 1), 1)
  set the loc of sprite LanternChan to getAt(getAt(gdmoLanternCycle, 1), 2)
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
    set animIdx to the crntLanternIndex of this
    set crntAnim to getAt(the crntLanternCycle of this, animIdx)
    set spt to the lanternSprite of this
    set mbr to getAt(crntAnim, 1)
    if mbr = -99 then
      set animIdx to 1
      set the nextFrameTime of this to the timer
    else
      if the objectVisible of this then
        set the member of sprite spt to mbr
        set the loc of sprite spt to getAt(crntAnim, 2)
        set animIdx to animIdx + 1
      end if
    end if
    set the crntLanternIndex of this to animIdx
  end if
end

on objrollover this
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
  set the loc of sprite the lanternSprite of this to point(-1000, 300)
  set the objectVisible of this to 0
  puppetSprite(the lanternSprite of this, 0)
end

on objShow this
  set the objectVisible of this to 1
  puppetSprite(the lanternSprite of this, 1)
end

on objDelete this
  objHide(this)
end

on dump this
  put " Lantern: ", this
end
