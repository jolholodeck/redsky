property psscriptname, plbullets, piselectrectsprite, pidefaultlinesize, ploffstageloc, pldefaultloc, ancestor, porequestor, pisprite, pimembernum, psbulletsize
global glmembers

on new me
  set psscriptname to "bulletformatter"
  return me
end

on init me
  set ancestor to #none
  set porequestor to #none
  set plbullets to ["4": "s_bullet", "3": "s_bullet_2", "2": "s_bullet_3", "1": "s_bullet_4"]
  set psbulletname to "s_bullet_4"
  set pibulletsize to 1
  set pimembernum to 0
  set pisprite to 0
  set piselectrectsprite to 77
  set ploffstageloc to point(-1000, -1000)
  set pidefaultlinesize to 2
  set pldefaultloc to point(149, 265)
end

on arrive me, asbulletsize, aisprite, aorequestor
  cleanup(me)
  set pisprite to aisprite
  setsize(me, asbulletsize)
  set porequestor to aorequestor
end

on removerect me
  set the loc of sprite piselectrectsprite to point(-1000, -1000)
end

on setsize me, asbulletsize
  set psbulletsize to asbulletsize
  set pimembernum to getOne(glmembers, getProp(plbullets, psbulletsize))
  set the member of sprite pisprite to pimembernum
end

on display me
  set the member of sprite pisprite to pimembernum
  set the ink of sprite pisprite to 8
  updateStage()
  typeselect(me)
end

on displaypage me, aisprite, asmemname, aloc
  set the member of sprite aisprite to getOne(glmembers, getProp(plbullets, asmemname))
  set the ink of sprite aisprite to 8
  set the loc of sprite aisprite to aloc
end

on cleanup me
  if objectp(porequestor) then
    set porequestor to #none
  end if
  if objectp(ancestor) then
    cleanup(ancestor)
    set ancestor to #none
  end if
  set pisprite to 0
  set pimembernum to 0
  set psbulletname to EMPTY
  set psbulletsize to EMPTY
end

on clearmove me
  if objectp(ancestor) then
    cleanup(ancestor)
    set ancestor to #none
  end if
end

on resetdisplay me
  set the loc of sprite piselectrectsprite to ploffstageloc
  updateStage()
end

on typeselect me
  set tlrect to the rect of sprite pisprite
  set the rect of sprite piselectrectsprite to rect(getAt(tlrect, 1) - 5, getAt(tlrect, 2) - 5, getAt(tlrect, 3) + 5, getAt(tlrect, 4) + 5)
  set the lineSize of sprite piselectrectsprite to pidefaultlinesize
  updateStage()
end

on moveselect me
  typeselect(me)
end

on move me
  cursorgrab(gocursors)
  set ancestor to getProp(glslaves, #itemmover)
  arrive(ancestor, pisprite, piselectrectsprite, porequestor, #bitmap)
end
