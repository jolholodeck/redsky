global ganimation_list, ganimation_latency2, ganimation_latency3, gactualticks

on animation_init
  set ganimation_list to [:]
  set ganimation_latency2 to 0
  set ganimation_latency3 to 0
end

on animation_idle
  set killlist to []
  set callbacklist to []
  set i to 0
  repeat with temp in ganimation_list
    set i to i + 1
    if (getaProp(temp, #state) = #paused) or (getaProp(temp, #latencyticks) > the ticks) then
      next repeat
    end if
    set theframe to getaProp(temp, #frame)
    set thefps to getaProp(temp, #fps)
    set thebt to getaProp(temp, #baseticks)
    set newframe to (the ticks - thebt) / (gactualticks / thefps)
    set newframei to integer(newframe + 0.5)
    set thescript to getaProp(temp, #script)
    set thesprite to getaProp(temp, #sprite)
    set thestream to getaProp(temp, #stream)
    set tempcount to count(thescript)
    if newframe >= tempcount then
      set tsub to (newframei - 1) / tempcount
      set newframei to (newframei mod tempcount) + 1
    else
      set tsub to 0
    end if
    set theloop to getaProp(temp, #loop)
    if (theloop = -1) or ((theloop - tsub) > 0) then
      if newframei = theframe then
        next repeat
      end if
      setaProp(temp, #frame, newframei)
      animation_updateframe(thesprite, thescript, newframei)
      if thestream then
        animation_streamframes(temp)
      end if
      set tp to getPropAt(ganimation_list, i)
      if ((newframei - theframe) > 2) and (tp = #cowboy) then
        put tp & " : Frames Skipped : " & newframei - theframe - 1
      end if
      next repeat
    end if
    add(killlist, getPropAt(ganimation_list, i))
    add(callbacklist, getaProp(temp, #callback))
  end repeat
  repeat with i in killlist
    animation_kill(i)
  end repeat
  repeat with i in callbacklist
    do(i)
  end repeat
end

on animation_testlatency2
  set temp1 to the volume of sound 1
  set temp2 to the volume of sound 2
  set the volume of sound 1 to 0
  set the volume of sound 2 to 0
  puppetSound(2, "Cue Test")
  repeat while not soundBusy(2)
    updateStage()
  end repeat
  startTimer()
  repeat while the timer < 30
  end repeat
  startTimer()
  puppetSound(1, "Cue Test")
  repeat while not soundBusy(1)
    updateStage()
  end repeat
  repeat while soundBusy(1)
    updateStage()
  end repeat
  set ganimation_latency2 to the timer - 60
  if ganimation_latency2 < 0 then
    set ganimation_latency2 to 0
  end if
  puppetSound(1, 0)
  puppetSound(2, 0)
  sound stop 1
  sound stop 2
  updateStage()
  set the volume of sound 1 to temp1
  set the volume of sound 2 to temp2
end

on animation_testlatency3
  set temp1 to the volume of sound 1
  set temp2 to the volume of sound 2
  set temp3 to the volume of sound 2
  set the volume of sound 1 to 0
  set the volume of sound 2 to 0
  set the volume of sound 3 to 0
  puppetSound(2, "Cue Test")
  puppetSound(3, "Cue Test")
  repeat while not soundBusy(2) or not soundBusy(3)
    updateStage()
  end repeat
  startTimer()
  repeat while the timer < 30
  end repeat
  startTimer()
  puppetSound(1, "Cue Test")
  repeat while not soundBusy(1)
    updateStage()
  end repeat
  repeat while soundBusy(1)
    updateStage()
  end repeat
  set ganimation_latency3 to the timer - 60
  if ganimation_latency3 < 0 then
    set ganimation_latency3 to 0
  end if
  puppetSound(1, 0)
  puppetSound(2, 0)
  puppetSound(3, 0)
  sound stop 1
  sound stop 2
  sound stop 3
  updateStage()
  set the volume of sound 1 to temp1
  set the volume of sound 2 to temp2
  set the volume of sound 3 to temp3
end

on animation_add theid, thesprite, theloop, thefps, thestream, thescript, thecallback, thereference
  set newanim to [#sprite: thesprite, #loop: theloop, #fps: thefps, #stream: thestream, #baseticks: 0, #latencyticks: 0, #script: thescript, #callback: thecallback, #state: #paused, #frame: 1, #lastFrame: 1, #reference: thereference]
  setaProp(ganimation_list, theid, newanim)
  puppetSprite(thesprite, 1)
end

on animation_kill theid
  set temp to getaProp(ganimation_list, theid)
  if not objectp(temp) then
    return -1
  else
    if getaProp(temp, #stream) then
      set thescript to getaProp(temp, #script)
      unloadMember(animation_frametomember(thescript, 1), animation_frametomember(thescript, count(thescript)))
    end if
    puppetSprite(getaProp(getaProp(ganimation_list, theid), #sprite), 0)
    deleteProp(ganimation_list, theid)
    return 0
  end if
end

on animation_exists theid
  set temp to getaProp(ganimation_list, theid)
  if temp = VOID then
    return 0
  else
    return 1
  end if
end

on animation_getsprite theid
  set temp to getaProp(ganimation_list, theid)
  return getaProp(temp, #sprite)
end

on animation_getloop theid
  set temp to getaProp(ganimation_list, theid)
  return getaProp(temp, #loop)
end

on animation_getfps theid
  set temp to getaProp(ganimation_list, theid)
  return getaProp(temp, #fps)
end

on animation_getscript theid
  set temp to getaProp(ganimation_list, theid)
  return getaProp(temp, #script)
end

on animation_getcallback theid
  set temp to getaProp(ganimation_list, theid)
  return getaProp(temp, #callback)
end

on animation_getreference theid
  set temp to getaProp(ganimation_list, theid)
  return getaProp(temp, #reference)
end

on animation_getframe theid
  set temp to getaProp(ganimation_list, theid)
  return getaProp(temp, #frame)
end

on animation_getstate theid
  set temp to getaProp(ganimation_list, theid)
  return getaProp(temp, #state)
end

on animation_setsprite theid, thesprite
  set temp to getaProp(ganimation_list, theid)
  setaProp(temp, #sprite, thesprite)
end

on animation_setloop theid, theloop
  set temp to getaProp(ganimation_list, theid)
  setaProp(temp, #loop, theloop)
end

on animation_setfps theid, thefps
  set temp to getaProp(ganimation_list, theid)
  setaProp(temp, #fps, thefps)
end

on animation_setscript theid, thescript
  set temp to getaProp(ganimation_list, theid)
  setaProp(temp, #script, thescript)
end

on animation_setcallback theid, thecallback
  set temp to getaProp(ganimation_list, theid)
  setaProp(temp, #callback, thecallback)
end

on animation_setreference theid, thereference
  set temp to getaProp(ganimation_list, theid)
  setaProp(temp, #reference, thereference)
end

on animation_setframe theid, theframe
  set temp to getaProp(ganimation_list, theid)
  setaProp(temp, #frame, theframe)
  setaProp(temp, #baseticks, animation_setbaseticks(theframe, getaProp(temp, #fps), 0))
end

on animation_setstate theid, thestate
  set temp to getaProp(ganimation_list, theid)
  set oldstate to getaProp(temp, #state)
  if oldstate = thestate then
    exit
  end if
  setaProp(temp, #state, thestate)
  if oldstate = #paused then
    set thel to animation_getproperlatency()
    setaProp(temp, #latencyticks, the ticks + thel)
    setaProp(temp, #baseticks, animation_setbaseticks(getaProp(temp, #frame), getaProp(temp, #fps), thel))
  end if
end

on animation_forceupdate theid
  set temp to getaProp(ganimation_list, theid)
  animation_updateframe(getaProp(temp, #sprite), getaProp(temp, #script), getaProp(temp, #frame))
end

on animation_forceupdateall
  set j to count(ganimation_list)
  repeat with i = 1 to j
    animation_forceupdate(getPropAt(ganimation_list, i))
  end repeat
end

on animation_texttoscript thetext
  set tempd to the itemDelimiter
  set the itemDelimiter to SPACE
  set outlist to []
  set numlines to the number of lines in thetext
  set theframe to [#member: 1, #loc: point(0, 0)]
  repeat with i = 1 to numlines
    set theline to line i of thetext
    case value(item 1 of theline) of
      #member:
        set temp to value(item 2 of theline)
        if not integerp(temp) then
          set temp to item 2 of theline
        end if
        setProp(theframe, #member, member temp)
      #loc:
        setProp(theframe, #loc, point(value(item 2 of theline), value(item 3 of theline)))
      #endframe:
        append(outlist, duplicate(theframe))
    end case
  end repeat
  set the itemDelimiter to tempd
  return outlist
end

on animation_updateframe thesprite, thescript, theframe
  set specs to getAt(thescript, theframe)
  set them to getaProp(specs, #member)
  set the member of sprite thesprite to them
  set the loc of sprite thesprite to getaProp(specs, #loc)
end

on animation_frametomember thescript, theframe
  return the number of member getaProp(getAt(thescript, theframe), #member)
end

on animation_streamframes thedirt
  set theframe to getaProp(thedirt, #frame)
  set thescript to getaProp(thedirt, #script)
  set thelfs to getaProp(thedirt, #lastFrame)
  set lastmemberstart to animation_frametomember(thescript, thelfs)
  unloadMember(lastmemberstart)
  if the machineType = 256 then
    exit
  end if
  set tempcount to count(thescript)
  set thenfs to theframe + 1
  if thenfs <= tempcount then
    set nextmemberstart to animation_frametomember(thescript, thenfs)
    preloadMember(nextmemberstart)
    setaProp(thedirt, #lastFrame, theframe)
  end if
end

on animation_setbaseticks theframe, thefps, thel
  return the ticks + thel - (theframe * (gactualticks / thefps))
end

on animation_getproperlatency
  updateStage()
  set temp to 0
  if soundBusy(1) then
    set temp to temp + 1
  end if
  if soundBusy(2) then
    set temp to temp + 1
  end if
  if soundBusy(3) then
    set temp to temp + 1
  end if
  case temp of
    0, 1:
      return 0
    2:
      return ganimation_latency2
    3:
      return ganimation_latency3
  end case
end

on animation_memberstoscript theh, thev, thestart, theend, interlace
  if interlace = VOID then
    set interlace to 0
  else
    set interlace to interlace - 1
  end if
  set outlist to []
  set st to the number of member thestart
  set ed to the number of member theend
  repeat with i = st to ed
    add(outlist, [#member: member i, #loc: point(theh, thev)])
    set i to i + interlace
  end repeat
  return outlist
end
