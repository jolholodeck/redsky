property psscriptname, pxmode

on new me
  set psscriptname to "modemgr"
  return me
end

on init me
  set pxmode to #start
end

on setmode me, axmode
  set pxmode to axmode
end

on getmode me
  return pxmode
end

on cleanup me
end
