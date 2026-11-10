global script_x, script_exit, script_bottle, script_bottlearrow, script_changebutton, script_windmill, script_smoke, script_bird, script_birdreturn, script_window1, script_window2, script_bottle1, script_bottle2, script_windmillhitr, script_windmillhitl, script_bucket1, script_bucket2, script_signsway, script_signhit, script_womanring, script_windowb1, script_windowb2, script_bottleexplode, script_ddenter, script_dddeath, script_dddeath2, script_ddexit, script_ddexit2, script_ddshock, script_pigshoot, script_pigdeath, script_pigdeath2, script_pigexit, script_pigshock, script_singing, script_cowboywelcome, script_cowboylasso, script_cowboyagritech, script_cowboyhelp, script_cowboythanks, script_cowboysongintro, script_cowboysong, script_cowboysendtoloop, script_cowboyguitardeath, script_cowboydeath, sprite_exit, sprite_bottle, sprite_bottlearrow, sprite_changebutton, sprite_windmill, sprite_smoke, sprite_bird, sprite_bucket, sprite_sign, sprite_window1, sprite_window2, sprite_woman, sprite_bottle1, sprite_bottle2, sprite_cowboy, sprite_dirtydan, sprite_pig, sprite_singing, sprite_bang, sprite_cowboybounds, state_cowboy, state_pnumber, state_ddorpig, ganimation_latency2, ganimation_latency3, gactualticks, ginsidebigpuffs, ginsidesmallpuffs

on exitFrame
  if state_cowboy < 1.5 then
    if animation_getframe(#cowboy) >= 225 then
      set state_cowboy to 1.5
      animation_add(#bottle, sprite_bottle, -1, 10, 0, script_bottle, EMPTY, 0)
      animation_forceupdate(#bottle)
      cursor([member "Bullet", member "BulletMask"])
    end if
    if animation_exists(#woman) and soundBusy(3) then
      if animation_getframe(#woman) >= 54 then
        puppetSound(3, 0)
        sound stop 3
        updateStage()
      end if
    end if
  else
    if state_cowboy = 3 then
      if animation_getframe(#cowboy) >= 192 then
        set state_cowboy to 3.5
        flicker_splicecutpart1()
      end if
    else
      if state_cowboy = 3.5 then
        if animation_getframe(#cowboy) >= 193 then
          set state_cowboy to 4
          animation_add(#changebutton, sprite_changebutton, -1, 10, 0, script_changebutton, EMPTY, 0)
          animation_forceupdate(#changebutton)
          flicker_splicecutpart2(1)
        end if
      else
        if state_cowboy = 8 then
          if animation_getframe(#cowboy) >= 448 then
            set state_cowboy to 8.09999999999999964
            flicker_splicecutpart1()
          end if
        else
          if state_cowboy = 8.09999999999999964 then
            if animation_getframe(#cowboy) >= 449 then
              set state_cowboy to 8.19999999999999929
              flicker_splicecutpart2(1)
            end if
          else
            if state_cowboy = 8.19999999999999929 then
              if animation_getframe(#cowboy) >= 630 then
                set state_cowboy to 8.30000000000000071
                flicker_splicecutpart1()
              end if
            else
              if state_cowboy = 8.30000000000000071 then
                if animation_getframe(#cowboy) >= 631 then
                  set state_cowboy to 8.40000000000000036
                  flicker_splicecutpart2(1)
                end if
              else
                if state_cowboy >= 50 then
                  if animation_getframe(#cowboy) = animation_getreference(#cowboy) then
                    flicker_jumpcut(1, 2, 2)
                  end if
                end if
              end if
            end if
          end if
        end if
      end if
    end if
  end if
  if (state_cowboy >= 8) and (state_cowboy < 9) and animation_exists(#singing) then
    if animation_getstate(#singing) <> #playing then
      set temp to animation_getframe(#cowboy)
      if ((temp >= 188) and (temp <= 192)) or ((temp >= 521) and (temp <= 525)) or ((temp >= 940) and (temp <= 944)) then
        animation_setstate(#singing, #playing)
      end if
      set temp to temp - 275
      if ((temp >= 188) and (temp <= 192)) or ((temp >= 521) and (temp <= 525)) or ((temp >= 940) and (temp <= 944)) then
        set tempexists to 0
        if animation_exists(#dirtydan) then
          set tempexists to #dirtydan
        end if
        if animation_exists(#pig) then
          set tempexists to #pig
        end if
        if tempexists <> 0 then
          flicker_splicecutpart1()
          animation_kill(tempexists)
          flicker_splicecutpart2(1)
        end if
      end if
    end if
  end if
  go(the frame)
  pass()
end

on mouseDown
  if state_cowboy < 1.5 then
    exit
  else
    if rollOver(sprite_windmill) and (animation_getreference(#windmill) = #Ok) then
      puppetSound(3, "e_windmill")
      hitwindmill()
    else
      if rollOver(sprite_bird) and (animation_getreference(#bird) <> #shot) then
        puppetSound(3, "e_bird" & string(random(2)))
        hitbird()
      else
        if rollOver(sprite_window1) and (animation_getreference(#window1) = #Ok) then
          puppetSound(3, "e_window_break" & string(random(2)))
          if animation_getstate(#window2) = #playing then
            animation_setscript(#window1, script_windowb1)
          end if
          animation_setstate(#window1, #playing)
        else
          if rollOver(sprite_window2) and (animation_getreference(#window2) = #Ok) then
            puppetSound(3, "e_window_break" & string(random(2)))
            if animation_getstate(#window1) = #playing then
              animation_setscript(#window2, script_windowb2)
            end if
            animation_setstate(#window2, #playing)
          else
            if rollOver(sprite_bucket) then
              if animation_getreference(#bucket) = #Ok then
                puppetSound(3, "e_bucket1")
              else
                puppetSound(3, "e_bucket2")
              end if
              animation_setstate(#bucket, #playing)
            else
              if rollOver(sprite_sign) then
                puppetSound(3, "e_sign")
                hitsign()
              else
                if rollOver(sprite_bottle1) then
                  puppetSound(3, "e_shoot_bottle" & string(random(2)))
                  animation_setstate(#bottle1, #playing)
                else
                  if rollOver(sprite_bottle2) then
                    puppetSound(3, "e_shoot_bottle" & string(random(2)))
                    animation_setstate(#bottle2, #playing)
                  else
                    if (rollOver(sprite_dirtydan) or rollOver(sprite_pig)) and ((state_cowboy >= 3) and (state_cowboy <= 4)) then
                      puppetSound(3, "e_ricochet" & string(random(3)))
                      flicker_splicecutpart1()
                      sync_kill(#cowboy)
                      killextraanimations()
                      if state_ddorpig = #dirtydan then
                        puppetSound(2, "e_dd_dies")
                      else
                        puppetSound(2, "e_pig_death")
                      end if
                      sync_add(#cowboy, sprite_cowboy, 10, script_cowboythanks, "cowboyHelpThanksDone", 0, member "cb_6.aif", 1)
                      sync_setstate(#cowboy, #playing)
                      if state_ddorpig = #dirtydan then
                        animation_add(#dirtydan, sprite_dirtydan, 1, 10, 1, script_dddeath, "doStaticDD", 0)
                        animation_setstate(#dirtydan, #playing)
                      else
                        animation_add(#pig, sprite_pig, 1, 10, 1, script_pigdeath, "doStaticPig", 0)
                        animation_setstate(#pig, #playing)
                      end if
                      flicker_splicecutpart2(1)
                      set state_cowboy to 6
                    else
                      if rollOver(sprite_cowboybounds) and rollOver(sprite_cowboy) and (state_cowboy < 50) and (state_cowboy <> 9) then
                        puppetSound(3, "e_ricochet" & string(random(3)))
                        flicker_splicecutpart1()
                        if state_cowboy = 2 then
                          animation_kill(#cowboy)
                          puppetSound(1, 0)
                          sound stop 1
                          updateStage()
                        else
                          sync_kill(#cowboy)
                        end if
                        killextraanimations()
                        case state_cowboy of
                          1.5:
                            sync_add(#cowboy, sprite_cowboy, 10, script_cowboydeath, "cowboyWelcomeDone", 33, member "cb_shot.aif", 1)
                          2:
                            sync_add(#cowboy, sprite_cowboy, 10, script_cowboydeath, "cowboyLassoDone", 33, member "cb_shot.aif", 1)
                          3, 3.5, 4:
                            if state_ddorpig = #pig then
                              animation_kill(#pig)
                              animation_add(#pig, sprite_pig, 1, 10, 1, script_pigexit, EMPTY, 0)
                              animation_setstate(#pig, #playing)
                            else
                              animation_kill(#dirtydan)
                              animation_add(#dirtydan, sprite_dirtydan, 1, 10, 1, script_ddexit, EMPTY, 0)
                              animation_setstate(#dirtydan, #playing)
                            end if
                            sync_add(#cowboy, sprite_cowboy, 10, script_cowboydeath, "cowboyHelpThanksDone", 33, member "cb_shot.aif", 1)
                          5, 6:
                            sync_add(#cowboy, sprite_cowboy, 10, script_cowboydeath, "cowboyHelpThanksDone", 33, member "cb_shot.aif", 1)
                          7:
                            sync_add(#cowboy, sprite_cowboy, 10, script_cowboyguitardeath, "cowboySongIntroDone", 26, member "cb_shot.aif", 1)
                          8, 8.09999999999999964, 8.19999999999999929, 8.30000000000000071, 8.40000000000000036:
                            sync_add(#cowboy, sprite_cowboy, 10, script_cowboyguitardeath, "cowboySongDone", 26, member "cb_shot.aif", 1)
                        end case
                        set state_cowboy to state_cowboy + 50
                        sync_setstate(#cowboy, #playing)
                        flicker_splicecutpart2(1)
                      else
                        if rollOver(sprite_cowboy) then
                          puppetSound(3, "e_ricochet" & string(random(3)))
                        else
                          if rollOver(sprite_singing) then
                            puppetSound(3, "e_ricochet" & string(random(3)))
                            if animation_getstate(#singing) = #playing then
                              animation_kill(#singing)
                              if the mouseH < 145 then
                                animation_add(#dirtydan, sprite_dirtydan, 1, 10, 1, script_dddeath2, "doStaticDD", 0)
                                animation_add(#pig, sprite_pig, 1, 10, 1, script_pigshock, EMPTY, 0)
                              else
                                animation_add(#dirtydan, sprite_dirtydan, 1, 10, 1, script_ddshock, "installDDShock2", 0)
                                animation_add(#pig, sprite_pig, 1, 10, 1, script_pigdeath2, "doStaticPig", 0)
                              end if
                              animation_forceupdate(#dirtydan)
                              animation_forceupdate(#pig)
                              animation_setstate(#dirtydan, #playing)
                              animation_setstate(#pig, #playing)
                            end if
                          else
                            puppetSound(3, "e_ricochet" & string(random(3)))
                            set bangh to the mouseH
                            set bangv to the mouseV
                            if ginsidebigpuffs then
                              case random(3) of
                                1:
                                  set bangscript to animation_memberstoscript(bangh + 4, bangv - 55, "e_dustkick_big102", "e_dustkick_big120")
                                2:
                                  set bangscript to animation_memberstoscript(bangh + 4, bangv - 55, "e_dustkick_big202", "e_dustkick_big217")
                                3:
                                  set bangscript to animation_memberstoscript(bangh + 4, bangv - 55, "e_dustkick_big302", "e_dustkick_big320")
                              end case
                              animation_add(#bang, sprite_bang, 1, 20, 0, bangscript, EMPTY, 0)
                              animation_setstate(#bang, #playing)
                            else
                              if ginsidesmallpuffs then
                                case random(3) of
                                  1:
                                    set bangscript to animation_memberstoscript(bangh + 4, bangv - 55, "e_dustkick_sm102", "e_dustkick_sm120")
                                  2:
                                    set bangscript to animation_memberstoscript(bangh + 4, bangv - 55, "e_dustkick_sm202", "e_dustkick_sm213")
                                  3:
                                    set bangscript to animation_memberstoscript(bangh + 4, bangv - 55, "e_dustkick_sm302", "e_dustkick_sm318")
                                end case
                                animation_add(#bang, sprite_bang, 1, 20, 0, bangscript, EMPTY, 0)
                                animation_setstate(#bang, #playing)
                              end if
                            end if
                          end if
                        end if
                      end if
                    end if
                  end if
                end if
              end if
            end if
          end if
        end if
      end if
    end if
    check6clicks(gactualticks)
  end if
  pass()
end

on keyDown
  if the key = SPACE then
    if state_cowboy >= 50 then
      set state_cowboy to state_cowboy - 50
    end if
    case state_cowboy of
      1:
        animation_add(#bottle, sprite_bottle, -1, 10, 0, script_bottle, EMPTY, 0)
        animation_forceupdate(#bottle)
        cursor([member "Bullet", member "BulletMask"])
        if animation_exists(#woman) then
          animation_kill(#woman)
        end if
        puppetSound(3, 0)
        sound stop 3
        updateStage()
        cowboywelcomedone()
      1.5:
        cowboywelcomedone()
      2:
        cowboylassodone()
      3, 3.5, 4, 5, 6:
        cowboyhelpthanksdone()
      7:
        cowboysongintrodone()
      8, 8.09999999999999964, 8.19999999999999929, 8.30000000000000071, 8.40000000000000036:
        cowboysongdone()
      9:
        cowboysendtoloopdone()
    end case
  end if
  pass()
end
