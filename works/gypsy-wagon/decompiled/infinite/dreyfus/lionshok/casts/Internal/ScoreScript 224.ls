on mouseUp
  clearPuppets(1, 48)
  puppetSound(0)
  set the volume of sound 1 to 255
  puppetTransition(26, 3, 12)
  puppetSound(2, the number of member "close")
  go("intro")
end
