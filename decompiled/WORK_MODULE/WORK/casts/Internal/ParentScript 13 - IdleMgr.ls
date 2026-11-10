property ploIdlers, ploToBeAdded, ploToBeRemoved, psymAtEnd

on new me, symAtEnd
  set psymAtEnd to symAtEnd
  set ploIdlers to []
  set ploToBeAdded to []
  set ploToBeRemoved to []
  return me
end

on mAdd me, oWho
  append(ploToBeAdded, oWho)
end

on mRemove me, oWho
  append(ploToBeRemoved, oWho)
end

on mIdleEvent me
  if count(ploToBeAdded) > 0 then
    repeat with oToAdd in ploToBeAdded
      set where to getPos(ploIdlers, oToAdd)
      if where = 0 then
        add(ploIdlers, oToAdd)
      end if
    end repeat
    set ploToBeAdded to []
  end if
  if count(ploToBeRemoved) > 0 then
    repeat with oToRemove in ploToBeRemoved
      set where to getPos(ploIdlers, oToRemove)
      if where > 0 then
        deleteAt(ploIdlers, where)
      end if
    end repeat
    set ploToBeRemoved to []
  end if
  repeat with oIdler in ploIdlers
    mIdleEvent(oIdler)
  end repeat
end

on mCleanUp me
  set nIdlers to count(ploIdlers)
  if nIdlers > 0 then
    repeat with i = 1 to nIdlers
      set oIdler to getAt(ploIdlers, i)
      if psymAtEnd = #kill then
        mCleanUp(oIdler)
        setAt(ploIdlers, i, VOID)
        next repeat
      end if
      put "*** Object not removed from IdleMgr:" && oIdler
      beep()
    end repeat
  end if
  set ploIdlers to []
  set ploToBeAdded to []
  set ploToBeRemoved to []
end
