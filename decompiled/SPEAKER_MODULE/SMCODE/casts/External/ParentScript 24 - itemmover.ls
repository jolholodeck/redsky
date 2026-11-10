property psscriptname, ancestor, porequestor, plloc, pirectsprite, plsprites, picomponentsprite, pxcomponentmembertype, pianimphase
global gocursors

on new me
  set psscriptname to "itemmover"
  return me
end

on init me
  set ancestor to #none
  set porequestor to #none
  set pianimphase to 0
  set plsprites to [:]
  set plloc to point(0, 0)
end

on arrive me, aicomponentsprite, airectsprite, aorequestor, axcomponentmembertype
  set porequestor to aorequestor
  set ancestor to new(script "animtimer")
  set picomponentsprite to aicomponentsprite
  set pirectsprite to airectsprite
  set pxcomponentmembertype to axcomponentmembertype
  startanimation(ancestor, pianimphase, me)
end

on animate me
  set timouseh to the mouseH
  set timousev to the mouseV
  if the mouseDown then
    domove(me, timouseh, timousev)
  else
    domove(me, timouseh, timousev)
    depart(me)
    cursorbullet(gocursors)
  end if
end

on domove me, aimouseh, aimousev
  set tlloc to movetopleft(me, pirectsprite, aimouseh, aimousev)
  case pxcomponentmembertype of
    #field:
      set the loc of sprite picomponentsprite to tlloc + point(5, 5)
    #bitmap:
      movecentered(me, picomponentsprite, aimouseh, aimousev)
  end case
  updateStage()
end

on movetopleft me, aisprite, aimouseh, aimousev
  set tihoriz to aimouseh - (the width of sprite aisprite / 2)
  set tivert to aimousev - (the height of sprite aisprite / 2)
  set tlloc to point(tihoriz, tivert)
  set the loc of sprite aisprite to tlloc
  return tlloc
end

on movecentered me, aisprite, aimouseh, aimousev
  set the loc of sprite aisprite to point(the mouseH, the mouseV)
end

on depart me
  if objectp(ancestor) then
    set plloc to the loc of sprite picomponentsprite
    setattribute(porequestor, #loc, plloc)
    stopanimation(ancestor)
    set ancestor to #none
    clearmove(porequestor)
  end if
end

on cleanup me
  if objectp(ancestor) then
    cleanup(ancestor)
    set ancestor to 0
  end if
  if objectp(porequestor) then
    set porequestor to #none
  end if
end
