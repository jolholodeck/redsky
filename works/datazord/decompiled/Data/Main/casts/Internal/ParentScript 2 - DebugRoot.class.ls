property ibla, ibla2
global gDebug

on new me
  ibla = "xxx"
  ibla2 = [1, 2, 3]
  if gDebug then
    return me
  else
    return 
  end if
end

on mGetPropList me, obj, lProps
  if not objectp(obj) then
    obj = me
    lProps = [:]
  end if
  cnt = count(obj)
  repeat with X = 1 to cnt
    curProp = obj.getPropAt(X)
    curVal = obj.getaProp(curProp)
    if curProp = #ancestor then
      if objectp(curVal) then
        if curVal <> me then
          obj.mGetPropList(curVal, lProps)
        end if
      end if
      next repeat
    end if
    lProps.addProp(curProp, curVal)
  end repeat
  return lProps
end

on mDumpPropList me
  lProps = mGetPropList(me)
  cnt = count(lProps)
  outStr = EMPTY
  repeat with X = 1 to cnt
    curProp = getPropAt(lProps, X)
    curVal = getaProp(lProps, curProp)
    put string(curProp) & " = " & string(curVal) & RETURN after lProps
  end repeat
  return outStr
end

on mGetAncestors me, obj, lAncestors
  if not objectp(obj) then
    obj = me
    lAncestors = []
  end if
  anc = obj.getaProp(#ancestor)
  if objectp(anc) then
    lAncestors.add(anc)
    obj.mGetAncestors(anc, lAncestors)
  end if
  return lAncestors
end

on mDeleteAllProps me
  obj = me
  cnt = count(me)
  repeat with X = 1 to cnt
    curProp = obj.getPropAt(X)
    obj[X] = 0
  end repeat
end
