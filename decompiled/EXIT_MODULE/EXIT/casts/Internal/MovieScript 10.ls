global goNavMgr, gCRDspeed, gCRDtextField, gCRDsound, gCRDchan, gCRDdoQuit, gCRDrollCredits, gCRDcreditsPhase, gWaitExitCue

on loadCreditsData
  set gCRDspeed to 1
  set gCRDrollCredits to 0
  set gCRDcreditsPhase to #prep
  set gWaitExitCue to 0
  set gCRDsound to "Credits.AIF"
  set gCRDchan to 3
  set gCRDdoQuit to 0
  set gCRDtextField to the memberNum of member ("RTFcredits." & string(the ikOStype of goNavMgr))
end
