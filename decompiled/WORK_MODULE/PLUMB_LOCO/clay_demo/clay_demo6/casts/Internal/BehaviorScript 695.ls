on exitFrame
  global Scroller, baseClientNum
  set x to the text of cast "Client List"
  set totClients to the number of lines in x
  puppetSprite(Scroller, 1)
  puppetSprite(Scroller + 1, 1)
  if (baseClientNum + 4) = totClients then
    set the castNum of sprite (Scroller + 1) to the number of member "down INACTIVE"
  else
    set the castNum of sprite (Scroller + 1) to the number of member "down"
  end if
  if baseClientNum = 1 then
    set the castNum of sprite Scroller to the number of member "up INACTIVE"
  else
    set the castNum of sprite Scroller to the number of member "up"
  end if
  go("base")
end
