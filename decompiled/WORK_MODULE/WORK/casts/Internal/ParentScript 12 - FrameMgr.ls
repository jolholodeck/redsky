property ploActors, ploToBeAdded, ploToBeRemoved, psymAtEnd

on new me, symAtEnd
  set psymAtEnd to symAtEnd
  set ploActors to []
  set ploToBeAdded to []
  set ploToBeRemoved to []
  add(the actorList, me)
  return me
end

on mAdd me, oWho
  append(ploToBeAdded, oWho)
end

on mRemove me, oWho
  append(ploToBeRemoved, oWho)
end

on stepFrame me
  if count(ploToBeAdded) > 0 then
    repeat with oToAdd in ploToBeAdded
      set where to getPos(ploActors, oToAdd)
      if where = 0 then
        add(ploActors, oToAdd)
      end if
    end repeat
    set ploToBeAdded to []
  end if
  if count(ploToBeRemoved) > 0 then
    repeat with oToRemove in ploToBeRemoved
      set where to getPos(ploActors, oToRemove)
      if where > 0 then
        deleteAt(ploActors, where)
      end if
    end repeat
    set ploToBeRemoved to []
  end if
  repeat with oActor in ploActors
    mFrameEvent(oActor)
  end repeat
end

on mCleanUp me
  set nActors to count(ploActors)
  if nActors > 0 then
    repeat with i = 1 to nActors
      set oActor to getAt(ploActors, i)
      if psymAtEnd = #kill then
        mCleanUp(oActor)
        setAt(ploActors, i, VOID)
        next repeat
      end if
      put "*** Object not removed from FrameMgr:" && oActor
      beep()
    end repeat
  end if
  set ploActors to []
  set ploToBeAdded to []
  set ploToBeRemoved to []
  set the actorList to []
end
