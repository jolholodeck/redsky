property xFile

on new me
  if objectp(xFile) then
    xFile = 0
  end if
  return me
end

on mIsFile me, fName
  if not stringp(fName) then
    return 0
  end if
  if fName = EMPTY then
    return 0
  end if
  if objectp(xFile) then
    xFile = 0
  end if
  xFile = new(xtra("fileIO"))
  openFile(xFile, fName, 0)
  errCod = status(xFile)
  if errCod = 0 then
    closeFile(xFile)
    xFile = 0
    return 1
  else
    xFile = 0
    return 0
  end if
end

on mReadFile me, fName
  if objectp(xFile) then
    xFile = 0
  end if
  xFile = new(xtra("fileIO"))
  openFile(xFile, fName, 1)
  err = status(xFile)
  if err <> 0 then
    xFile = 0
    return err
  end if
  str = readFile(xFile)
  err = status(xFile)
  if err <> 0 then
    xFile = 0
    return err
  end if
  closeFile(xFile)
  err = status(xFile)
  if err <> 0 then
    xFile = 0
    return err
  end if
  xFile = 0
  return str
end

on mWriteFile me, fName, dataStr, deleteFlg, macFlg, fType, fCreator
  if voidp(deleteFlg) then
    deleteFlg = 1
  end if
  if voidp(macFlg) then
    macFlg = 0
  end if
  if me.mIsFile(fName) then
    if deleteFlg then
      err = me.mDeleteFile(fName)
      if err <> 0 then
        return err
      end if
    else
      return -122
    end if
  end if
  if objectp(xFile) then
    xFile = 0
  end if
  xFile = new(xtra("fileIO"))
  createFile(xFile, fName)
  err = status(xFile)
  if err <> 0 then
    xFile = 0
    return err
  end if
  openFile(xFile, fName, 2)
  err = status(xFile)
  if err <> 0 then
    xFile = 0
    return err
  end if
  writeString(xFile, dataStr)
  err = status(xFile)
  if err <> 0 then
    xFile = 0
    return err
  end if
  if not (voidp(fType) or voidp(fCreator)) and macFlg then
    setFinderInfo(xFile, fType && fCreator)
    err = status(xFile)
    if err <> 0 then
      xFile = 0
      return err
    end if
  end if
  closeFile(xFile)
  err = status(xFile)
  if err <> 0 then
    xFile = 0
    return err
  end if
  xFile = 0
  return 0
end

on mDeleteFile me, fName
  if objectp(xFile) then
    xFile = 0
  end if
  xFile = new(xtra("fileIO"))
  openFile(xFile, fName, 1)
  err = status(xFile)
  if err <> 0 then
    xFile = 0
    return err
  end if
  delete(xFile)
  err = status(xFile)
  if err <> 0 then
    xFile = 0
    return err
  end if
  xFile = 0
  return 0
end
