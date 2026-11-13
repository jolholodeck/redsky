property ancestor

on new me
  return me
end

on mPreloadMembers me, lMbrs, cLib, doIdleLoad
  if doIdleLoad then
    the idleLoadMode = 1
  else
    the idleLoadMode = 0
  end if
  if not listp(lMbrs) then
    exit
  end if
  if ilk(lMbrs, #point) then
    a = lMbrs[1]
    z = lMbrs[2]
    if a < z then
      preLoad(member(a, cLib), member(z, cLib))
    else
      preLoad(member(z, cLib), member(a, cLib))
    end if
  else
    repeat with mbr in lMbrs
      preloadMember(member(mbr, cLib))
    end repeat
  end if
  the idleLoadMode = 1
end
