property ancestor, duration, StartLap, EndLap, LastLapTime, TractorTimeOrigin
global goDiorama, ProbabilityOveride

on new me, animName
  ancestor = script("Anim Class").new(animName)
  duration = 1000
  StartLap = 0
  EndLap = 0
  LastLapTime = 0
  return me
end

on InitTiming me
  usedTime = the milliSeconds - TractorTimeOrigin
  frames = ancestor.LSeqs[1].frames
  interframeDelay = float(duration - usedTime) / frames.count
  FPS = 1000.0 / interframeDelay
  totalFrames = frames.count
  totalMilliseconds = totalFrames * interframeDelay
  totalSeconds = totalMilliseconds / 1000.0
  ancestor.FpsLow = 1
  ancestor.FpsMedium = 1
  ancestor.FpsHigh = 1
  ancestor.FPS = FPS
  ancestor.NextTime = the milliSeconds
end

on start me, dur
  TractorTimeOrigin = the milliSeconds
  StartLap = the milliSeconds
  ancestor.start()
  duration = dur
  me.InitTiming()
end

on EndOfLap me
  EndLap = the milliSeconds
  LastLapTime = EndLap - StartLap
end
