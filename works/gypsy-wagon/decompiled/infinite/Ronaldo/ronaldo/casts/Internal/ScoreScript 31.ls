on exitFrame
  if not soundBusy(1) then
    puppetSound("growlThunder.aiff")
    updateStage()
  end if
end
