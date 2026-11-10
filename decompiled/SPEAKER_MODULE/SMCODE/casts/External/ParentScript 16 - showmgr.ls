property pilinkcastnum, psscriptname, ancestor, plpages, plkeypages, psshowname, picurpage, pbneedtosave, psfilename
global glmembers, glslaves, gofilemgr

on new me
  set psscriptname to "showmgr"
  return me
end

on init me
  set ancestor to #none
  set plpages to []
  sort(plpages)
  set plkeypages to []
  sort(plkeypages)
  set pilinkcastnum to 3
  set psfilename to EMPTY
  setneedtosave(me, 0)
  initancestor(me)
end

on cleanup me
  if objectp(ancestor) then
    cleanup(ancestor)
    set ancestor to 0
  end if
end

on makeinits me
  if objectp(ancestor) then
    cleanup(ancestor)
    set ancestor to VOID
  end if
end

on playinits me
  if objectp(ancestor) then
    deselect(ancestor, #update)
    cleanup(ancestor)
    set ancestor to VOID
  end if
  openplayshow(me)
end

on initancestor me
  set ancestor to new(script "components")
  init(ancestor)
end

on returnplayinits me, aipagenumber
  openreturnshow(me, aipagenumber)
end

on setneedtosave me, abonoroff
  set pbneedtosave to abonoroff
end

on getneedtosave me
  return pbneedtosave
end

on setshowname me, asshowname
  set psshowname to asshowname
end

on importshow me, asfilename, asprevfile
  set tbnotashow to 0
  set tstext to the text of member 1 of castLib pilinkcastnum
  set psshowname to line 1 of tstext
  set tlpages to value(line 2 of tstext)
  if listp(tlpages) then
    set plpages to tlpages
  else
    set tbnotashow to 1
  end if
  set tlkeypages to value(line 3 of tstext)
  if listp(tlkeypages) then
    set plkeypages to tlkeypages
  else
    set tbnotashow to 1
  end if
  set tlcomponents to value(line 4 of tstext)
  if listp(tlcomponents) then
    if objectp(ancestor) then
      init(ancestor)
    else
      initancestor(me)
    end if
    setcomponentlist(me, tlcomponents)
    set the text of member getOne(glmembers, "filename") to asfilename
    set the text of member getOne(glmembers, "entershowname") to psshowname
    set the text of member getOne(glmembers, "showname") to psshowname
  else
    set tbnotashow to 1
  end if
  set tlmembers to value(line 5 of tstext)
  if listp(tlmembers) then
    setmemlist(getProp(glslaves, #indexer), tlmembers)
  else
    set tbnotashow to 1
  end if
  set tlshadows to value(line 6 of tstext)
  if listp(tlshadows) then
    setshadowlist(getProp(glslaves, #indexer), tlshadows)
  else
    set tbnotashow to 1
  end if
  if tbnotashow then
    domessage(gomessagemgr, 12)
    case asprevfile of
      "link.cst":
        set psfilename to EMPTY
        newshow(me)
      asfilename:
        set psfilename to asfilename
        nothing()
      otherwise:
        set psfilename to asfilename
        openshow(me, asprevfile)
    end case
  end if
  set psfilename to asfilename
  setneedtosave(me, 0)
  setcurpage(gotoolbox, 1)
end

on openshow me, asfilename, aipagenum
  cursornumber(gocursors, #WATCH)
  set tsprevfile to getcurlinked(gofilemgr)
  openshow(gofilemgr, asfilename)
  importshow(me, asfilename, tsprevfile)
  if not voidp(aipagenum) then
    displaypage(me, aipagenum)
  else
    displaypage(me, 1)
  end if
  dokeypage(gotoolbox)
  cursorbullet(gocursors)
end

on openplayshow me
  openplayshow(gofilemgr)
  importshow(me, "current", "link.cst")
  displaypage(me, 1)
  dokeypage(gotoolbox)
end

on openreturnshow me, aipagenumber
  openplayshow(gofilemgr)
  importshow(me, "current", "link.cst")
  displaypage(me, aipagenumber)
  dokeypage(gotoolbox)
end

on opencurrentshow me
  setcurpage(gotoolbox, 1)
  displaypage(me, 1)
  dokeypage(gotoolbox)
end

on newshow me
  setneedtosave(me, 0)
  setshowname(me, EMPTY)
  resetmemlist(getProp(glslaves, #indexer))
  set the text of member getOne(glmembers, "filename") to EMPTY
  set the text of member getOne(glmembers, "entershowname") to psshowname
  set the text of member getOne(glmembers, "showname") to psshowname
  set psfilename to EMPTY
  set plpages to []
  sort(plpages)
  set plkeypages to []
  sort(plkeypages)
  if objectp(ancestor) then
    init(ancestor)
  else
    initancestor(me)
  end if
  if the fileName of castLib pilinkcastnum <> (the pathName & "link.cst") then
    resetlink(gofilemgr)
  end if
  addpage(me, 1)
end

on saveshow me, asfilename
  set tstext to EMPTY
  put psshowname into line 1 of tstext
  put string(plpages) into line 2 of tstext
  put string(plkeypages) into line 3 of tstext
  set tlcomponents to getcomponentlist(me)
  put string(tlcomponents) into line 4 of tstext
  set tlmemlist to getmemlist(getProp(glslaves, #indexer))
  set tlshadowlist to getshadowlist(getProp(glslaves, #indexer))
  put string(tlmemlist) into line 5 of tstext
  put string(tlshadowlist) into line 6 of tstext
  set the text of member 1 of castLib pilinkcastnum to tstext
  set psfilename to asfilename
  saveshow(gofilemgr, psfilename)
  setneedtosave(me, 0)
end

on getcurfile me
  return psfilename
end

on addpage me, ainumber
  setneedtosave(me, 1)
  add(plpages, ainumber)
  set picurpage to ainumber
  newpage(me, ainumber)
end

on addkeypage me, ainumber
  setneedtosave(me, 1)
  if not getPos(plkeypages, ainumber) then
    add(plkeypages, ainumber)
  end if
end

on checkkeypage me, aipagenumber
  set tipos to getPos(plkeypages, aipagenumber)
  if tipos then
    return 1
  else
    return 0
  end if
end

on removekeypage me, ainumber
  if getPos(plkeypages, ainumber) then
    deleteOne(plkeypages, ainumber)
  end if
end

on removepage me, ainumber
  if count(plpages) < 2 then
    domessage(gomessagemgr, 11)
  else
    removesprites(getProp(glslaves, #pagedisplayer))
    deleteOne(plpages, ainumber)
    if getPos(plkeypages, ainumber) then
      deleteOne(plkeypages, ainumber)
    end if
    renumberpages(me)
    set tipagenumber to ainumber - 1
    if tipagenumber > 0 then
      set picurpage to tipagenumber
    else
      set picurpage to tipagenumber + 1
    end if
    deletecomponentpage(me, ainumber)
  end if
  return picurpage
end

on insertpage me
  set tipagenumber to picurpage + 1
  add(plpages, tipagenumber)
  set picurpage to tipagenumber
  renumberpages(me)
  insertcomponentpage(me)
  return picurpage
end

on insertcopypage me, aipagenumber
  set tinewpagenum to insertcomponentcopypage(me)
  if tinewpagenum = 0 then
    return picurpage
  else
    set ticurpage to picurpage
    set picurpage to tinewpagenum
    add(plpages, picurpage)
    renumberpages(me)
    if getPos(plkeypages, ticurpage) then
      add(plkeypages, picurpage)
    end if
    return picurpage
  end if
end

on renumberpages me
  set ticount to count(plpages)
  repeat with n = 1 to ticount
    set tipage to getAt(plpages, n)
    set tikeypos to getPos(plkeypages, tipage)
    if tipage <> n then
      setAt(plpages, n, n)
      if tikeypos then
        setAt(plkeypages, tikeypos, n)
      end if
    end if
  end repeat
end

on displaypage me, aipagenumber
  if getPos(plpages, aipagenumber) then
    set picurpage to aipagenumber
    selectpage(me, picurpage)
  else
    addpage(me, aipagenumber)
  end if
end

on changepage me, aidirection
  set ticurpage to picurpage + aidirection
  if getPos(plpages, ticurpage) then
    resetspritelist(getProp(glslaves, #indexer))
    set picurpage to ticurpage
    doplaypagedisplay(me)
  end if
end

on changekeypage me, aidirection
  set ticount to count(plkeypages)
  set tinewpage to picurpage
  case aidirection of
    1:
      repeat with n = 1 to ticount
        set tikeypage to getAt(plkeypages, n)
        if tikeypage > picurpage then
          set tinewpage to tikeypage
          exit repeat
        end if
      end repeat
    (-1):
      repeat with n = ticount down to 1
        set tikeypage to getAt(plkeypages, n)
        if tikeypage < picurpage then
          set tinewpage to tikeypage
          exit repeat
        end if
      end repeat
  end case
  if tinewpage <> picurpage then
    set picurpage to tinewpage
    resetspritelist(getProp(glslaves, #indexer))
    doplaypagedisplay(me)
  end if
end

on doplaypagedisplay me
  set tllist to getProp(getcomponentlist(me), picurpage)
  setup(getProp(glslaves, #pagedisplayer), tllist)
  dodisplay(getProp(glslaves, #pagedisplayer))
end

on getcurpage me
  if picurpage = 0 then
    return 1
  else
    return picurpage
  end if
end
