on enterFrame
  global gdmoInfiniteBottle
  puppetSound(the eventSndChan of gdmoInfiniteBottle, "infOutSound")
  set the soundFadeState of gdmoInfiniteBottle to #fading
end
