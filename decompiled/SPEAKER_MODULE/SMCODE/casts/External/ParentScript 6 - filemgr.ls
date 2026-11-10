property psscriptname, psrootdrive, psrsifolder, psshowpath, psdemopath, pilinkcastnumber, pscurrentfilename, pslinkfilename, pscurrentpath
global goNavMgr, gspathdelimiter, glslaves

on new me
  set psscriptname to "filemgrobj"
  return me
end

on init me
  set tsrootdrive to getrootdrive(me)
  if the ikOStype of goNavMgr = #win then
    set psrootdrive to tsrootdrive & gspathdelimiter
  else
    set psrootdrive to tsrootdrive & gspathdelimiter
  end if
  setupneededfolders(me)
  set pilinkcastnumber to 3
  set pscurrentfilename to pscurrentpath & "current"
  set pslinkfilename to the pathName & "link.cst"
end

on getrootdrive me
  set tsrootpath to the ikSystemDrive of goNavMgr
  set tsorgdelimiter to the itemDelimiter
  set the itemDelimiter to gspathdelimiter
  set tsrootdrive to item 1 of tsrootpath
  return tsrootdrive
end

on setupneededfolders me
  set psrsifolder to psrootdrive & "RSI_DEMO_SUPPORT" & gspathdelimiter
  set psshowpath to psrsifolder & "SHOWS" & gspathdelimiter
  set psdemopath to psrsifolder & "DEMOS" & gspathdelimiter
  set pscurrentpath to psrsifolder & "CURRENT" & gspathdelimiter
  if DirectoryExists(psrsifolder) < 0 then
    set tisuccessful to CreateDirectory(psrsifolder)
    if tisuccessful < 0 then
      domessage(gomessagemgr, 16)
    end if
  end if
  if DirectoryExists(psshowpath) < 0 then
    set tisuccessful to CreateDirectory(psshowpath)
    if tisuccessful < 0 then
      domessage(gomessagemgr, 16)
      exit
    end if
  end if
  if DirectoryExists(psdemopath) < 0 then
    set tisuccessful to CreateDirectory(psdemopath)
    if tisuccessful < 0 then
      domessage(gomessagemgr, 16)
      exit
    end if
  end if
  if DirectoryExists(pscurrentpath) < 0 then
    set tisuccessful to CreateDirectory(pscurrentpath)
    if tisuccessful < 0 then
      domessage(gomessagemgr, 16)
      exit
    end if
  end if
end

on cleanup me
  resetlink(me)
end

on checkforcurrent me
  if FileExists(pscurrentpath & "current") = 0 then
    return 1
  else
    return 0
  end if
end

on saveshow me, asfilename
  set tsfile to psshowpath & asfilename
  if FileExists(tsfile) then
    DeleteFile(tsfile)
  end if
  save(castLib pilinkcastnumber, tsfile)
end

on resetlink me
  set the fileName of castLib pilinkcastnumber to pslinkfilename
end

on openshow me, asfilename
  resetlink(me)
  set the fileName of castLib pilinkcastnumber to psshowpath & asfilename
end

on openplayshow
  set the fileName of castLib pilinkcastnumber to pscurrentfilename
end

on getcurlinked me
  set tsitemdelimiter to the itemDelimiter
  set the itemDelimiter to gspathdelimiter
  set tspathname to the fileName of castLib pilinkcastnumber
  set tsfile to the last item in tspathname
  set the itemDelimiter to tsitemdelimiter
  return tsfile
end

on getdemofiles me
  set tldemofiles to getfiles(getProp(glslaves, #getfilelist), psdemopath, #demo)
  return tldemofiles
end

on getshowfiles me
  set tlshowfiles to getfiles(getProp(glslaves, #getfilelist), psshowpath, #show)
  return tlshowfiles
end

on getdemopath me
  return psdemopath
end

on getcurrentfilename
  return pscurrentfilename
end
