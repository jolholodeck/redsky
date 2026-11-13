global BaseNameChan

on turnOn num
  repeat with x = 0 to 4
    set the visible of sprite (BaseNameChan + x) to 0
  end repeat
  set the visible of sprite (((num - BaseNameChan - 2) / 3) + BaseNameChan - 1) to 1
  updateStage()
  puppetSound(2, "client click")
  repeat while soundBusy(2)
    nothing()
  end repeat
end

on turnOnAll
  repeat with x = 0 to 4
    set the visible of sprite (BaseNameChan + x) to 1
  end repeat
  updateStage()
  puppetSound(2, "client click")
  repeat while soundBusy(2)
    nothing()
  end repeat
end

on turnOffAll
  global ClientSelect
  set ClientSelect to EMPTY
  repeat with x = 0 to 4
    set the visible of sprite (BaseNameChan + x) to 0
  end repeat
  updateStage()
end
