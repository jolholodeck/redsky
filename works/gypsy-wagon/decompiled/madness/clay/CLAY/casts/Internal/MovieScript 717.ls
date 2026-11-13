global baseClientNum

on freezeFrame
  set yyy to EMPTY
  repeat with x = 1 to 48
    put the visible of sprite x into item 1 of xxx
    put string(the puppet of sprite x) into item 2 of xxx
    put the castNum of sprite x into item 3 of xxx
    put xxx into line x of yyy
  end repeat
  put baseClientNum into line 49 of yyy
  put yyy into field "Remember"
  saveMovie()
end

on unfreezeFrame
  set rrr to the text of cast "Remember"
  repeat with x = 1 to 48
    set xxx to line x of rrr
    set the visible of sprite x to value(item 1 of xxx)
    if value(item 2 of xxx) then
      puppetSprite(x, 1)
      set the castNum of sprite x to integer(item 3 of xxx)
    end if
  end repeat
  set baseClientNum to value(line 49 of rrr)
end
