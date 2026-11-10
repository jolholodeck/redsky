global gDepth

on doQuit
  if gDepth <> 0 then
    set the colorDepth to gDepth
  end if
  play done
end
