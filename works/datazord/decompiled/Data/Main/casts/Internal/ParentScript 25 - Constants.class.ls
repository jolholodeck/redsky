property ancestor, ikMaxNbWidgets, ikMaxThreads, ikDummyMbr, ikDummyLibName, ikConfigFileName, ikModuleBaseSpr, ikMaxSpriteNum, ikActiveCurs, ikInactiveCurs, ikWaitCurs, ikRegionHandlerClass, ikVersion, ikDebug, ikPrelinkLibs

on new me
  ikVersion = "1.0gm2"
  if the machineType = 256 then
    ikRegionHandlerClass = "RegionHandlerWin.class"
  else
    ikRegionHandlerClass = "RegionHandlerMac.class"
  end if
  ikMaxNbWidgets = 7
  ikMaxThreads = 15
  ikDummyMbr = member(101, 1)
  ikDummyLibName = "dz_deflt"
  ikConfigFileName = "config.txt"
  ikModuleBaseSpr = 2
  ikMaxSpriteNum = 120
  ikPrelinkLibs = 0
  ikActiveCurs = [91, 92]
  ikInactiveCurs = [93, 94]
  ikWaitCurs = [95, 96]
  return me
end
