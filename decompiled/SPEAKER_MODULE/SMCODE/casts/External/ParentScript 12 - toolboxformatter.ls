property psscriptname, pldisplaysprites, plfonts, plstyles, plsizechoices, ploffstageloc, piboxhilitesprite, piprojectnamemem, pipagenumbermem, picurpage, psbulletsize, psfont, psfontstyle, psfontsize, psproject, pxtype, plkeycheck, pboktoeditpage
global glmembers, goshowmgr, gomessagemgr, gocursors, glslaves, goNavMgr, gotoolbox

on new me
  set psscriptname to "toolboxformatter"
  return me
end

on init me
  initConstants(me)
  reset(me)
end

on reset me
  set pboktoeditpage to 1
  set pbtoolboxon to 1
  set pbgridon to 0
  set pxtype to #none
  settextdefaults(me)
  setbulletdefaults(me)
  setprojectdefaults(me)
  setpagedefaults(me)
end

on initConstants me
  set ploffstageloc to point(-1000, -1000)
  set piboxhilitesprite to 102
  set piprojectnamemem to getOne(glmembers, "projectname")
  set plstyles to [1: "plain", 2: "bold", 3: "italic", 4: "underline"]
  set txplatform to the ikOStype of goNavMgr
  case txplatform of
    #win:
      set plfonts to ["thunderbird": "Thunderbird", "bgothic": "LBGothic", "monolinescript": "MonolineScriptMT"]
    #mac:
      set plfonts to ["thunderbird": "Thunderbird BT", "bgothic": "LBGothic", "monolinescript": "Monoline Script MT"]
  end case
  set plsizechoices to ["thunderbird": ["1": 24, "2": 30, "3": 36, "4": 48], "bgothic": ["1": 20, "2": 24, "3": 26, "4": 30], "monolinescript": ["1": 36, "2": 36, "3": 36, "4": 36]]
  set plkeycheck to [100: point(43, 360)]
  set pldisplaysprites to [#toolbox: [79: point(72, 287)], #showname: [93: point(17, 129)], #fontname: [94: point(46, 214)], #fontSize: [95: point(46, 226)], #fontStyle: [96: point(46, 238)], #bulletsize: [97: point(46, 265)], #projectname: [98: point(17, 308)], #pagenumber: [99: point(96, 353)]]
  set pipagenumbermem to getOne(glmembers, "pagenumber")
end

on cleanup me
end

on settextdefaults me
  set psfont to "bgothic"
  set psfontstyle to "plain"
  set psfontsize to "1"
end

on setbulletdefaults me
  set psbulletsize to "1"
end

on setprojectdefaults me
  set psproject to EMPTY
  set the text of member piprojectnamemem to EMPTY
end

on setpagedefaults me
  setcurpage(me, 1)
end

on dohelp me
  domessage(gomessagemgr, 8)
end

on clearselectedcomponent me, axtype
  set txorgtype to pxtype
  settextdefaults(me)
  setbulletdefaults(me)
  setprojectdefaults(me)
  if txorgtype <> axtype then
    case txorgtype of
      #text:
        set tisprite to getPropAt(getProp(pldisplaysprites, #fontname), 1)
        set the loc of sprite tisprite to ploffstageloc
        set tisprite to getPropAt(getProp(pldisplaysprites, #fontStyle), 1)
        set the loc of sprite tisprite to ploffstageloc
        set tisprite to getPropAt(getProp(pldisplaysprites, #fontSize), 1)
        set the loc of sprite tisprite to ploffstageloc
      #bullet:
        set tisprite to getPropAt(getProp(pldisplaysprites, #bulletsize), 1)
        set the loc of sprite tisprite to ploffstageloc
      #project:
        set tisprite to getPropAt(getProp(pldisplaysprites, #projectname), 1)
        set the loc of sprite tisprite to ploffstageloc
    end case
  end if
end

on removehilite me
  set the loc of sprite piboxhilitesprite to ploffstageloc
end

on displayselectedcomponent me, alattributes
  if gettoolboxon(gotoolbox) then
    settype(me, getProp(alattributes, #type))
    case pxtype of
      #text:
        hilitearea(me, #text)
        set psfont to getOne(plfonts, getProp(alattributes, #font))
        set psfontstyle to getProp(alattributes, #style)
        set psfontsize to getOne(getProp(plsizechoices, psfont), getProp(alattributes, #size))
        set tisprite to getPropAt(getProp(pldisplaysprites, #fontname), 1)
        set the member of sprite tisprite to getOne(glmembers, psfont)
        displayformatinfo(me, #fontname, tisprite)
        set tisprite to getPropAt(getProp(pldisplaysprites, #fontStyle), 1)
        set the member of sprite tisprite to getOne(glmembers, psfontstyle)
        displayformatinfo(me, #fontStyle, tisprite)
        set tisprite to getPropAt(getProp(pldisplaysprites, #fontSize), 1)
        set the member of sprite tisprite to getOne(glmembers, psfontsize)
        displayformatinfo(me, #fontSize, tisprite)
      #bullet:
        hilitearea(me, #bullet)
        set psbulletsize to getProp(alattributes, #fileormem)
        set tisprite to getPropAt(getProp(pldisplaysprites, #bulletsize), 1)
        set the member of sprite tisprite to getOne(glmembers, psbulletsize)
        displayformatinfo(me, #bulletsize, tisprite)
      #project:
        hilitearea(me, #project)
        set psproject to getProp(alattributes, #fileormem)
        set the text of member piprojectnamemem to psproject
        set tisprite to getPropAt(getProp(pldisplaysprites, #projectname), 1)
        displayformatinfo(me, #projectname, tisprite)
    end case
  end if
end

on newshow me
  cursornumber(gocursors, #WATCH)
  if getneedtosave(goshowmgr) then
    domessage(gomessagemgr, 14)
    cursornumber(gocursors, #ARROW)
  else
    settextdefaults(me)
    setbulletdefaults(me)
    setprojectdefaults(me)
    newshow(goshowmgr)
    dokeypage(me)
    cursorbullet(gocursors)
  end if
end

on playshow me
  goplaymode()
end

on displaybkg me, aidirection
  setneedtosave(goshowmgr, 1)
  removehilite(me)
  case aidirection of
    (-1):
      hilitearea(me, #backgroundback)
    1:
      hilitearea(me, #backgroundfwd)
  end case
  updateStage()
  newcomponent(goshowmgr, #background)
  nextbackground(goshowmgr, aidirection)
  removehilite(me)
end

on placetext me
  if count(the actorList) = 0 then
    setneedtosave(goshowmgr, 1)
    deselect(goshowmgr, #update)
    newcomponent(goshowmgr, #text)
    settextdefaults(me)
    setfont(goshowmgr, getProp(plfonts, psfont))
    setsize(goshowmgr, getProp(getProp(plsizechoices, psfont), psfontsize))
    setstyle(goshowmgr, psfontstyle)
    set tisprite to getPropAt(getProp(pldisplaysprites, #fontname), 1)
    set the member of sprite tisprite to getOne(glmembers, psfont)
    displayformatinfo(me, #fontname, tisprite)
    set tisprite to getPropAt(getProp(pldisplaysprites, #fontStyle), 1)
    set the member of sprite tisprite to getOne(glmembers, psfontstyle)
    displayformatinfo(me, #fontStyle, tisprite)
    set tisprite to getPropAt(getProp(pldisplaysprites, #fontSize), 1)
    set the member of sprite tisprite to getOne(glmembers, psfontsize)
    displayformatinfo(me, #fontSize, tisprite)
    display(goshowmgr)
    move(goshowmgr)
  end if
end

on placebullet me
  setneedtosave(goshowmgr, 1)
  setbulletdefaults(me)
  set tisprite to getPropAt(getProp(pldisplaysprites, #bulletsize), 1)
  set the member of sprite tisprite to getOne(glmembers, psbulletsize)
  displayformatinfo(me, #bulletsize, tisprite)
  deselect(goshowmgr, #update)
  setfileormem(goshowmgr, #bullet, psbulletsize)
  newcomponent(goshowmgr, #bullet)
  setattribute(goshowmgr, #fileormem, psbulletsize)
  display(goshowmgr)
  move(goshowmgr)
end

on placeproject me
  setneedtosave(goshowmgr, 1)
  set the text of member piprojectnamemem to EMPTY
  set tisprite to getPropAt(getProp(pldisplaysprites, #projectname), 1)
  displayformatinfo(me, #projectname, tisprite)
  deselect(goshowmgr, #update)
  setfileormem(goshowmgr, #project, psproject)
  newcomponent(goshowmgr, #project)
  display(goshowmgr)
  move(goshowmgr)
end

on setcurpage me, aipagenum
  set the text of member pipagenumbermem to string(aipagenum)
  set picurpage to aipagenum
end

on setkeypage me, abonoroff
  setneedtosave(goshowmgr, 1)
  case abonoroff of
    0:
      removekeypage(goshowmgr, picurpage)
    1:
      addkeypage(goshowmgr, picurpage)
  end case
end

on displaypage me, aidirection
  cursornumber(gocursors, #WATCH)
  resetpos(getProp(glslaves, #backgroundformatter))
  set picurpage to picurpage + aidirection
  if picurpage > 0 then
    displaypage(goshowmgr, picurpage)
  else
    setcurpage(me, 1)
  end if
  settextdefaults(me)
  setbulletdefaults(me)
  setprojectdefaults(me)
  dokeypage(me)
  cursorbullet(gocursors)
end

on dokeypage me
  set tbiskeypage to checkkeypage(goshowmgr, picurpage)
  if tbiskeypage then
    set the loc of sprite getPropAt(plkeycheck, 1) to getAt(plkeycheck, 1)
  else
    set the loc of sprite getPropAt(plkeycheck, 1) to ploffstageloc
  end if
end

on deletepage me
  if pboktoeditpage then
    cursornumber(gocursors, #WATCH)
    set pboktoeditpage to 0
    set tinumber to removepage(goshowmgr, picurpage)
    if tinumber > 0 then
      setcurpage(me, tinumber)
      setneedtosave(goshowmgr, 1)
    end if
    settextdefaults(me)
    setbulletdefaults(me)
    setprojectdefaults(me)
    dokeypage(me)
    cursorbullet(gocursors)
    set pboktoeditpage to 1
  end if
end

on insertpage me
  if pboktoeditpage then
    cursornumber(gocursors, #WATCH)
    set pboktoeditpage to 0
    setneedtosave(goshowmgr, 1)
    if the shiftDown then
      set tinewpage to insertcopypage(goshowmgr)
    else
      set tinewpage to insertpage(goshowmgr)
    end if
    if tinewpage > picurpage then
      displaypage(me, 1)
      dokeypage(me)
    end if
    settextdefaults(me)
    setbulletdefaults(me)
    setprojectdefaults(me)
    cursorbullet(gocursors)
    set pboktoeditpage to 1
  end if
end

on settype me, axtype
  set pxtype to axtype
end

on setbullet me, ainum
  setneedtosave(goshowmgr, 1)
  set psbulletsize to string(ainum)
  set tisprite to getPropAt(getProp(pldisplaysprites, #bulletsize), 1)
  set the member of sprite tisprite to getOne(glmembers, psbulletsize)
  displayformatinfo(me, #bulletsize, tisprite)
  if pxtype = #bullet then
    setattribute(goshowmgr, #fileormem, psbulletsize)
    setsize(goshowmgr, psbulletsize)
  end if
end

on setTextFont me, ainum
  setneedtosave(goshowmgr, 1)
  set psfont to getPropAt(plfonts, ainum)
  set tisprite to getPropAt(getProp(pldisplaysprites, #fontname), 1)
  set the member of sprite tisprite to getOne(glmembers, psfont)
  displayformatinfo(me, #fontname, tisprite)
  if pxtype = #text then
    set tssizechoices to getProp(plsizechoices, psfont)
    set tinewfontsize to getProp(tssizechoices, psfontsize)
    setsize(goshowmgr, tinewfontsize)
    setfont(goshowmgr, getProp(plfonts, psfont))
  end if
end

on setTextSize me, ainum
  setneedtosave(goshowmgr, 1)
  set psfontsize to string(ainum)
  set tisprite to getPropAt(getProp(pldisplaysprites, #fontSize), 1)
  set the member of sprite tisprite to getOne(glmembers, psfontsize)
  displayformatinfo(me, #fontSize, tisprite)
  if pxtype = #text then
    setsize(goshowmgr, getProp(getProp(plsizechoices, psfont), psfontsize))
  end if
end

on setTextStyle me, ainum
  setneedtosave(goshowmgr, 1)
  set psfontstyle to getProp(plstyles, ainum)
  set tisprite to getPropAt(getProp(pldisplaysprites, #fontStyle), 1)
  set the member of sprite tisprite to getOne(glmembers, psfontstyle)
  displayformatinfo(me, #fontStyle, tisprite)
  if pxtype = #text then
    setstyle(goshowmgr, psfontstyle)
  end if
end

on setproject me, asproject
  setneedtosave(goshowmgr, 1)
  set psproject to asproject
  set the text of member piprojectnamemem to psproject
  set tisprite to getPropAt(getProp(pldisplaysprites, #projectname), 1)
  displayformatinfo(me, #projectname, tisprite)
  if pxtype = #project then
    setattribute(goshowmgr, #fileormem, psproject)
  end if
end

on displayformatinfo me, axtype, aisprite
  set the loc of sprite aisprite to getAt(getProp(pldisplaysprites, axtype), 1)
end

on getcurtype me
  return pxtype
end
