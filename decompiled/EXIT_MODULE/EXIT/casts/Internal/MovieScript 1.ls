global kStartExitFrame, kEndExitFrame, gDoClickThru, kEndSnd, gLastkey

on startMovie
  startTimer()
  set kStartExitFrame to label("startExit")
  set kEndExitFrame to label("endExit")
  set kEndSnd to 110
  preLoad(kStartExitFrame, kEndExitFrame)
  preloadMember(19, 26)
  preloadMember(29)
  preloadMember(kEndSnd)
  timer_init()
  flicker_init()
  set gDoClickThru to 0
  loadCreditsData()
  timer_addFinite(#gFlicker_dust, 3, "flicker_dust")
  timer_addFinite(#newFlicker, 1, "flickerLight")
  flicker_splicecut(2, "startExit")
  cursor([71, 72])
  set the keyDownScript to "keyDownHandler"
  set the keyUpScript to "keyUpHandler"
end

on idle
  timer_idle()
  credits_idle()
  clickThru_idle()
end

on keyDownHandler
  set gLastkey to the key
end

on keyUpHandler
  set gLastkey to EMPTY
end

on flickerLight
  puppetPalette("Palette2", 60)
  updateStage()
  timer_addFinite(#newFlicker, 3, "flickerDark")
end

on flickerDark
  puppetPalette("Palette1", 60)
  updateStage()
  timer_addFinite(#newFlicker, 3, "flickerLight")
end

on clickThru_idle
  if not gDoClickThru then
    exit
  end if
  if the timer < 60 then
    exit
  end if
  if the mouseDown or ((the lastKey < 10) and (gLastkey = " ")) then
    set gDoClickThru to 0
    puppetSound(1, 0)
    jumpToCredits()
  end if
end

on jumpToCredits
  global gFlicker_dustMember, gFlicker_dustAmount
  puppetPalette(0)
  repeat with i = gFlicker_dustMember to gFlicker_dustMember + gFlicker_dustAmount - 1
    set the locH of sprite i to -1000
  end repeat
  timer_kill(#gFlicker_dust)
  timer_kill(#newFlicker)
  flicker_splicecut(1, "splicecut")
end
