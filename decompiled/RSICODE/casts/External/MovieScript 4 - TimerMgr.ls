global gTimer_List

on timer_init
  set gTimer_List to [:]
end

on timer_idle
  set killlist to []
  set callbacklist to []
  set i to 1
  repeat with temp in gTimer_List
    if getaProp(temp, #type) = #finite then
      if getaProp(temp, #killticks) <= the ticks then
        add(killlist, getPropAt(gTimer_List, i))
        add(callbacklist, getaProp(temp, #callback))
      end if
    end if
    set i to i + 1
  end repeat
  repeat with i in killlist
    deleteProp(gTimer_List, i)
  end repeat
  repeat with i in callbacklist
    do(i)
  end repeat
end

on timer_addinfinite name
  setaProp(gTimer_List, name, [#type: #infinite, #ticks: the ticks])
end

on timer_addFinite name, killTime, callback
  setaProp(gTimer_List, name, [#type: #finite, #ticks: the ticks, #killticks: the ticks + killTime, #callback: callback])
end

on timer_gettime name
  set temp to getaProp(gTimer_List, name)
  if not objectp(temp) then
    return -1
  else
    return the ticks - getaProp(temp, #ticks)
  end if
end

on timer_kill name
  set temp to getaProp(gTimer_List, name)
  if not objectp(temp) then
    return -1
  else
    deleteProp(gTimer_List, name)
    return 0
  end if
end
