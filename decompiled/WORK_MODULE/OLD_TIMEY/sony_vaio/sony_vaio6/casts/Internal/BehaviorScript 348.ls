on exitFrame
  global gdmoFixPaletteObj
  if objectp(gdmoFixPaletteObj) and (the machineType <> 256) then
    gdmoFixPaletteObj(mPatchIt)
    gdmoFixPaletteObj(mdispose)
  end if
end
