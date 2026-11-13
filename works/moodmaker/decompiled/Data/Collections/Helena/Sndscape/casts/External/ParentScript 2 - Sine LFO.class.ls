property ikMinVal, ikMaxVal, iCurVal, iCurStep, iStepsPerCycle, iCycleStart, iIncr, ioCallBack

on new me, stepsPerCycle, cycleStart
  iCycleStart = cycleStart
  case iCycleStart of
    (-1):
      ikMinVal = PI / -2
      ikMaxVal = (PI * 2) + ikMinVal
    0:
      ikMinVal = 0
      ikMaxVal = PI * 2
    1:
      ikMinVal = PI / 2
      ikMaxVal = (PI * 2) + ikMinVal
  end case
  me.mSetIncr(stepsPerCycle)
  iCurVal = ikMinVal
  iCurStep = 0
  return me
end

on mSetIncr me, stepsPerCycle
  if stepsPerCycle = 0 then
    exit
  end if
  if stepsPerCycle <> iStepsPerCycle then
    iStepsPerCycle = stepsPerCycle
    iIncr = PI / stepsPerCycle
  end if
end

on mStep me
  if iCurStep = (iStepsPerCycle * 2) then
    iCurStep = 0
    iCurVal = ikMinVal
    if objectp(ioCallBack) then
      ioCallBack.mCycleDone()
    end if
  end if
  iCurStep = iCurStep + 1
  iCurVal = iCurVal + iIncr
  return sin(iCurVal)
end
