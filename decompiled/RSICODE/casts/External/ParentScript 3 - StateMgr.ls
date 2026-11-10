property plData

on new me
  set plData to [:]
  return me
end

on mCleanUp me
end

on mSetData me, symTag, lData
  setaProp(plData, symTag, lData)
end

on mGetData me, theSym
  set theData to getaProp(plData, theSym)
  return theData
end
