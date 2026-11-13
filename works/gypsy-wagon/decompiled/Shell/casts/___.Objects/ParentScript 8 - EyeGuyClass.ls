property delayBtwnFrames, nextFrameTime, animRestDelay, crntAnimPos, crntAnimDest, crntAnimCycle, crntAnimIndex, jumpMember, animSprite, soundChan, objPaused, objectVisible, objAnimMode, clickCount, clickTime, clickGag1, clickGag2
global gdmoEyeGuyFrom1Cycle, gdmoEyeGuyFrom2Cycle, gdmoEyeGuyTo2Cycle, gdmoEyeGuyFrom3Cycle1, gdmoEyeGuyFrom3Cycle2, gdmoEyeGuyTo3Cycle, gdmoEyeGuyBlinkMember, gdmoEyeGuyDelayTo0, gdmoEyeGuyDelayFrom0

on new this, sptChan, sndChan
  set gdmoEyeGuyDelayTo0 to 12
  set gdmoEyeGuyDelayFrom0 to 2
  set the delayBtwnFrames of this to gdmoEyeGuyDelayTo0
  set the nextFrameTime of this to the timer
  set the animRestDelay of this to the timer + random(600) + 180
  set the crntAnimPos of this to 1
  set the crntAnimDest of this to 0
  set the crntAnimCycle of this to gdmoEyeGuyFrom1Cycle
  set the crntAnimIndex of this to 1
  set the jumpMember of this to gdmoEyeGuyBlinkMember
  set the animSprite of this to sptChan
  set the soundChan of this to sndChan
  set the objPaused of this to 0
  set the objAnimMode of this to #resting
  set the objectVisible of this to 1
  set the clickCount of this to 0
  set the clickTime of this to 0
  set the clickGag1 of this to 0
  set the clickGag2 of this to 0
  set gdmoEyeGuyBlinkMember to member "eyeguy00000"
  puppetSprite(sptChan, 1)
  set the loc of sprite sptChan to point(-1000, 300)
  return this
end

on objUpdate this
  if the objPaused of this then
    exit
  end if
  case the objAnimMode of this of
    #resting:
      if the timer > the animRestDelay of this then
        case the crntAnimPos of this of
          0:
            set the delayBtwnFrames of this to gdmoEyeGuyDelayFrom0
            case random(5) of
              1:
                set the member of sprite the animSprite of this to gdmoEyeGuyBlinkMember
                set the objAnimMode of this to #jumping
                set the crntAnimDest of this to 1
                set the jumpMember of this to getAt(getAt(gdmoEyeGuyFrom1Cycle, 1), 1)
                set the nextFrameTime of this to the timer + random(3) + 2
              2:
                set the member of sprite the animSprite of this to gdmoEyeGuyBlinkMember
                set the objAnimMode of this to #jumping
                set the crntAnimDest of this to 2
                set the jumpMember of this to getAt(getAt(gdmoEyeGuyFrom2Cycle, 1), 1)
                set the nextFrameTime of this to the timer + random(3) + 2
              3:
                set the member of sprite the animSprite of this to gdmoEyeGuyBlinkMember
                set the objAnimMode of this to #jumping
                set the crntAnimDest of this to 3
                set the jumpMember of this to getAt(getAt(gdmoEyeGuyFrom3Cycle1, 1), 1)
                set the nextFrameTime of this to the timer + random(3) + 2
              4:
                set the crntAnimCycle of this to gdmoEyeGuyTo2Cycle
                set the crntAnimDest of this to 2
                set the objAnimMode of this to #animating
              5:
                set the crntAnimCycle of this to gdmoEyeGuyTo3Cycle
                set the crntAnimDest of this to 3
                set the objAnimMode of this to #animating
            end case
          1:
            set the delayBtwnFrames of this to gdmoEyeGuyDelayTo0
            set the objAnimMode of this to #animating
            set the crntAnimDest of this to 0
            set the crntAnimCycle of this to gdmoEyeGuyFrom1Cycle
          2:
            set the delayBtwnFrames of this to gdmoEyeGuyDelayTo0
            set the objAnimMode of this to #animating
            set the crntAnimDest of this to 0
            set the crntAnimCycle of this to gdmoEyeGuyFrom2Cycle
          3:
            set the delayBtwnFrames of this to gdmoEyeGuyDelayTo0
            set the objAnimMode of this to #animating
            set the crntAnimDest of this to 0
            if random(2) = 1 then
              set the crntAnimCycle of this to gdmoEyeGuyFrom3Cycle1
            else
              set the crntAnimCycle of this to gdmoEyeGuyFrom3Cycle2
            end if
        end case
        set the crntAnimIndex of this to 1
        set the nextFrameTime of this to the timer
      end if
    #jumping:
      if the timer > the nextFrameTime of this then
        set the member of sprite the animSprite of this to the jumpMember of this
        set the objAnimMode of this to #resting
        set the crntAnimPos of this to the crntAnimDest of this
        set the animRestDelay of this to the timer + random(600) + 180
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
        set crntAnim to getAt(the crntAnimCycle of this, animIdx)
        set spt to the animSprite of this
        set mbr to getAt(crntAnim, 1)
        if mbr = -99 then
          set animIdx to 1
          set the objAnimMode of this to #resting
          set the crntAnimPos of this to the crntAnimDest of this
          set the delayBtwnFrames of this to gdmoEyeGuyDelayTo0
          if the crntAnimPos of this = 0 then
            if random(2) = 1 then
              set the animRestDelay of this to the timer + random(120)
            else
              set the animRestDelay of this to the timer + random(60) + 60
            end if
          else
            set the animRestDelay of this to the timer + random(600) + 120
          end if
        else
          if the objectVisible of this then
            set the member of sprite spt to mbr
            set the loc of sprite spt to getAt(crntAnim, 2)
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
  set cnum to the clickCount of this
  set cnum to cnum + 1
  if (cnum > 5) and (the clickGag1 of this = 0) then
    puppetSound(the soundChan of this, "clicker.nose")
    set the clickGag1 of this to 1
  end if
  if (cnum > 8) and (the clickGag2 of this = 0) then
    puppetSound(the soundChan of this, "clicker.thisdont")
    set the clickGag2 of this to 1
  end if
  if (the timer - the clickTime of this) > 7200 then
    set cnum to 1
    set the clickGag1 of this to 0
    set the clickGag2 of this to 0
  end if
  set the clickCount of this to cnum
  set the clickTime of this to the timer
end

on objPlay this
  set the objPaused of this to 0
end

on objPause this
  set the objPaused of this to 1
  sound stop the soundChan of this
end

on objReset this
  set the animRestDelay of this to the timer + random(120) + 60
  set the crntAnimPos of this to 1
  set the crntAnimDest of this to 0
  set the crntAnimCycle of this to gdmoEyeGuyFrom1Cycle
  set the crntAnimIndex of this to 1
  set the objAnimMode of this to #resting
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
  put " EyeGuy: ", this
end
