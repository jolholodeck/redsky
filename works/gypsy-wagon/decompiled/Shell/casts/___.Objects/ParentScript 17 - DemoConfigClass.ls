property mediaType, demoTitle, demoPathName, assocApp, colrDepth, memRequired

on new this
  set mediaType to #unknown
  set demoTitle to 0
  set demoPathName to 0
  set assocApp to 0
  set colrDepth to 0
  set memRequired to 0
  return this
end

on dump this
  put " DemoConfig: ", this
  put "  mediaType: " & the mediaType of this
  put "  demoTitle: " & the demoTitle of this
  put "  pathname:  " & the demoPathName of this
  put "  assocApp:  " & the assocApp of this
  put "  colrDepth: " & the colrDepth of this & " bit"
  put "  memReqd:   " & the memRequired of this
end
