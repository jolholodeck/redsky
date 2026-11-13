on enterFrame
  global gdmoFiniteBottle
  puppetSound(the eventSndChan of gdmoFiniteBottle, "finOutSound")
  set the soundFadeState of gdmoFiniteBottle to #fading
end
