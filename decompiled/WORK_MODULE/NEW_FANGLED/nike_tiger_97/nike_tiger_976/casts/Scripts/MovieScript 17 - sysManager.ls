on startMovie
end

on stopMovie
end

on keyDown
  global firstFrame, lastFrame
  CheckForExitKey()
end

on systemExitCleanupHandler
  put "CHILD: in systemExitCleanupHandler"
end
