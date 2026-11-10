global ganimation_latency2

on exitFrame
  unloadMember("film letterspict", "legend")
  unloadMember("title1", "title3")
  mouse_addevent([#ticks: -1, #loc: point(0, 0)])
  animation_setstate(#woman, #playing)
  sync_setstate(#cowboy, #playing)
  puppetSound(3, "TriangleLoop")
  set the keyDownScript to "checkForModuleKey()"
  pass()
end
