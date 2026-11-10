on startMovie
  global firstFrame, lastFrame
  set firstFrame to label("first") + 1
  set lastFrame to label("last") + 1
end

on stopMovie
end

on keyDown
  global firstFrame, lastFrame
  if the keyCode = 124 then
    if not (marker(1) > lastFrame) then
      go(marker(1))
    end if
  end if
  if the keyCode = 123 then
    if marker(-1) > 0 then
      go(marker(-1))
    end if
  end if
  CheckForExitKey()
end

on systemExitCleanupHandler
  put "CHILD: in systemExitCleanupHandler"
end
