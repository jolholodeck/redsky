global gLastH, gLastV, gLastR, gMaxPeeking, gExitCurling, gLogoBreathing, gGoOutAndPlay, gCrntMode, gMarketingOn, gLogoBreathList, gMetronome, gRoleCallCount, gRoleCallDelay, gFlashingIS, gFlashingDOES, gFlashingFasterBadder, gMaxSoleStomping, gIsPCversion, gNumAnimationsRunning

on updateEyes
  if (the mouseH > 80) and (the mouseH < 140) and ((the mouseV > 226) and (the mouseV < 264)) then
    set extraX to (the mouseV - 242) / 6
    set the locH of sprite 31 to 84 + 7 - abs(extraX)
    set the locV of sprite 31 to the mouseV - extraX
    set the locH of sprite 32 to 136 - 7 + abs(extraX)
    set the locV of sprite 32 to the mouseV - extraX
  else
    set dy to the mouseV - 242.0
    set dy2 to dy * dy
    set dx to the mouseH - 84.0
    set dr to sqrt((dx * dx) + dy2)
    set the locH of sprite 31 to 84 + (7.0 * (dx / dr))
    set the locV of sprite 31 to 242 + (20.0 * (dy / dr))
    set dx to the mouseH - 136.0
    set dr to sqrt((dx * dx) + dy2)
    set the locH of sprite 32 to 136 + (7.0 * (dx / dr))
    set the locV of sprite 32 to 242 + (20.0 * (dy / dr))
  end if
  if (the mouseH > 65) and (the mouseH < 155) then
    if the mouseV < 232 then
      set the castNum of sprite 30 to cast "Brows Up"
      set the locV of sprite 30 to 200
    else
      if the mouseV > 250 then
        set the castNum of sprite 30 to cast "Brows Down"
        set the locV of sprite 30 to 210
      else
        set the castNum of sprite 30 to cast "Brows Normal"
        set the locV of sprite 30 to 210
      end if
    end if
  else
    if the mouseV < 150 then
      set the castNum of sprite 30 to cast "Brows Up"
      set the locV of sprite 30 to 200
    else
      if the mouseV > 300 then
        set the castNum of sprite 30 to cast "Brows Down"
        set the locV of sprite 30 to 210
      else
        set the castNum of sprite 30 to cast "Brows Normal"
        set the locV of sprite 30 to 210
      end if
    end if
  end if
end

on updateHologram
  global gMetronome
  set holoX to the mouseH - 425
  set holoY to the mouseV - 226
  set crntShoe to cast "holo.O"
  if gIsPCversion = 1 then
    set px to holoX / 19.89999999999999858
    set py to holoY / 14.59999999999999964
    if (px + py) > 10.0 then
      if px > py then
        if holoX < 120 then
          set crntShoe to cast "holo.O"
        else
          if holoX < 160 then
            set crntShoe to cast "holo.E1"
          else
            set crntShoe to cast "holo.E2"
          end if
        end if
      else
        if holoY < 100 then
          set crntShoe to cast "holo.O"
        else
          if holoY < 130 then
            set crntShoe to cast "holo.S1"
          else
            set crntShoe to cast "holo.S2"
          end if
        end if
      end if
    else
      if px > py then
        if holoY > 50 then
          set crntShoe to cast "holo.O"
        else
          if holoY > 20 then
            set crntShoe to cast "holo.N1"
          else
            set crntShoe to cast "holo.N2"
          end if
        end if
      else
        if holoX > 60 then
          set crntShoe to cast "holo.O"
        else
          if holoX > 30 then
            set crntShoe to cast "holo.W1"
          else
            set crntShoe to cast "holo.W2"
          end if
        end if
      end if
    end if
  else
    if holoX < 30 then
      if holoY < 60 then
        set crntShoe to cast "holo.NW2"
      else
        if holoY < 90 then
          set crntShoe to cast "holo.W2"
        else
          set crntShoe to cast "holo.SW2"
        end if
      end if
    end if
    if (holoX > 29) and (holoX < 80) then
      if holoY < 20 then
        set crntShoe to cast "holo.NW2"
      else
        if holoY < 50 then
          set crntShoe to cast "holo.NW1"
        else
          if holoY < 100 then
            set crntShoe to cast "holo.W1"
          else
            if holoY < 130 then
              set crntShoe to cast "holo.SW1"
            else
              set crntShoe to cast "holo.SW2"
            end if
          end if
        end if
      end if
    end if
    if (holoX > 79) and (holoX < 120) then
      if holoY < 20 then
        set crntShoe to cast "holo.N2"
      else
        if holoY < 50 then
          set crntShoe to cast "holo.N1"
        else
          if holoY < 100 then
            set crntShoe to cast "holo.O"
          else
            if holoY < 130 then
              set crntShoe to cast "holo.S1"
            else
              set crntShoe to cast "holo.S2"
            end if
          end if
        end if
      end if
    end if
    if (holoX > 119) and (holoX < 160) then
      if holoY < 20 then
        set crntShoe to cast "holo.NE2"
      else
        if holoY < 50 then
          set crntShoe to cast "holo.NE1"
        else
          if holoY < 100 then
            set crntShoe to cast "holo.E1"
          else
            if holoY < 130 then
              set crntShoe to cast "holo.SE1"
            else
              set crntShoe to cast "holo.SE2"
            end if
          end if
        end if
      end if
    end if
    if holoX > 159 then
      if holoY < 50 then
        set crntShoe to cast "holo.NE2"
      else
        if holoY < 100 then
          set crntShoe to cast "holo.E2"
        else
          set crntShoe to cast "holo.SE2"
        end if
      end if
    end if
  end if
  set the castNum of sprite 33 to crntShoe
end

on updateWalkingMax
  global maxLocX, maxLocY, maxCycle, maxDirectionX, maxDirectionY, maxSpeedX, maxSpeedY, maxWalkingTimer, maxWalkingTimerDelay, targetLocX, targetLocY
  if (abs(maxLocX - targetLocX) < 45) and (abs(maxLocY - targetLocY) < 60) then
    go("Max Gets Squished")
  end if
  if rollOver(9) then
    if random(2) = 1 then
      set maxDirectionX to 2 - maxDirectionX
    end if
    if random(2) = 1 then
      set maxDirectionY to 2 - maxDirectionY
    end if
    if soundBusy(1) = 0 then
      puppetSound("hey!")
    end if
  end if
  set maxWalkingTimer to maxWalkingTimer + 1
  if maxWalkingTimer > maxWalkingTimerDelay then
    if soundBusy(1) = 0 then
      puppetSound("hey!")
    end if
    set maxWalkingTimer to 0
    set maxWalkingTimerDelay to 10 + random(30)
  end if
  set maxCycle to 1 - maxCycle
  if maxDirectionX = 2 then
    if maxCycle = 0 then
      set the castNum of sprite 9 to cast "Max.R.talk"
    else
      set the castNum of sprite 9 to cast "Max.R.wink"
    end if
  else
    if maxCycle = 0 then
      set the castNum of sprite 9 to cast "Max.L.talk"
    else
      set the castNum of sprite 9 to cast "Max.L.wink"
    end if
  end if
  set maxLocX to maxLocX + (maxSpeedX * (maxDirectionX - 1))
  set maxLocY to maxLocY + (maxSpeedY * (maxDirectionY - 1))
  set the locH of sprite 9 to maxLocX
  set the locV of sprite 9 to maxLocY
  if maxLocX < 45 then
    set maxLocX to 45
    set maxDirectionX to 2
    set maxSpeedX to 10 + random(15)
  end if
  if maxLocX > 598 then
    set maxLocX to 598
    set maxDirectionX to 0
    set maxSpeedX to 10 + random(15)
  end if
  if maxLocY < 48 then
    set maxLocY to 48
    set maxDirectionY to 2
    set maxSpeedY to 10 + random(10)
  end if
  if maxLocY > 431 then
    set maxLocY to 431
    set maxDirectionY to 0
    set maxSpeedY to 10 + random(10)
  end if
  set px to maxLocX - targetLocX
  set py to maxLocY - targetLocY
  set r to abs(px) + abs(py)
  set px to 2.0 * px / r
  set py to 2.0 * py / r
  set targetLocX to targetLocX + px
  set targetLocY to targetLocY + py
  set the locH of sprite 30 to targetLocX
  set the locV of sprite 30 to targetLocY
end

on updateJohnsonAnimation
  if rollOver(14) then
    if the mouseV < 321 then
      set the castNum of sprite 34 to cast "Johnson.3"
      set the locH of sprite 34 to 332
      set the locV of sprite 34 to 344
    end if
    if (the mouseV > 320) and (the mouseV < 347) then
      set the castNum of sprite 34 to cast "Johnson.2"
      set the locH of sprite 34 to 332
      set the locV of sprite 34 to 343
    end if
    if (the mouseV > 346) and (the mouseV < 373) then
      set the castNum of sprite 34 to cast "Johnson.1"
      set the locH of sprite 34 to 332
      set the locV of sprite 34 to 346
    end if
    if the mouseV > 372 then
      set the locH of sprite 34 to 730
    end if
  end if
end

on updatePippinAnimation
  if rollOver(12) then
    if the mouseV < 316 then
      if the mouseH > 475 then
        set the castNum of sprite 34 to cast "Pippin.1"
        set the locH of sprite 34 to 477
        set the locV of sprite 34 to 316
      else
        set the castNum of sprite 34 to cast "Pippin.2"
        set the locH of sprite 34 to 477
        set the locV of sprite 34 to 316
      end if
    end if
    if the mouseV > 315 then
      set the locH of sprite 34 to 750
    end if
  end if
end

on incrementMarketingSequence
  set gMarketingOn to gMarketingOn + 1
  if gCrntMode = 20 then
    puppetSound("stamp.aiff")
    if gMarketingOn = 1 then
      go("Uptempo.Marketing")
    end if
    if gMarketingOn = 2 then
      go("Uptempo.Marketing.2")
    end if
    if gMarketingOn > 2 then
      set gMarketingOn to 0
      go("Uptempo Shoe")
    end if
  end if
  if gCrntMode = 30 then
    puppetSound("stamp.aiff")
    if gMarketingOn = 1 then
      go("AirMax.Marketing")
    end if
    if gMarketingOn = 2 then
      go("AirMax.Marketing.2")
    end if
    if gMarketingOn > 2 then
      set gMarketingOn to 0
      go("AirMax Shoe")
    end if
  end if
  if gCrntMode = 40 then
    set gMarketingOn to 0
  end if
end
