global ShowType, ClientSelect, showChips, chipCount, BaseNameChan, baseClientNum, demoName, lastClientClickTick, lastTypeClickTick, Scroller, baseChipChannel, doSwitch, frameData

on startMovie
  set Scroller to 24
  set BaseNameChan to 4
  set baseChipChannel to 37
  set showChips to []
  set lastClientClickTick to 0
  set lastTypeClickTick to 0
  set baseClientNum to 1
  set chipCount to 0
  set doSwitch to 0
  set ShowType to EMPTY
  set ClientSelect to EMPTY
  set demoName to EMPTY
  set the text of cast "OutPut" to EMPTY
  set frameData to EMPTY
  turnOffAll()
  set the volume of sound 1 to 200
  set the volume of sound 2 to 255
  set the keyDownScript to "CheckForExitKey()"
end

on setChips
  put ShowType & "-" & ClientSelect
  set showChips to []
  if ShowType = "all" then
    set st to 1
  end if
  if ShowType = "online" then
    set st to 2
  end if
  if ShowType = "fixed" then
    set st to 3
  end if
  if ShowType = "other" then
    set st to 4
  end if
  if ClientSelect = EMPTY then
    set cs to "all"
  else
    set cs to ClientSelect
  end if
  set projects to the text of cast "Projects"
  put ClientSelect && ShowType
  repeat with c = 2 to the number of lines in projects
    set projectLine to line c of projects
    set lll to value(string(projectLine))
    if (cs = "all") or (cs = getAt(lll, 1)) then
      repeat with p = 2 to 4
        if (st = p) or (st = 1) then
          set maybeP to getAt(lll, p)
          repeat with x = 1 to count(maybeP)
            add(showChips, getAt(maybeP, x))
          end repeat
        end if
      end repeat
    end if
  end repeat
  set chipCount to count(showChips)
end

on settle num
  puppetSprite(baseChipChannel + num, 1)
  if num > chipCount then
    set the castNum of sprite (baseChipChannel + num) to the number of member ("blacktile" & random(7))
  else
    set the castNum of sprite (baseChipChannel + num) to the number of member string(getAt(showChips, num))
  end if
end

on unsettle num
  puppetSprite(baseChipChannel + num, 0)
end
