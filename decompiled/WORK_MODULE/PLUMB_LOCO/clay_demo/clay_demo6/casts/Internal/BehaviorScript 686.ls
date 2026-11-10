on mouseUp
  global Scroller, baseClientNum
  set x to the text of cast "Client List"
  set totClients to the number of lines in x
  if baseClientNum > 1 then
    puppetSprite(Scroller, 1)
    set the castNum of sprite Scroller to the number of member "up MOUSE CLICK"
    set baseClientNum to baseClientNum - 5
    if baseClientNum <= 1 then
      set baseClientNum to 1
    end if
    turnOffAll()
    go("switch")
  end if
end
