property ioLFO, iAmp, iBase, iMaxStepsPerCycle, iMaxAmp, iBlnRnd, iBlnPositiveNumbers

on new me, oLFO, amp, blnRnd, blnPositiveNumbers
  iBlnRnd = blnRnd
  iBlnPositiveNumbers = blnPositiveNumbers
  ioLFO = oLFO
  ioLFO.ioCallBack = me
  iMaxStepsPerCycle = ioLFO.iStepsPerCycle
  iMaxAmp = amp / 2.0
  iAmp = iMaxAmp
  iBase = iAmp
  return me
end

on mCycleDone me
  if iBlnRnd then
    iAmp = random(iMaxAmp)
    newStepsPerCycle = max(2, random(iMaxStepsPerCycle))
    ioLFO.mSetIncr(newStepsPerCycle)
    case ioLFO.iCycleStart of
      (-1):
        iBase = iAmp
      1:
        iBase = (iMaxAmp * 2) - iAmp
    end case
  end if
end

on mSetStepsPerCycle me, newStepsPerCycle
  iMaxStepsPerCycle = newStepsPerCycle
end

on mSetAmp me, newAmp
  iMaxAmp = newAmp / 2.0
  iAmp = iMaxAmp
  iBase = iAmp
end

on mStep me
  val = ioLFO.mStep() * iAmp
  if ioLFO.iCycleStart then
    val = val + iBase - iMaxAmp
  end if
  if iBlnPositiveNumbers then
    val = val + iMaxAmp
  end if
  return val
end
