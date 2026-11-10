global gdmoFixPaletteObj

on startMovie
  if the machineType <> 256 then
    openXLib(the pathName & "fixPalette.lib")
    if objectp(gdmoFixPaletteObj) then
      gdmoFixPaletteObj(mdispose)
    end if
    set gdmoFixPaletteObj to FixPalette(mnew, the stageLeft, the stageTop, the stageRight, the stageBottom)
  end if
  set the keyDownScript to "CheckForExitKey()"
end

on stopMovie
end
