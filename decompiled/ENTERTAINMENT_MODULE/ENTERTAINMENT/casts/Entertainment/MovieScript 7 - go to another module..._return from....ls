global ganimation_list, gsync_list, state_cowboy, state_pnumber, ganimation_latency2, ganimation_latency3, gactualticks, goStateMgr, goNavMgr

on prepModule
  flicker_setstate(#off)
  if state_cowboy = 2 then
    animation_kill(#cowboy)
  else
    sync_kill(#cowboy)
  end if
  killextraanimations()
  mPurgeAllSounds(goNavMgr)
  savestate()
end

on savestate
  mSetData(goStateMgr, #animation_list, ganimation_list)
  mSetData(goStateMgr, #animation_latency2, ganimation_latency2)
  mSetData(goStateMgr, #animation_latency3, ganimation_latency3)
  mSetData(goStateMgr, #sync_list, gsync_list)
  mSetData(goStateMgr, #actualticks, gactualticks)
  mSetData(goStateMgr, #cowboy, state_cowboy)
  mSetData(goStateMgr, #pnumber, state_pnumber)
  set puppetlist to []
  repeat with i = 1 to 120
    set k to #no
    if the type of the member of sprite i <> #empty then
      if the puppet of sprite i = 1 then
        set k to #yes
      end if
    end if
    add(puppetlist, k)
  end repeat
  mSetData(goStateMgr, #puppetlist, puppetlist)
end

on restorestate
  timer_init()
  mouse_init(6)
  set ganimation_list to mGetData(goStateMgr, #animation_list)
  set ganimation_latency2 to mGetData(goStateMgr, #animation_latency2)
  set ganimation_latency3 to mGetData(goStateMgr, #animation_latency3)
  set gsync_list to mGetData(goStateMgr, #sync_list)
  set gactualticks to mGetData(goStateMgr, #actualticks)
  flicker_init()
  flicker_setstate(#on)
  setupglobals()
  set state_cowboy to mGetData(goStateMgr, #cowboy)
  set state_pnumber to mGetData(goStateMgr, #pnumber)
  set puppetlist to mGetData(goStateMgr, #puppetlist)
  set j to 1
  repeat with i in puppetlist
    if i = #yes then
      puppetSprite(j, 1)
    end if
    set j to j + 1
  end repeat
  reinstallcowboy()
  animation_forceupdateall()
  cursor([member "Bullet", member "BulletMask"])
end

on reinstallcowboy
  if state_cowboy >= 50 then
    set state_cowboy to state_cowboy - 50
  end if
  case state_cowboy of
    1, 1.5:
      cowboysendtoloopdone()
    2:
      cowboywelcomedone()
    3, 3.5, 4, 5, 6:
      cowboylassodone()
    7:
      cowboyhelpthanksdone()
    8, 8.09999999999999964, 8.19999999999999929, 8.30000000000000071, 8.40000000000000036:
      cowboysongintrodone()
    9:
      cowboysongdone()
  end case
end
