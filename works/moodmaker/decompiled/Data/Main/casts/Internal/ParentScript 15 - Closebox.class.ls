property iWinHandle, iRectCloseBox, iState

on new me, MacOSvers
  iWinHandle = baFindWindow("SHMM", EMPTY)
  iState = #wait_mousedown
  case MacOSvers of
    "Mac7":
      iRectCloseBox = rect(8, -15, 17, -6)
    otherwise:
      iRectCloseBox = rect(0, -17, 10, -6)
  end case
  (the actorList).append(me)
  return me
end

on stepFrame me
  case iState of
    #wait_mousedown:
      if the mouseDown then
        if baActiveWindow() = iWinHandle then
          if inside(the mouseLoc, iRectCloseBox) then
            iState = #wait_mouseup
          else
            iState = #wait_reset
          end if
        end if
      end if
    #wait_reset:
      if the mouseUp then
        iState = #wait_mousedown
      end if
    #wait_mouseup:
      if the mouseUp then
        iState = #wait_mousedown
        if inside(the mouseLoc, iRectCloseBox) then
          DoQuit()
        end if
      end if
  end case
end
