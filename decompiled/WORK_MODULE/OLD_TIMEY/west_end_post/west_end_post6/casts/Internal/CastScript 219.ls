on mouseUp
  puppetSound("laugh")
  updateStage()
  repeat while soundBusy(1)
  end repeat
  repeat while soundBusy(2)
  end repeat
  puppetTransition(23)
  go("backDoor")
end
