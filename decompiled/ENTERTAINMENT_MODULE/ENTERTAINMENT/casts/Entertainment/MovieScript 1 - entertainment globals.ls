global script_x, script_exit, script_bottle, script_bottlearrow, script_changebutton, script_windmill, script_smoke, script_bird, script_birdreturn, script_window1, script_window2, script_bottle1, script_bottle2, script_windmillhitr, script_windmillhitl, script_bucket1, script_bucket2, script_signsway, script_signhit, script_womanring, script_windowb1, script_windowb2, script_bottleexplode, script_ddenter, script_dddeath, script_dddeath2, script_ddexit, script_ddexit2, script_ddshock, script_pigshoot, script_pigdeath, script_pigdeath2, script_pigexit, script_pigshock, script_singing, script_cowboywelcome, script_cowboylasso, script_cowboyagritech, script_cowboyhelp, script_cowboythanks, script_cowboysongintro, script_cowboysong, script_cowboysendtoloop, script_cowboyguitardeath, script_cowboydeath, sprite_exit, sprite_bottle, sprite_bottlearrow, sprite_changebutton, sprite_windmill, sprite_smoke, sprite_bird, sprite_bucket, sprite_sign, sprite_window1, sprite_window2, sprite_woman, sprite_bottle1, sprite_bottle2, sprite_cowboy, sprite_dirtydan, sprite_pig, sprite_singing, sprite_bang, sprite_cowboybounds, state_cowboy, state_pnumber, state_ddorpig, ganimation_latency2, ganimation_latency3, gactualticks, ginsidebigpuffs, ginsidesmallpuffs

on setupglobals
  set sprite_exit to 15
  set script_x to animation_texttoscript(the text of member "script_x")
  set script_exit to animation_texttoscript(the text of member "script_exit")
  set sprite_bottle to 34
  set script_bottle to animation_texttoscript(the text of member "script_bottle")
  set sprite_bottlearrow to 35
  set script_bottlearrow to animation_texttoscript(the text of member "script_bottleArrow")
  set sprite_changebutton to 36
  set script_changebutton to animation_texttoscript(the text of member "script_changeButton")
  set sprite_windmill to 16
  set sprite_smoke to 17
  set sprite_bird to 18
  set sprite_sign to 19
  set sprite_window1 to 20
  set sprite_window2 to 21
  set sprite_woman to 22
  set sprite_bucket to 23
  set sprite_dirtydan to 24
  set sprite_pig to 25
  set sprite_singing to 26
  set sprite_bottle1 to 27
  set sprite_bottle2 to 28
  set sprite_cowboy to 39
  set sprite_bang to 40
  set sprite_cowboybounds to 45
  set script_windmill to animation_memberstoscript(320, 240, "e_wmillloop00001", "e_wmillloop00010")
  set script_windmillhitr to animation_memberstoscript(320, 240, "e_wmillright00001", "e_wmillright00036")
  set script_windmillhitl to animation_memberstoscript(320, 240, "e_wmill_left00001", "e_wmill_left00053")
  set script_bird to animation_memberstoscript(320, 240, "e_eagle_loop00001", "e_eagle_loop00080")
  set script_birdreturn to animation_memberstoscript(320, 240, "e_eagle_return00001", "e_eagle_return00107")
  set script_bucket1 to animation_memberstoscript(320, 240, "e_bucket100001", "e_bucket100031")
  set script_bucket2 to animation_memberstoscript(320, 240, "e_bucket200001", "e_bucket200022")
  set script_signsway to animation_texttoscript(the text of member "script_signSway")
  set script_signhit to animation_memberstoscript(320, 240, "e_sign00000", "e_sign00101")
  set script_window1 to animation_memberstoscript(320, 240, "e_wn_winbreak100000", "e_wn_winbreak100139")
  set script_window2 to animation_memberstoscript(320, 240, "e_wn_winbreak200000", "e_wn_winbreak200115")
  set script_windowb1 to animation_memberstoscript(320, 240, "e_wn_winbreak100000", "e_wn_winbreak100008")
  set script_windowb2 to animation_memberstoscript(320, 240, "e_wn_winbreak200000", "e_wn_winbreak200008")
  set script_bottle1 to animation_memberstoscript(320, 240, "e_bottle100001", "e_bottle100015")
  set script_bottle2 to animation_memberstoscript(320, 240, "e_bottle200001", "e_bottle200033")
  set script_womanring to animation_memberstoscript(320, 240, "e_wn_bell00161", "e_wn_bell00445")
  set script_ddenter to animation_memberstoscript(320, 240, "e_dd_enter00005", "e_dd_escapes00093")
  set script_dddeath to animation_memberstoscript(320, 240, "e_dd_death00005", "e_dd_death00137", 3)
  set script_dddeath2 to animation_memberstoscript(320, 240, "e_dd_death00005b", "e_dd_death00137b")
  set script_ddexit to animation_memberstoscript(320, 240, "e_dd_escapes00071b", "e_dd_escapes00093b")
  set script_ddexit2 to animation_memberstoscript(320, 240, "e_dd_escapes00071", "e_dd_escapes00093")
  set script_ddshock to animation_memberstoscript(320, 240, "e_dd_pigdeath00019", "e_dd_pigdeath00098")
  set script_pigshoot to animation_memberstoscript(320, 240, "e_pig_shoot00001", "e_pig_shoot00073")
  set script_pigdeath to animation_memberstoscript(320, 240, "e_pig_pigdeath00001", "e_pig_death00020", 3)
  set script_pigdeath2 to animation_memberstoscript(320, 240, "e_pig_pigdeath00001b", "e_pig_death00020b")
  set script_pigexit to animation_memberstoscript(320, 240, "e_pig_dddeath00075b", "e_pig_dddeath00095b")
  set script_pigshock to animation_memberstoscript(320, 240, "e_pig_dddeath00001", "e_pig_dddeath00095")
  set script_singing to animation_memberstoscript(320, 240, "e_pig_chorus00005", "e_pig_chorus00323")
  set script_cowboywelcome to animation_memberstoscript(320, 240, "e_cb_welcome00001", "e_cb_welcome00574")
  set script_cowboylasso to animation_memberstoscript(320, 240, "e_cb_lasso00001", "e_cb_lasso00039")
  set script_cowboyagritech to animation_memberstoscript(320, 240, "e_cb_agritech00022", "e_cb_shoot00225")
  set script_cowboyhelp to animation_memberstoscript(320, 240, "e_cb_help00031", "e_cb_help00102")
  set script_cowboythanks to animation_memberstoscript(320, 240, "e_cb_thanks00079", "e_cb_thanks00173", 3)
  set script_cowboysongintro to animation_memberstoscript(320, 240, "e_cb_songintro00001", "e_cb_songintro00165")
  set script_cowboysong to animation_memberstoscript(320, 240, "e_cb_song00014", "e_cb_song01250")
  set script_cowboysendtoloop to animation_memberstoscript(320, 240, "e_cb_sendtoloop00001", "e_cb_sendtoloop00132")
  set script_cowboyguitardeath to animation_memberstoscript(320, 240, "e_cb_guitardeath 00032", "e_cb_return00050a")
  set script_cowboydeath to animation_memberstoscript(320, 240, "e_cb_death00024", "e_cb_return00050b")
  set script_bottleexplode to animation_memberstoscript(320, 240, "e_workbotttle00001", "e_workbotttle00020")
  set state_cowboy to 1.0
  set state_pnumber to 1
  set ginsidebigpuffs to 0
  set ginsidesmallpuffs to 0
end
