global backCh, exitCh

on init
  global sectionList, section, firstRoCh, lastRoCh, mediumSoundPlaying, exitCastnum, Xcastnum, backCastnum, arrowCastnum, againCastNum, returnCastNum, musicPhase, shortCutHiliteCh
  set backCh to 42
  set exitCh to 44
  puppetSprite(backCh, 1)
  puppetSprite(exitCh, 1)
  set sectionList to ["kn", "ki", "tr", "st"]
  set section to "main"
  set firstRoCh to 8
  set lastRoCh to firstRoCh + count(sectionList) - 1
  startTimer()
  set mediumSoundPlaying to 0
  set exitCastnum to the number of member "exit"
  set Xcastnum to the number of member "X"
  set backCastnum to the number of member "back"
  set arrowCastnum to the number of member "<-"
  set againCastNum to the number of member "again"
  set returnCastNum to the number of member "<-'"
  set nilCast to the number of member "nil"
  set musicPhase to 1
  set shortCutHiliteCh to 14
  puppetSprite(shortCutHiliteCh, 1)
  set the stretch of sprite shortCutHiliteCh to 1
  setRandPlay()
  preLoadCast(the number of member "first blur", the number of member "last blur")
  preLoadCast(backCastnum + 1, arrowCastnum)
  preLoadCast(exitCastnum + 1, Xcastnum)
end

on setRandPlay
  global randomSilenceSecs, randomPlaySecs
  set randomPlaySecs to random(5) + 16
  set randomSilenceSecs to random(5) + 19
end

on recordMousePos
  global initMouseH, initMouseV
  set initMouseH to the mouseH
  set initMouseV to the mouseV
end

on mouseMoved
  global initMouseH, initMouseV
  return (the mouseH <> initMouseH) or (the mouseV <> initMouseV)
end

on main
  global firstRoCh, lastRoCh, section, mediumSoundPlaying
  checkButtons()
  set ro to 0
  set ch to firstRoCh
  set keepgoing to 1
  repeat while keepgoing
    if rollOver(ch) then
      set ro to ch
      set keepgoing to 0
      next repeat
    end if
    set ch to ch + 1
    if ch > lastRoCh then
      set keepgoing to 0
    end if
  end repeat
  if ro = 0 then
    set section to "main"
    go("main")
  else
    set newsection to getAt(sectionList, ro - firstRoCh + 1)
    if section <> newsection then
      set section to newsection
      go(section & " rollover")
    end if
  end if
end

on checkShortcutROs
  global shortCutHiliteCh, firstRoCh, lastRoCh
  set ro to 0
  set ch to firstRoCh
  set keepgoing to 1
  repeat while keepgoing
    if rollOver(ch) then
      set ro to ch
      set keepgoing to 0
      next repeat
    end if
    set ch to ch + 1
    if ch > lastRoCh then
      set keepgoing to 0
    end if
  end repeat
  if ro = 0 then
    set the locH of sprite shortCutHiliteCh to -1000
    return 0
  else
    set the rect of sprite shortCutHiliteCh to the rect of sprite ro
    return 1
  end if
end

on clearShortcutHIlite
  global shortCutHiliteCh
  set the locH of sprite shortCutHiliteCh to -1000
end

on initKnowledgeROs
  global subsection
  set subsection to "kn"
end

on checkKnowledgeROs
  global subsection
  set newsubsection to subsection
  if rollOver(30) then
    set newsubsection to "planning RO"
  else
    if rollOver(32) then
      set newsubsection to "financial RO"
    else
      if rollOver(34) then
        set newsubsection to "life RO"
      else
        set newsubsection to "kn"
      end if
    end if
  end if
  if newsubsection <> subsection then
    set subsection to newsubsection
    go(subsection)
  end if
end

on initKingdomROs
  global rolledOverCh, textCh
  set rolledOverCh to 0
  set textCh to 15
end

on checkKingdomROs firstCh, lastCh
  global textCh, rolledOverCh
  set ro to 0
  set ch to firstCh
  set keepgoing to 1
  repeat while keepgoing
    if rollOver(ch) then
      set ro to ch
      set keepgoing to 0
      next repeat
    end if
    set ch to ch + 1
    if ch > lastCh then
      set keepgoing to 0
    end if
  end repeat
  if ro = 0 then
    puppetSprite(rolledOverCh, 0)
    puppetSprite(textCh, 0)
    set rolledOverCh to 0
  else
    if ro <> rolledOverCh then
      puppetSprite(rolledOverCh, 0)
      set rolledOverCh to ro
      puppetSprite(rolledOverCh, 1)
      set the castNum of sprite rolledOverCh to the castNum of sprite rolledOverCh + 1
      puppetSprite(textCh, 1)
      set the castNum of sprite textCh to the castNum of sprite rolledOverCh + 1
    end if
  end if
end

on initTrackROs
  global rolledOverCh, textCh, bigCh
  set rolledOverCh to 0
  set textCh to 15
  set bigCh to 27
end

on checkTrackROs firstCh, lastCh
  global textCh, rolledOverCh, bigCh, hiliteCh
  set ro to 0
  set ch to lastCh
  set keepgoing to 1
  repeat while keepgoing
    if rollOver(ch) then
      set ro to ch
      set keepgoing to 0
      next repeat
    end if
    set ch to ch - 2
    if ch < firstCh then
      set keepgoing to 0
    end if
  end repeat
  if (ro = 0) and (rolledOverCh <> 0) then
    puppetSprite(bigCh, 0)
    puppetSprite(textCh, 0)
    set the locH of sprite (rolledOverCh + 1) to -1000
    set rolledOverCh to 0
  else
    if ro <> rolledOverCh then
      set the locH of sprite (rolledOverCh + 1) to -1000
      set rolledOverCh to ro
      puppetSprite(bigCh, 1)
      set the castNum of sprite bigCh to the castNum of sprite rolledOverCh + 1
      puppetSprite(textCh, 1)
      set the castNum of sprite textCh to the castNum of sprite rolledOverCh + 2
      puppetSprite(ro + 1, 1)
      set the stretch of sprite (ro + 1) to 1
      set the rect of sprite (ro + 1) to the rect of sprite rolledOverCh
      return 1
    end if
  end if
  return 0
end

on checkButtons
  global exitCastnum, Xcastnum, backCastnum, arrowCastnum, musicPhase, randomPlaySecs, randomSilenceSecs
  if (the timer > ((randomSilenceSecs + randomPlaySecs) * 60)) and (marker(0) <> label("exit")) then
    put "play"
    puppetSound("medium loop")
    sound fadeIn 1, 180
    startTimer()
    set musicPhase to 1
    setRandPlay()
  else
    if (the timer > (randomPlaySecs * 60)) and (musicPhase = 1) then
      sound fadeOut 1, 180
      set musicPhase to 2
    end if
  end if
  set backCast to the castNum of sprite backCh
  if rollOver(backCh - 1) then
    if backCast <> arrowCastnum then
      set the castNum of sprite backCh to backCast + 1
    else
      nothing()
    end if
    return 1
  else
    if backCast <> backCastnum then
      set the castNum of sprite backCh to backCastnum
    end if
    set exitCast to the castNum of sprite exitCh
    if rollOver(exitCh - 1) then
      if exitCast <> Xcastnum then
        set the castNum of sprite exitCh to exitCast + 1
      else
        nothing()
      end if
      return 1
    else
      if exitCast <> exitCastnum then
        set the castNum of sprite exitCh to exitCastnum
      end if
    end if
  end if
  return 0
end

on checkAgainButton
  global againCh, againCastNum, returnCastNum
  set againCast to the castNum of sprite againCh
  if rollOver(againCh - 1) then
    if againCast <> returnCastNum then
      set the castNum of sprite againCh to againCast + 1
    else
      nothing()
    end if
  else
    if againCast <> againCastNum then
      set the castNum of sprite againCh to againCastNum
    end if
  end if
end

on clearPuppets a, b
  repeat with ch = a to b
    puppetSprite(ch, 0)
  end repeat
  updateStage()
end

on alignreg a, b
  repeat with c = a + 1 to b
    set the regPoint of cast c to the regPoint of cast a
  end repeat
end
