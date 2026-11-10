property sscriptname, plusedids, plavailsprites, pinextmeminlist, plavailmems, plavailshadows, plshadowsprites

on new me
  set psscriptname to "indexer"
  return me
end

on init me
  set plusedids to []
  sort(plusedids)
  set plavailsprites to []
  sort(plavailsprites)
  repeat with n = 45 to 76
    add(plavailsprites, n)
  end repeat
  set plshadowsprites to []
  sort(plshadowsprites)
  repeat with n = 7 to 38
    add(plshadowsprites, n)
  end repeat
  set plavailmems to []
  sort(plavailmems)
  repeat with n = 2 to 501
    add(plavailmems, n)
  end repeat
  set plavailshadows to []
  repeat with n = 503 to 1002
    add(plavailshadows, n)
  end repeat
  set pinextmeminlist to 1
end

on resetspritelist me
  set plavailsprites to []
  sort(plavailsprites)
  repeat with n = 45 to 76
    add(plavailsprites, n)
  end repeat
  set plshadowsprites to []
  sort(plshadowsprites)
  repeat with n = 7 to 38
    add(plshadowsprites, n)
  end repeat
end

on resetmemlist me
  set plavailmems to []
  sort(plavailmems)
  repeat with n = 2 to 501
    add(plavailmems, n)
  end repeat
  set plavailshadows to []
  repeat with n = 503 to 1002
    add(plavailshadows, n)
  end repeat
  set pinextmeminlist to 1
end

on addmemnum me, aimemnum
  add(plavailmems, aimemnum)
end

on removememnum me, aimemnum
  deleteOne(plavailmems, aimemnum)
end

on addtolist me, ainum
  add(plavailsprites, ainum)
end

on getfirstsprite me
  return getAt(plshadowsprites, 1)
end

on getlastsprite me
  return getAt(plavailsprites, count(plavailsprites))
end

on getsprite me
  if count(plavailsprites) > 0 then
    set tisprite to getAt(plavailsprites, 1)
    deleteAt(plavailsprites, 1)
  else
    set tisprite to 0
  end if
  if tisprite <> 0 then
    set the stretch of sprite tisprite to 0
  end if
  return tisprite
end

on adjustspritelist me, allist
  set ticount to count(allist)
  repeat with n = 1 to ticount
    deleteOne(plavailsprites, getAt(allist, n))
  end repeat
end

on getid me
end

on getmember me
  if count(plavailmems) > 0 then
    set tinextmem to getAt(plavailmems, 1)
    deleteAt(plavailmems, 1)
  else
    set tinextmem to 0
  end if
  if tinextmem = 0 then
    return 0
  else
    set tinextmem to the number of member tinextmem of castLib 3
    return tinextmem
  end if
end

on getshadowmember me
  if count(plavailshadows) > 0 then
    set tinextmem to getAt(plavailshadows, 1)
    deleteAt(plavailshadows, 1)
  else
    set tinextmem to 0
  end if
  set tinextmem to the number of member tinextmem of castLib 3
  return tinextmem
end

on cleanup me
end

on getmemlist me
  return plavailmems
end

on getshadowlist me
  return plavailshadows
end

on setmemlist me, alist
  set plavailmems to alist
end

on setshadowlist me, alist
  set plavailshadows to alist
end
