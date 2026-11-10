property sscriptname, pifirstsprite, pilastsprite, pitextselectsprite, pigraphicselectsprite, ploffstageloc, plpagelist, plattachedbehaviors
global glslaves, glmembers

on new me
  set psscriptname to "pagedisplayer"
  return me
end

on init me
  set pitextselectsprite to 6
  set pigraphicselectsprite to 41
  set ploffstageloc to point(-1000, -1000)
  reset(me)
end

on cleanup me
  reset(me)
end

on reset me
  set pifirstsprite to 0
  set pilastsprite to 0
  set plpagelist to [:]
  set plattachedbehaviors to [:]
end

on setup me, alpagelist
  set pifirstsprite to getfirstsprite(getProp(glslaves, #indexer))
  set pilastsprite to getlastsprite(getProp(glslaves, #indexer))
  set plpagelist to alpagelist
end

on removesprites me
  repeat with n = pifirstsprite to pilastsprite
    set the member of sprite n to getOne(glmembers, "stub")
    set the loc of sprite n to ploffstageloc
  end repeat
  set the loc of sprite pitextselectsprite to ploffstageloc
  set the loc of sprite pigraphicselectsprite to ploffstageloc
  updateStage()
end

on dodisplay me
  removescripts(me)
  set tomode to getmode(gomodemgr)
  removesprites(me)
  set ticount to count(plpagelist)
  repeat with n = 1 to ticount
    set tisprite to getPropAt(plpagelist, n)
    set tlattributelist to getAt(plpagelist, n)
    set txtype to getProp(tlattributelist, #type)
    case txtype of
      #background:
        dobackground(me, tlattributelist)
      #text:
        dotext(me, tisprite, tlattributelist)
      #bullet:
        dobullet(me, tisprite, tlattributelist)
      #project:
        doproject(me, tisprite, tlattributelist)
    end case
    set the stretch of sprite tisprite to 0
  end repeat
  if getPos([#play, #playmake], tomode) then
    flicker_splicecut(1, the frame)
    flicker_jumpcut(1, 3, 3)
  end if
end

on dobackground me, alattributelist
  set toformatter to getProp(glslaves, #backgroundformatter)
  set tsfilename to getProp(alattributelist, #fileormem)
  displaybackground(toformatter, tsfilename)
  cleanup(toformatter)
  set toformatter to #none
end

on dotext me, aisprite, alattributelist
  set toformatter to getProp(glslaves, #textformatter)
  set tsmemname to getProp(alattributelist, #fileormem)
  set tsshadowname to getProp(alattributelist, #shadowmem)
  set tlloc to getProp(alattributelist, #loc)
  displaypage(toformatter, aisprite, tsmemname, tlloc, tsshadowname)
  cleanup(toformatter)
  set toformatter to #none
end

on dobullet me, aisprite, alattributelist
  set toformatter to getProp(glslaves, #bulletformatter)
  set tsmemname to getProp(alattributelist, #fileormem)
  set tlloc to getProp(alattributelist, #loc)
  displaypage(toformatter, aisprite, tsmemname, tlloc)
  cleanup(toformatter)
  set toformatter to #none
end

on doproject me, aisprite, alattributelist
  set toformatter to getProp(glslaves, #projectformatter)
  set tlloc to getProp(alattributelist, #loc)
  set tsfilename to getProp(alattributelist, #fileormem)
  displaypage(toformatter, aisprite, tlloc)
  case getmode(gomodemgr) of
    #play:
      addscript(me, aisprite, tsfilename)
    #playmake:
      addscript(me, aisprite, tsfilename)
  end case
  cleanup(toformatter)
  set toformatter to #none
end

on removescripts me
  set ticount to count(plattachedbehaviors)
  repeat with n = 1 to ticount
    set tisprite to getPropAt(plattachedbehaviors, n)
    set the loc of sprite tisprite to ploffstageloc
    deleteOne(the scriptInstanceList of sprite tisprite, getAt(plattachedbehaviors, n))
  end repeat
  set plattachedbehaviors to [:]
end

on addscript me, aispritenum, asfilename
  set toscript to new(script "goproject", asfilename)
  addProp(plattachedbehaviors, aispritenum, toscript)
  add(the scriptInstanceList of sprite aispritenum, toscript)
end
