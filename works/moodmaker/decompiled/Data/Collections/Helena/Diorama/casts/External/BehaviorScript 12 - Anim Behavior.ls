property animName, StartProb, spr, sprNum, InkEffect, OffsetX, OffsetY, FpsLow, FpsMedium, FpsHigh, CurSeq, AutoStart, Blockers
global goDiorama, goK

on getPropertyDescriptionList me
  propList = [:]
  setaProp(propList, #animName, [#comment: "Name", #format: #symbol, #default: EMPTY])
  setaProp(propList, #sprNum, [#comment: "Sprite number", #format: #integer, #default: the currentSpriteNum])
  setaProp(propList, #InkEffect, [#comment: "Ink", #format: #ink, #default: 0])
  setaProp(propList, #blend, [#comment: "Opacity", #format: #integer, #range: [#min: 0, #max: 100], #default: 100])
  setaProp(propList, #OffsetX, [#comment: "X offset (from Diorama origin)", #format: #integer, #default: 0])
  setaProp(propList, #OffsetY, [#comment: "Y offset (from Diorama origin)", #format: #integer, #default: 0])
  setaProp(propList, #AutoStart, [#comment: "Auto-start", #format: #boolean, #default: 1])
  setaProp(propList, #CurSeq, [#comment: "Initial sequence number", #format: #integer, #default: 1])
  setaProp(propList, #FpsLow, [#comment: "Low intensity frames per second", #format: #integer, #range: [#min: 1, #max: 24], #default: 12])
  setaProp(propList, #FpsMedium, [#comment: "Medium intensity frames per second", #format: #integer, #range: [#min: 1, #max: 24], #default: 12])
  setaProp(propList, #FpsHigh, [#comment: "High intensity frames per second", #format: #integer, #range: [#min: 1, #max: 24], #default: 12])
  setaProp(propList, #Blockers, [#comment: "Don't start if any of these are playing." & RETURN & "Example:  [#Bird, #Windmill]", #format: #string, #range: [#min: 1, #max: 100], #default: "[]"])
  setaProp(propList, #StartProb, [#comment: "Startup probability when requested by SoundScape", #format: #integer, #range: [#min: 0, #max: 100], #default: 100])
  setaProp(propList, #UseIntensityFactoring, [#comment: "Louder sounds increase startup probability", #format: #boolean, #default: 0])
  return propList
end

on beginSprite me
  animName = symbol(animName)
  txt = EMPTY
  Sequences = GetSequences(sprite(me.spriteNum), "Anim Behavior")
  ErrorCheck(Sequences, Sequences.count <> 0, "No anim behavior on " & animName)
  repeat with thisSeq in Sequences
    txt = txt & extractProps(thisSeq)
    if thisSeq <> Sequences[Sequences.count] then
      txt = txt & ","
    end if
  end repeat
  ErrorCheck(txt, ilk(value(txt)) = #propList, "Bad anim behav for " & animName)
  thisName = string(animName)
  member(thisName, goK.iLibNumCollDio).text = txt
  case animName of
    #Balloon1:
      thisAnim = script("Anim Balloon Subclass").new(animName)
    #Balloon2:
      thisAnim = script("Anim Balloon Subclass").new(animName)
    otherwise:
      thisAnim = script("Anim Class").new(animName)
  end case
  thisAnim.Init()
  thisAnim.InitTiming()
  goDiorama.LAnimObjs.addProp(animName, thisAnim)
end
