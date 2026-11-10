on doPause nbTicks
  set endTime to the timer + nbTicks
  repeat while the timer < endTime
    timer_idle()
    updateStage()
  end repeat
end
