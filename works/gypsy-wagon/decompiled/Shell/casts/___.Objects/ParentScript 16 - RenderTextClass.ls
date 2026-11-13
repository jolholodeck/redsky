property textString, textWidth, rasterValue, penX, penY, numChars, charIndex, cTableRec, numStrokes, strokeIndex

on new this, gfxObj
  set the textString of this to the textString of gfxObj
  set the textWidth of this to the textWidth of gfxObj
  set the rasterValue of this to the rasterValue of gfxObj
  set the penX of this to the txtX of gfxObj
  set the penY of this to the txtY of gfxObj
  set the numChars of this to the textLength of gfxObj
  set the charIndex of this to 1
  set the cTableRec of this to []
  set the numStrokes of this to 0
  set the strokeIndex of this to 0
  return this
end

on dump this
  put " Render Object: ", this
  put "  string:  <" & the textString of this & ">"
  put "  width:    ", the textWidth of this
  put "  penXY:   (" & the penX of this & ", " & the penY of this & ")"
  put "  crntChr:  " & the cTableRec of this
  put "  charIdx:  " & the charIndex of this & " of " & the numChars of this
  put "  strkIdx:  " & the strokeIndex of this & " of " & the numStrokes of this
end
