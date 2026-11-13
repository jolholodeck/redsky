property ancestor, ikDummyLibPath, ikStartLibNum, ikNbLibs, ikLastLibNum, ilLinkMap, ilFreeLibs, iNbLinks

on new me, dummyLibPath, startLibNum, nbLibs
  ikDummyLibPath = dummyLibPath
  ikStartLibNum = startLibNum
  ikNbLibs = nbLibs
  ikLastLibNum = ikStartLibNum + ikNbLibs - 1
  ilLinkMap = [:]
  ilFreeLibs = []
  repeat with X = ikStartLibNum to ikLastLibNum
    ilLinkMap.addProp(X, EMPTY)
    ilFreeLibs.add(X)
  end repeat
  iNbLinks = 0
  return me
end

on mLink me, libPath
  libNum = ilLinkMap.getOne(libPath)
  if libNum then
    return libNum
  end if
  if iNbLinks >= ikNbLibs then
    return -1
  end if
  libNum = ilFreeLibs[1]
  castLib(libNum).fileName = libPath
  if not (castLib(libNum).fileName starts libPath) then
    return -2
  end if
  ilFreeLibs.deleteAt(1)
  iNbLinks = iNbLinks + 1
  ilLinkMap.setaProp(libNum, libPath)
  return libNum
end

on mUnlinkByPath me, libPath
  if iNbLinks <= 0 then
    return -1
  end if
  libNum = ilLinkMap.getOne(libPath)
  if not libNum then
    return -2
  end if
  castLib(libNum).fileName = ikDummyLibPath
  ilFreeLibs.add(libNum)
  iNbLinks = iNbLinks - 1
  ilLinkMap.setaProp(libNum, EMPTY)
  return 0
end

on mUnlinkByLibNum me, libNum
  if iNbLinks <= 0 then
    return -1
  end if
  libPath = ilLinkMap.getaProp(libNum)
  if libPath = EMPTY then
    return -2
  end if
  castLib(libNum).fileName = ikDummyLibPath
  ilFreeLibs.add(libNum)
  iNbLinks = iNbLinks - 1
  ilLinkMap.setaProp(libNum, EMPTY)
  return 0
end

on mUnlinkAll me
  repeat with X = ikStartLibNum to ikLastLibNum
    err = me.mUnlinkByLibNum(X)
    if err = -3 then
      return -1
    end if
  end repeat
  return 0
end

on mGetLibNum me, libPath
  return ilLinkMap.getOne(libPath)
end

on mGetLibPath me, libNum
  return ilLinkMap.getaProp(libNum)
end
