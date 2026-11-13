property ilFileData, iFilename, iMacFlag, ioFileUtil, ioEncrypt
global goSysEnvirons

on new me, fName
  iFilename = fName
  if goSysEnvirons.iPlatform = #mac then
    iMacFlag = 1
  else
    iMacFlag = 0
  end if
  ioFileUtil = new(script("FileUtil.class"))
  ioEncrypt = new(script("Encrypt.class"))
  me.mLoadData()
  return me
end

on mGetData me, aKey
  return getaProp(ilFileData, aKey)
end

on mSetData me, aKey, aVal, blnWriteToDisk
  curVal = getaProp(ilFileData, aKey)
  if (curVal <> aVal) or voidp(curVal) then
    setaProp(ilFileData, aKey, aVal)
    if voidp(blnWriteToDisk) then
      blnWriteToDisk = 0
    end if
    if blnWriteToDisk then
      me.mSaveData()
    end if
  end if
end

on mLoadData me
  if ioFileUtil.mIsFile(iFilename) then
    readstr = ioFileUtil.mReadFile(iFilename)
    if ilk(readstr) = #string then
      tempList = value(ioEncrypt.mDecryptString(readstr))
      if ilk(tempList) = #propList then
        ilFileData = tempList
        exit
      else
        alert("The Preferences Data File is corrupt and will be rewritten.")
      end if
    else
      me.mHandleError("Error reading preferences file: ", readstr)
    end if
  end if
  ilFileData = [:]
end

on mSaveData me
  savestr = ioEncrypt.mEncryptString(string(ilFileData))
  err = ioFileUtil.mWriteFile(iFilename, savestr, 1, iMacFlag, "pref", "ttxt")
  if err <> 0 then
    me.mHandleError("Error writing preferences file: ", err)
  end if
end

on mHandleError me, infoStr, errCod
  xFile = new(xtra("fileIO"))
  errStr = error(xFile, errCod)
  alert(infoStr & errStr)
  xFile = 0
end
