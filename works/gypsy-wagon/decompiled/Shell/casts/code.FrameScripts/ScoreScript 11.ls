on exitFrame
  global gdmoPrestoSplash, gdmoPrestoSplashPuppeted
  puppetSprite(gdmoPrestoSplash, 1)
  set gdmoPrestoSplashPuppeted to 1
  initMenuScreenMode()
  go("Idle")
end
