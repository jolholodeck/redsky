on AdjustWdgDatMemNumRefs LmemNumWdgDat, libNum, theOffset
  repeat with memNumWdgDat in LmemNumWdgDat
    mbrWdgData = member(memNumWdgDat, libNum)
    if member(mbrWdgData).type <> #field then
      alert("The member is not a field.")
      exit
    end if
    LwdgData = value(member(mbrWdgData).text)
    if not ilk(LwdgData, #propList) then
      alert("The data is corrupt.")
      exit
    end if
    Ltags = LwdgData[1]
    repeat with Ltag in Ltags
      animDef = Ltag.anim
      if ilk(animDef, #point) then
        Ltag.anim = point(animDef[1] + theOffset, animDef[2] + theOffset)
      else
        if ilk(animDef, #linearList) then
          Lanim = []
          repeat with memNum in animDef
            append(Lanim, memNum + theOffset)
          end repeat
          Ltag.anim = Lanim
        else
          alert("Unknown animation definition.")
          exit
        end if
      end if
      if Ltag.bg > 0 then
        Ltag.bg = Ltag.bg + theOffset
      end if
      Ltag.deleteProp(#sound)
      Ltag.deleteProp(#unused3)
    end repeat
    member(mbrWdgData).text = string(LwdgData)
  end repeat
end

on AdjustMemNumRefs LmemNum, libNum, theOffset
  repeat with memNum in LmemNum
    mbr = member(memNum, libNum)
    if member(mbr).type <> #field then
      alert("The member is not a field.")
      exit
    end if
    Ldata = value(member(mbr).text)
    if not ilk(Ldata, #propList) then
      alert("The data is corrupt.")
      exit
    end if
    repeat with Ltemp in Ldata
      if ilk(Ltemp, #linearList) then
        repeat with n = 1 to Ltemp.count
          Ltemp[n] = Ltemp[n] + theOffset
        end repeat
      end if
    end repeat
    member(mbr).text = string(Ldata)
  end repeat
end

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

on checkSyncTag
  libNumBgn = 3
  libNumEnd = the number of castLibs
  repeat with libNum = libNumBgn to libNumEnd
    repeat with n = 1 to the number of castMembers of castLib libNum
      mbr = member(n, libNum)
      if (mbr.type <> #field) and (mbr.type <> #text) then
        next repeat
      end if
      cName = mbr.name
      if not (cName starts "wdgData_") then
        next repeat
      end if
      Ldata = parseListData(mbr)
      if not listp(Ldata) then
        put "conversion failed: " & cName
        next repeat
      end if
      Ltags = getaProp(Ldata, #iklTags)
      if not listp(Ltags) then
        next repeat
      end if
      syncTag = getaProp(Ltags, #sync)
      if not listp(syncTag) then
        put "no sync tag: " & cName
        next repeat
      end if
      if getaProp(syncTag, #sync) <> #done then
        put "***sync not done***: " & cName
        next repeat
      end if
      put cName && "OK"
    end repeat
  end repeat
end

on CheckBitMaps libNum
  LmemNum = []
  repeat with n = 1 to the number of castMembers of castLib libNum
    mbr = member(n, libNum)
    type = member(mbr).type
    if type = #bitmap then
      append(LmemNum, n)
    end if
  end repeat
  CheckDepth(LmemNum, libNum, 8)
  CheckSamePalette(LmemNum, libNum)
end

on CheckDepth LmemNum, libNum, testDepth
  repeat with memNum in LmemNum
    if member(memNum, libNum).depth <> testDepth then
      put "member" && string(memNum) && "colorDepth:" && member(memNum, libNum).depth
    end if
  end repeat
  return 0
end

on CheckSamePalette LmemNum, libNum
  memNum = LmemNum[LmemNum.count()]
  pal = member(memNum, libNum).palette
  repeat with memNum in LmemNum
    if member(memNum, libNum).palette <> pal then
      put "member" && string(memNum) && "palette:" && member(memNum, libNum).palette
    end if
  end repeat
  return [#Ok, pal]
end

on CheckMbrType LmemNum, libNum, mbrType
  repeat with memNum in LmemNum
    if member(memNum, libNum).type <> mbrType then
      return -1
    end if
  end repeat
  return 0
end

on GetCastSelection
  libNum = the activeCastLib
  Lselection = castLib(libNum).selection
  if Lselection.count = 0 then
    return -1
  end if
  Lmaster = [libNum]
  LmemNum = []
  repeat with Ltemp in Lselection
    bgnMemNum = Ltemp[1]
    endMemNum = Ltemp[2]
    if bgnMemNum = endMemNum then
      append(LmemNum, bgnMemNum)
      next repeat
    end if
    repeat with memNum = bgnMemNum to endMemNum
      append(LmemNum, memNum)
    end repeat
  end repeat
  append(Lmaster, LmemNum)
  return Lmaster
end

on ReverseList aList
  Ltemp = []
  repeat with n = aList.count down to 1
    append(Ltemp, aList[n])
  end repeat
  return Ltemp
end

on OffsetListVals theList, theOffset
  theList = duplicate(theList)
  repeat with n = 1 to theList.count
    theList[n] = theList[n] + theOffset
  end repeat
  put theList
end
