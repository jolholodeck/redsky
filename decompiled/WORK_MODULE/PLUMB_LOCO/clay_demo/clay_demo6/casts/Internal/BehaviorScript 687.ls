on mouseUp
  global Scroller, baseClientNum
  set x to the text of cast "Client List"
  set totClients to the number of lines in x
  if (baseClientNum + 4) < totClients then
    puppetSprite(Scroller + 1, 1)
    set the castNum of sprite (Scroller + 1) to the number of member "down MOUSE CLICK"
    set baseClientNum to baseClientNum + 5
    if (baseClientNum + 4) >= totClients then
      set baseClientNum to totClients - 4
    end if
    turnOffAll()
    go("switch")
  end if
end
