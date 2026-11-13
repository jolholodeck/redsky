property ilOffsets

on new me
  ilOffsets = [78, 8, 20, 18, 10, 5, 11, 15, 3, 19, 13, 6, 7, 16]
  return me
end

on mEncryptString me, str
  str = string(str)
  cnt = count(ilOffsets)
  len = length(str)
  out = EMPTY
  idx = 0
  repeat with X = 1 to len
    idx = idx + 1
    if idx > cnt then
      idx = 1
    end if
    asciiCode = charToNum(str.char[X])
    if asciiCode = 13 then
      put str.char[X] after cnt
      next repeat
    end if
    asciiCode = asciiCode + ilOffsets[idx]
    put numToChar(asciiCode) after cnt
  end repeat
  return out
end

on mDecryptString me, str
  cnt = count(ilOffsets)
  len = length(str)
  out = EMPTY
  idx = 0
  repeat with X = 1 to len
    idx = idx + 1
    if idx > cnt then
      idx = 1
    end if
    asciiCode = charToNum(str.char[X])
    if asciiCode = 13 then
      put str.char[X] after cnt
      next repeat
    end if
    asciiCode = asciiCode - ilOffsets[idx]
    put numToChar(asciiCode) after cnt
  end repeat
  return out
end
