global state_pnumber

on exitFrame
  if soundBusy(1) then
    go(the frame)
  else
    unloadMember("project" & string(state_pnumber))
    if state_pnumber < 4 then
      set state_pnumber to state_pnumber + 1
    end if
    play done
  end if
  pass()
end
