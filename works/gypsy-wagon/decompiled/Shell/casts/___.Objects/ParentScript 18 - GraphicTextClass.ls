property textString, textLength, textWidth, charTable, txtX, txtY, rasterValue

on new this, str
  global gdmoQuillCharTable
  set tlen to length(str)
  set the textString of this to str
  set the textLength of this to tlen
  set the charTable of this to gdmoQuillCharTable
  set the rasterValue of this to #text1
  set the txtX of this to 0
  set the txtY of this to 0
  set lineWidth to 0
  repeat with i = 1 to tlen
    set c to char i of str
    set cIndex to charTableGetIndex(c)
    set chr to getAt(gdmoQuillCharTable, cIndex)
    set cwidth to getAt(chr, 1)
    set ckern to getAt(chr, 2)
    set lineWidth to lineWidth + cwidth - ckern
  end repeat
  set the textWidth of this to lineWidth
  return this
end

on dump this
  put " Graphic Text Object: ", this
  put "  string:  <" & the textString of this & ">"
  put "  length:   ", the textLength of this
  put "  width:    ", the textWidth of this
  put "  txtXY:   (" & the txtX of this & ", " & the txtY of this & ")"
  put "  rastVal:  " & the rasterValue of this
end
