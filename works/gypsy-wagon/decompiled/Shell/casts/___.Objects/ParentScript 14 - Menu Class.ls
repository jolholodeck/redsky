property titleCast, titleLoc, numItems, itemList, rolloverIconPointList, pageList, crntPageIndex

on new this, iList
  set the numItems of this to count(iList)
  set the itemList of this to iList
  set the pageList of this to []
  set the rolloverIconPointList of this to []
  menuLayoutPages(this)
  set the crntPageIndex of this to 1
  set the titleCast of this to member "title.infinite"
  set the titleLoc of this to point(384, 112)
  return this
end

on menuLayoutPages this
  global gdmoMenuAreaBotY, gdmoMenuAreaTopY, gdmoMaxCharHeight, gMenuCenterX, gMenuLeftColX, gMenuRghtColX
  set topOfThisPage to 1
  set lastMenuItem to the numItems of this
  set maxEntryWdth to (gMenuCenterX - gMenuLeftColX) * 2.0 * 0.75
  set rollPointAboveBaseLine to gdmoMaxCharHeight / 5
  set pageList to []
  set rolloverIconPointList to []
  set dy to gdmoMenuAreaBotY - gdmoMenuAreaTopY
  set numPerCol to 1 + integer(dy / gdmoMaxCharHeight)
  set dyPerEntry to dy / numPerCol
  repeat while topOfThisPage <= lastMenuItem
    set numCols to 2
    set firstOne to topOfThisPage
    set lastOne to topOfThisPage + (numCols * numPerCol) - 1
    if lastOne > lastMenuItem then
      set lastOne to lastMenuItem
    end if
    if (lastOne - firstOne + 1) > numPerCol then
      repeat with i = firstOne to lastOne
        if the textWidth of getAt(the itemList of this, i) > maxEntryWdth then
          set numCols to 1
          exit repeat
        end if
      end repeat
    else
      set numCols to 1
    end if
    set lastOne to topOfThisPage + (numCols * numPerCol) - 1
    if lastOne > lastMenuItem then
      set lastOne to lastMenuItem
    end if
    if numCols = 2 then
      set colItem to (firstOne + lastOne) / 2
    else
      set colItem to lastOne
    end if
    set thisPage to new(script "PageClass")
    set the itemsOnPage of thisPage to lastOne - firstOne + 1
    set the numColumns of thisPage to numCols
    set the topIndex of thisPage to firstOne
    set the botIndex of thisPage to lastOne
    set the colIndex of thisPage to colItem
    set the heightPerEntry of thisPage to dyPerEntry
    append(the pageList of this, thisPage)
    repeat with i = firstOne to lastOne
      set iw2 to the textWidth of getAt(itemList, i) / 2
      case numCols of
        1:
          set px0 to gMenuCenterX - iw2
          set px1 to gMenuCenterX - iw2 - 25
          set px2 to gMenuCenterX + iw2 + 25
        2:
          if i > colItem then
            set px0 to gMenuRghtColX - iw2
            set px1 to gMenuRghtColX - iw2 - 25
            set px2 to gMenuRghtColX + iw2 + 25
          else
            set px0 to gMenuLeftColX - iw2
            set px1 to gMenuLeftColX - iw2 - 25
            set px2 to gMenuLeftColX + iw2 + 25
          end if
        otherwise:
          put "MENU: Invalid number of columns in menu layout:" && numCols && " ****"
      end case
      case numCols of
        1:
          set py to gdmoMenuAreaTopY + ((i - firstOne) * dyPerEntry)
        2:
          if i > colItem then
            set py to gdmoMenuAreaTopY + ((i - (colItem + 1)) * dyPerEntry)
          else
            set py to gdmoMenuAreaTopY + ((i - firstOne) * dyPerEntry)
          end if
      end case
      set py0 to py + getBaselineDroop(px0, py)
      set py1 to py + getBaselineDroop(px1, py) - rollPointAboveBaseLine
      set py2 to py + getBaselineDroop(px2, py) - rollPointAboveBaseLine
      set leftSidePoint to point(px1, py1)
      set rghtSidePoint to point(px2, py2)
      append(the rolloverIconPointList of this, list(leftSidePoint, rghtSidePoint))
      set the txtX of getAt(itemList, i) to px0
      set the txtY of getAt(itemList, i) to py0
      if i > colItem then
        set the rasterValue of getAt(itemList, i) to #text2
        next repeat
      end if
      set the rasterValue of getAt(itemList, i) to #text1
    end repeat
    set topOfThisPage to lastOne + 1
  end repeat
end

on menuScheduleRender this, theQuill
  global gdmoMenuAreaTopY, gMenuLeftColX, gMenuRghtColX
  set thisPage to getAt(the pageList of this, the crntPageIndex of this)
  set firstOne to the topIndex of thisPage
  set lastOne to the botIndex of thisPage
  set colItem to the colIndex of thisPage
  set dyPerItm to the heightPerEntry of thisPage
  set lTime to the timer
  set lDelay to 30
  repeat with i = firstOne to lastOne
    quillScheduleText(theQuill, lTime, getAt(the itemList of this, i))
    set lTime to lTime + lDelay
  end repeat
  set leftArrow to new(script "GraphicTextClass", numToChar(30))
  set rghtArrow to new(script "GraphicTextClass", numToChar(31))
  set the txtX of leftArrow to 235
  set the txtY of leftArrow to 365
  set the txtX of rghtArrow to 400
  set the txtY of rghtArrow to 369
  set the rasterValue of leftArrow to #leftArrow
  set the rasterValue of rghtArrow to #rghtArrow
  if the crntPageIndex of this > 1 then
    quillScheduleText(theQuill, lTime, leftArrow)
  end if
  if the crntPageIndex of this < count(the pageList of this) then
    set lTime to lTime + lDelay
    quillScheduleText(theQuill, lTime, rghtArrow)
  end if
end

on menuGetRollOverIndex this, x, y
  global gMenuCenterX, gdmoMenuAreaBotY, gdmoMenuAreaTopY
  set thisPage to getAt(the pageList of this, the crntPageIndex of this)
  set numCols to the numColumns of thisPage
  set firstOne to the topIndex of thisPage
  set lastOne to the botIndex of thisPage
  set colItem to the colIndex of thisPage
  set retVal to 1
  if y < gdmoMenuAreaTopY then
    if (numCols = 2) and (x > gMenuCenterX) then
      set retVal to colItem + 1
    else
      set retVal to firstOne
    end if
  else
    if y > gdmoMenuAreaBotY then
      if (numCols = 2) and (x < gMenuCenterX) then
        set retVal to colItem
      else
        set retVal to lastOne
      end if
    else
      set py to float(y - gdmoMenuAreaTopY)
      set py to py - getBaselineDroop(x, py)
      set py to 0.29999999999999999 + (py / the heightPerEntry of thisPage)
      if (numCols = 2) and (x > gMenuCenterX) then
        set retVal to integer(py) + colItem + 1
      else
        set retVal to integer(py) + firstOne
      end if
    end if
  end if
  if retVal < firstOne then
    set retVal to firstOne
  end if
  if retVal > lastOne then
    set retVal to lastOne
  end if
  return retVal
end

on menuGetRollOverIconPoint this, x, y
  global gMenuCenterX, gMenuLeftColX, gMenuRghtColX, gdmoTheAnt
  set thisPage to getAt(the pageList of this, the crntPageIndex of this)
  set numCols to the numColumns of thisPage
  set colItem to the colIndex of thisPage
  set idx to menuGetRollOverIndex(this, x, y)
  set ptList to getAt(the rolloverIconPointList of this, idx)
  if numCols = 2 then
    if idx > colItem then
      set colCenterX to gMenuRghtColX
    else
      set colCenterX to gMenuLeftColX
    end if
  else
    set colCenterX to gMenuCenterX
  end if
  set antPt to antGetPosition(gdmoTheAnt)
  set antX to getAt(antPt, 1)
  if getAt(antPt, 1) < colCenterX then
    return getAt(ptList, 1)
  else
    return getAt(ptList, 2)
  end if
end

on menuJumpRelativePage this, relativePageJump
  set crntPage to the crntPageIndex of this
  set numPages to count(the pageList of this)
  set newPage to crntPage + relativePageJump
  if newPage > numPages then
    set newPage to numPages
  end if
  if newPage < 1 then
    set newPage to 1
  end if
  if newPage <> crntPage then
    set the crntPageIndex of this to newPage
    quillQueueMenu(gdmoTheQuill, this)
  end if
end

on dump this
  put "-- Menu object:  " & this
  put "  " & the numItems of this & " items:"
  repeat with i = 1 to the numItems of this
    set gTxt to getAt(the itemList of this, i)
    put " " & i & ": <" & the textString of gTxt & ">"
  end repeat
end

on test this
  put 
  put "/-----------------------\"
  put "|  Testing: Menu Class  |"
  put "\-----------------------/"
end
