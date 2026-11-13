property delayBtwnFrames, nextFrameTime, offsetX, offsetY, crntAnimCycle, crntAnimIndex, animSprite, soundChan, objPaused, objectVisible, objAnimMode
global gdmoTextPoofLeftCycle, gdmoTextPoofRightCycle

on new this, sptChan, sndChan
  set the delayBtwnFrames of this to 1
  set the nextFrameTime of this to the timer
  set the crntAnimCycle of this to gdmoTextPoofLeftCycle
  set the crntAnimIndex of this to 1
  set the animSprite of this to sptChan
  set the soundChan of this to sndChan
  set the objPaused of this to 1
  set the objAnimMode of this to #resting
  set the objectVisible of this to 1
  set the offsetX of this to 0
  set the offsetY of this to 0
  puppetSprite(sptChan, 1)
  set the loc of sprite sptChan to point(-1000, 300)
  set the ink of sprite sptChan to 1
  return this
end

on launchTextPoof this, tpx, tpy, goLeftFlag
  set the delayBtwnFrames of this to 1
  set the nextFrameTime of this to the timer
  if goLeftFlag = 1 then
    set the crntAnimCycle of this to gdmoTextPoofLeftCycle
  else
    set the crntAnimCycle of this to gdmoTextPoofRightCycle
  end if
  set the crntAnimIndex of this to 1
  set the objPaused of this to 0
  set the objAnimMode of this to #animating
  set the objectVisible of this to 1
  set firstPoint to getAt(getAt(the crntAnimCycle of this, 1), 2)
  set the offsetX of this to tpx - getAt(firstPoint, 1)
  set the offsetY of this to tpy - getAt(firstPoint, 2) - getBaselineDroop(tpx, tpy)
  puppetSound(the soundChan of this, "textpoof.aiff")
end

on objUpdate this
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
        set animIdx to the crntAnimIndex of this
        set crntAnim to getAt(the crntAnimCycle of this, animIdx)
        set spt to the animSprite of this
        set mbr to getAt(crntAnim, 1)
        if mbr = -99 then
          set animIdx to 1
          set the objAnimMode of this to #resting
        else
          if the objectVisible of this then
            set the member of sprite spt to mbr
            set animLoc to getAt(crntAnim, 2)
            set thisX to getAt(animLoc, 1) + the offsetX of this
            set thisY to getAt(animLoc, 2) + the offsetY of this
            set thisY to thisY + getBaselineDroop(thisX, thisY)
            set the loc of sprite spt to point(thisX, thisY)
            set animIdx to animIdx + 1
          end if
        end if
        set the crntAnimIndex of this to animIdx
      end if
  end case
end

on objrollover this
end

on objClicked this
end

on objPlay this
  set the objPaused of this to 0
end

on objPause this
  set the objPaused of this to 1
  sound stop the soundChan of this
end

on objReset this
  set the objPaused of this to 1
  sound stop the soundChan of this
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
  sound stop the soundChan of this
end

on dump this
  put " TextPoof: ", this
end
