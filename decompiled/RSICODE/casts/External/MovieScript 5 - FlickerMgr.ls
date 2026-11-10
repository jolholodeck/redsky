global goNavMgr, gFlicker_dustMember, gFlicker_state, gsplicespritebottom, gsplicespritetop, gFlicker_dustAmount, lTempPuppets

on flicker_init
  set gFlicker_dustMember to 112
  set gFlicker_dustAmount to 4
  repeat with i = gFlicker_dustMember to gFlicker_dustMember + gFlicker_dustAmount - 1
    puppetSprite(i, 1)
  end repeat
  set gFlicker_state to #off
  set gsplicespritebottom to 110
  set gsplicespritetop to 111
end

on flicker_setstate thestate
  if gFlicker_state = thestate then
    exit
  end if
  if thestate = #on then
    timer_addFinite(#flicker_palette, 1, "flicker_paletteShiftLight")
    timer_addFinite(#flicker_filmJerk, random(10) * 60, "flicker_filmJerk")
    timer_addFinite(#gFlicker_dust, 3, "flicker_dust")
  else
    repeat with i = gFlicker_dustMember to gFlicker_dustMember + gFlicker_dustAmount - 1
      set the loc of sprite i to point(-320, -240)
    end repeat
    timer_kill(#flicker_palette)
    timer_kill(#flicker_filmJerk)
    timer_kill(#gFlicker_dust)
    puppetPalette(0)
  end if
  set gFlicker_state to thestate
end

on flicker_jumpcut thedelay, hShift, vShift
  set lTempPuppets to []
  repeat with ch = 1 to 120
    if the type of the member of sprite ch <> #empty then
      if the puppet of sprite ch = 0 then
        append(lTempPuppets, ch)
        puppetSprite(ch, 1)
      end if
      set the locH of sprite ch to the locH of sprite ch + hShift
      set the locV of sprite ch to the locV of sprite ch - vShift
    end if
  end repeat
  updateStage()
  startTimer()
  repeat while the timer < thedelay
  end repeat
  repeat with ch = 1 to 120
    if the type of the member of sprite ch <> #empty then
      set the locH of sprite ch to the locH of sprite ch - hShift
      set the locV of sprite ch to the locV of sprite ch + vShift
    end if
  end repeat
  if the iCurModuleID of goNavMgr <> #speaker then
    repeat with ch in lTempPuppets
      puppetSprite(ch, 0)
    end repeat
  end if
  updateStage()
end

on flicker_splicecut thedelay, nextFrame
  set the member of sprite gsplicespritebottom to member "g_splicebottom"
  set the loc of sprite gsplicespritebottom to point(320, 445)
  updateStage()
  startTimer()
  repeat while the timer < thedelay
  end repeat
  set the locH of sprite gsplicespritebottom to -1000
  set the member of sprite gsplicespritetop to member "g_splicetop"
  set the loc of sprite gsplicespritetop to point(320, 28)
  go(nextFrame)
  startTimer()
  repeat while the timer < thedelay
  end repeat
  set the locH of sprite gsplicespritetop to -1000
end

on flicker_splicecutpart1
  set the member of sprite gsplicespritebottom to member "g_splicebottom"
  set the loc of sprite gsplicespritebottom to point(320, 445)
  updateStage()
end

on flicker_splicecutpart2 thedelay
  set the locH of sprite gsplicespritebottom to -1000
  set the member of sprite gsplicespritetop to member "g_splicetop"
  set the loc of sprite gsplicespritetop to point(320, 28)
  updateStage()
  flicker_jumpcut(1, 2, 1)
  startTimer()
  repeat while the timer < thedelay
  end repeat
  set the locH of sprite gsplicespritetop to -1000
end

on flicker_paletteShiftLight
  puppetPalette("Palette2", 60)
  timer_addFinite(#flicker_palette, 3, "flicker_paletteShiftDark")
end

on flicker_paletteShiftDark
  puppetPalette(0)
  timer_addFinite(#flicker_palette, 3, "flicker_paletteShiftLight")
end

on flicker_filmJerk
  flicker_jumpcut(1, random(5) - 3, random(5) - 3)
  timer_addFinite(#flicker_filmJerk, random(10) * 60, "flicker_filmJerk")
end

on flicker_dust
  repeat with i = gFlicker_dustMember to gFlicker_dustMember + gFlicker_dustAmount - 1
    set the member of sprite i to member ("dust" & string(random(12)))
    set the loc of sprite i to point(random(640), random(480))
  end repeat
  timer_addFinite(#gFlicker_dust, 6, "flicker_dust")
end
