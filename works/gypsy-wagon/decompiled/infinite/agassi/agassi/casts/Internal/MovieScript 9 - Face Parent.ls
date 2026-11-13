property iIdleAnims, ifrownAnim, iLaughAnim, iCurAnim, iDefaultFrame, iLoc, iState, iMinIdleDelay, iIdleFreq, iLastIdle
global gFaceSpr, gBgdOffH, gBgdOffV, gBgdOffPt

on new me
  set iIdleFreq to 50
  set iLastIdle to 0
  set iMinIdleDelay to 60
  set iDefaultFrame to 341
  set DEF to iDefaultFrame
  set iIdleAnims to [[0, DEF, 342, 343, 344, 345], [0, 344, 345], [0, DEF, 342, 343, 342]]
  set ifrownAnim to [0, DEF, 351, 352, 353, 354, 355, 356, 357, 358, 359, 359, 359, 359, 359, 359, 358, 357, 356, 355, 354, 353, 352, 351, DEF]
  set iLaughAnim to [0, DEF, 353, 352, 351, 371, 372, 373, 374, 375, 376, 377, 378, 377, 376, 375, 374, 375, 376, 377, 378, 377, 376, 375, 374, 373, 372, 371, 352, 351, 353, DEF]
  set iLoc to point(272, 192)
  set the loc of sprite gFaceSpr to iLoc + gBgdOffPt
  set the castNum of sprite gFaceSpr to iDefaultFrame
  mTrigger(me, #laugh)
  return me
end

on mMove me
  case iState of
    #reset:
      set the castNum of sprite gFaceSpr to iDefaultFrame
      set iState to #idle
    #idle:
      if the timer < (iLastIdle + iMinIdleDelay) then
        exit
      end if
      if random(iIdleFreq) <> iIdleFreq then
        exit
      end if
      set iCurAnim to value(string(getAt(iIdleAnims, random(count(iIdleAnims)))))
      set iState to #anim
      set iLastIdle to the timer
    #anim:
      set idx to getAt(iCurAnim, 1) + 1
      if idx > (count(iCurAnim) - 1) then
        set iState to #reset
        exit
      end if
      set the castNum of sprite gFaceSpr to getAt(iCurAnim, idx + 1)
      setAt(iCurAnim, 1, idx)
  end case
end

on mTrigger me, Face
  case Face of
    #laugh:
      set iCurAnim to value(string(iLaughAnim))
    #frown:
      set iCurAnim to value(string(ifrownAnim))
  end case
  set iState to #anim
end
