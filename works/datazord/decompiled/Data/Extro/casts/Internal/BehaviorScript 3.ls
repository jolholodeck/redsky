property iIncr, iLocVStop, iCBscript, iTime

on stepFrame me
  sprite(me.spriteNum).locV = sprite(me.spriteNum).locV - iIncr
end

on getPropertyDescriptionList me
  vPDList = [:]
  Ltemp = [#comment: "increment:", #format: #integer, #default: 4]
  addProp(vPDList, #iIncr, Ltemp)
  Ltemp = [#comment: "vertical stopping loc:", #format: #integer, #default: 0]
  addProp(vPDList, #iLocVStop, Ltemp)
  Ltemp = [#comment: "callback script:", #format: #string, #default: EMPTY]
  addProp(vPDList, #iCBscript, Ltemp)
  return vPDList
end
