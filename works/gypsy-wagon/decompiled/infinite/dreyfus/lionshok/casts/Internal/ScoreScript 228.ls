on exitFrame
  global shortCutHiliteCh, afterClose, section
  set the locH of sprite shortCutHiliteCh to -1000
  set section to word 1 of afterClose
  go(afterClose)
end
