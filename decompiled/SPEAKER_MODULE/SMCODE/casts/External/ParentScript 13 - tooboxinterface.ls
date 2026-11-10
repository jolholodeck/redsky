property ancestor, psscriptname, plbkgback, plbkgfwd, pltextfont, pltextsize, pltextstyle, plbulletsize, plkeypage, plpageback, plpagefwd, plsavebtn, plopenbtn, plplaybtn, plnewbtn, pltoolbar, plgrid, plhelp, plplacetext, plplacebullet, plplaceproject, plprojectfilename, pldeletepage, plinsertpage, plshownote, pltextfield, plBullet, plproject, plpage, plpresentation, plbulletsize1, plbulletsize2, plbulletsize3, plbulletsize4, pltextfont1, pltextfont2, pltextfont3, pltextsize1, pltextsize2, pltextsize3, pltextsize4, pltextstyle1, pltextstyle2, pltextstyle3, pltextstyle4, pldisplaysprites, plpalettelocs, pleditablefields, ploffstageloc, piboxhilitesprite, pipalettehilitesprite, pigridsprite, plhidegridbtn, pihideadjustment, piprojectlistmem, plkeycheck, pbgridon, plopenpalsprites, pbtoolboxon, plremovedsprites, psopenfile
global glmembers, goshowmgr, gspathdelimiter, gocursors, gomessagemgr, gofilemgr

on new me
  set psscriptname to "tooboxinterface"
  return me
end

on init me
  set ancestor to new(script "toolboxformatter")
  init(ancestor)
  initbuttonrects(me)
  initpaletterects(me)
  inithotspots(me)
  initConstants(me)
  resetopenpalsprites(me)
  reset(me)
  set plremovedsprites to [:]
  set pbtoolboxon to 1
end

on gettoolboxon me
  return pbtoolboxon
end

on reset me
  set pbtoolboxon to 1
  set pbgridon to 0
  set psopenfile to EMPTY
  set plremovedsprite to [:]
  reset(ancestor)
end

on cleanup me
  if objectp(ancestor) then
    cleanup(ancestor)
    set ancestor to VOID
  end if
end

on initConstants me
  set ploffstageloc to point(-1000, -1000)
  set piprojectlistmem to getOne(glmembers, "projectlist")
  set pihideadjustment to 371
  set pleditablefields to [81, 90]
  set pigridsprite to 2
  set piboxhilitesprite to 102
  set pipalettehilitesprite to 103
  set plhidegridbtn to [82: point(72, 190)]
  set plkeycheck to [100: point(43, 360)]
  set plpalettelocs to [#shownote: [80: point(208, 135), 81: point(154, 135)], #textFont: [83: point(183, 240)], #textSize: [84: point(150, 244)], #textStyle: [85: point(163, 264)], #bulletsize: [86: point(150, 285)], #projectfilename: [87: point(219, 338), 88: point(142, 305)], #save: [89: point(208, 434), 90: point(154, 422), 101: point(208, 455)], #open: [91: point(220, 424), 92: point(142, 388)]]
  set pldisplaysprites to [#toolbox: [79: point(72, 287)], #showname: [93: point(17, 129)], #fontname: [94: point(46, 214)], #fontSize: [95: point(46, 226)], #fontStyle: [96: point(46, 238)], #bulletsize: [97: point(46, 265)], #projectname: [98: point(17, 308)], #pagenumber: [99: point(96, 353)]]
end

on resetopenpalsprites me
  set plopenpalsprites to []
end

on clicktoolbox me
  closepalette(me)
  set tlclickloc to the clickLoc
  if the pbtoolboxon of me then
    if inside(tlclickloc, plshownote) then
      hilitearea(me, #shownote)
    end if
    if inside(tlclickloc, pltextfield) then
      hilitearea(me, #text)
    end if
    if inside(tlclickloc, plBullet) then
      hilitearea(me, #bullet)
    end if
    if inside(tlclickloc, plproject) then
      hilitearea(me, #project)
    end if
    if inside(tlclickloc, plpage) then
      hilitearea(me, #page)
    end if
    if inside(tlclickloc, plpresentation) then
      hilitearea(me, #Presentation)
    end if
    if inside(tlclickloc, plhelp) then
      hilitearea(me, #help)
    end if
    updateStage()
    if inside(tlclickloc, plbkgfwd) then
      displaybkg(me, 1)
    end if
    if inside(tlclickloc, plbkgback) then
      displaybkg(me, -1)
    end if
    if inside(tlclickloc, plshownote) then
      displaypalette(me, #shownote)
    end if
    if inside(tlclickloc, pltextfont) then
      displaypalette(me, #textFont)
    end if
    if inside(tlclickloc, pltextsize) then
      displaypalette(me, #textSize)
    end if
    if inside(tlclickloc, pltextstyle) then
      displaypalette(me, #textStyle)
    end if
    if inside(tlclickloc, plbulletsize) then
      displaypalette(me, #bulletsize)
    end if
    if inside(tlclickloc, plprojectfilename) then
      displaypalette(me, #projectfilename)
    end if
    if inside(tlclickloc, plkeypage) then
      togglekeypage(me)
    end if
    if inside(tlclickloc, plpageback) then
      displaypage(me, -1)
    end if
    if inside(tlclickloc, plpagefwd) then
      displaypage(me, 1)
    end if
    if inside(tlclickloc, pldeletepage) then
      deletepage(me)
    end if
    if inside(tlclickloc, plinsertpage) then
      insertpage(me)
    end if
    if inside(tlclickloc, plsavebtn) then
      displaypalette(me, #save)
    end if
    if inside(tlclickloc, plopenbtn) then
      displaypalette(me, #open)
    end if
    if inside(tlclickloc, plnewbtn) then
      newshow(me)
    end if
    if inside(tlclickloc, plplaybtn) then
      playshow(me)
    end if
    if inside(tlclickloc, pltoolbar) then
      displaytoobox(me, 0)
    end if
    if inside(tlclickloc, plgrid) then
      togglegrid(me)
    end if
    if inside(tlclickloc, plhelp) then
      dohelp(me)
    end if
    if inside(tlclickloc, plplacetext) then
      placetext(me)
    end if
    if inside(tlclickloc, plplacebullet) then
      placebullet(me)
    end if
    if inside(tlclickloc, plplaceproject) then
      placeproject(me)
    end if
  else
    displaytoobox(me, 1)
  end if
end

on rollovertoolbox me
  if the pbtoolboxon of me then
    set tmouseloc to point(the mouseH, the mouseV)
    set handcursor to 0
    if inside(tmouseloc, plplacetext) then
      cursorhand(gocursors)
      set handcursor to handcursor + 1
    end if
    if inside(tmouseloc, plplacebullet) then
      cursorhand(gocursors)
      set handcursor to handcursor + 1
    end if
    if inside(tmouseloc, plplaceproject) then
      set handcursor to handcursor + 1
      cursorhand(gocursors)
    end if
    if handcursor = 0 then
      if count(the actorList) > 0 then
        cursorgrab(gocursors)
      else
        cursorbullet(gocursors)
      end if
    end if
  end if
end

on hilitearea me, axtype
  if pbtoolboxon then
    case axtype of
      #shownote:
        deselect(goshowmgr, #update)
        set tlrect to plshownote
      #text:
        set tlrect to pltextfield
      #bullet:
        set tlrect to plBullet
      #project:
        set tlrect to plproject
      #page:
        deselect(goshowmgr, #update)
        set tlrect to plpage
      #Presentation:
        deselect(goshowmgr, #update)
        set tlrect to plpresentation
      #grid:
        deselect(goshowmgr, #update)
        set tlrect to plgrid
      #backgroundback:
        deselect(goshowmgr, #update)
        set tlrect to plbkgback
      #backgroundfwd:
        deselect(goshowmgr, #update)
        set tlrect to plbkgfwd
      #help:
        deselect(goshowmgr, #update)
        set tlrect to plhelp
    end case
    set the rect of sprite piboxhilitesprite to tlrect
  end if
end

on displaytoobox me
  if pbtoolboxon = 1 then
    set pbtoolboxon to 0
  else
    set pbtoolboxon to 1
  end if
  if pbtoolboxon = 0 then
    set ticount to count(pldisplaysprites)
    repeat with n = 1 to ticount
      set tlsublist to getAt(pldisplaysprites, n)
      set tisprite to getPropAt(tlsublist, 1)
      set tlloc to the loc of sprite tisprite
      if tlloc > point(0, 0) then
        addProp(plremovedsprites, tisprite, tlloc)
        set the locV of sprite tisprite to getAt(tlloc, 2) + pihideadjustment
      end if
    end repeat
    set tisprite to getPropAt(plkeycheck, 1)
    if the locH of sprite tisprite > 0 then
      set the loc of sprite tisprite to ploffstageloc
      addProp(plremovedsprites, tisprite, getAt(plkeycheck, 1))
    end if
  end if
  if pbtoolboxon = 1 then
    set ticount to count(plremovedsprites)
    repeat with n = 1 to ticount
      set the loc of sprite getPropAt(plremovedsprites, n) to getAt(plremovedsprites, n)
    end repeat
    set plremovedsprites to [:]
  end if
  removehilite(me)
  updateStage()
end

on displaypalette me, axtype
  set txcurtype to getcurtype(me)
  set tboktodisplay to 0
  case axtype of
    #textFont:
      if txcurtype = #text then
        set tboktodisplay to 1
      end if
    #textSize:
      if txcurtype = #text then
        set tboktodisplay to 1
      end if
    #textStyle:
      if txcurtype = #text then
        set tboktodisplay to 1
      end if
    #bulletsize:
      if txcurtype = #bullet then
        set tboktodisplay to 1
      end if
    #projectfilename:
      if txcurtype = #project then
        set tboktodisplay to 1
      end if
    #save:
      set tboktodisplay to 1
    #open:
      getshownames(me)
      set tboktodisplay to 1
    #shownote:
      set tboktodisplay to 1
  end case
  if tboktodisplay then
    set tldisplaylist to getProp(plpalettelocs, axtype)
    set ticount to count(tldisplaylist)
    repeat with n = 1 to ticount
      set tisprite to getPropAt(tldisplaylist, n)
      set the loc of sprite tisprite to getAt(tldisplaylist, n)
      add(plopenpalsprites, tisprite)
      if getPos(pleditablefields, tisprite) then
        set the editableText of sprite tisprite to 1
        set the selStart to 0
        updateStage()
      end if
    end repeat
    updateStage()
  else
    beep()
  end if
end

on getshownames me
  set tlshowfiles to getshowfiles(gofilemgr)
  initshownames(me, tlshowfiles)
end

on initshownames me, alshowfiles
  set tinumshows to count(alshowfiles)
  set tstring to EMPTY
  set the text of member getOne(glmembers, "showlist") to tstring
  repeat with n = 1 to tinumshows
    set tsnextname to getAt(alshowfiles, n)
    put tsnextname & RETURN after tstring
  end repeat
  set the text of member getOne(glmembers, "showlist") to tstring
end

on closepalette me
  set ticount to count(plopenpalsprites)
  if ticount > 0 then
    repeat with n = 1 to ticount
      set tisprite to getAt(plopenpalsprites, n)
      if tisprite = 81 then
        setshowname(me)
      end if
      if getPos(pleditablefields, tisprite) then
        set the editableText of sprite tisprite to 0
      end if
      updateStage()
      set the loc of sprite tisprite to ploffstageloc
    end repeat
    set the loc of sprite pipalettehilitesprite to ploffstageloc
    updateStage()
    resetopenpalsprites(me)
  end if
end

on togglegrid me
  hilitearea(me, #grid)
  updateStage()
  if pbgridon = 1 then
    set pbgridon to 0
  else
    set pbgridon to 1
  end if
  case pbgridon of
    0:
      set the loc of sprite pigridsprite to point(-1000, -1000)
      set the loc of sprite getPropAt(plhidegridbtn, 1) to point(-1000, -1000)
    1:
      set the loc of sprite pigridsprite to point(320, 240)
      set the loc of sprite getPropAt(plhidegridbtn, 1) to getAt(plhidegridbtn, 1)
  end case
  updateStage()
  removehilite(me)
end

on turnoffgrid me
  set the loc of sprite pigridsprite to point(-1000, -1000)
  set the loc of sprite getPropAt(plhidegridbtn, 1) to point(-1000, -1000)
  updateStage()
end

on hilitepalette me, alrect
  set the rect of sprite pipalettehilitesprite to alrect
  updateStage()
end

on togglekeypage me
  set tisprite to getPropAt(plkeycheck, 1)
  if the locH of sprite tisprite > 0 then
    set the loc of sprite tisprite to ploffstageloc
    setkeypage(me, 0)
  else
    set the loc of sprite tisprite to getAt(plkeycheck, 1)
    setkeypage(me, 1)
  end if
end

on savefile me
  set tboktosave to 1
  cursornumber(gocursors, #WATCH)
  set tsfilename to the text of member getOne(glmembers, "filename")
  set tboktosave to checkalphanumeric(me, tsfilename)
  if tsfilename = EMPTY then
    set tboktosave to 0
  end if
  if tboktosave then
    closepalette(me)
    saveshow(goshowmgr, tsfilename)
  else
    domessage(gomessagemgr, 6)
  end if
  cursorbullet(gocursors)
end

on checkalphanumeric me, asfilename
  set tbstringok to 1
  set tlcharlist to ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", " ", "_", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
  set ticount to the number of chars in asfilename
  repeat with n = 1 to ticount
    set tschar to char n of asfilename
    if not getPos(tlcharlist, tschar) then
      return 0
      exit repeat
    end if
  end repeat
  return 1
end

on openshow me
  set timouseline to the mouseLine
  set timember to getOne(glmembers, "showlist")
  set tstext to the text of member timember
  set tilines to the number of lines in tstext
  set tsopenfile to line timouseline of tstext
  if timouseline > -1 then
    if tsopenfile = EMPTY then
      if tstext = EMPTY then
        domessage(gomessagemgr, 15)
      end if
    else
      hilite line timouseline of (field timember)
      set psopenfile to tsopenfile
      if getneedtosave(goshowmgr) then
        domessage(gomessagemgr, 13)
      else
        openshow(goshowmgr, psopenfile)
        closepalette(me)
        set psopenfile to EMPTY
      end if
    end if
  end if
end

on doopenwarned me
  openshow(goshowmgr, psopenfile)
  closepalette(me)
  set psopenfile to EMPTY
end

on clickproject me
  set timouseline to the mouseLine
  set tstext to the text of member piprojectlistmem
  set tilines to the number of lines in tstext
  set tsproject to line timouseline of tstext
  if timouseline > -1 then
    if tsproject = EMPTY then
      if tstext = EMPTY then
        domessage(gomessagemgr, 9)
      end if
    else
      hilite line timouseline of (field piprojectlistmem)
      setproject(me, tsproject)
      closepalette(me)
    end if
  end if
end

on setshowname me
  set tsshowname to the text of member getOne(glmembers, "entershowname")
  set the text of member getOne(glmembers, "showname") to tsshowname
  setshowname(goshowmgr, tsshowname)
end

on clickbulletsize me
  set tlclickloc to the clickLoc
  if inside(tlclickloc, plbulletsize1) then
    hilitepalette(me, plbulletsize1)
    setbullet(me, 1)
  end if
  if inside(tlclickloc, plbulletsize2) then
    hilitepalette(me, plbulletsize2)
    setbullet(me, 2)
  end if
  if inside(tlclickloc, plbulletsize3) then
    hilitepalette(me, plbulletsize3)
    setbullet(me, 3)
  end if
  if inside(tlclickloc, plbulletsize4) then
    hilitepalette(me, plbulletsize4)
    setbullet(me, 4)
  end if
  closepalette(me)
end

on clicktextfont me
  set tlclickloc to the clickLoc
  if inside(tlclickloc, pltextfont1) then
    hilitepalette(me, pltextfont1)
    setTextFont(me, 1)
  end if
  if inside(tlclickloc, pltextfont2) then
    hilitepalette(me, pltextfont2)
    setTextFont(me, 2)
  end if
  if inside(tlclickloc, pltextfont3) then
    hilitepalette(me, pltextfont3)
    setTextFont(me, 3)
  end if
  closepalette(me)
end

on clicktextsize me
  set tlclickloc to the clickLoc
  if inside(tlclickloc, pltextsize1) then
    hilitepalette(me, pltextsize1)
    setTextSize(me, 1)
  end if
  if inside(tlclickloc, pltextsize2) then
    hilitepalette(me, pltextsize2)
    setTextSize(me, 2)
  end if
  if inside(tlclickloc, pltextsize3) then
    hilitepalette(me, pltextsize3)
    setTextSize(me, 3)
  end if
  if inside(tlclickloc, pltextsize4) then
    hilitepalette(me, pltextsize4)
    setTextSize(me, 4)
  end if
  closepalette(me)
end

on clicktextstyle me
  set tlclickloc to the clickLoc
  if inside(tlclickloc, pltextstyle1) then
    hilitepalette(me, pltextstyle1)
    setTextStyle(me, 1)
  end if
  if inside(tlclickloc, pltextstyle2) then
    hilitepalette(me, pltextstyle2)
    setTextStyle(me, 2)
  end if
  if inside(tlclickloc, pltextstyle3) then
    hilitepalette(me, pltextstyle3)
    setTextStyle(me, 3)
  end if
  if inside(tlclickloc, pltextstyle4) then
    hilitepalette(me, pltextstyle4)
    setTextStyle(me, 4)
  end if
  closepalette(me)
end

on initbuttonrects me
  set plbkgfwd to rect(73, 167, 112, 178)
  set plbkgback to rect(32, 167, 72, 178)
  set pltextfont to rect(44, 213, 113, 222)
  set pltextsize to rect(44, 225, 113, 235)
  set pltextstyle to rect(44, 237, 113, 246)
  set plbulletsize to rect(44, 264, 113, 274)
  set plkeypage to rect(36, 353, 50, 367)
  set plpageback to rect(32, 375, 70, 387)
  set plpagefwd to rect(73, 375, 113, 387)
  set plsavebtn to rect(28, 428, 64, 439)
  set plplaybtn to rect(28, 442, 64, 455)
  set plnewbtn to rect(80, 427, 117, 439)
  set plopenbtn to rect(80, 444, 117, 455)
  set plprojectfilename to rect(13, 304, 133, 328)
  set pltoolbar to rect(8, 99, 137, 108)
  set plgrid to rect(8, 182, 137, 200)
  set plhelp to rect(8, 458, 137, 474)
  set plplacetext to rect(119, 213, 137, 248)
  set plplacebullet to rect(119, 250, 137, 275)
  set plplaceproject to rect(119, 277, 137, 300)
  set pldeletepage to rect(13, 392, 30, 410)
  set plinsertpage to rect(89, 394, 130, 408)
end

on inithotspots me
  set plshownote to rect(8, 110, 137, 153)
  set pltextfield to rect(8, 200, 137, 248)
  set plBullet to rect(8, 250, 137, 275)
  set plproject to rect(8, 277, 137, 332)
  set plpage to rect(8, 334, 137, 412)
  set plpresentation to rect(8, 414, 137, 458)
end

on initpaletterects me
  set plbulletsize1 to rect(138, 265, 161, 274)
  set plbulletsize2 to rect(138, 275, 161, 284)
  set plbulletsize3 to rect(138, 285, 161, 295)
  set plbulletsize4 to rect(138, 296, 161, 306)
  set pltextfont1 to rect(138, 213, 229, 224)
  set pltextfont2 to rect(138, 225, 229, 234)
  set pltextfont3 to rect(138, 235, 229, 244)
  set pltextsize1 to rect(138, 224, 161, 234)
  set pltextsize2 to rect(138, 235, 161, 243)
  set pltextsize3 to rect(138, 244, 161, 254)
  set pltextsize4 to rect(138, 255, 161, 265)
  set pltextstyle1 to rect(138, 243, 188, 254)
  set pltextstyle2 to rect(138, 255, 188, 264)
  set pltextstyle3 to rect(138, 265, 188, 275)
  set pltextstyle4 to rect(138, 276, 188, 286)
end
