on swapClient num
  global BaseNameChan, baseClientNum
  set chan to BaseNameChan + 2 + (num * 3)
  puppetSprite(chan, 1)
  set the castNum of sprite chan to the number of member line (baseClientNum + num - 1) of (the text of cast "Client List")
end
