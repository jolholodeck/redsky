property ancestor, ioConsole, ioGlobalUI, ikLastKeyFlushTime, iklCaseMap, iKbdEnabled, ilKeyMap, ilModMap

on new me, oConsole
  ioConsole = oConsole
  ioGlobalUI = ioConsole.ioGlobalUI
  ikLastKeyFlushTime = 20
  iklCaseMap = mGetCaseMap(me)
  sort(iklCaseMap)
  ilKeyMap = [:]
  ilModMap = [:]
  me.mDisableKbd()
  return me
end

on mRegisterModule me, oModule, Ldata
  if listp(ilModMap.getaProp(oModule)) then
    exit
  end if
  Ldata = duplicate(Ldata)
  lKeys = []
  cnt = Ldata.count
  repeat with X = 1 to cnt
    lKeys.add(Ldata.getPropAt(X))
  end repeat
  ilModMap.addProp(oModule, lKeys)
  repeat with X = 1 to cnt
    aKey = Ldata.getPropAt(X)
    target = Ldata[X]
    target.addAt(1, oModule)
    ilKeyMap.setaProp(aKey, duplicate(target))
  end repeat
end

on mUnregisterModule me, oModule
  if not listp(ilModMap.getaProp(oModule)) then
    exit
  end if
  lKeys = ilModMap.getaProp(oModule)
  if not listp(lKeys) then
    exit
  end if
  repeat with aKey in lKeys
    ilKeyMap.deleteProp(aKey)
  end repeat
  ilModMap.deleteProp(oModule)
end

on mHandleKey me
  aKey = the key
  if not iKbdEnabled then
    exit
  end if
  if the lastKey > ikLastKeyFlushTime then
    exit
  end if
  if ioGlobalUI.mHandleKey(the keyCode) then
    exit
  end if
  aKey = getaProp(iklCaseMap, aKey)
  if voidp(aKey) then
    exit
  end if
  widgetData = getaProp(ilKeyMap, aKey)
  if voidp(widgetData) then
    exit
  end if
  widgetData[2].mTrigger(widgetData[3], aKey)
  return aKey
end

on mDisableKbd me
  iKbdEnabled = 0
end

on mEnableKbd me
  iKbdEnabled = 1
end

on mGetCaseMap me
  map = ["A": "a", "B": "b", "C": "c", "D": "d", "E": "e", "F": "f", "G": "g", "H": "h", "I": "i", "J": "j", "K": "k", "L": "l", "M": "m", "N": "n", "O": "o", "P": "p", "Q": "q", "R": "r", "S": "s", "T": "t", "U": "u", "V": "v", "W": "w", "X": "x", "Y": "y", "Z": "z", "{": "[", "}": "]", "|": "\", ":": ";", "<": ",", ">": ".", "?": "/", "~": "`", "!": "1", "@": "2", "#": "3", "$": "4", "%": "5", "^": "6", "&": "7", "*": "8", "(": "9", ")": "0", "_": "-", "+": "="]
  out = duplicate(map)
  repeat with chr in map
    addProp(out, chr, chr)
  end repeat
  addProp(out, QUOTE, "'")
  addProp(out, "'", "'")
  return out
end
