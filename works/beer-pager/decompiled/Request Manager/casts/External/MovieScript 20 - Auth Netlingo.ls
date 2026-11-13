global proxyMgr, gProxyUserName, gProxyUserPassword, gProxyStr, gPortStr, gDoneWithInitialNet

on DoShit
  gProxyStr = "192.168.1.43"
  gPortStr = "80"
  gProxyUserName = "chetnet\adam kane"
  gProxyUserPassword = "Selbram"
  GetProxyAddress()
  test = IsProxyAuthenticating()
  if test = 1 then
    put "Authenticated proxy detected"
    first = AuthenticatedPostNetText("http://www.millerlite.com/servlet/com.redsky.beermailer.Hello", EMPTY)
    put AuthenticatedGetText(first)
    Second = AuthenticatedPostNetText("http://www.millerlite.com/servlet/com.redsky.beermailer.Hello", EMPTY)
    put AuthenticatedGetText(Second)
    third = AuthenticatedPostNetText("http://www.millerlite.com/servlet/com.redsky.beermailer.Hello", EMPTY)
    put AuthenticatedGetText(third)
    fourth = AuthenticatedPostNetText("http://www.millerlite.com/servlet/com.redsky.beermailer.Hello", EMPTY)
    put AuthenticatedGetText(fourth)
  else
    put "Non-authenticated proxy detected."
  end if
  first = 0
  Second = 0
  third = 0
  fourth = 0
  proxyMgr = 0
end

on GetProxyAddress
  GLURegister("R100-71-73810374")
  proxyMgr = new(xtra("glu32"))
  err = GLUNew(proxyMgr, "ProxyNet.dll", "GetProxyAddress", "S", "V", 0, 1)
  proxyCall = GLUCall(proxyMgr)
  proxyCallError = GLUGetLastError(proxyMgr)
  GLUDispose(proxyMgr)
  return proxyCall
end

on IsProxyAuthenticating
  port = value(gPortStr)
  err = GLUNew(proxyMgr, "ProxyNet.dll", "IsProxyAuthenticating", "N", "@SI", 0, 1)
  proxyCall = GLUCall(proxyMgr, gProxyStr, 80)
  proxyCallError = GLUGetLastError(proxyMgr)
  GLUDispose(proxyMgr)
  return proxyCall
end

on AuthenticatedPostNetText URL, Args
  err = GLUSetProp(proxyMgr, "MAXSTRINGSIZE", 102400)
  port = value(gPortStr)
  err = GLUNew(proxyMgr, "ProxyNet.dll", "AuthenticatedPostNetText", "W", "@SI@S@S@S@S", 0, 1)
  netID = GLUCall(proxyMgr, gProxyStr, port, gProxyUserName, gProxyUserPassword, URL, Args)
  proxyCallError = GLUGetLastError(proxyMgr)
  err = GLUSetProp(proxyMgr, "MAXSTRINGSIZE", 256)
  GLUDispose(proxyMgr)
  put "netID = " & netID
  return netID
end

on AuthenticatedGetText netID
  err = GLUSetProp(proxyMgr, "MAXSTRINGSIZE", 102400)
  err = GLUNew(proxyMgr, "ProxyNet.dll", "ProxyServerNetTextResult", "S", "W", 0, 1)
  proxyCall = GLUCall(proxyMgr, netID)
  proxyCallError = GLUGetLastError(proxyMgr)
  err = GLUSetProp(proxyMgr, "MAXSTRINGSIZE", 256)
  GLUDispose(proxyMgr)
  return proxyCall
end

on ProxyServerNetDone netID
  err = GLUNew(proxyMgr, "ProxyNet.dll", "ProxyServerNetDone", "I", "W", 0, 1)
  proxyCall = GLUCall(proxyMgr, netID)
  proxyCallError = GLUGetLastError(proxyMgr)
  GLUDispose(proxyMgr)
  return proxyCall
end

on ProxyServerNetError netID
  err = GLUNew(proxyMgr, "ProxyNet.dll", "ProxyServerNetError", "I", "I", 0, 1)
  proxyCall = GLUCall(proxyMgr, netID)
  proxyCallError = GLUGetLastError(proxyMgr)
  GLUDispose(proxyMgr)
  return proxyCall
end
