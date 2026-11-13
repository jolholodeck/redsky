on bump ptBump
  Lselection = GetCastSelection()
  if not ilk(Lselection, #list) then
    exit
  end if
  cstNum = Lselection[1]
  repeat with memNum in Lselection[2]
    curRegPt = member(memNum, cstNum).regPoint
    member(memNum, cstNum).regPoint = curRegPt + ptBump
  end repeat
end

on bitMapInfo
  Lselection = GetCastSelection()
  if not ilk(Lselection, #list) then
    exit
  end if
  cstNum = Lselection[1]
  repeat with memNum in Lselection[2]
    mbr = member(memNum, cstNum)
    if mbr.type = #bitmap then
      put memNum, mbr.depth, mbr.paletteRef, mbr.dither
    end if
  end repeat
end

on mbrInfo
  Lselection = GetCastSelection()
  if not ilk(Lselection, #list) then
    exit
  end if
  cstNum = Lselection[1]
  repeat with memNum in Lselection[2]
    mbr = member(memNum, cstNum)
    put memNum, mbr.type, mbr.size
  end repeat
end

on bitMapRegPoints
  Lselection = GetCastSelection()
  if not ilk(Lselection, #list) then
    exit
  end if
  cstNum = Lselection[1]
  repeat with memNum in Lselection[2]
    mbr = member(memNum, cstNum)
    put memNum, mbr.regPoint
  end repeat
end

on setPaletteRef whichPalette
  Lselection = GetCastSelection()
  if not ilk(Lselection, #list) then
    exit
  end if
  cstNum = Lselection[1]
  repeat with memNum in Lselection[2]
    mbr = member(memNum, cstNum)
    if mbr.type = #bitmap then
      mbr.paletteRef = whichPalette
    end if
  end repeat
end

on setDitherFlag flg
  Lselection = GetCastSelection()
  if not ilk(Lselection, #list) then
    exit
  end if
  cstNum = Lselection[1]
  repeat with memNum in Lselection[2]
    mbr = member(memNum, cstNum)
    if mbr.type = #bitmap then
      mbr.dither = flg
    end if
  end repeat
end

on GetCastSelection
  libNum = the activeCastLib
  Lselection = castLib(libNum).selection
  if Lselection.count = 0 then
    return -4
  end if
  Lmaster = [libNum]
  LmemNum = []
  repeat with Ltemp in Lselection
    bgnMemNum = Ltemp[1]
    endMemNum = Ltemp[2]
    if bgnMemNum = endMemNum then
      LmemNum.append(bgnMemNum)
      next repeat
    end if
    repeat with memNum = bgnMemNum to endMemNum
      LmemNum.append(memNum)
    end repeat
  end repeat
  Lmaster.append(LmemNum)
  return Lmaster
end

on CleanUp
  global goK
  castLib(goK.iLibNumCollUI).fileName = goK.iEmptyCstPath
  castLib(goK.iLibNumCollDio).fileName = goK.iEmptyCstPath
  castLib(goK.iLibNumSndScape).fileName = goK.iEmptyCstPath
  member("friend's email", goK.iLibNumAssets).text = " "
  member("friend's name", goK.iLibNumAssets).text = " "
  member("your name", goK.iLibNumAssets).text = " "
end

on DoVisible bln
  Lselect = the scoreSelection
  repeat with l in Lselect
    sprite(l[1]).visible = bln
  end repeat
end

on domainvisible bln
  global goK
  repeat with sprNum in goK.iLsprNum.main.PANEL
    sprite(sprNum).visible = bln
  end repeat
end

on WriteXtraList
  ofile = new(script("FileUtil.class"))
  ofile.mWriteFile(the moviePath & "Xtra List", string(the xtraList), 1)
  ofile = 0
end

on CompareLists whichBlend
  global goK
  aList = value(member("blend" && string(whichBlend), goK.iLibNumSndScape).text)
  bList = value(member("blend" && string(whichBlend) & ".2", goK.iLibNumSndScape).text)
  if aList.count <> bList.count then
    put "Master lists have different counts."
  end if
  repeat with n = 1 to aList.count
    if aList[n] <> bList[n] then
      put "Sublist" && string(n) && "is different."
    end if
    if aList[n].count <> bList[n].count then
      put "Sublist" && string(n) && "has a different count."
    end if
  end repeat
end

on Wait msecs
  t = the milliSeconds
  repeat while the milliSeconds < (t + msecs)
  end repeat
end
