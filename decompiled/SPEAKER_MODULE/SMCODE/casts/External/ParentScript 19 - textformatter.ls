property psscriptname, pldefaultrect, pidefaultink, pladjustrect, pidefaultlinesize, psdefaultfont, pidefaultsize, psdefaultstyle, piwhitecolor, ploffstageloc, pirectadjust, pilocadjust, piselectsprite, pisizemin, pishadowhoriz, pishadowvert, pishadowmem, piblackcolor, pishadowspriteoffset, ancestor, pimember, pisprite, porequestor
global glslaves, glmembers, gocursors, gtextborderon

on new me
  set psscriptname to "textformatter"
  return me
end

on init me
  set ancestor to #none
  set porequestor to #none
  set pimember to 0
  set pisprite to 0
  set piselectsprite to 6
  set pldefaultrect to rect(0, 0, 100, 40)
  set pidefaultink to 36
  set pidefaultlinesize to 2
  set pladjustrect to rect(1000, 1000, 1000, 1000)
  set psdefaultfont to "LBGothic"
  set pidefaultsize to 20
  set psdefaultstyle to "plain"
  set ploffstageloc to point(-1000, -1000)
  set piwhitecolor to the foreColor of member getOne(glmembers, "white")
  set piblackcolor to the foreColor of member getOne(glmembers, "black")
  set pirectadjust to 12
  set pilocadjust to 5
  set pisizemin to 30
  set pishadowspriteoffset to -38
  set pishadowhoriz to 1
  set pishadowvert to 2
  set pishadowmem to 0
end

on setshadowmember me, aishadowmem
  set pishadowmem to aishadowmem
end

on arrive me, aimember, aisprite, aorequestor
  cleanup(me)
  set pimember to aimember
  set pisprite to aisprite
  set porequestor to aorequestor
end

on display me
  set the rect of member pimember to pldefaultrect
  setattribute(porequestor, #rect, pldefaultrect)
  set the member of sprite pisprite to pimember
  set the ink of sprite pisprite to pidefaultink
  updateStage()
  set the rect of sprite pisprite to the rect of member pimember - pladjustrect
  set the member of sprite piselectsprite to member "rect"
  set the lineSize of sprite piselectsprite to pidefaultlinesize
  set the ink of sprite piselectsprite to pidefaultink
  updateStage()
  set trect to the rect of sprite pisprite
  set the rect of sprite piselectsprite to rect(getAt(trect, 1) - 5, getAt(trect, 2) - 5, getAt(trect, 3) + 5, getAt(trect, 4) + 5)
  set the text of member pimember to " "
  set the editableText of sprite pisprite to 1
  updateStage()
  set the selStart to 0
  updateStage()
end

on updateshadow me
  set the text of member pishadowmem to the text of member pimember
end

on displaypage me, aisprite, asmemname, alloc, ashadowname
  set the foreColor of member asmemname to piwhitecolor
  set the editableText of sprite aisprite to 0
  set the member of sprite aisprite to asmemname
  set the ink of sprite aisprite to pidefaultink
  set the loc of sprite aisprite to alloc
  set tomode to getmode(gomodemgr)
  if (tomode = #play) or (tomode = #playmake) then
    set tishadowsprite to aisprite + pishadowspriteoffset
    set the member of sprite tishadowsprite to member ashadowname
    set the foreColor of member ashadowname to piblackcolor
    set the textFont of member ashadowname to the textFont of member asmemname
    set the textStyle of member ashadowname to the textStyle of member asmemname
    set the textSize of member ashadowname to the textSize of member asmemname
    set the rect of member ashadowname to the rect of member asmemname
    set the ink of sprite tishadowsprite to pidefaultink
    set the loc of sprite tishadowsprite to alloc + point(pishadowhoriz, pishadowvert)
  end if
end

on undoborder me
  set the border of member pimember to 0
  set gtextborderon to 0
end

on cleanup me
  set pimember to 0
  set pisprite to 0
  if objectp(porequestor) then
    set porequestor to #none
  end if
  if objectp(ancestor) then
    set ancestor to #none
  end if
end

on typeselect me
  set trect to the rect of sprite pisprite
  set the rect of sprite piselectsprite to rect(getAt(trect, 1) - 5, getAt(trect, 2) - 5, getAt(trect, 3) + 5, getAt(trect, 4) + 5)
  set the lineSize of sprite piselectsprite to pidefaultlinesize
  set the editableText of sprite pisprite to 1
  updateStage()
end

on moveselect me
  set trect to the rect of sprite pisprite
  set the rect of sprite piselectsprite to rect(getAt(trect, 1) - 5, getAt(trect, 2) - 5, getAt(trect, 3) + 5, getAt(trect, 4) + 5)
  set the lineSize of sprite piselectsprite to pidefaultlinesize
  set the editableText of sprite pisprite to 0
  updateStage()
end

on removerect me
  set the loc of sprite piselectsprite to point(-1000, -1000)
end

on clearmove me
  if objectp(ancestor) then
    cleanup(ancestor)
    set ancestor to #none
  end if
  set the editableText of sprite pisprite to 1
end

on resetdisplay me
  set the foreColor of member pimember to piwhitecolor
  set the loc of sprite piselectsprite to ploffstageloc
  set the editableText of sprite pisprite to 0
  updateStage()
end

on move me
  cursorgrab(gocursors)
  resetdisplay(me)
  set ancestor to getProp(glslaves, #itemmover)
  arrive(ancestor, pisprite, piselectsprite, porequestor, #field)
end

on setfont me, asfont
  set the textFont of member pimember to asfont
  setattribute(porequestor, #font, asfont)
end

on setstyle me, asstyle
  set the textStyle of member pimember to "plain "
  set the textStyle of member pimember to asstyle
  setattribute(porequestor, #style, asstyle)
end

on setsize me, aisize
  set the textSize of member pimember to aisize
  setattribute(porequestor, #size, aisize)
end

on resize me
  setattribute(porequestor, #rect, the rect of member pimember)
end

on stretchfield me
  set trect to the rect of sprite piselectsprite
  set tloc to the clickLoc
  set left to getAt(trect, 1)
  set top to getAt(trect, 2)
  set right to getAt(trect, 3)
  set bottom to getAt(trect, 4)
  set adjustedleft to ((right - left) / 2) + left
  set adjustedright to adjustedleft
  set adjustedbottom to ((bottom - top) / 2) + top
  set adjustedtop to adjustedbottom
  set lefttoprect to rect(left, top, adjustedright, adjustedbottom)
  set toprightrect to rect(adjustedleft, top, right, adjustedbottom)
  set bottomleftrect to rect(left, adjustedtop, adjustedright, bottom)
  set bottomrightrect to rect(adjustedleft, adjustedtop, right, bottom)
  if inside(tloc, lefttoprect) then
    pulllefttop(me)
  end if
  if inside(tloc, toprightrect) then
    pullrighttop(me)
  end if
  if inside(tloc, bottomleftrect) then
    pullleftbottom(me)
  end if
  if inside(tloc, bottomrightrect) then
    pullrightbottom(me)
  end if
end

on pullrightbottom me
  set tlstartrect to the rect of sprite pisprite
  repeat while the mouseDown
    set tlendloc to point(the mouseH, the mouseV)
    set tileft to getAt(tlstartrect, 1)
    set titop to getAt(tlstartrect, 2)
    set tiright to getAt(tlendloc, 1)
    set tibottom to getAt(tlendloc, 2)
    displaynewrect(me, tileft, titop, tiright, tibottom)
  end repeat
  setattribute(porequestor, #rect, the rect of member pimember)
end

on pullrighttop me
  set tlstartrect to the rect of sprite pisprite
  repeat while the mouseDown
    set tlendloc to point(the mouseH, the mouseV)
    set tileft to getAt(tlstartrect, 1)
    set titop to getAt(tlendloc, 2)
    set tiright to getAt(tlendloc, 1)
    set tibottom to getAt(tlstartrect, 4)
    displaynewrect(me, tileft, titop, tiright, tibottom)
  end repeat
  setattribute(porequestor, #rect, the rect of member pimember)
end

on pulllefttop me
  set tlstartrect to the rect of sprite pisprite
  repeat while the mouseDown
    set tlendloc to point(the mouseH, the mouseV)
    set tileft to getAt(tlendloc, 1)
    set titop to getAt(tlendloc, 2)
    set tiright to getAt(tlstartrect, 3)
    set tibottom to getAt(tlstartrect, 4)
    displaynewrect(me, tileft, titop, tiright, tibottom)
  end repeat
  setattribute(porequestor, #rect, the rect of member pimember)
end

on pullleftbottom me
  set tlstartrect to the rect of sprite pisprite
  repeat while the mouseDown
    set tlendloc to point(the mouseH, the mouseV)
    set tileft to getAt(tlendloc, 1)
    set titop to getAt(tlstartrect, 2)
    set tiright to getAt(tlstartrect, 3)
    set tibottom to getAt(tlendloc, 2)
    displaynewrect(me, tileft, titop, tiright, tibottom)
  end repeat
  setattribute(porequestor, #rect, the rect of member pimember)
end

on displaynewrect me, aileft, aitop, airight, aibottom
  if aileft < 2 then
    set aileft to 0
  end if
  if aitop < 2 then
    set aitop to 0
  end if
  if airight > 638 then
    set airight to 638
  end if
  if aibottom > 478 then
    set aibottom to 478
  end if
  if (airight >= (aileft + pisizemin)) and (aibottom >= (aitop + pisizemin)) then
    set the rect of member pimember to rect(0, 0, airight - aileft - pirectadjust, aibottom - aitop - pirectadjust)
    set the loc of sprite pisprite to point(aileft + pilocadjust, aitop + pilocadjust)
    spriteBox(piselectsprite, aileft, aitop, airight, aibottom)
    updateStage()
  end if
end
