property psscriptname
global goshowmgr, goNavMgr, gonavigator

on new me
  set psscriptname to "keymgr"
  return me
end

on init me
end

on startkeyscript me
  moduleskey(me)
  pass()
end

on makekeyscript me
  moduleskey(me)
  if (the keyCode = 51) and the shiftDown then
    deletecomponent(goshowmgr)
  end if
  if (the keyCode = 35) and the controlDown then
    goplaymode()
  end if
  pass()
end

on playkeyscript me
  moduleskey(me)
  case the keyCode of
    123:
      changepage(goshowmgr, -1)
    124:
      changepage(goshowmgr, 1)
    126:
      changekeypage(goshowmgr, 1)
    125:
      changekeypage(goshowmgr, -1)
  end case
  if (the keyCode = 35) and the controlDown then
    gomakemode()
  end if
  pass()
end

on cleanup me
end

on moduleskey me
  set destModule to mCheckModuleKey(goNavMgr)
  case destModule of
    #none:
      exit
    #quit:
      fastquit()
    otherwise:
      goouttomodule(gonavigator, destModule)
  end case
end
