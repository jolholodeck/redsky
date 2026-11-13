property iLoSignal

on new me, Ldat
  iLoSignal = []
  repeat with n = 1 to Ldat.count
    oLFO = Ldat[n][1]
    amp = Ldat[n][2]
    blnRnd = Ldat[n][3]
    blnPosNums = Ldat[n][4]
    iLoSignal.append(new(script("Cycle Processer.class"), oLFO, amp, blnRnd, blnPosNums))
  end repeat
  return me
end

on mSetStepsPerCycle me, signalIDX, newStepsPerCycle
  iLoSignal[signalIDX].mSetStepsPerCycle(newStepsPerCycle)
end

on mSetAmp me, signalIDX, newAmp
  iLoSignal[signalIDX].mSetAmp(newAmp)
end

on mStep me
  val = 0
  repeat with n = 1 to iLoSignal.count
    val = val + iLoSignal[n].mStep()
  end repeat
  return val
end
