on parseListData mbr, doReplace
  if (mbr.type <> #text) and (mbr.type <> #field) then
    return -1
  end if
  dataStr = mbr.text
  if dataStr = EMPTY then
    return -2
  end if
  lTest = value(dataStr)
  if listp(lTest) then
    return lTest
  end if
  nbLines = the number of lines in dataStr
  out = EMPTY
  repeat with X = 1 to nbLines
    if line X of dataStr starts "--" then
      next repeat
    end if
    put line X of dataStr after dataStr
  end repeat
  lOut = value(out)
  if not listp(lOut) then
    return -3
  end if
  if doReplace then
    mbr.text = string(lOut)
  end if
  return lOut
end

on buildList a, z
  lOut = []
  repeat with X = a to z
    lOut.add(X)
  end repeat
  return lOut
end

on makeList a, b
  if a = b then
    return [a]
  end if
  myList = []
  if a < b then
    repeat with i = a to b
      add(myList, i)
    end repeat
    return myList
  else
    repeat with i = a down to b
      add(myList, i)
    end repeat
    return myList
  end if
end

on zeroRegPoints startMbr, endMbr, libNum
  repeat with X = startMbr to endMbr
    if member(X, libNum).type <> #bitmap then
      next repeat
    end if
    member(X, libNum).regPoint = point(0, 0)
  end repeat
end

on offsetRegPoints startMbr, endMbr, libNum, off
  repeat with X = startMbr to endMbr
    if member(X, libNum).type <> #bitmap then
      next repeat
    end if
    member(X, libNum).regPoint = member(X, libNum).regPoint + off
  end repeat
end

on buildHelpKeyMbrList startMbr
  map = ["A": "a", "B": "b", "C": "c", "D": "d", "E": "e", "F": "f", "G": "g", "H": "h", "I": "i", "J": "j", "K": "k", "L": "l", "M": "m", "N": "n", "O": "o", "P": "p", "Q": "q", "R": "r", "S": "s", "T": "t", "U": "u", "V": "v", "W": "w", "X": "x", "Y": "y", "Z": "z", "{": "[", "}": "]", "|": "\", ":": ";", "<": ",", ">": ".", "?": "/", "~": "`", "!": "1", "@": "2", "#": "3", "$": "4", "%": "5", "^": "6", "&": "7", "*": "8", "(": "9", ")": "0", "_": "-", "+": "="]
  cnt = map.count
  out = [:]
  repeat with X = 1 to cnt
    out.addProp(map[X], startMbr + X - 1)
  end repeat
  out.addProp("'", startMbr + cnt)
  return out
end

on getWidgetOrgs
  global goConsole
  out = []
  lWidgets = goConsole.ioCurFrameset.iloModules[2].ikloWidgets
  idx = 0
  repeat with w in lWidgets
    idx = idx + 1
    mbr = w.iklWidgetData.animMbrs[1]
    pt = -member(mbr, 3).regPoint
    data = [idx, "wdg " & idx, pt, pt + point(30, 0)]
    out.add(duplicate(data))
  end repeat
  return out
end

on genPixelData pictMbr, fieldMbr, scale
  if pictMbr.type <> #bitmap then
    return -1
  end if
  if fieldMbr.type <> #field then
    return -2
  end if
  if not integerp(scale) then
    scale = 1
  end if
  if scale < 1 then
    scale = 1
  end if
  out = EMPTY
  pictWidth = pictMbr.width
  pictHeight = pictMbr.height
  X = 0
  Y = 0
  if the machineType = 256 then
    repeat while Y < pictHeight
      repeat while X < pictWidth
        pixChar = numToChar(pictMbr.getPixel(X, Y))
        put pixChar after out
        X = X + scale
      end repeat
      Y = Y + scale
      X = 0
    end repeat
  else
    repeat while Y < pictHeight
      repeat while X < pictWidth
        pixChar = numToChar(255 - pictMbr.getPixel(X, Y))
        put pixChar after out
        X = X + scale
      end repeat
      Y = Y + scale
      X = 0
    end repeat
  end if
  fieldMbr.text = out
  return 0
end

on switchColor pictMbr, srcCol, dstCol
  if pictMbr.type <> #bitmap then
    return -1
  end if
  if pictMbr.depth <> 8 then
    return -2
  end if
  if not integerp(srcCol) then
    return -3
  end if
  if not integerp(dstCol) then
    return -3
  end if
  srcCol = 255 - srcCol
  dstCol = 255 - dstCol
  if (srcCol < 0) or (srcCol > 255) then
    return -4
  end if
  if (dstCol < 0) or (dstCol > 255) then
    return -4
  end if
  if srcCol = dstCol then
    return -5
  end if
  pictWidth = pictMbr.width - 1
  pictHeight = pictMbr.height - 1
  repeat with Y = 0 to pictHeight
    repeat with X = 0 to pictWidth
      if pictMbr.getPixel(X, Y) = srcCol then
        pictMbr.setPixel(X, Y, dstCol)
      end if
    end repeat
  end repeat
  return 0
end

on getCastStats
  the itemDelimiter = ":"
  nbLibs = the number of castLibs
  total = 0
  repeat with X = 3 to nbLibs
    libName = the last item in the fileName of castLib X
    bitmaps = 0
    repeat with mbr = 1 to the number of castMembers of castLib X
      if member(mbr, X).type = #bitmap then
        bitmaps = bitmaps + 1
      end if
    end repeat
    total = total + bitmaps
    put libName & " : " & bitmaps & " bitmaps"
  end repeat
  put "total bitmaps: " & total
  put "average bitmaps per module: " & total / nbLibs
end

on getUIStats
  the itemDelimiter = ":"
  total = 0
  repeat with X = 1 to 2
    libName = the last item in the fileName of castLib X
    bitmaps = 0
    repeat with mbr = 1 to the number of castMembers of castLib X
      if member(mbr, X).type = #bitmap then
        bitmaps = bitmaps + 1
      end if
    end repeat
    total = total + bitmaps
    put libName & " : " & bitmaps & " bitmaps"
  end repeat
  put "total bitmaps: " & total
end

on checkPalette X
  repeat with mbr = 1 to the number of castMembers of castLib X
    if member(mbr, X).type = #bitmap then
      if member(mbr, X).paletteRef <> member(1, X) then
        put member(mbr, X) && member(mbr, X).paletteRef
      end if
    end if
  end repeat
end

on restorePalette X
  repeat with mbr = 1 to the number of castMembers of castLib X
    if member(mbr, X).type = #bitmap then
      if member(mbr, X).paletteRef <> member(1, X) then
        if mbr >= 1100 then
          member(mbr, X).paletteRef = member(1, X)
        end if
      end if
    end if
  end repeat
end

on RestoreDefaultCastLib
  repeat with libNum = 3 to 19
    castLib(libNum).fileName = the moviePath & "assets:lib:dz_deflt"
  end repeat
end

on LinkDZcastLibs
  repeat with libNum = 3 to 8
    castLib(libNum).fileName = the moviePath & "assets:lib:dz" & string(libNum - 2) & "base"
    put "linked castLib " & libNum
  end repeat
end

on ReportCstLibFileName
  repeat with n = 1 to the number of castLibs
    put castLib(n).fileName
  end repeat
end

on syncWidget
  global gRolloverWidget
  gRolloverWidget.mSync()
  gRolloverWidget.iSyncFromInterrupt = 1
end

on checkThreadWidgets
  cnt = count(the actorList)
  if cnt < 1 then
    put "actorlist empty"
    exit
  end if
  repeat with X = 1 to cnt
    obj = getAt(the actorList, X)
    if string(obj) contains "WgenericWidget.class" then
      put obj.ikFullID
    end if
  end repeat
end
