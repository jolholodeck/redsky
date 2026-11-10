on exitFrame
  global gOnBanner, gBannerTimer, gBannerSlow, gQuitTime
  if gQuitTime < the timer then
    set myDist to the mouseV - 60
    set mySpeed to 5
    if (myDist > 0) and (myDist < 360) then
      set gOnBanner to 0
      set mySpeed to (360 - myDist) / 3
      set myMove to mySpeed / 10
    else
      if rollOver(2) then
        if not gOnBanner then
          sound stop 1
          puppetSound(1, 9)
          set gBannerTimer to 0
        end if
        set gOnBanner to 1
        set mySpeed to 5
        set myMove to 40
      else
        if (myDist > -61) and (myDist < 0) then
          set mySpeed to 5
          set myMove to 40
        else
          if myDist < -60 then
            set gOnBanner to 0
            set myDist to (myDist + 60) * -1
            set mySpeed to (360 - myDist) / 3
            set mySpeed to mySpeed * 0.5
            set myMove to mySpeed / 5
          end if
        end if
      end if
    end if
    if not soundBusy(1) and not gOnBanner then
      puppetSound(1, 10)
    end if
    if myMove < 1 then
      set myMove to 1
    end if
    set the locH of sprite 10 to the locH of sprite 10 - myMove
    if (the castNum of sprite 10 = 20) and (the locH of sprite 10 < 230) and gBannerSlow then
      set the locH of sprite 10 to 234
      set gBannerSlow to 0
      set gQuitTime to the timer + 180
      sound stop 1
    else
      if the right of sprite 10 < 0 then
        if ((the right of sprite 10 < (-200 - random(48000))) and not soundBusy(1)) or not gOnBanner then
          if gOnBanner and (gBannerTimer > 2) then
            set myCast to 20
            set gBannerTimer to 0
            set gBannerSlow to 1
          else
            set gBannerTimer to gBannerTimer + 1
            set gBannerSlow to 0
            if gOnBanner then
              puppetSound(1, 9)
            end if
            set myCast to 24
            if (myMove > 4) and (myMove < 9) then
              set myCast to myCast + 1
            end if
            if myMove > 8 then
              set myCast to myCast + 2
            end if
          end if
          set the castNum of sprite 10 to myCast
          set the locH of sprite 10 to the stageRight + (the width of cast the castNum of sprite 10 / 2)
        end if
      end if
    end if
  end if
  set the locH of sprite 13 to the locH of sprite 13 + 1
  if the left of sprite 13 > the stageRight then
    set the locH of sprite 13 to the stageLeft - (the width of cast the castNum of sprite 13 / 2)
  end if
  set the volume of sound 1 to 10 + (myMove * 20)
  go(the frame)
end
