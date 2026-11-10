global goNavMgr, gocursors, gofilemgr, gomessagemgr, gokeymgr, gomodemgr, goshowmgr, gotoolbox, gonavigator, glslaves, glmembers, gspathdelimiter

on startupmovie
  modulesetup()
  set tlstartdata to mGetData(goStateMgr, #speaker)
  if listp(tlstartdata) then
    set txmode to getAt(tlstartdata, 1)
    set tinfo1 to getAt(tlstartdata, 2)
    if count(tlstartdata) = 3 then
      set tinfo2 to getAt(tlstartdata, 3)
    end if
    case txmode of
      #start:
        runspeakermodule()
      #play:
        if integerp(tinfo1) then
          returnplaysetup(tinfo1)
        else
          playsetup()
        end if
      #playmake:
        case tinfo1 of
          EMPTY:
            makesetup()
          otherwise:
            returnplaymakesetup(tinfo1, tinfo2)
        end case
      #make:
        case tinfo1 of
          EMPTY:
            makesetup()
          otherwise:
            returnmakesetup(tinfo1)
        end case
      otherwise:
        runspeakermodule()
    end case
  else
    runspeakermodule()
  end if
  cursorbullet(gocursors)
end

on modulesetup
  moveToFront(the stage)
  initglobalvariables()
  dosearchpaths()
  createglobalobjects()
  createslaveobjects()
  set the keyDownScript to "startkeyscript gokeymgr"
  timer_init()
  flicker_init()
end

on runspeakermodule
  if checkforcurrent(gofilemgr) = 0 then
    domessage(gomessagemgr, 1)
  else
    playsetup()
  end if
end

on initglobalvariables
  set gspathdelimiter to the ikFileSep of goNavMgr
  indexcast(100, "internal")
end

on dosearchpaths
  add(the searchPath, the pathName)
end

on createglobalobjects
  set gomessagemgr to new(script "messagemgr")
  init(gomessagemgr)
  set gofilemgr to new(script "filemgr")
  init(gofilemgr)
  set gonavigator to new(script "navigator")
  init(gonavigator)
  set gomodemgr to new(script "modemgr")
  init(gomodemgr)
  set gokeymgr to new(script "keymgr")
  init(gokeymgr)
  set gocursors to new(script "cursormgr")
  init(gocursors)
  set goshowmgr to new(script "showmgr")
  init(goshowmgr)
  set gotoolbox to new(script "tooboxinterface")
  init(gotoolbox)
end

on gomakemode
  flicker_setstate(#off)
  depart(getProp(glslaves, #exitanim))
  go("load")
  setmode(gomodemgr, #make)
  set the keyDownScript to "makekeyscript gokeymgr"
  resetspritelist(getProp(glslaves, #indexer))
  set tscurrentfile to getcurrentfilename(gofilemgr)
  if the fileName of castLib 3 = tscurrentfile then
    resetlink(gofilemgr)
    newshow(goshowmgr)
  end if
  reset(gotoolbox)
  go("make")
  displaypage(goshowmgr, 1)
  dokeypage(gotoolbox)
end

on makesetup
  setmode(gomodemgr, #make)
  set the keyDownScript to "makekeyscript gokeymgr"
  resetspritelist(getProp(glslaves, #indexer))
  startmakemode()
end

on startmakemode
  flicker_setstate(#off)
  depart(getProp(glslaves, #exitanim))
  reset(gotoolbox)
  go("make")
  makeinits(goshowmgr)
  newshow(goshowmgr)
end

on goplaymode
  flicker_setstate(#off)
  depart(getProp(glslaves, #exitanim))
  go("load")
  setmode(gomodemgr, #playmake)
  set the keyDownScript to "playkeyscript gokeymgr"
  resetspritelist(getProp(glslaves, #indexer))
  go("play")
  flicker_setstate(#on)
  opencurrentshow(goshowmgr)
  arrive(getProp(glslaves, #exitanim))
end

on returnmakesetup asfilename
  flicker_setstate(#off)
  depart(getProp(glslaves, #exitanim))
  setmode(gomodemgr, #make)
  set the keyDownScript to "makekeyscript gokeymgr"
  resetspritelist(getProp(glslaves, #indexer))
  reset(gotoolbox)
  go("make")
  makeinits(goshowmgr)
  openshow(goshowmgr, asfilename)
end

on returnplaymakesetup asfilename, aipagenum
  flicker_setstate(#off)
  depart(getProp(glslaves, #exitanim))
  setmode(gomodemgr, #playmake)
  set the keyDownScript to "playkeyscript gokeymgr"
  resetspritelist(getProp(glslaves, #indexer))
  go("play")
  flicker_setstate(#on)
  initancestor(goshowmgr)
  openshow(goshowmgr, asfilename, aipagenum)
  arrive(getProp(glslaves, #exitanim))
end

on returnplaysetup aipagenumber
  flicker_setstate(#off)
  depart(getProp(glslaves, #exitanim))
  setmode(gomodemgr, #play)
  set the keyDownScript to "playkeyscript gokeymgr"
  resetspritelist(getProp(glslaves, #indexer))
  go("play")
  flicker_setstate(#on)
  returnplayinits(goshowmgr, aipagenumber)
  arrive(getProp(glslaves, #exitanim))
end

on playsetup
  flicker_setstate(#off)
  depart(getProp(glslaves, #exitanim))
  setmode(gomodemgr, #play)
  set the keyDownScript to "playkeyscript gokeymgr"
  resetspritelist(getProp(glslaves, #indexer))
  go("play")
  flicker_setstate(#on)
  playinits(goshowmgr)
  arrive(getProp(glslaves, #exitanim))
end

on savewarned
  closemessage(gomessagemgr)
  set txmode to getmode(gomodemgr)
  if getPos([#play, #playmake], txmode) then
    gomakemode()
  end if
  closepalette(gotoolbox)
  displaypalette(gotoolbox, #save)
end

on fastquit
  setupleaving(gonavigator)
  cleanupmovie()
  mRestoreSystem(goNavMgr)
  quit()
end

on cleanupglobalobjects
  if listp(glslaves) then
    set ticount to count(glslaves)
    repeat with n = 1 to ticount
      set toobject to getAt(glslaves, n)
      cleanup(toobject)
    end repeat
    set glslaves to [:]
  end if
  if objectp(gocursors) then
    cleanup(gocursors)
    set gocursors to VOID
  end if
  if objectp(gofilemgr) then
    cleanup(gofilemgr)
    set gofilemgr to VOID
  end if
  if objectp(gonavigator) then
    cleanup(gonavigator)
    set gonavigator to VOID
  end if
  if objectp(gomessagemgr) then
    cleanup(gomessagemgr)
    set gomessagemgr to VOID
  end if
  if objectp(gomodemgr) then
    cleanup(gomodemgr)
    set gomodemgr to VOID
  end if
  if objectp(gokeymgr) then
    cleanup(gokeymgr)
    set gokeymgr to VOID
  end if
  if objectp(goshowmgr) then
    cleanup(goshowmgr)
    set goshowmgr to VOID
  end if
  if objectp(gotoolbox) then
    cleanup(gotoolbox)
    set gotoolbox to VOID
  end if
end

on createslaveobjects
  set glslaves to [:]
  sort(glslaves)
  addProp(glslaves, #itemmover, new(script "itemmover"))
  init(getProp(glslaves, #itemmover))
  addProp(glslaves, #getfilelist, new(script "getfilelist"))
  init(getProp(glslaves, #getfilelist))
  addProp(glslaves, #indexer, new(script "indexer"))
  init(getProp(glslaves, #indexer))
  addProp(glslaves, #pagedisplayer, new(script "pagedisplayer"))
  init(getProp(glslaves, #pagedisplayer))
  addProp(glslaves, #exitanim, new(script "exitanim"))
  init(getProp(glslaves, #exitanim))
  addProp(glslaves, #textformatter, new(script "textformatter"))
  init(getProp(glslaves, #textformatter))
  addProp(glslaves, #backgroundformatter, new(script "backgroundformatter"))
  init(getProp(glslaves, #backgroundformatter))
  addProp(glslaves, #projectformatter, new(script "projectformatter"))
  init(getProp(glslaves, #projectformatter))
  addProp(glslaves, #bulletformatter, new(script "bulletformatter"))
  init(getProp(glslaves, #bulletformatter))
end

on cleanupmovie
  cleanupglobalobjects()
  set glmembers to [:]
  set the actorList to []
  set the keyDownScript to EMPTY
end

on indexcast amaxnum, acastlib
  set glmembers to [:]
  sort(glmembers)
  repeat with n = 1 to amaxnum
    if the type of member n of castLib acastlib <> #empty then
      setaProp(glmembers, the number of member n of castLib acastlib, the name of member n of castLib acastlib)
    end if
  end repeat
end
