property psscriptname, pscurproject, psprojectpath
global goNavMgr, gomodemgr, goshowmgr

on new me
  set psscriptname to "navigator"
  return me
end

on init me
  set pscurproject to EMPTY
  set psprojectpath to EMPTY
end

on goouttomodule me, axmodule
  if getneedtosave(goshowmgr) then
    case axmodule of
      #work:
        domessage(gomessagemgr, 17)
      #entertainment:
        domessage(gomessagemgr, 18)
      #exit:
        domessage(gomessagemgr, 19)
    end case
  else
    setupleaving(me)
    mGotoModule(goNavMgr, axmodule)
  end if
end

on setprojectname me, asprojectname
  set pscurproject to asprojectname
end

on setupleaving me
  set tlstate to getstateinfo(me)
  mSetData(goStateMgr, #speaker, tlstate)
  repeat with n = 1 to 120
    puppetSprite(n, 0)
  end repeat
  flicker_splicecut(1, "dmo_black")
  flicker_jumpcut(1, 3, 3)
  cleanupmovie()
  flicker_setstate(#off)
end

on getstateinfo me
  set txmode to getmode(gomodemgr)
  set tinfo to 0
  set tllist to []
  append(tllist, txmode)
  case txmode of
    #start:
      set tinfo to 0
      append(tllist, tinfo)
    #play:
      set tinfo to getcurpage(goshowmgr)
      append(tllist, tinfo)
    #make:
      set tinfo to getcurfile(goshowmgr)
      append(tllist, tinfo)
    #playmake:
      set tinfo to getcurfile(goshowmgr)
      append(tllist, tinfo)
      set tinfo2 to getcurpage(goshowmgr)
      append(tllist, tinfo2)
    otherwise:
      set txmode to #start
      set tinfo to 0
      set tllist to []
      append(tllist, txmode)
      append(tllist, tinfo)
  end case
  return tllist
end

on cleanup me
end
