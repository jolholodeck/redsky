property mx, my, RasterMap, cellX, cellY, ax1, ay1, ax2, ay2
global gdmoDebugRasterMap, gdmoQuillSprite, gdmoDEBUG

on new this, x1, y1, x2, y2, dx, dy
  set gdmoDebugRasterMap to 0
  set x to x2 - x1
  set y to y2 - y1
  if x < 0 then
    set x to 0
  end if
  if y < 0 then
    set y to 0
  end if
  if dx <= 0 then
    set dx to 1
  end if
  if dy <= 0 then
    set dy to 1
  end if
  set cx to integer(x / dx) + 1
  set cy to integer(y / dy) + 1
  set the RasterMap of this to []
  repeat with i = 1 to cy
    set xlist to []
    repeat with j = 1 to cx
      append(xlist, #nothing)
    end repeat
    append(the RasterMap of this, xlist)
  end repeat
  set the mx of this to cx
  set the my of this to cy
  set the cellX of this to dx
  set the cellY of this to dy
  set the ax1 of this to x1
  set the ay1 of this to y1
  set the ax2 of this to x2
  set the ay2 of this to y2
  if gdmoDEBUG then
    put "raster cell size:  ", cellX, cellY
  end if
  return this
end

on setVal this, x, y, val
  set x1 to the ax1 of this
  set y1 to the ay1 of this
  set x2 to the ax2 of this
  set y2 to the ay2 of this
  if (x < x1) or (x > x2) or (y < y1) or (y > y2) then
    return 0
  end if
  set px to 1 + integer((x - x1) / the cellX of this)
  set py to 1 + integer((y - y1) / the cellY of this)
  deleteAt(getAt(the RasterMap of this, py), px)
  addAt(getAt(the RasterMap of this, py), px, val)
  if gdmoDebugRasterMap then
    debugRasterMap(this, px, py)
  end if
  return 1
end

on setValForArea this, x1, y1, x2, y2, val
  if x2 < x1 then
    set tt to x2
    set x2 to x1
    set x1 to tt
  end if
  if y2 < y1 then
    set tt to y2
    set y2 to y1
    set y1 to tt
  end if
  set tx1 to the ax1 of this
  set ty1 to the ay1 of this
  set px1 to 1 + integer((x1 - tx1) / the cellX of this)
  set py1 to 1 + integer((y1 - ty1) / the cellY of this)
  set px2 to 1 + integer((x2 - tx1) / the cellX of this)
  set py2 to 1 + integer((y2 - ty1) / the cellY of this)
  if px1 < 1 then
    set px1 to 1
  end if
  if py1 < 1 then
    set py1 to 1
  end if
  if px2 > the mx of this then
    set px2 to the mx of this
  end if
  if py2 > the my of this then
    set py2 to the my of this
  end if
  repeat with px = px1 to px2
    repeat with py = py1 to py2
      deleteAt(getAt(the RasterMap of this, py), px)
      addAt(getAt(the RasterMap of this, py), px, val)
      if gdmoDebugRasterMap then
        debugRasterMap(this, px, py)
      end if
    end repeat
  end repeat
end

on getVal this, x, y
  set x1 to the ax1 of this
  set y1 to the ay1 of this
  set x2 to the ax2 of this
  set y2 to the ay2 of this
  if (x < x1) or (x > x2) or (y < y1) or (y > y2) then
    return #nothing
  end if
  set px to 1 + integer((x - x1) / the cellX of this)
  set py to 1 + integer((y - y1) / the cellY of this)
  return getAt(getAt(the RasterMap of this, py), px)
end

on dump this
  put "RasterMap ", this
  put "User Area:   (" & the ax1 of this & ", " & the ay1 of this & ") - (" & the ax2 of this & ", " & the ay2 of this & ")"
  put "Grid Dims:   (" & the mx of this & ", " & the my of this & ")"
  put "Cell Size:   (" & the cellX of this & ", " & the cellY of this & ")"
  set cy to the my of this
  repeat with i = 1 to cy
    put getAt(the RasterMap of this, i)
  end repeat
end

on clearValFromMap this, val
  set gx to the mx of this
  set gy to the my of this
  set rm to the RasterMap of this
  repeat with i = 1 to gy
    repeat with k = 1 to gx
      if getAt(getAt(rm, i), k) = val then
        deleteAt(getAt(the RasterMap of this, i), k)
        addAt(getAt(the RasterMap of this, i), k, #nothing)
      end if
    end repeat
  end repeat
end

on getBoundingBoxForVal this, val
  set gx to the mx of this
  set gy to the my of this
  set cx to the cellX of this
  set cy to the cellY of this
  set x1 to the ax1 of this
  set y1 to the ay1 of this
  set rm to the RasterMap of this
  set minX to gx
  set maxX to 0
  set minY to gy
  set maxY to 0
  set oneFound to 0
  repeat with i = 1 to gy
    repeat with k = 1 to gx
      if getAt(getAt(rm, i), k) = val then
        if i < minY then
          set minY to i
        end if
        if i > maxY then
          set maxY to i
        end if
        if k < minX then
          set minX to k
        end if
        if k > maxX then
          set maxX to k
        end if
        set oneFound to 1
      end if
    end repeat
  end repeat
  if oneFound then
    set minX to x1 + (cx * (minX - 1))
    set minY to y1 + (cy * (minY - 1))
    set maxX to x1 + (cx * (maxX - 1)) + cx
    set maxY to y1 + (cy * (maxY - 1)) + cy
  else
    set minX to 0
    set minY to 0
    set maxX to 0
    set maxY to 0
  end if
  return rect(minX, minY, maxX, maxY)
end

on getScanLineMaskForVal this, val
  set gx to the mx of this
  set gy to the my of this
  set cx to the cellX of this
  set cy to the cellY of this
  set x1 to the ax1 of this
  set y1 to the ay1 of this
  set rm to the RasterMap of this
  set pList to []
  repeat with i = 1 to gy
    set ptFound to 0
    repeat with k = 1 to gx
      if getAt(getAt(rm, i), k) = val then
        set px to x1 + (cx * (k - 0.5))
        set py to y1 + (cy * (i - 0.5))
        set pLeft to point(px, py)
        set ptFound to 1
      end if
    end repeat
    repeat with k = 1 to gx
      set pk to gx - k + 1
      if getAt(getAt(rm, i), pk) = val then
        set px to x1 + (cx * (k - 0.5))
        set py to y1 + (cy * (i - 0.5))
        set pRight to point(px, py)
      end if
    end repeat
    if ptFound then
      append(pList, pLeft)
      append(pList, pRight)
    end if
  end repeat
  return pList
end

on debugRasterMap this, px, py
  set x1 to the ax1 of this
  set y1 to the ay1 of this
  set cx to the cellX of this
  set cy to the cellY of this
  set zx1 to x1 + (cx * (px - 1))
  set zy1 to y1 + (cy * (py - 1))
  updateStage()
  set the member of sprite gdmoQuillSprite to member "cell.block"
  set the loc of sprite gdmoQuillSprite to point(zx1, zy1)
  set the blend of sprite gdmoQuillSprite to 30
  updateStage()
end

on dumpMap this
  set cx to the mx of this
  set cy to the my of this
  repeat with i = 1 to cy
    set row to " "
    repeat with k = 1 to cx
      case getAt(getAt(the RasterMap of this, i), k) of
        #paperEdge:
          set row to row & "# "
        #antPatrol:
          set row to row & "a "
        #text1:
          set row to row & "t1"
        #text2:
          set row to row & "t2"
        #leftArrow:
          set row to row & "<-"
        #rghtArrow:
          set row to row & "->"
        #deadAnt:
          set row to row & "x "
        #nothing:
          set row to row & ". "
        otherwise:
          set row to row & "? "
      end case
    end repeat
    put row
  end repeat
end

on test this
  put 
  put "/---------------------------\"
  put "|  Testing: RasterMap Class  |"
  put "\---------------------------/"
  put 
  put "Creating:  new(script " & QUOTE & "RasterMap Class" & QUOTE & ", 0,0,0,0,0,0)"
  set f to new(script "RasterMap Class", 0, 0, 0, 0, 0, 0)
  put " result:"
  dump(f)
  set f to 0
  put 
  put "Creating:  new(script " & QUOTE & "RasterMap Class" & QUOTE & ", 0,0, -1.6, -2.4, -0.8, -9.6)"
  set f to new(script "RasterMap Class", 0, 0, -1.60000000000000009, -2.39999999999999991, -0.80000000000000004, -9.59999999999999964)
  put " result:"
  dump(f)
  set f to 0
  put 
  put "Creating:  new(script " & QUOTE & "RasterMap Class" & QUOTE & ", 0,0,2,3,18,19)"
  set f to new(script "RasterMap Class", 0, 0, 2, 3, 18, 19)
  put " result:"
  dump(f)
  set f to 0
  put 
  put "Testing Set/Get"
  put "---------------"
  set f to new(script "RasterMap Class", 0, 0, 10, 10, 4, 4)
  dump(f)
  put setVal(f, 7, 6, 2)
  put setVal(f, 1, 1, 1)
  put setVal(f, 10, 10, 4)
  put setVal(f, 8, 2, 8)
  put setVal(f, 3, 7, 3)
  put setVal(f, 19, 18, 7)
  put setVal(f, -1, -10, 8)
  dump(f)
  repeat with i = -1 to 5
    set r to "[ "
    repeat with j = -1 to 5
      set r to r & getVal(f, j * 3, i * 3) & " "
    end repeat
    set r to r & " ]"
    put r
  end repeat
  set f to 0
  put 
  put "Some random/float sized floors,  setArea"
  put "----------------------------------------"
  set f to new(script "RasterMap Class", -50, -60, 107, 98, 26, 32)
  setValForArea(f, 0, -10, 40, 10, 3)
  dump(f)
  set f to 0
  set f to new(script "RasterMap Class", 27.60000000000000142, 48.70000000000000284, 367.23000000000001819, 264.88999999999998636, 44.70000000000000284, 48.5)
  setValForArea(f, 58.20000000000000284, 63.89999999999999858, 184.59999999999999432, 172.90000000000000568, 4)
  setValForArea(f, 0, 0, 40, 40, 1)
  setValForArea(f, 300, -100, 800, 100, 8)
  setValForArea(f, -100, 200, 100, 800, 6)
  dump(f)
  set f to 0
end
