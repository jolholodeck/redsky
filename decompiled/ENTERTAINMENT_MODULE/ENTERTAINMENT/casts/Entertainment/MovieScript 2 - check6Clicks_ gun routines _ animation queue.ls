global script_x, script_exit, script_bottle, script_bottlearrow, script_changebutton, script_windmill, script_smoke, script_bird, script_birdreturn, script_window1, script_window2, script_bottle1, script_bottle2, script_windmillhitr, script_windmillhitl, script_bucket1, script_bucket2, script_signsway, script_signhit, script_womanring, script_windowb1, script_windowb2, script_ddenter, script_dddeath, script_dddeath2, script_ddexit, script_ddexit2, script_ddshock, script_pigshoot, script_pigdeath, script_pigdeath2, script_pigexit, script_pigshock, script_singing, script_cowboywelcome, script_cowboylasso, script_cowboyagritech, script_cowboyhelp, script_cowboythanks, script_cowboysongintro, script_cowboysong, script_cowboysendtoloop, script_cowboyguitardeath, script_cowboydeath, sprite_exit, sprite_bottle, sprite_bottlearrow, sprite_changebutton, sprite_windmill, sprite_smoke, sprite_bird, sprite_bucket, sprite_sign, sprite_window1, sprite_window2, sprite_woman, sprite_bottle1, sprite_bottle2, sprite_cowboy, sprite_dirtydan, sprite_pig, sprite_singing, sprite_bang, sprite_cowboybounds, state_cowboy, state_pnumber, state_ddorpig, ganimation_latency2, ganimation_latency3, gactualticks, ginsidebigpuffs, ginsidesmallpuffs

on check6clicks thetime
  set tempqueue to mouse_getqueue()
  repeat with temp in tempqueue
    if getaProp(temp, #ticks) = -1 then
      exit
    end if
  end repeat
  set firstitem to getaProp(getAt(tempqueue, 1), #ticks)
  set lastitem to getaProp(getAt(tempqueue, 6), #ticks)
  if (firstitem - lastitem) < thetime then
    if state_cowboy = 2 then
      animation_kill(#cowboy)
      puppetSound(1, 0)
      sound stop 1
      updateStage()
    else
      sync_kill(#cowboy)
    end if
    killextraanimations()
    flicker_setstate(#off)
    preloadMember("sprocket1", "sprocket3")
    superidleload()
    play frame "Broken"
    unloadMember("sprocket1", "sprocket3")
    mouse_addevent([#ticks: -1, #loc: point(0, 0)])
    flicker_setstate(#on)
    reinstallcowboy()
  end if
end

on killextraanimations
  if animation_exists(#dirtydan) then
    animation_kill(#dirtydan)
  end if
  if animation_exists(#pig) then
    animation_kill(#pig)
  end if
  if animation_exists(#changebutton) then
    animation_kill(#changebutton)
  end if
  if animation_exists(#singing) then
    animation_kill(#singing)
  end if
  if animation_exists(#bottlearrow) then
    animation_kill(#bottlearrow)
  end if
  if animation_exists(#burn) then
    animation_kill(#burn)
  end if
end

on hitwindmill
  animation_kill(#windmill)
  if the mouseH > 43 then
    animation_add(#windmill, sprite_windmill, 1, 20, 0, script_windmillhitr, "installWindmill", #shot)
  else
    animation_add(#windmill, sprite_windmill, 1, 20, 0, script_windmillhitl, "installWindmill", #shot)
  end if
  animation_setstate(#windmill, #playing)
end

on installwindmill
  animation_add(#windmill, sprite_windmill, -1, 20, 0, script_windmill, EMPTY, #Ok)
  animation_setstate(#windmill, #playing)
end

on hitbird
  set birdh to the mouseH
  set birdv to the mouseV
  set temp to animation_getframe(#bird)
  if animation_getreference(#bird) = #Ok then
    if temp > 40 then
      set birdhitscript to animation_memberstoscript(birdh + 165, birdv + 140, "e_eagle_shotR001", "e_eagle_shotR036")
    else
      set birdhitscript to animation_memberstoscript(birdh - 165, birdv + 140, "e_eagle_shotL00001", "e_eagle_shotL00036")
    end if
  else
    if temp < 40 then
      exit
    else
      if temp > 68 then
        set birdhitscript to animation_memberstoscript(birdh + 165, birdv + 140, "e_eagle_shotR001", "e_eagle_shotR036")
      else
        set birdhitscript to animation_memberstoscript(birdh - 165, birdv + 140, "e_eagle_shotL00001", "e_eagle_shotL00036")
      end if
    end if
  end if
  animation_kill(#bird)
  animation_add(#bird, sprite_bird, 1, 20, 0, birdhitscript, "installBirdReturn", #shot)
  animation_setstate(#bird, #playing)
end

on installbird
  animation_add(#bird, sprite_bird, -1, 20, 0, script_bird, EMPTY, #Ok)
  animation_setstate(#bird, #playing)
end

on installbirdreturn
  animation_add(#bird, sprite_bird, 1, 20, 0, script_birdreturn, "installBird", #return)
  animation_setstate(#bird, #playing)
end

on installbucket2
  animation_add(#bucket, sprite_bucket, 1, 20, 0, script_bucket2, EMPTY, #shot)
  animation_forceupdate(#bucket)
end

on installsign
  animation_add(#sign, sprite_sign, -1, 20, 0, script_signsway, EMPTY, #Ok)
  animation_forceupdate(#sign)
end

on hitsign
  animation_add(#sign, sprite_sign, 1, 20, 0, script_signhit, "installSign", #shot)
  animation_setstate(#sign, #playing)
end

on installbrokenwindow1
  animation_add(#window1, sprite_window1, 1, 20, 0, script_window1, EMPTY, #shot)
  animation_setframe(#window1, 9)
  animation_forceupdate(#window1)
end

on installbrokenwindow2
  animation_add(#window2, sprite_window2, 1, 20, 0, script_window2, EMPTY, #shot)
  animation_setframe(#window2, 9)
  animation_forceupdate(#window2)
end

on cowboywelcomedone
  flicker_splicecutpart1()
  if animation_exists(#bottle) = 0 then
    animation_add(#bottle, sprite_bottle, -1, 10, 0, script_bottle, EMPTY, 0)
    animation_forceupdate(#bottle)
  end if
  animation_add(#cowboy, sprite_cowboy, 3, 10, 1, script_cowboylasso, "cowboyLassoDone", 0)
  animation_setstate(#cowboy, #playing)
  puppetSound(1, "cb_2.aif")
  flicker_splicecutpart2(1)
  set state_cowboy to 2
end

on cowboylassodone
  puppetSound(1, 0)
  sound stop 1
  updateStage()
  flicker_splicecutpart1()
  sync_add(#cowboy, sprite_cowboy, 10, script_cowboyagritech, "cowboyShootDone", 0, member "cb_3.aif", 1)
  sync_setstate(#cowboy, #playing)
  animation_add(#dirtydan, sprite_dirtydan, 1, 10, 1, script_ddenter, EMPTY, 0)
  animation_setstate(#dirtydan, #playing)
  flicker_splicecutpart2(1)
  set state_cowboy to 3
  set state_ddorpig to #dirtydan
end

on cowboyshootdone
  flicker_splicecutpart1()
  if animation_exists(#changebutton) then
    animation_kill(#changebutton)
  end if
  if state_ddorpig = #pig then
    animation_kill(#pig)
    animation_add(#pig, sprite_pig, 1, 10, 1, script_pigexit, EMPTY, 0)
    animation_setstate(#pig, #playing)
  else
    animation_kill(#dirtydan)
    animation_add(#dirtydan, sprite_dirtydan, 1, 10, 1, script_ddexit, EMPTY, 0)
    animation_setstate(#dirtydan, #playing)
  end if
  sync_add(#cowboy, sprite_cowboy, 10, script_cowboyhelp, "cowboyHelpThanksDone", 0, member "cb_5.aif", 1)
  sync_setstate(#cowboy, #playing)
  flicker_splicecutpart2(1)
  set state_cowboy to 5
end

on dostaticdd
  animation_add(#dirtydan, sprite_dirtydan, 1, 10, 1, script_dddeath, "doStaticDD", 0)
  animation_setframe(#dirtydan, 67)
  animation_forceupdate(#dirtydan)
  if (state_cowboy >= 8) and (state_cowboy < 9) then
    installsinging()
  end if
end

on dostaticpig
  animation_add(#pig, sprite_pig, 1, 10, 1, script_pigdeath, "doStaticPig", 0)
  animation_setframe(#pig, 20)
  animation_forceupdate(#pig)
  if (state_cowboy >= 8) and (state_cowboy < 9) then
    installsinging()
  end if
end

on cowboyhelpthanksdone
  flicker_splicecutpart1()
  if animation_exists(#dirtydan) then
    animation_kill(#dirtydan)
  end if
  if animation_exists(#pig) then
    animation_kill(#pig)
  end if
  if animation_exists(#changebutton) then
    animation_kill(#changebutton)
  end if
  sync_add(#cowboy, sprite_cowboy, 10, script_cowboysongintro, "cowboySongIntroDone", 0, member "cb_7.aif", 1)
  sync_setstate(#cowboy, #playing)
  flicker_splicecutpart2(1)
  set state_cowboy to 7
end

on installsinging
  animation_add(#singing, sprite_singing, 1, 10, 1, script_singing, "installSinging", 0)
end

on cowboysongintrodone
  flicker_splicecutpart1()
  installsinging()
  sync_add(#cowboy, sprite_cowboy, 10, script_cowboysong, "cowboySongDone", 0, member "cb_8.aif", 1)
  sync_setstate(#cowboy, #playing)
  flicker_splicecutpart2(1)
  set state_cowboy to 8
end

on installddshock2
  flicker_splicecutpart1()
  animation_add(#dirtydan, sprite_dirtydan, 1, 10, 1, script_ddexit2, EMPTY, 0)
  animation_setstate(#dirtydan, #playing)
  flicker_splicecutpart2(1)
end

on cowboysongdone
  flicker_splicecutpart1()
  killextraanimations()
  sync_add(#cowboy, sprite_cowboy, 10, script_cowboysendtoloop, "cowboySendToLoopDone", 0, member "cb_9.aif", 1)
  sync_setstate(#cowboy, #playing)
  flicker_splicecutpart2(1)
  set state_cowboy to 9
end

on cowboysendtoloopdone
  flicker_splicecutpart1()
  set the visible of sprite 112 to 0
  set the visible of sprite 113 to 0
  set the visible of sprite 114 to 0
  set the visible of sprite 115 to 0
  set the loc of sprite 109 to point(0, 0)
  flicker_splicecutpart2(1)
  cowboyreset()
  set k to the ticks + 30
  repeat while the ticks < k
  end repeat
  flicker_splicecutpart1()
  set the loc of sprite 109 to point(-640, -480)
  flicker_splicecutpart2(1)
  set the visible of sprite 112 to 1
  set the visible of sprite 113 to 1
  set the visible of sprite 114 to 1
  set the visible of sprite 115 to 1
  set state_cowboy to 1
end

on cowboyreset
  animation_kill(#bottle)
  set the loc of sprite sprite_bottle to point(-1024, -1024)
  if animation_exists(#bottlearrow) then
    animation_kill(#bottlearrow)
  end if
  killextraanimations()
  animation_add(#window1, sprite_window1, 1, 20, 0, script_window1, "installBrokenWindow1", #Ok)
  animation_add(#window2, sprite_window2, 1, 20, 0, script_window2, "installBrokenWindow2", #Ok)
  animation_add(#bottle1, sprite_bottle1, 1, 20, 0, script_bottle1, EMPTY, #Ok)
  animation_add(#bottle2, sprite_bottle2, 1, 20, 0, script_bottle2, EMPTY, #Ok)
  animation_add(#bucket, sprite_bucket, 1, 20, 0, script_bucket1, "installBucket2", #Ok)
  animation_add(#woman, sprite_woman, 1, 10, 0, script_womanring, EMPTY, 0)
  sync_add(#cowboy, sprite_cowboy, 10, script_cowboywelcome, "cowboyWelcomeDone", 0, member "cb_1.aif", 1)
  animation_setstate(#woman, #playing)
  sync_setstate(#cowboy, #playing)
  puppetSound(3, "TriangleLoop")
  animation_forceupdateall()
  updateStage()
end
