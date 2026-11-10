property psscriptname, porequestobj, pitimedelay, picurtime, pinexttime

on new me
  set psscriptname to "animtimer"
  init(me)
  return me
end

on init me
  set porequestobj to #none
  set picurtime to 0
  set pinexttime to 0
end

on reset me
  deleteOne(the actorList, me)
  set porequestobj to #none
  set picurtime to 0
  set pinexttime to 0
end

on cleanup me
end

on startanimation me, aitime, aorequestobj
  if getPos(the actorList, me) then
    turnoff(me)
  end if
  set porequestobj to aorequestobj
  set pitimedelay to aitime
  setcurtime(me)
  set pinexttime to picurtime + pitimedelay
  add(the actorList, me)
end

on setcurtime me
  set picurtime to the ticks
end

on stepFrame me
  playanimation(me)
end

on playanimation me
  setcurtime(me)
  gothroughanimation(me)
end

on gothroughanimation me
  if picurtime > pinexttime then
    set pinexttime to picurtime + pitimedelay
    if objectp(porequestobj) then
      animate(porequestobj)
    end if
  end if
end

on stopanimation me
  if objectp(porequestobj) then
    reset(me)
  end if
end
