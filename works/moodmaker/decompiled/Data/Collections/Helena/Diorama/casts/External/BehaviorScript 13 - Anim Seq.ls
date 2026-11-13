property name, frames, Fade, next, MinDelay, MaxDelay, UsePreloading
global goDiorama

on getPropertyDescriptionList
  propList = [:]
  setaProp(propList, #name, [#comment: "Sequence name", #format: #symbol, #default: EMPTY])
  setaProp(propList, #frames, [#comment: "Cast members. Example: 1-4 or [2,17,5]", #format: #string, #default: EMPTY])
  setaProp(propList, #Fade, [#comment: "Fade", #format: #symbol, #range: [#none, #in, #out], #default: #none])
  setaProp(propList, #next, [#comment: "Next sequence" & RETURN & "Example: #Extro or [#Extro:50, #Idle:50]", #format: #string, #default: EMPTY])
  setaProp(propList, #MinDelay, [#comment: "Minimum delay before next sequence (in seconds)", #format: #integer, #range: [#min: 0, #max: 600], #default: 0])
  setaProp(propList, #MaxDelay, [#comment: "Maximum delay before next sequence (in seconds)", #format: #integer, #range: [#min: 0, #max: 600], #default: 0])
  setaProp(propList, #UsePreloading, [#comment: "Preload this sequence before playing", #format: #boolean, #default: 0])
  return propList
end

on beginSprite me
end
