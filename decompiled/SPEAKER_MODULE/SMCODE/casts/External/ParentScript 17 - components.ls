property psscriptname, pibackgroundsprite, pilinklib, ancestor, plcomponents, picursprite, picurpage, plcurcomponents, psfileormem
global glslaves, gtextborderon, gomessagemgr, gotoolbox

on new me
  set psscriptname to "components"
  return me
end

on init me
  set picursprite to 0
  set ancestor to #none
  set plcomponents to [:]
  sort(plcomponents)
  set picurpage to 0
  set psfileormem to "none"
  set plcurcomponents to [:]
  set pibackgroundsprite to 1
  set pilinklib to 3
end

on setcomponentlist me, allist
  set plcomponents to allist
  set ticount to count(plcomponents)
  repeat with n = 1 to ticount
    set tlcomponent to getAt(plcomponents, n)
    updatememlist(me, tlcomponent, 1)
  end repeat
end

on getcomponentlist me
  return plcomponents
end

on setfirstbackground me
  newcomponent(me, #background)
  set the loc of sprite picursprite to getattribute(me, #loc)
  set tsfileormem to getdefaultbackground(me)
  setfileormem(me, #background, tsfileormem)
  setbackground(me, psfileormem)
  setattribute(me, #fileormem, psfileormem)
end

on setfileormem me, axtype, asfileormem
  if axtype <> #text then
    set psfileormem to asfileormem
  end if
end

on nametextmember me
  set tsmembernum to getmember(getProp(glslaves, #indexer))
  if tsmembernum = 0 then
    domessage(gomessagemgr, 5)
    abort()
  end if
  set tsshadowmember to getshadowmember(getProp(glslaves, #indexer))
  if tsshadowmember = 0 then
    domessage(gomessagemgr, 5)
    abort()
  end if
  set psfileormem to tsmembernum
  setattribute(me, #fileormem, psfileormem)
  setattribute(me, #shadowmem, tsshadowmember)
end

on newcomponent me, axtype
  deselect(me, #update)
  setcursprite(me, axtype)
  initattributelist(me, axtype)
  setattribute(me, #type, axtype)
  if axtype = #text then
    set gtextborderon to 1
  end if
  if axtype = #text then
    nametextmember(me)
  end if
  setupancestor(me, axtype)
  if axtype <> #background then
    settype(gotoolbox, axtype)
    typeselect(me)
  end if
end

on setcursprite me, axtype
  if axtype <> #background then
    set picursprite to getsprite(getProp(glslaves, #indexer))
  else
    set picursprite to pibackgroundsprite
  end if
  if picursprite = 0 then
    domessage(gomessagemgr, 4)
    abort()
  end if
end

on initattributelist me, axtype
  case axtype of
    #text:
      set tlattributes to [#type: 0, #loc: 0, #fileormem: EMPTY, #rect: 0, #font: 0, #style: 0, #size: 0, #shadowmem: 0]
    #project:
      set tlattributes to [#type: 0, #loc: 0, #fileormem: EMPTY]
    #background:
      set tlattributes to [#type: 0, #loc: 0, #fileormem: EMPTY]
    #bullet:
      set tlattributes to [#type: 0, #loc: 0, #fileormem: EMPTY]
  end case
  addProp(plcurcomponents, picursprite, tlattributes)
end

on setattribute me, axattribute, aValue
  set tlattributes to getProp(plcurcomponents, picursprite)
  setProp(tlattributes, axattribute, aValue)
end

on getattribute me, axattribute
  set tvalue to getProp(getProp(plcurcomponents, picursprite), axattribute)
  return tvalue
end

on setid me
  set aiid to getid(getProp(glslaves, #indexer))
  setattribute(me, #id, aiid)
end

on setupancestor me, axtype
  setformatter(me, axtype)
  if axtype = #text then
    setshadowmember(me, getProp(getProp(plcurcomponents, picursprite), #shadowmem))
  end if
  arrive(ancestor, psfileormem, picursprite, me)
end

on setformatter me, axtype
  case axtype of
    #text:
      changeancestor(me, #textformatter)
    #project:
      changeancestor(me, #projectformatter)
    #background:
      changeancestor(me, #backgroundformatter)
    #bullet:
      changeancestor(me, #bulletformatter)
  end case
end

on changeancestor me, axslave
  set ancestor to getProp(glslaves, axslave)
end

on select me
  set tlclickon to the clickOn
  if tlclickon <> picursprite then
    deselect(me, #update)
    set picursprite to tlclickon
    set tlattributes to getProp(plcurcomponents, picursprite)
    set axtype to getProp(tlattributes, #type)
    set psfileormem to getProp(tlattributes, #fileormem)
    setupancestor(me, axtype)
  else
    set tlattributes to getProp(plcurcomponents, picursprite)
  end if
  settype(gotoolbox, axtype)
  displayselectedcomponent(gotoolbox, tlattributes)
  if the shiftDown then
    moveselect(me)
  else
    typeselect(me)
  end if
end

on deselect me, axtype
  if objectp(ancestor) then
    case axtype of
      #update:
        if getProp(getProp(plcurcomponents, picursprite), #type) = #text then
          updateshadow(me)
        end if
      #delete:
        removehilite(gotoolbox)
    end case
    clearmove(me)
    resetdisplay(me)
    reset(me)
    clearselectedcomponent(gotoolbox)
    settype(gotoolbox, #none)
  end if
end

on reset me
  if objectp(ancestor) then
    set picursprite to 0
    cleanup(ancestor)
    set ancestor to #none
  end if
end

on cleanup me
  if objectp(ancestor) then
    cleanup(ancestor)
    set ancestor to #none
  end if
end

on deletecomponent me
  if picursprite > 0 then
    set txtype to getProp(getProp(plcurcomponents, picursprite), #type)
    if txtype <> #background then
      if txtype = #text then
        set timemnum to getProp(getProp(plcurcomponents, picursprite), #fileormem)
        set the text of member timemnum to " "
        set tishadowmem to getProp(getProp(plcurcomponents, picursprite), #shadowmem)
        set the text of member tishadowmem to " "
        set the border of member timemnum to 1
        addmemnum(getProp(glslaves, #indexer), timemnum)
      end if
      deleteProp(plcurcomponents, picursprite)
      set the member of sprite picursprite to getOne(glmembers, "stub")
      set the loc of sprite picursprite to point(-1000, -1000)
      addtolist(getProp(glslaves, #indexer), picursprite)
      deselect(me, #delete)
    end if
  end if
end

on removeborder me
  case getProp(getProp(plcurcomponents, picursprite), #type) of
    #text:
      undoborder(me)
  end case
end

on newpage me, ainumber
  if ainumber > 0 then
    addProp(plcomponents, ainumber, [:])
    setuppage(me, ainumber)
    setfirstbackground(me)
    dopagedisplay(me)
  else
    alert("page = 0, must be one or more")
  end if
end

on selectpage me, ainumber
  if ainumber > 0 then
    setcurpage(gotoolbox, ainumber)
    setuppage(me, ainumber)
    dopagedisplay(me)
  else
    alert("page = 0, must be one or more")
  end if
end

on adjustavailablesprites me
  set ticount to count(plcurcomponents)
  if ticount > 1 then
    set tllist to []
    repeat with n = 2 to ticount
      add(tllist, getPropAt(plcurcomponents, n))
    end repeat
    adjustspritelist(getProp(glslaves, #indexer), tllist)
  end if
end

on dopagedisplay me
  setcurpage(gotoolbox, picurpage)
  setup(getProp(glslaves, #pagedisplayer), plcurcomponents)
  dodisplay(getProp(glslaves, #pagedisplayer))
  adjustavailablesprites(me)
end

on setcurpage me, ainumber
  set picurpage to ainumber
end

on updatememlist me, allist, abonoroff
  set ticount to count(allist)
  if ticount > 1 then
    repeat with n = 2 to ticount
      set tlthiscomponent to getAt(allist, n)
      set txtype to getProp(tlthiscomponent, #type)
      if txtype = #text then
        set tsmember to getProp(tlthiscomponent, #fileormem)
        set timemnum to the memberNum of member tsmember
        case abonoroff of
          0:
            set the text of member timemnum of castLib 3 to " "
            set the border of member timemnum of castLib 3 to 1
            addmemnum(getProp(glslaves, #indexer), timemnum)
          1:
            removememnum(getProp(glslaves, #indexer), timemnum)
        end case
      end if
    end repeat
  end if
end

on setuppage me, aipagenumber
  setcurpage(me, aipagenumber)
  set plcurcomponents to getProp(plcomponents, picurpage)
  resetspritelist(getProp(glslaves, #indexer))
end

on deletecomponentpage me, aipagenum
  set tlpagecomponents to getProp(plcomponents, aipagenum)
  updatememlist(me, tlpagecomponents, 0)
  deleteProp(plcomponents, aipagenum)
  renumbercomponentpages(me)
  set tipagenum to aipagenum - 1
  if tipagenum > 0 then
    setuppage(me, tipagenum)
  else
    setuppage(me, tipagenum + 1)
  end if
  dopagedisplay(me)
end

on insertcomponentpage me
  set tinewpagenum to picurpage + 1
  addProp(plcomponents, picurpage, [:])
  renumbercomponentpages(me)
  setuppage(me, tinewpagenum)
  setfirstbackground(me)
  dopagedisplay(me)
end

on renumbercomponentpages me
  set tlcomponents to duplicate(plcomponents)
  sort(tlcomponents)
  set plcomponents to [:]
  sort(plcomponents)
  set ticount to count(tlcomponents)
  repeat with n = 1 to ticount
    addProp(plcomponents, n, getAt(tlcomponents, n))
  end repeat
end

on insertcomponentcopypage me
  set tinewpagenum to picurpage + 1
  set tlattributes to getProp(plcomponents, picurpage)
  set tlnewattributes to duplicate(tlattributes)
  set ticount to count(tlnewattributes)
  repeat with n = 1 to ticount
    set tlcomponent to getAt(tlnewattributes, n)
    set txtype to getProp(tlcomponent, #type)
    case txtype of
      #text:
        set tsmemname to getProp(tlcomponent, #fileormem)
        set tstext to the text of member tsmemname
        set tinewmembernum to getmember(getProp(glslaves, #indexer))
        if tinewmembernum = 0 then
          set tinewpagenum to 0
          domessage(gomessagemgr, 5)
          exit repeat
        end if
        setProp(tlcomponent, #fileormem, tinewmembernum)
        set the text of member tinewmembernum to tstext
        set the textFont of member tinewmembernum to getProp(tlcomponent, #font)
        set the textStyle of member tinewmembernum to getProp(tlcomponent, #style)
        set the textSize of member tinewmembernum to getProp(tlcomponent, #size)
        set the rect of member tinewmembernum to getProp(tlcomponent, #rect)
        set tishadowmem to getshadowmember(getProp(glslaves, #indexer))
        if tishadowmem = 0 then
          set tinewpagenum to 0
          domessage(gomessagemgr, 5)
          exit repeat
        end if
        setProp(tlcomponent, #shadowmem, tishadowmem)
        set the text of member tishadowmem to tstext
        set the textFont of member tishadowmem to getProp(tlcomponent, #font)
        set the textStyle of member tishadowmem to getProp(tlcomponent, #style)
        set the textSize of member tishadowmem to getProp(tlcomponent, #size)
        set the rect of member tishadowmem to getProp(tlcomponent, #rect)
        if tstext <> " " then
          set the border of member tinewmembernum of castLib 3 to 0
        end if
    end case
  end repeat
  if tinewpagenum = 0 then
    return tinewpagenum
  else
    addProp(plcomponents, picurpage, tlnewattributes)
    renumbercomponentpages(me)
    setuppage(me, tinewpagenum)
    return tinewpagenum
  end if
end
