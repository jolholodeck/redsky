global gcounter

on exitFrame
  set gcounter to gcounter + 1
  if gcounter = 2 then
    puppetSound(1, 8)
    set gcounter to 0
  else
    go(1)
  end if
end
