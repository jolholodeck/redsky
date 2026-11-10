global gsync_list

on sync_init
  set gsync_list to [:]
end

on sync_add theid, thesprite, thefps, thescript, thecallback, thereference, theaudiomember, theaudiochannel
  animation_add(theid, thesprite, 1, thefps, 1, thescript, "sync_callbackKill(#" & theid & ")", thereference)
  set newanim to [#state: #stopped, #audiomember: theaudiomember, #audiochannel: theaudiochannel, #callback: thecallback]
  setaProp(gsync_list, theid, newanim)
end

on sync_kill theid
  set temp to getaProp(gsync_list, theid)
  if not objectp(temp) then
    return -1
  else
    if animation_exists(theid) then
      animation_kill(theid)
    end if
    set tac to getaProp(temp, #audiochannel)
    puppetSound(tac, 0)
    sound stop tac
    updateStage()
    deleteProp(gsync_list, theid)
    return 0
  end if
end

on sync_callbackkill theid
  set temp to getaProp(gsync_list, theid)
  if objectp(temp) then
    set tcb to getaProp(temp, #callback)
    set tac to getaProp(temp, #audiochannel)
    puppetSound(tac, 0)
    sound stop tac
    updateStage()
    deleteProp(gsync_list, theid)
    do(tcb)
  end if
end

on sync_setstate theid, thestate
  set temp to getaProp(gsync_list, theid)
  set oldstate to getaProp(temp, #state)
  if oldstate = thestate then
    exit
  end if
  setaProp(temp, #state, thestate)
  set tac to getaProp(temp, #audiochannel)
  if oldstate = #stopped then
    puppetSound(tac, getaProp(temp, #audiomember))
    animation_setstate(theid, #playing)
    updateStage()
  else
    puppetSound(tac, 0)
    sound stop tac
    updateStage()
    animation_setstate(theid, #paused)
    animation_setframe(theid, 1)
    animation_forceupdate(theid)
  end if
end
