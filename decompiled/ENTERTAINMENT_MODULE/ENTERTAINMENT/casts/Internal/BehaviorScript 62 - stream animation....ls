on exitFrame
  set tempscript to animation_memberstoscript(350, 210, "e_filmburn001", "e_filmburn165")
  animation_add(#burn, 102, 1, 10, 1, tempscript, "go to the frame+1", 0)
  animation_setstate(#burn, #playing)
  pass()
end
