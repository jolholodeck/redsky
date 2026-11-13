property ancestor, iStepFrameEnabled, ikTextMbr, iLastCall, ikTextOrg, ikTextSpr, iFreeKB, ikRAMpollCue, iRAMnextCue
global gRolloverWidget, koConstants

on new me, TextMbr
  ikTextMbr = TextMbr
  ikTextMbr.text = " "
  ikTextOrg = point(295, 466)
  ikTextSpr = 118
  sprite(ikTextSpr).loc = ikTextOrg
  iLastCall = 0
  iFreeKB = the freeBytes / 1024
  ikRAMpollCue = 1000
  iRAMnextCue = the milliSeconds + ikRAMpollCue
  iStepFrameEnabled = 0
  me.mSetStepFrameHook(1)
  return me
end

on stepFrame me
  ms = the milliSeconds
  elapsed = ms - iLastCall
  iLastCall = ms
  if objectp(gRolloverWidget) then
    id = gRolloverWidget.ikFullID
    tag = gRolloverWidget.iCurTagName
  else
    id = EMPTY
    tag = EMPTY
  end if
  if ms > iRAMnextCue then
    iRAMnextCue = ms + ikRAMpollCue
    iFreeKB = the freeBytes / 1024
  end if
  ikTextMbr.text = tag && id & "|fps:" & 1000 / elapsed & "|thr:" & count(the actorList) & "|mem:" & iFreeKB & "|" & koConstants.ikVersion
end

on mSetStepFrameHook me, State
  if State = iStepFrameEnabled then
    exit
  end if
  iStepFrameEnabled = State
  if iStepFrameEnabled then
    add(the actorList, me)
  else
    deleteOne(the actorList, me)
  end if
end
