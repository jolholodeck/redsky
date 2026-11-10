property psscriptname, pldefaultloc, plprojectfiles, pinumprojects, piselectrectsprite, pidefaultlinesize, ploffstageloc, pimembernum, ancestor, porequestor, psprojectname, pisprite
global gspathdelimiter, glmembers, glslaves, gonavigator

on new me
  set psscriptname to "projectformatter"
  return me
end

on init me
  set ancestor to #none
  set porequestor to #none
  set pisprite to 0
  set pimembernum to getOne(glmembers, "s_projbutton")
  set pldefaultloc to point(162, 288)
  set psprojectname to EMPTY
  set piselectrectsprite to 77
  set ploffstageloc to point(-1000, -1000)
  set pidefaultlinesize to 2
  updateprojectfiles(me)
end

on updateprojectfiles me
  set tspathname to the pathName & "demos" & gspathdelimiter
  set plprojectfiles to getdemofiles(gofilemgr)
  set pinumprojects to count(plprojectfiles)
  initprojectselections(me)
end

on initprojectselections me
  set tstring to EMPTY
  repeat with n = 1 to pinumprojects
    set tsnextname to getAt(plprojectfiles, n)
    put tsnextname & RETURN after tstring
  end repeat
  set the text of member getOne(glmembers, "projectlist") to tstring
end

on arrive me, asfileormem, aisprite, aorequestor
  cleanup(me)
  set pisprite to aisprite
  set porequestor to aorequestor
  set psprojectname to asfileormem
end

on removerect me
  set the loc of sprite piselectrectsprite to point(-1000, -1000)
end

on display me
  setattribute(porequestor, #loc, pldefaultloc)
  set the member of sprite pisprite to pimembernum
  set the ink of sprite pisprite to 8
  updateStage()
  typeselect(me)
end

on displaypage me, aisprite, alloc
  set the member of sprite aisprite to pimembernum
  set the ink of sprite aisprite to 8
  set the loc of sprite aisprite to alloc
end

on gotoproject me
  if psprojectname <> "none" then
    setupleaving(gonavigator)
    go(1, psprojectname)
  else
    alert("no project selected")
  end if
end

on cleanup me
  if objectp(porequestor) then
    set porequestor to #none
  end if
  if objectp(ancestor) then
    cleanup(ancestor)
    set ancestor to #none
  end if
  set psprojectname to "none"
end

on resetdisplay me
  set the loc of sprite piselectrectsprite to ploffstageloc
  updateStage()
end

on clearmove me
  if objectp(ancestor) then
    cleanup(ancestor)
    set ancestor to #none
  end if
end

on typeselect me
  set tlrect to the rect of sprite pisprite
  set the rect of sprite piselectrectsprite to rect(getAt(tlrect, 1) - 5, getAt(tlrect, 2) - 5, getAt(tlrect, 3) + 5, getAt(tlrect, 4) + 5)
  set the lineSize of sprite piselectrectsprite to pidefaultlinesize
end

on moveselect me
  typeselect(me)
end

on move me
  cursorgrab(gocursors)
  set ancestor to getProp(glslaves, #itemmover)
  arrive(ancestor, pisprite, piselectrectsprite, porequestor, #bitmap)
end
