on startMovie
  global oldSound
  set oldSound to the volume of sound 1
  set the volume of sound 1 to 80
  set the volume of sound 2 to 80
  put the volume of sound 1
  set the keyDownScript to "CheckForExitKey()"
end
