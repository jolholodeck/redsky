on mouseUp
  global onceThru, dummyOk
  set dummyOk to 0
  puppetSound("drum1")
  updateStage()
  set onceThru to 0
  go("main")
end
