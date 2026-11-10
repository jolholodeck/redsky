property psscriptname, plidlemembers, plrollovermembers, pisprite, pitotal, pianimphase, plbuttonloc, ploffstageloc, picount, ancestor
global glmembers

on new me
  set psscriptname to "exitanim"
  init(me)
  return me
end

on init me
  set plidlemembers to []
  sort(plidlemembers)
  add(plidlemembers, getOne(glmembers, "g_exit_idle1"))
  add(plidlemembers, getOne(glmembers, "g_exit_idle2"))
  add(plidlemembers, getOne(glmembers, "g_exit_idle3"))
  set plrollovermembers to []
  sort(plrollovermembers)
  add(plrollovermembers, getOne(glmembers, "g_exit_rollover1"))
  add(plrollovermembers, getOne(glmembers, "g_exit_rollover2"))
  add(plrollovermembers, getOne(glmembers, "g_exit_rollover3"))
  set pisprite to 3
  set pitotal to 3
  set pianimphase to 10
  set ancestor to #none
  set plbuttonloc to point(608, 25)
  set ploffstageloc to point(-1000, -1000)
  resetcount(me)
end

on cleanup me
  if objectp(ancestor) then
    cleanup(ancestor)
    set ancestor to 0
  end if
end

on resetcount me
  set picount to 1
end

on animate me
  set picount to picount + 1
  if picount > pitotal then
    resetcount(me)
  end if
  if rollOver(pisprite) then
    set the member of sprite pisprite to getAt(plrollovermembers, picount)
  else
    set the member of sprite pisprite to getAt(plidlemembers, picount)
  end if
  updateStage()
end

on arrive me
  set the loc of sprite pisprite to plbuttonloc
  set ancestor to new(script "animtimer")
  startanimation(ancestor, pianimphase, me)
end

on depart me
  if objectp(ancestor) then
    set the loc of sprite pisprite to ploffstageloc
    stopanimation(ancestor)
    set ancestor to #none
  end if
end
