property numScoreChannels, demoReturnKey, puppetStateList
global gSysMgrDebug, gdmoExternalDataPath, kdmoOStype, gdmoFixPaletteObj

on new this
  set the demoReturnKey of this to 13
  set the numScoreChannels of this to 48
  set the puppetStateList of this to []
  set gSysMgrDebug to 0
  if kdmoOStype = #mac then
    openXLib(gdmoExternalDataPath & "RSIXLIB.LIB")
    if objectp(gdmoFixPaletteObj) then
      gdmoFixPaletteObj(mdispose)
    end if
    set gdmoFixPaletteObj to fixpalette(mnew, the stageLeft, the stageTop, the stageRight, the stageBottom)
  end if
  return this
end

on sysEnterStartMovie this
  if gSysMgrDebug then
    put "SHELL: in sysEnterStartMovie: ", this
  end if
  mFixPalette(this)
end

on sysExitStartMovie this
  if gSysMgrDebug then
    put "SHELL: in sysExitStartMovie: ", this
  end if
end

on sysExitStopMovie this
  if gSysMgrDebug then
    put "SHELL: in sysExitStopMovie: ", this
  end if
end

on systemKeyHandler this, key
  if gSysMgrDebug then
    put "SHELL: in systemKeyHandler: " & this & ",   key = <" & key & "> (" & charToNum(key) & ")"
  end if
  set keyNum to charToNum(key)
  if keyNum = the demoReturnKey of this then
    systemExitCleanupHandler()
  end if
  if (keyNum > 47) and (keyNum < 56) and the optionDown then
    set the soundLevel to keyNum - 48
    if gSysMgrDebug then
      put "sound level set to ", the soundLevel
    end if
  end if
end

on savePuppetState this
  set tmpList to []
  set numChans to the numScoreChannels of this
  repeat with i = 1 to numChans
    append(tmpList, the puppet of sprite i)
  end repeat
  set c to count(puppetStateList)
  set refHandle to 0
  repeat with i = 1 to c
    if getAt(getAt(puppetStateList, i), 1) <> i then
      set refHandle to i
      exit repeat
    end if
  end repeat
  if refHandle = 0 then
    set refHandle to c + 1
  end if
  set newEntry to list(refHandle, tmpList)
  addAt(puppetStateList, refHandle, newEntry)
  return refHandle
end

on loadPuppetState this, refHandle
  set c to count(the puppetStateList of this)
  set result to 0
  repeat with i = 1 to c
    if getAt(getAt(the puppetStateList of this, i), 1) = refHandle then
      set pStates to getAt(getAt(the puppetStateList of this, i), 2)
      set numChans to the numScoreChannels of this
      repeat with j = 1 to numChans
        set the puppet of sprite j to getAt(pStates, j)
      end repeat
      set result to 1
      exit repeat
    end if
  end repeat
  return result
end

on deletePuppetState this, refHandle
  set c to count(the puppetStateList of this)
  set result to 0
  repeat with i = 1 to c
    if getAt(getAt(the puppetStateList of this, i), 1) = refHandle then
      deleteAt(the puppetStateList of this, i)
      set result to 1
      exit repeat
    end if
  end repeat
  return result
end

on puppetAllSprites this
  set numChans to the numScoreChannels of this
  repeat with i = 1 to numChans
    set the puppet of sprite i to 1
  end repeat
end

on unPuppetAllSprites this
  set numChans to the numScoreChannels of this
  repeat with i = 1 to numChans
    set the puppet of sprite i to 0
  end repeat
end

on mFixPalette this
  if objectp(gdmoFixPaletteObj) and (kdmoOStype = #mac) then
    gdmoFixPaletteObj(mPatchIt)
  end if
end
