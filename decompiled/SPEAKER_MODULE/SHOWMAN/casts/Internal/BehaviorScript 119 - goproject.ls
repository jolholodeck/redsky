property psfilename
global gofilemgr, gonavigator

on new me, asfilename
  set psfilename to asfilename
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "go to project file"
end

on mouseDown
  set tspathname to getdemopath(gofilemgr)
  if (psfilename <> EMPTY) and (psfilename <> "none") then
    setupleaving(gonavigator)
    go(1, tspathname & psfilename)
  end if
end
