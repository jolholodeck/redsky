on enterFrame
  global gdmoMadBottle
  puppetSound(the eventSndChan of gdmoMadBottle, "madOutSound")
  set the soundFadeState of gdmoMadBottle to #fading
end
