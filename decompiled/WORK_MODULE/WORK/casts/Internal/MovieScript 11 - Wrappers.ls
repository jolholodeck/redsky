global goFrameMgr, goIdleMgr

on StartFrameWork symFrameAtEnd, symIdleAtEnd
  set goFrameMgr to new(script "FrameMgr", symFrameAtEnd)
  set goIdleMgr to new(script "IdleMgr", symIdleAtEnd)
end

on StopFrameWork
  mCleanUp(goIdleMgr)
  set goIdleMgr to VOID
  mCleanUp(goFrameMgr)
  set goFrameMgr to VOID
end

on RegisterForFrameEvents oWho
  mAdd(goFrameMgr, oWho)
end

on DeRegisterForFrameEvents oWho
  mRemove(goFrameMgr, oWho)
end

on RegisterForIdleEvents oWho
  mAdd(goIdleMgr, oWho)
end

on DeRegisterForIdleEvents oWho
  mRemove(goIdleMgr, oWho)
end
