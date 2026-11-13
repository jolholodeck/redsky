property plSndObjs
global glGlob

on new this
  this.mInit()
  return this
end

on mInit this
  plSndObjs = [:]
end

on mDestroy this
  cnt = plSndObjs.count
  repeat with i = 1 to cnt
    plSndObjs[i].mDestroy()
    plSndObjs[i] = VOID
  end repeat
  plSndObjs = VOID
end

on mUpdate this
  repeat with sndObj in plSndObjs
    sndObj.mUpdate()
  end repeat
end

on mLoadDone this
  repeat with sndObj in plSndObjs
    if not sndObj.mRMFready() then
      return 0
    end if
  end repeat
  return 1
end

on mLoadPcnt this
  bytesSoFar = 0
  bytesTotal = 1
  repeat with sndObj in plSndObjs
    bytesSoFar = bytesSoFar + sndObj.pBytesSoFar
    bytesTotal = bytesTotal + sndObj.pBytesTotal
  end repeat
  return [bytesSoFar, bytesTotal]
end

on mNewRMFobj this, tag, RMFurl
  newObj = glGlob.cSndObj.new()
  if newObj.pXtraReady then
    if stringp(RMFurl) then
      newObj.mLoadRMF(RMFurl)
    end if
    plSndObjs.addProp(tag, newObj)
  else
    newObj = VOID
  end if
  return newObj
end
