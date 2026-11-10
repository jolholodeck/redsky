global script_x, script_exit, script_bottle, script_bottlearrow, script_changebutton, script_windmill, script_smoke, script_bird, script_birdreturn, script_window1, script_window2, script_bottle1, script_bottle2, script_windmillhitr, script_windmillhitl, script_bucket1, script_bucket2, script_signsway, script_signhit, script_womanring, script_windowb1, script_windowb2, script_ddenter, script_dddeath, script_dddeath2, script_ddexit, script_ddexit2, script_ddshock, script_pigshoot, script_pigdeath, script_pigdeath2, script_pigexit, script_pigshock, script_singing, script_cowboywelcome, script_cowboylasso, script_cowboyagritech, script_cowboyhelp, script_cowboythanks, script_cowboysongintro, script_cowboysong, script_cowboysendtoloop, script_cowboyguitardeath, script_cowboydeath, sprite_exit, sprite_bottle, sprite_bottlearrow, sprite_changebutton, sprite_windmill, sprite_smoke, sprite_bird, sprite_bucket, sprite_sign, sprite_window1, sprite_window2, sprite_woman, sprite_bottle1, sprite_bottle2, sprite_cowboy, sprite_dirtydan, sprite_pig, sprite_singing, sprite_bang, sprite_cowboybounds, state_cowboy, state_pnumber, state_ddorpig, ganimation_latency2, ganimation_latency3, gactualticks, ginsidebigpuffs, ginsidesmallpuffs

on exitFrame
  setupglobals()
  animation_add(#exit, sprite_exit, -1, 10, 0, script_x, EMPTY, 0)
  animation_setstate(#exit, #playing)
  installwindmill()
  installbird()
  animation_add(#window1, sprite_window1, 1, 20, 0, script_window1, "installBrokenWindow1", #Ok)
  animation_add(#window2, sprite_window2, 1, 20, 0, script_window2, "installBrokenWindow2", #Ok)
  animation_add(#bottle1, sprite_bottle1, 1, 20, 0, script_bottle1, EMPTY, #Ok)
  animation_add(#bottle2, sprite_bottle2, 1, 20, 0, script_bottle2, EMPTY, #Ok)
  animation_add(#bucket, sprite_bucket, 1, 20, 0, script_bucket1, "installBucket2", #Ok)
  installsign()
  animation_add(#woman, sprite_woman, 1, 10, 0, script_womanring, EMPTY, 0)
  animation_forceupdateall()
  sync_add(#cowboy, sprite_cowboy, 10, script_cowboywelcome, "cowboyWelcomeDone", 0, member "cb_1.aif", 1)
  preLoad(label("Lead"), label("Loop"))
  pass()
end
