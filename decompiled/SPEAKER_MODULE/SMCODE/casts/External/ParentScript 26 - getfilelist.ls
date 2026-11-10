property sscriptname

on new me
  set psscriptname to "getfilelist"
  return me
end

on init me
end

on cleanup me
end

on getfiles me, aspath, askind
  set tioktogo to DirectoryExists(aspath)
  set tlfiles to []
  sort(tlfiles)
  if tioktogo = 0 then
    repeat with n = 1 to the maxinteger
      set tsfile to getNthFileNameInFolder(aspath, n)
      if tsfile = EMPTY then
        exit repeat
      end if
      case askind of
        #demo:
          set tslength to length(tsfile)
          set tsextension to char (tslength - 3) to tslength of tsfile
          if (tsextension = ".dir") or (tsextension = ".dxr") then
            add(tlfiles, tsfile)
          end if
        #show:
          add(tlfiles, tsfile)
        otherwise:
          add(tlfiles, tsfile)
      end case
    end repeat
  end if
  return tlfiles
end
