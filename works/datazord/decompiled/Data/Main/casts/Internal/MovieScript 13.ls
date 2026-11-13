on loadFile filePath
  fileObj = new(xtra("fileIO"))
  if not objectp(fileObj) then
    return -1
  end if
  if not stringp(filePath) then
    return -2
  end if
  if filePath = EMPTY then
    return -3
  end if
  openFile(fileObj, filePath, 1)
  errCod = status(fileObj)
  errStr = error(fileObj, errCod)
  if errStr <> "OK" then
    fileObj = 0
    return errCod
  end if
  fileStr = readFile(fileObj)
  errCod = status(fileObj)
  errStr = error(fileObj, errCod)
  closeFile(fileObj)
  fileObj = 0
  if errStr <> "OK" then
    return errCod
  end if
  if not stringp(fileStr) then
    return errCod
  end if
  return fileStr
end
