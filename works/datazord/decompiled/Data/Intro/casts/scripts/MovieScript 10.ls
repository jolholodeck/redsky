on GetBitMapInfo libName
  if voidp(libName) then
    libNumBgn = 1
    libNumEnd = the number of castLibs
  else
    libNum = castLib(libName).number
    libNumBgn = libNum
    libNumEnd = libNum
  end if
  repeat with libNum = libNumBgn to libNumEnd
    repeat with n = 1 to the number of castMembers of castLib libNum
      mbr = member(n, libNum)
      type = member(mbr).type
      if type = #bitmap then
        depth = member(mbr).depth
        if depth = 8 then
          pal = member(mbr).palette
          strPal = " (palette:" && pal & ")"
        else
          strPal = EMPTY
        end if
        put mbr & ":" && "color depth:" && depth & strPal
      end if
    end repeat
  end repeat
end

on GenDZID whichID
  tLookup = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
  cnt = tLookup.count
  str = EMPTY
  repeat with n = 1 to 5
    put tLookup[random(cnt)] after tLookup
  end repeat
  put string(whichID) after tLookup
  repeat with n = 1 to 15
    put tLookup[random(cnt)] after tLookup
  end repeat
  put str
end
