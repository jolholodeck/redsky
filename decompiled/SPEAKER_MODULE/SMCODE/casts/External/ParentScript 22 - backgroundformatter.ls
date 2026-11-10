property ancestor, psscriptname, plbkgmems, psdefaultbackground, pldefaultloc, pinumbkgs, pibkgpos, porequestor, pibkgsprite
global glmembers, gspathdelimiter, glslaves, gocursors

on new me
  set psscriptname to "backgroundformatter"
  return me
end

on init me
  set porequestor to #none
  set ancestor to #none
  set pibkgsprite to 1
  set plbkgmems to []
  sort(plbkgmems)
  set tistartmem to getPos(glmembers, "bkgstart") + 1
  set tiendmem to getPos(glmembers, "bkgend") - 1
  repeat with n = tistartmem to tiendmem
    add(plbkgmems, getAt(glmembers, n))
  end repeat
  set pinumbkgs to count(plbkgmems)
  set pibkgpos to 1
  set psdefaultbackground to getAt(plbkgmems, pibkgpos)
  set pldefaultloc to point(320, 240)
end

on getdefaultbackground me
  return psdefaultbackground
end

on getnumavailable me
  return pinumbkgs
end

on arrive me, asfileormem, aisprite, aorequestor
  cleanup(me)
  set porequestor to aorequestor
  setattribute(porequestor, #loc, pldefaultloc)
end

on nextbackground me, aidirection
  cursornumber(gocursors, #WATCH)
  set tibkgpos to pibkgpos + aidirection
  if (tibkgpos > 0) and (tibkgpos <= pinumbkgs) then
    set pibkgpos to tibkgpos
    set timemnum to getAt(plbkgmems, pibkgpos)
    setbackground(me, timemnum)
  else
    if tibkgpos = 0 then
      set pibkgpos to pinumbkgs
    end if
    if tibkgpos >= pinumbkgs then
      set pibkgpos to 1
    end if
    set timemnum to getAt(plbkgmems, pibkgpos)
    setbackground(me, timemnum)
  end if
  cursorbullet(gocursors)
end

on resetpos me
  set pibkgpos to 1
end

on setbackground me, aimemnum
  displaybackground(me, aimemnum)
  setattribute(porequestor, #fileormem, aimemnum)
end

on displaybackground me, aimemnum
  set timemnum to the number of member the member of sprite pibkgsprite
  preloadMember(member aimemnum)
  set the member of sprite pibkgsprite to member aimemnum
  set the loc of sprite pibkgsprite to pldefaultloc
  unloadMember(member timemnum)
end

on cleanup me
  if objectp(ancestor) then
    set ancestor to #none
  end if
end

on clearmove me
end

on resetdisplay me
end
