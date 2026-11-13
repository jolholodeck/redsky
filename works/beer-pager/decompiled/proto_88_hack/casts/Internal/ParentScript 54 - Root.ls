on new me
  return me
end

on mGetPropList me
  cnt = count(me)
  lProps = [:]
  repeat with X = 1 to cnt
    curProp = getPropAt(me, X)
    curVal = getaProp(me, curProp)
    addProp(lProps, curProp, curVal)
  end repeat
  return lProps
end

on mDumpPropList me
  lProps = mGetPropList(me)
  cnt = count(lProps)
  outStr = EMPTY
  repeat with X = 1 to cnt
    curProp = getPropAt(me, X)
    curVal = getaProp(me, curProp)
  end repeat
  return outStr
end
