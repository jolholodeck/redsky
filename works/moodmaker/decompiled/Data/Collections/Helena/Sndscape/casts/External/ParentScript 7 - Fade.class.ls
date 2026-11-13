property iFadeIncr, iTimer, iState, iDir, iCurVal, iBgnVal, iEndVal, iFrameTime, iDebugTimer

on new me
  iState = #done
  return me
end

on mInit me, FPS, fadeSecs, bgnVal, endVal
  iBgnVal = bgnVal
  iEndVal = endVal
  frameIncr = 1000 / float(FPS)
  fadeMsecs = fadeSecs * 1000
  iFadeIncr = (endVal - bgnVal) / float(fadeMsecs)
  if bgnVal < endVal then
    iDir = 1
  else
    iDir = -1
  end if
end

on mStart me
  iState = #start
end

on mStep me, msecs
  case iState of
    #start:
      iCurVal = iBgnVal
      iState = #Fade
      iTimer = msecs
      return iBgnVal
    #Fade:
      iFrameTime = msecs - iTimer
      incr = iFadeIncr * iFrameTime
      iCurVal = iCurVal + incr
      blnDone = 0
      if iDir > 0 then
        if iCurVal >= iEndVal then
          blnDone = 1
        end if
      else
        if iCurVal <= iEndVal then
          blnDone = 1
        end if
      end if
      if blnDone then
        iState = #done
        return iEndVal
      end if
      iTimer = msecs
      return iCurVal
    #done:
      return #done
  end case
end
