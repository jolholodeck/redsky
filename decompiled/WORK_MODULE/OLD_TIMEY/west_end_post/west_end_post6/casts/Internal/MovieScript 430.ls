on startMovie
  global fixpal, startDepth, dummyOk, onceThru, year_counter, year_inc, i1, i2, i3, i4, i5, textSlot, stage, bg
  set fixpal to FixPalette(mnew, the stageLeft, the stageTop, the stageRight, the stageTop)
  set dummyOk to 0
  set the centerStage to 1
  set onceThru to 0
  set year_counter to 0
  set year_inc to 0
  set i1 to 0
  set i2 to 0
  set i3 to 0
  set i4 to 0
  set i5 to 0
  set textSlot to 10
  set stage to 1
  set startDepth to the colorDepth
  if the colorQD = 0 then
    go("noColor")
  else
    if the colorDepth <> 8 then
      go("chgColor")
    end if
  end if
end

on stopMovie
  global fixpal
  fixpal(mdispose)
  setColorDepth(0)
end

on keyDown
  CheckForExitKey()
end

on systemExitCleanupHandler
  put "CHILD: in systemExitCleanupHandler"
  sound stop 1
  sound stop 2
end

on setColorDepth whichWay
  global startDepth
  if whichWay = 1 then
    set the colorDepth to 8
  else
    if whichWay = 0 then
      set the colorDepth to startDepth
    end if
  end if
end

on patchPal
  global fixpal
  fixpal(mPatchIt)
end

on idle
  global year_counter, year_inc
  set year_counter to year_counter + year_inc
  set the text of cast "counter" to string(abs(year_counter))
end

on setYear stage
  global year_counter, year_inc
  if stage = 1 then
    set year_counter to -5230
    set year_inc to 0.5
  else
    if stage = 2 then
      set year_counter to 1400
      set year_inc to 0.20000000000000001
    else
      if stage = 3 then
        set year_counter to 1980
        set year_inc to 0.003
      end if
    end if
  end if
end

on set_puppets
  repeat with n = 4 to 8
    set the puppet of sprite n to 1
    set the visible of sprite n to 1
  end repeat
  repeat with n = 4 to 8
    set the cursor of sprite n to 199
  end repeat
  repeat with n = 10 to 15
    set the puppet of sprite n to 1
  end repeat
  updateStage()
end

on kill_puppets
  repeat with n = 4 to 8
    set the puppet of sprite n to 0
  end repeat
  repeat with n = 10 to 15
    set the puppet of sprite n to 0
  end repeat
  updateStage()
end

on reset_icons
  global i1, i2, i3, i4, i5
  set i1 to 0
  set i2 to 0
  set i3 to 0
  set i4 to 0
  set i5 to 0
  repeat with n = 4 to 8
    set the visible of sprite n to 1
  end repeat
end

on checkPass
  global onceThru
  if onceThru then
    go("nav")
  end if
end

on cursorState state
  if state = 1 then
    cursor(-1)
  else
    if state = 0 then
      cursor(200)
    end if
  end if
  updateStage()
end

on stg1_action
  global dummyOk
  if (the timer > (15 * 60)) and not dummyOk then
    helpDummy()
  end if
  stg1_sounds()
  stg1_rollovers()
  updateStage()
end

on helpDummy
  puppetSound("Thunk")
  updateStage()
  go("helpD")
end

on stg1_sounds
  set n to random(30)
  if n = 10 then
    puppetSound("Growl 2")
  else
    if n = 11 then
      puppetSound("Growl 3")
    else
      if n = 12 then
        puppetSound("drum3")
      end if
    end if
  end if
  updateStage()
end

on stg1_rollovers
  global textSlot, i1, i2, i3, i4, i5
  set flash to 0
  if rollOver(4) and not i1 then
    set flash to 1
    set the castNum of sprite textSlot to the number of member "iconA1txt"
  else
    if rollOver(5) and not i2 then
      set flash to 1
      set the castNum of sprite textSlot to the number of member "iconA2txt"
    else
      if rollOver(6) and not i3 then
        set flash to 1
        set the castNum of sprite textSlot to the number of member "iconA3txt"
      else
        if rollOver(7) and not i4 then
          set flash to 1
          set the castNum of sprite textSlot to the number of member "iconA4txt"
        else
          if rollOver(8) and not i5 then
            set flash to 1
            set the castNum of sprite textSlot to the number of member "iconA5txt"
          end if
        end if
      end if
    end if
  end if
  if flash then
    updateStage()
    repeat with n = 1 to 4
      set the ink of sprite textSlot to 3
      updateStage()
      set the ink of sprite textSlot to 0
      updateStage()
    end repeat
    set the castNum of sprite textSlot to the number of member "null_cast"
    updateStage()
  end if
end

on stg1_text origin
  global textSlot, dummyOk
  if origin = 1 then
    set the castNum of sprite textSlot to the number of member "iconA1txt"
  else
    if origin = 2 then
      set the castNum of sprite textSlot to the number of member "iconA2txt"
    else
      if origin = 3 then
        set the castNum of sprite textSlot to the number of member "iconA3txt"
      else
        if origin = 4 then
          set the castNum of sprite textSlot to the number of member "iconA4txt"
        else
          if origin = 5 then
            set the castNum of sprite textSlot to the number of member "iconA5txt"
          end if
        end if
      end if
    end if
  end if
  set textSlot to textSlot + 1
  updateStage()
  if textSlot = 11 then
    set the castNum of sprite 13 to the number of member "and"
    set dummyOk to 1
  else
    if textSlot = 12 then
      set the castNum of sprite 14 to the number of member "and"
    else
      if textSlot = 13 then
        stg1_combo(origin)
      end if
    end if
  end if
end

on stg1_combo lastText
  global i1, i2, i3, i4, i5, stage, textSlot
  set win to 0
  if i1 and i2 and i5 then
    puppetSound("drum3")
    updateStage()
    set win to 1
  else
    set the text of cast "loseMessage" to "Think skill and tools..."
    set the castNum of sprite 15 to the number of member "loseMessage"
    updateStage()
  end if
  startTimer()
  repeat with n = 10 to 15
    set the castNum of sprite n to the number of member "null_cast"
  end repeat
  set textSlot to 10
  repeat while the timer < (2 * 60)
  end repeat
  if win then
    kill_puppets()
    reset_icons()
    go("win1")
  else
    reset_icons()
    go("p1")
  end if
end

on stg2_action
  stg2_sounds()
  stg2_rollovers()
  updateStage()
end

on stg2_sounds
  set n to random(30)
  if n = 10 then
    puppetSound("horses")
  else
    if n = 11 then
      puppetSound("monk")
    else
      if n = 12 then
        puppetSound("sword")
      end if
    end if
  end if
end

on stg2_rollovers
  global textSlot, i1, i2, i3, i4, i5
  set flash to 0
  if rollOver(4) and not i1 then
    set flash to 1
    set the castNum of sprite textSlot to the number of member "iconB1txt"
  else
    if rollOver(5) and not i2 then
      set flash to 1
      set the castNum of sprite textSlot to the number of member "iconB2txt"
    else
      if rollOver(6) and not i3 then
        set flash to 1
        set the castNum of sprite textSlot to the number of member "iconB3txt"
      else
        if rollOver(7) and not i4 then
          set flash to 1
          set the castNum of sprite textSlot to the number of member "iconB4txt"
        else
          if rollOver(8) and not i5 then
            set flash to 1
            set the castNum of sprite textSlot to the number of member "iconB5txt"
          end if
        end if
      end if
    end if
  end if
  if flash then
    updateStage()
    repeat with n = 1 to 4
      set the ink of sprite textSlot to 3
      updateStage()
      set the ink of sprite textSlot to 0
      updateStage()
    end repeat
    set the castNum of sprite textSlot to the number of member "null_cast"
    updateStage()
  end if
end

on stg2_text origin
  global textSlot
  if origin = 1 then
    set the castNum of sprite textSlot to the number of member "iconB1txt"
  else
    if origin = 2 then
      set the castNum of sprite textSlot to the number of member "iconB2txt"
    else
      if origin = 3 then
        set the castNum of sprite textSlot to the number of member "iconB3txt"
      else
        if origin = 4 then
          set the castNum of sprite textSlot to the number of member "iconB4txt"
        else
          if origin = 5 then
            set the castNum of sprite textSlot to the number of member "iconB5txt"
          end if
        end if
      end if
    end if
  end if
  set textSlot to textSlot + 1
  updateStage()
  if textSlot = 11 then
    set the castNum of sprite 13 to the number of member "and"
  else
    if textSlot = 12 then
      set the castNum of sprite 14 to the number of member "and"
    else
      if textSlot = 13 then
        stg2_combo(origin)
      end if
    end if
  end if
end

on stg2_combo lastText
  global i1, i2, i3, i4, i5, stage, textSlot
  set win to 0
  if i1 and i3 and i5 then
    puppetSound("drum3")
    updateStage()
    set win to 1
  else
    set the text of cast "loseMessage" to "Think information revolution..."
    set the castNum of sprite 15 to the number of member "loseMessage"
    updateStage()
  end if
  startTimer()
  repeat with n = 10 to 15
    set the castNum of sprite n to the number of member "null_cast"
  end repeat
  set textSlot to 10
  repeat while the timer < (2 * 60)
  end repeat
  if win then
    kill_puppets()
    reset_icons()
    go("win2")
  else
    reset_icons()
    go("m1")
  end if
end

on stg3_action
  stg3_sounds()
  stg3_rollovers()
  updateStage()
end

on stg3_sounds
  set n to random(30)
  if n = 10 then
    puppetSound("horn")
  else
    if n = 11 then
      puppetSound("laugh")
    else
      if n = 12 then
        puppetSound("doo")
      end if
    end if
  end if
  updateStage()
end

on stg3_rollovers
  global textSlot, i1, i2, i3, i4, i5
  set flash to 0
  if rollOver(4) and not i1 then
    set flash to 1
    set the castNum of sprite textSlot to the number of member "iconC1txt"
  else
    if rollOver(5) and not i2 then
      set flash to 1
      set the castNum of sprite textSlot to the number of member "iconC2txt"
    else
      if rollOver(6) and not i3 then
        set flash to 1
        set the castNum of sprite textSlot to the number of member "iconC3txt"
      else
        if rollOver(7) and not i4 then
          set flash to 1
          set the castNum of sprite textSlot to the number of member "iconC4txt"
        else
          if rollOver(8) and not i5 then
            set flash to 1
            set the castNum of sprite textSlot to the number of member "iconC5txt"
          end if
        end if
      end if
    end if
  end if
  if flash then
    updateStage()
    repeat with n = 1 to 4
      set the ink of sprite textSlot to 3
      updateStage()
      set the ink of sprite textSlot to 0
      updateStage()
    end repeat
    set the castNum of sprite textSlot to the number of member "null_cast"
    updateStage()
  end if
end

on stg3_text origin
  global textSlot
  if origin = 1 then
    set the castNum of sprite textSlot to the number of member "iconC1txt"
  else
    if origin = 2 then
      set the castNum of sprite textSlot to the number of member "iconC2txt"
    else
      if origin = 3 then
        set the castNum of sprite textSlot to the number of member "iconC3txt"
      else
        if origin = 4 then
          set the castNum of sprite textSlot to the number of member "iconC4txt"
        else
          if origin = 5 then
            set the castNum of sprite textSlot to the number of member "iconC5txt"
          end if
        end if
      end if
    end if
  end if
  set textSlot to textSlot + 1
  updateStage()
  if textSlot = 11 then
    set the castNum of sprite 13 to the number of member "and"
  else
    if textSlot = 12 then
      set the castNum of sprite 14 to the number of member "and"
    else
      if textSlot = 13 then
        updateStage()
        stg3_combo(origin)
      end if
    end if
  end if
end

on stg3_combo lastText
  global i1, i2, i3, i4, i5, stage, textSlot
  set win to 0
  if i1 and i2 and i4 then
    set win to 1
  else
    set the text of cast "loseMessage" to "Think talent and technologies..."
    set the castNum of sprite 15 to the number of member "loseMessage"
    updateStage()
  end if
  startTimer()
  repeat with n = 10 to 15
    set the castNum of sprite n to the number of member "null_cast"
  end repeat
  set textSlot to 10
  repeat while the timer < (2 * 60)
  end repeat
  puppetTransition(23)
  if win then
    kill_puppets()
    reset_icons()
    go("win3")
  else
    reset_icons()
    go("w1")
  end if
end

on nav_sounds
  set n to random(100)
  if n = 1 then
    puppetSound("drum1")
  else
    if n = 2 then
      puppetSound("Growl 2")
    else
      if n = 3 then
        puppetSound("Growl 3")
      else
        if n = 5 then
          puppetSound("laugh")
        else
          if n = 6 then
            puppetSound("horn")
          else
            if n = 7 then
              puppetSound("horses")
            else
              if n = 8 then
                puppetSound("sword")
              else
                if n = 9 then
                  puppetSound("monk")
                else
                  if n = 10 then
                    puppetSound("doo")
                  else
                    if n = 11 then
                      puppetSound("drum3")
                    end if
                  end if
                end if
              end if
            end if
          end if
        end if
      end if
    end if
  end if
end
